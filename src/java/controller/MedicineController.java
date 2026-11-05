package controller;

import dal.MedicineDAO;
import models.Medicine;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

public class MedicineController extends HttpServlet {

    // Khai báo đối tượng DAO dạng private final
    private final MedicineDAO medicineDAO = new MedicineDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        List<Medicine> list = medicineDAO.getAllMedicines(keyword);

        request.setAttribute("medicineList", list);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("/WEB-INF/views/admin/medicines.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                String name = request.getParameter("medicineName");
                String unit = request.getParameter("unit");
                BigDecimal price = new BigDecimal(request.getParameter("price"));
                int stock = Integer.parseInt(request.getParameter("stockQuantity"));
                String instruction = request.getParameter("usageInstruction");

                Medicine m = new Medicine(0, name, unit, price, stock, instruction, true);
                medicineDAO.addMedicine(m);

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("medicineId"));
                String name = request.getParameter("medicineName");
                String unit = request.getParameter("unit");
                BigDecimal price = new BigDecimal(request.getParameter("price"));
                int stock = Integer.parseInt(request.getParameter("stockQuantity"));
                String instruction = request.getParameter("usageInstruction");

                Medicine m = new Medicine(id, name, unit, price, stock, instruction, true);
                medicineDAO.updateMedicine(m);

            } else if ("toggle".equals(action)) {
                int id = Integer.parseInt(request.getParameter("medicineId"));
                boolean currentStatus = Boolean.parseBoolean(request.getParameter("currentStatus"));
                medicineDAO.toggleStatus(id, currentStatus);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Áp dụng mô hình Post-Redirect-Get để tránh lặp form khi người dùng ấn F5
        response.sendRedirect(request.getContextPath() + "/admin/medicines");
    }
}