package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.LinkedHashMap;
import java.util.Map;

public class DashboardDAO extends DBContext {

    // ------------------ KHAI BÁO CÂU LỆNH SQL (PRIVATE STATIC FINAL) ------------------
    // Doanh thu theo thời gian
    private static final String SQL_REVENUE_DATE = 
        "SELECT ISNULL(SUM(TotalAmount), 0) FROM Invoices WHERE CAST(CreatedDate AS DATE) = ?";
    
    private static final String SQL_REVENUE_MONTH = 
        "SELECT ISNULL(SUM(TotalAmount), 0) FROM Invoices WHERE MONTH(CreatedDate) = ? AND YEAR(CreatedDate) = ?";
    
    private static final String SQL_REVENUE_QUARTER = 
        "SELECT ISNULL(SUM(TotalAmount), 0) FROM Invoices WHERE DATEPART(QUARTER, CreatedDate) = ? AND YEAR(CreatedDate) = ?";
    
    private static final String SQL_REVENUE_YEAR = 
        "SELECT ISNULL(SUM(TotalAmount), 0) FROM Invoices WHERE YEAR(CreatedDate) = ?";

    // Lưu lượng bệnh nhân theo thời gian
    private static final String SQL_PATIENTS_DATE = 
        "SELECT COUNT(*) FROM Appointments WHERE CAST(AppointmentDate AS DATE) = ?";
    
    private static final String SQL_PATIENTS_MONTH = 
        "SELECT COUNT(*) FROM Appointments WHERE MONTH(AppointmentDate) = ? AND YEAR(AppointmentDate) = ?";
    
    private static final String SQL_PATIENTS_QUARTER = 
        "SELECT COUNT(*) FROM Appointments WHERE DATEPART(QUARTER, AppointmentDate) = ? AND YEAR(AppointmentDate) = ?";
    
    private static final String SQL_PATIENTS_YEAR = 
        "SELECT COUNT(*) FROM Appointments WHERE YEAR(AppointmentDate) = ?";

    // Biểu đồ chi tiết theo Tháng (Gom nhóm theo Ngày)
    private static final String SQL_CHART_BY_MONTH = 
        "SELECT DAY(CreatedDate) AS Label, ISNULL(SUM(TotalAmount), 0) AS Revenue " +
        "FROM Invoices WHERE MONTH(CreatedDate) = ? AND YEAR(CreatedDate) = ? " +
        "GROUP BY DAY(CreatedDate) ORDER BY DAY(CreatedDate) ASC";

    // Biểu đồ chi tiết theo Quý/Năm (Gom nhóm theo Tháng)
    private static final String SQL_CHART_BY_YEAR = 
        "SELECT MONTH(CreatedDate) AS Label, ISNULL(SUM(TotalAmount), 0) AS Revenue " +
        "FROM Invoices WHERE YEAR(CreatedDate) = ? " +
        "GROUP BY MONTH(CreatedDate) ORDER BY MONTH(CreatedDate) ASC";

    // ------------------ PHƯƠNG THỨC TRUY VẤN LỌC DOANH THU ------------------
    public double getFilteredRevenue(String filterType, String dateStr, int month, int quarter, int year) {
        String sql = SQL_REVENUE_MONTH;
        if ("date".equals(filterType)) sql = SQL_REVENUE_DATE;
        else if ("quarter".equals(filterType)) sql = SQL_REVENUE_QUARTER;
        else if ("year".equals(filterType)) sql = SQL_REVENUE_YEAR;

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if ("date".equals(filterType)) {
                ps.setString(1, dateStr);
            } else if ("quarter".equals(filterType)) {
                ps.setInt(1, quarter);
                ps.setInt(2, year);
            } else if ("year".equals(filterType)) {
                ps.setInt(1, year);
            } else { // default: month
                ps.setInt(1, month);
                ps.setInt(2, year);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ------------------ PHƯƠNG THỨC TRUY VẤN LỌC SỐ LƯỢNG BỆNH NHÂN ------------------
    public int getFilteredPatients(String filterType, String dateStr, int month, int quarter, int year) {
        String sql = SQL_PATIENTS_MONTH;
        if ("date".equals(filterType)) sql = SQL_PATIENTS_DATE;
        else if ("quarter".equals(filterType)) sql = SQL_PATIENTS_QUARTER;
        else if ("year".equals(filterType)) sql = SQL_PATIENTS_YEAR;

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if ("date".equals(filterType)) {
                ps.setString(1, dateStr);
            } else if ("quarter".equals(filterType)) {
                ps.setInt(1, quarter);
                ps.setInt(2, year);
            } else if ("year".equals(filterType)) {
                ps.setInt(1, year);
            } else {
                ps.setInt(1, month);
                ps.setInt(2, year);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ------------------ DỮ LIỆU BIỂU ĐỒ THEO BỘ LỌC ------------------
    public Map<String, Double> getChartData(String filterType, int month, int year) {
        Map<String, Double> map = new LinkedHashMap<>();
        boolean isYearly = "year".equals(filterType) || "quarter".equals(filterType);
        String sql = isYearly ? SQL_CHART_BY_YEAR : SQL_CHART_BY_MONTH;

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (isYearly) {
                ps.setInt(1, year);
            } else {
                ps.setInt(1, month);
                ps.setInt(2, year);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String prefix = isYearly ? "Tháng " : "Ngày ";
                    map.put(prefix + rs.getInt("Label"), rs.getDouble("Revenue"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }
}