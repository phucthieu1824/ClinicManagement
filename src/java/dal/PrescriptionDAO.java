package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Prescription;
import model.PrescriptionItem;

/*
 * Trạng thái đơn lưu ở Prescriptions.DispenseStatus:
 * NEW (bác sĩ kê) -> PENDING_PAYMENT (đã tạo đơn, đã trừ kho) -> COMPLETED (đã thanh toán)
 */
public class PrescriptionDAO extends DBContext {

    private static final int CASHIER_ID = 5; // AccountID của dược sĩ (seed: 5)

    private static final String SELECT =
            "SELECT p.PrescriptionID, pt.PatientID, pt.FullName, pt.Allergies, pt.MedicalHistory, a.FullName, "
          + "v.Diagnosis, v.Symptoms, p.Note, p.DispenseStatus, "
          + "(SELECT TOP 1 i.PaymentMethod FROM Invoices i WHERE i.VisitID = v.VisitID AND i.PaymentStatus = 'PAID' ORDER BY i.InvoiceID DESC) "
          + "FROM Prescriptions p JOIN Visits v ON v.VisitID = p.VisitID "
          + "JOIN Patients pt ON pt.PatientID = v.PatientID JOIN Accounts a ON a.AccountID = p.DoctorID ";

    // ---------- Đọc dữ liệu ----------

    // Đơn bác sĩ vừa kê (NEW) của một bệnh nhân. Không có thì trả về null.
    public Prescription findNewByPatient(int patientId) throws SQLException {
        Prescription r = null;
        String sql = SELECT + "WHERE p.DispenseStatus = 'NEW' AND pt.PatientID = ? ORDER BY p.PrescriptionID";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) r = map(rs);
            }
        }
        if (r != null) r.items = getItems(r.id);
        return r;
    }

    // status: PENDING_PAYMENT hoặc COMPLETED
    public List<Prescription> findByStatus(String status) throws SQLException {
        List<Prescription> list = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(SELECT + "WHERE p.DispenseStatus = ? ORDER BY p.PrescriptionID DESC")) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        for (Prescription r : list) r.items = getItems(r.id);
        return list;
    }

    private Prescription map(ResultSet rs) throws SQLException {
        Prescription r = new Prescription();
        r.id = rs.getInt(1);
        r.patientId = rs.getInt(2);
        r.patientName = s(rs, 3);
        r.allergies = s(rs, 4);
        r.history = s(rs, 5);
        r.doctorName = s(rs, 6);
        r.diagnosis = s(rs, 7);
        r.symptoms = s(rs, 8);
        r.note = s(rs, 9);
        r.status = s(rs, 10);
        r.payMethod = s(rs, 11);
        return r;
    }

    private String s(ResultSet rs, int i) throws SQLException {
        String x = rs.getString(i);
        return x == null ? "" : x;
    }

    private List<PrescriptionItem> getItems(int rxId) throws SQLException {
        List<PrescriptionItem> list = new ArrayList<>();
        String sql = "SELECT d.MedicineID, d.Quantity, d.UnitPrice, d.Dosage, m.MedicineName, m.Unit "
                + "FROM PrescriptionDetails d JOIN Medicines m ON m.MedicineID = d.MedicineID "
                + "WHERE d.PrescriptionID = ? ORDER BY d.DetailID";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, rxId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PrescriptionItem it = new PrescriptionItem();
                    it.medicineId = rs.getInt(1);
                    it.quantity = rs.getInt(2);
                    it.price = rs.getDouble(3);
                    it.usage = s(rs, 4);
                    it.name = s(rs, 5);
                    it.unit = s(rs, 6);
                    list.add(it);
                }
            }
        }
        return list;
    }

    // ---------- Tạo đơn: lưu đơn đã chỉnh, TRỪ KHO, tạo hóa đơn chờ thanh toán ----------

    public void create(int rxId, List<PrescriptionItem> items) throws Exception {
        if (items.isEmpty()) throw new Exception("Đơn thuốc cần có ít nhất một loại thuốc.");
        connection.setAutoCommit(false);
        try {
            int visitId = visitOf(rxId, "NEW");
            run("DELETE FROM PrescriptionDetails WHERE PrescriptionID = ?", rxId);
            double total = 0;
            for (PrescriptionItem it : items) {
                double price;
                String name;
                try (PreparedStatement ps = connection.prepareStatement(
                        "SELECT Price, MedicineName FROM Medicines WHERE MedicineID = ? AND IsActive = 1")) {
                    ps.setInt(1, it.medicineId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) throw new Exception("Thuốc không còn trong kho.");
                        price = rs.getDouble(1);
                        name = rs.getString(2);
                    }
                }
                // Chỉ trừ được khi còn đủ hàng
                int ok = run("UPDATE Medicines SET StockQuantity = StockQuantity - ? WHERE MedicineID = ? AND StockQuantity >= ?",
                        it.quantity, it.medicineId, it.quantity);
                if (ok == 0) throw new Exception(name + " không đủ tồn kho.");
                run("INSERT INTO PrescriptionDetails (PrescriptionID, MedicineID, Quantity, UnitPrice, Dosage) VALUES (?,?,?,?,?)",
                        rxId, it.medicineId, it.quantity, price, it.usage);
                total += price * it.quantity;
            }
            run("UPDATE Prescriptions SET DispenseStatus = 'PENDING_PAYMENT' WHERE PrescriptionID = ?", rxId);
            run("INSERT INTO Invoices (VisitID, CashierID, InvoiceType, TotalAmount, PaymentStatus) VALUES (?,?,?,?,?)",
                    visitId, CASHIER_ID, "MEDICINE", total, "PENDING");
            connection.commit();
        } catch (Exception e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }
    }

    // ---------- Thanh toán: hóa đơn PAID, đơn COMPLETED. method: CASH hoặc TRANSFER ----------

    public void pay(int rxId, String method) throws Exception {
        connection.setAutoCommit(false);
        try {
            int visitId = visitOf(rxId, "PENDING_PAYMENT");
            int n = run("UPDATE Invoices SET PaymentStatus = 'PAID', PaymentMethod = ?, CashierID = ? "
                    + "WHERE VisitID = ? AND PaymentStatus = 'PENDING'", method, CASHIER_ID, visitId);
            if (n == 0) { // chưa có hóa đơn chờ thì tạo hóa đơn đã thanh toán
                run("INSERT INTO Invoices (VisitID, CashierID, InvoiceType, TotalAmount, PaymentMethod, PaymentStatus) "
                        + "SELECT ?, ?, 'MEDICINE', ISNULL(SUM(Quantity * UnitPrice), 0), ?, 'PAID' "
                        + "FROM PrescriptionDetails WHERE PrescriptionID = ?", visitId, CASHIER_ID, method, rxId);
            }
            run("UPDATE Prescriptions SET DispenseStatus = 'COMPLETED' WHERE PrescriptionID = ?", rxId);
            connection.commit();
        } catch (Exception e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }
    }

    // ---------- Hủy đơn chờ thanh toán: trả thuốc về kho, đơn quay lại NEW ----------

    public void cancel(int rxId) throws Exception {
        connection.setAutoCommit(false);
        try {
            int visitId = visitOf(rxId, "PENDING_PAYMENT");
            run("UPDATE Medicines SET StockQuantity = StockQuantity + ISNULL((SELECT SUM(Quantity) FROM PrescriptionDetails "
                    + "WHERE PrescriptionID = ? AND MedicineID = Medicines.MedicineID), 0) "
                    + "WHERE MedicineID IN (SELECT MedicineID FROM PrescriptionDetails WHERE PrescriptionID = ?)", rxId, rxId);
            run("DELETE FROM Invoices WHERE VisitID = ? AND InvoiceType = 'MEDICINE' AND PaymentStatus = 'PENDING'", visitId);
            run("UPDATE Prescriptions SET DispenseStatus = 'NEW' WHERE PrescriptionID = ?", rxId);
            connection.commit();
        } catch (Exception e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }
    }

    // ---------- Hàm phụ ----------

    private int run(String sql, Object... args) throws SQLException {
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (int i = 0; i < args.length; i++) ps.setObject(i + 1, args[i]);
            return ps.executeUpdate();
        }
    }

    private int visitOf(int rxId, String status) throws Exception {
        try (PreparedStatement ps = connection.prepareStatement(
                "SELECT VisitID FROM Prescriptions WHERE PrescriptionID = ? AND DispenseStatus = ?")) {
            ps.setInt(1, rxId);
            ps.setString(2, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) throw new Exception("Đơn không ở đúng trạng thái để thực hiện thao tác này.");
                return rs.getInt(1);
            }
        }
    }
}