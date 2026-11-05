package controller;

import dal.AccountDAO;
import dal.DashboardDAO;
import dal.MedicineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.Map;

public class DashboardController extends HttpServlet {

    private final DashboardDAO dashboardDAO = new DashboardDAO();
    private final MedicineDAO medicineDAO = new MedicineDAO();
    private final AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LocalDate now = LocalDate.now();

        // Lấy các giá trị lọc từ Form
        String filterType = request.getParameter("filterType");
        if (filterType == null || filterType.trim().isEmpty()) {
            filterType = "month"; // Mặc định lọc theo Tháng hiện tại
        }

        String selectedDate = request.getParameter("selectedDate");
        if (selectedDate == null || selectedDate.trim().isEmpty()) {
            selectedDate = now.toString();
        }

        int month = parseOrDefault(request.getParameter("selectedMonth"), now.getMonthValue());
        int quarter = parseOrDefault(request.getParameter("selectedQuarter"), (now.getMonthValue() - 1) / 3 + 1);
        int year = parseOrDefault(request.getParameter("selectedYear"), now.getYear());

        // Lấy con số chỉ số KPI theo bộ lọc
        double filteredRevenue = dashboardDAO.getFilteredRevenue(filterType, selectedDate, month, quarter, year);
        int filteredPatients = dashboardDAO.getFilteredPatients(filterType, selectedDate, month, quarter, year);

        // Đếm cảnh báo kho thuốc & tài khoản
        long lowStockCount = medicineDAO.getAllMedicines(null).stream()
                .filter(m -> m.getStockQuantity() <= 50 && m.isIsActive())
                .count();

        // Lấy dữ liệu vẽ Biểu đồ
        Map<String, Double> chartDataMap = dashboardDAO.getChartData(filterType, month, year);

        // Build mảng JSON cho Chart.js
        StringBuilder labelsJson = new StringBuilder("[");
        StringBuilder revenueJson = new StringBuilder("[");

        if (chartDataMap.isEmpty()) {
            // Dữ liệu mẫu hiển thị nếu chưa có giao dịch trong DB
            if ("year".equals(filterType) || "quarter".equals(filterType)) {
                labelsJson.append("'Th1', 'Th2', 'Th3', 'Th4', 'Th5', 'Th6', 'Th7', 'Th8', 'Th9', 'Th10', 'Th11', 'Th12']");
                revenueJson.append("45000000, 52000000, 61000000, 58000000, 70000000, 85000000, 92000000, 88000000, 79000000, 95000000, 110000000, 125000000]");
            } else {
                labelsJson.append("'Tuần 1', 'Tuần 2', 'Tuần 3', 'Tuần 4']");
                revenueJson.append("18000000, 25000000, 31000000, 28000000]");
            }
        } else {
            int count = 0;
            for (Map.Entry<String, Double> entry : chartDataMap.entrySet()) {
                if (count > 0) {
                    labelsJson.append(",");
                    revenueJson.append(",");
                }
                labelsJson.append("'").append(entry.getKey()).append("'");
                revenueJson.append(entry.getValue());
                count++;
            }
            labelsJson.append("]");
            revenueJson.append("]");
        }

        // Truyền trạng thái & dữ liệu sang JSP
        request.setAttribute("filterType", filterType);
        request.setAttribute("selectedDate", selectedDate);
        request.setAttribute("selectedMonth", month);
        request.setAttribute("selectedQuarter", quarter);
        request.setAttribute("selectedYear", year);

        request.setAttribute("filteredRevenue", filteredRevenue);
        request.setAttribute("filteredPatients", filteredPatients);
        request.setAttribute("lowStockCount", lowStockCount);

        request.setAttribute("chartLabels", labelsJson.toString());
        request.setAttribute("chartRevenue", revenueJson.toString());

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }

    private int parseOrDefault(String value, int defaultValue) {
        try {
            if (value != null && !value.trim().isEmpty()) {
                return Integer.parseInt(value);
            }
        } catch (NumberFormatException ignored) {}
        return defaultValue;
    }
}