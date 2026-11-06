package controller;

import dal.MedicineDAO;
import dal.PrescriptionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.PrescriptionItem;

@WebServlet("/create-prescription")
public class CreatePrescriptionServlet extends HttpServlet {

    // Nhập ID bệnh nhân -> hiện thông tin, chẩn đoán và đơn thuốc bác sĩ đã kê
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pid = req.getParameter("patientId");
        try {
            if (pid != null && !pid.trim().isEmpty()) {
                req.setAttribute("rx", new PrescriptionDAO().findNewByPatient(Integer.parseInt(pid.trim())));
                req.setAttribute("meds", new MedicineDAO().getAll());
                req.setAttribute("searched", true);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "ID bệnh nhân phải là số.");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("create.jsp").forward(req, resp);
    }

    // Dược sĩ chỉnh đơn xong bấm tạo đơn
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        try {
            int rxId = Integer.parseInt(req.getParameter("rxId"));
            String[] ids = req.getParameterValues("medId");
            String[] qtys = req.getParameterValues("qty");
            String[] usages = req.getParameterValues("usage");

            List<PrescriptionItem> items = new ArrayList<>();
            for (int i = 0; i < ids.length; i++) {
                String q = qtys[i].trim();
                int qty = q.isEmpty() ? 0 : Integer.parseInt(q);
                if (qty > 0) { // số lượng 0 nghĩa là bỏ thuốc này khỏi đơn
                    PrescriptionItem it = new PrescriptionItem();
                    it.medicineId = Integer.parseInt(ids[i]);
                    it.quantity = qty;
                    it.usage = usages[i].trim();
                    items.add(it);
                }
            }
            new PrescriptionDAO().create(rxId, items);
            resp.sendRedirect("prescriptions?status=pending");
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Số lượng phải là số nguyên.");
            doGet(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            doGet(req, resp);
        }
    }
}