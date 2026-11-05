package dal;

import models.Medicine;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class MedicineDAO extends DBContext {

    // Khai báo các câu lệnh SQL dạng hằng số static final
    private static final String SQL_SELECT_ALL = "SELECT * FROM Medicines WHERE 1=1";
    private static final String SQL_INSERT = "INSERT INTO Medicines (MedicineName, Unit, Price, StockQuantity, UsageInstruction, IsActive) VALUES (?, ?, ?, ?, ?, 1)";
    private static final String SQL_UPDATE = "UPDATE Medicines SET MedicineName = ?, Unit = ?, Price = ?, StockQuantity = ?, UsageInstruction = ? WHERE MedicineID = ?";
    private static final String SQL_TOGGLE_STATUS = "UPDATE Medicines SET IsActive = ? WHERE MedicineID = ?";

    public List<Medicine> getAllMedicines(String keyword) {
        List<Medicine> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(SQL_SELECT_ALL);
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (MedicineName LIKE ? OR UsageInstruction LIKE ?)");
        }
        sql.append(" ORDER BY MedicineID DESC");

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchPattern = "%" + keyword.trim() + "%";
                ps.setString(1, searchPattern);
                ps.setString(2, searchPattern);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Medicine m = new Medicine(
                        rs.getInt("MedicineID"),
                        rs.getString("MedicineName"),
                        rs.getString("Unit"),
                        rs.getBigDecimal("Price"),
                        rs.getInt("StockQuantity"),
                        rs.getString("UsageInstruction"),
                        rs.getBoolean("IsActive")
                    );
                    list.add(m);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addMedicine(Medicine m) {
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_INSERT)) {
            ps.setString(1, m.getMedicineName());
            ps.setString(2, m.getUnit());
            ps.setBigDecimal(3, m.getPrice());
            ps.setInt(4, m.getStockQuantity());
            ps.setString(5, m.getUsageInstruction());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateMedicine(Medicine m) {
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_UPDATE)) {
            ps.setString(1, m.getMedicineName());
            ps.setString(2, m.getUnit());
            ps.setBigDecimal(3, m.getPrice());
            ps.setInt(4, m.getStockQuantity());
            ps.setString(5, m.getUsageInstruction());
            ps.setInt(6, m.getMedicineId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean toggleStatus(int medicineId, boolean currentStatus) {
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_TOGGLE_STATUS)) {
            ps.setBoolean(1, !currentStatus);
            ps.setInt(2, medicineId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}