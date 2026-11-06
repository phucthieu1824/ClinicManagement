package controller;

import dal.MedicineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/medicines")
public class MedicineServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setAttribute("list", new MedicineDAO().getAll());
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("medicines.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        try {
            MedicineDAO dao = new MedicineDAO();
            if ("add".equals(action)) {
                dao.add(req.getParameter("name").trim(), req.getParameter("unit").trim(),
                        Double.parseDouble(req.getParameter("price")), Integer.parseInt(req.getParameter("stock")),
                        req.getParameter("usage").trim());
            } else if ("adjust".equals(action)) {
                dao.adjust(Integer.parseInt(req.getParameter("id")), req.getParameter("mode"),
                        Integer.parseInt(req.getParameter("qty")));
            } else if ("delete".equals(action)) {
                dao.delete(Integer.parseInt(req.getParameter("id")));
            }
            resp.sendRedirect("medicines");
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Hãy nhập số hợp lệ.");
            doGet(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            doGet(req, resp);
        }
    }
}