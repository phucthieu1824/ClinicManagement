package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Medicine;

public class MedicineDAO extends DBContext {

    public List<Medicine> getAll() throws SQLException {
        List<Medicine> list = new ArrayList<>();
        String sql = "SELECT MedicineID, MedicineName, ISNULL(Unit, N''), Price, StockQuantity, ISNULL(UsageInstruction, N'') "
                + "FROM Medicines WHERE IsActive = 1 ORDER BY MedicineID";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Medicine m = new Medicine();
                m.id = rs.getInt(1);
                m.name = rs.getString(2);
                m.unit = rs.getString(3);
                m.price = rs.getDouble(4);
                m.stock = rs.getInt(5);
                m.usage = rs.getString(6);
                list.add(m);
            }
        }
        return list;
    }

    // Thêm loại thuốc mới
    public void add(String name, String unit, double price, int stock, String usage) throws Exception {
        if (name.isEmpty() || unit.isEmpty()) throw new Exception("Nhập tên thuốc và đơn vị.");
        if (price <= 0) throw new Exception("Giá bán phải lớn hơn 0.");
        if (stock < 0) throw new Exception("Số lượng không được âm.");
        if (count("SELECT COUNT(*) FROM Medicines WHERE LOWER(MedicineName) = LOWER(?) AND IsActive = 1", name) > 0)
            throw new Exception("Thuốc này đã có trong kho. Hãy dùng chức năng điều chỉnh số lượng.");
        String sql = "INSERT INTO Medicines (MedicineName, Unit, Price, StockQuantity, UsageInstruction) VALUES (?,?,?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, unit);
            ps.setDouble(3, price);
            ps.setInt(4, stock);
            ps.setString(5, usage);
            ps.executeUpdate();
        }
    }

    // mode: add = nhập thêm, sub = giảm, set = đặt lại số tồn
    public void adjust(int id, String mode, int qty) throws Exception {
        if (qty < 0) throw new Exception("Số lượng không được âm.");
        String sql;
        if ("add".equals(mode)) {
            sql = "UPDATE Medicines SET StockQuantity = StockQuantity + ? WHERE MedicineID = ?";
        } else if ("sub".equals(mode)) {
            sql = "UPDATE Medicines SET StockQuantity = StockQuantity - ? WHERE MedicineID = ? AND StockQuantity >= ?";
        } else {
            sql = "UPDATE Medicines SET StockQuantity = ? WHERE MedicineID = ?";
        }
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, qty);
            ps.setInt(2, id);
            if ("sub".equals(mode)) ps.setInt(3, qty);
            if (ps.executeUpdate() == 0) {
                throw new Exception("sub".equals(mode) ? "Không thể giảm quá số lượng đang có." : "Không tìm thấy thuốc.");
            }
        }
    }

    // Xóa thuốc. Thuốc đã từng được kê thì chỉ ẩn đi (IsActive = 0) vì có khóa ngoại.
    public void delete(int id) throws Exception {
        if (count("SELECT COUNT(*) FROM PrescriptionDetails d JOIN Prescriptions p ON p.PrescriptionID = d.PrescriptionID "
                + "WHERE d.MedicineID = ? AND p.DispenseStatus IN ('NEW','PENDING_PAYMENT')", id) > 0)
            throw new Exception("Thuốc đang nằm trong đơn chờ phát hoặc chờ thanh toán, chưa thể xóa.");
        String sql = count("SELECT COUNT(*) FROM PrescriptionDetails WHERE MedicineID = ?", id) > 0
                ? "UPDATE Medicines SET IsActive = 0 WHERE MedicineID = ?"
                : "DELETE FROM Medicines WHERE MedicineID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    private int count(String sql, Object param) throws SQLException {
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setObject(1, param);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }
}