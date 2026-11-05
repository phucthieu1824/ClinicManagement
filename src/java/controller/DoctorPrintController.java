package controller;

import dal.DoctorDAO;
import models.Prescription;
import models.PrescriptionDetail;
import models.Visit;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class DoctorPrintController extends HttpServlet {

    private final DoctorDAO doctorDAO = new DoctorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String visitIdRaw = request.getParameter("visitId");
        if (visitIdRaw == null || visitIdRaw.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
            return;
        }

        try {
            int visitId = Integer.parseInt(visitIdRaw);
            Visit visit = doctorDAO.getVisitById(visitId);

            if (visit == null) {
                response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
                return;
            }

            Prescription prescription = doctorDAO.getPrescriptionByVisitId(visitId);
            List<PrescriptionDetail> details = null;
            
            if (prescription != null) {
                details = doctorDAO.getPrescriptionDetails(prescription.getPrescriptionId());
            }

            request.setAttribute("visit", visit);
            request.setAttribute("prescription", prescription);
            request.setAttribute("details", details);

            request.getRequestDispatcher("/WEB-INF/views/doctor/print_prescription.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
        }
    }
}