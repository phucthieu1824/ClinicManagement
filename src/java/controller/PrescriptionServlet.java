package controller;

import dal.PrescriptionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/prescriptions")
public class PrescriptionServlet extends HttpServlet {

    // status=pending: đơn chờ thanh toán, status=done: đơn đã hoàn thành
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String status = "done".equals(req.getParameter("status")) ? "done" : "pending";
        try {
            String dbStatus = "done".equals(status) ? "COMPLETED" : "PENDING_PAYMENT";
            req.setAttribute("list", new PrescriptionDAO().findByStatus(dbStatus));
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
        }
        req.setAttribute("status", status);
        req.getRequestDispatcher("prescriptions.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            PrescriptionDAO dao = new PrescriptionDAO();
            if ("pay".equals(action)) {
                dao.pay(id, "TRANSFER".equals(req.getParameter("method")) ? "TRANSFER" : "CASH");
                resp.sendRedirect("prescriptions?status=done");
            } else {
                dao.cancel(id);
                resp.sendRedirect("prescriptions?status=pending");
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            doGet(req, resp);
        }
    }
}