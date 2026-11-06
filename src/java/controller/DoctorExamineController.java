package controller;

import dal.DoctorDAO;
import dal.MedicineDAO;
import models.Account;
import models.Medicine;
import models.Prescription;
import models.PrescriptionDetail;
import models.Visit;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class DoctorExamineController extends HttpServlet {

    private final DoctorDAO doctorDAO = new DoctorDAO();
    private final MedicineDAO medicineDAO = new MedicineDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Account accUser = (Account) session.getAttribute("accUser");
        int doctorId = (accUser != null) ? accUser.getAccountId() : 2;

        String visitIdRaw = request.getParameter("visitId");
        int visitId = 0;

        if (visitIdRaw != null && !visitIdRaw.trim().isEmpty()) {
            try {
                visitId = Integer.parseInt(visitIdRaw);
            } catch (NumberFormatException ignored) {}
        }

        // Nếu bấm trực tiếp từ Sidebar, tự động tìm ca khám dở dang (EXAMINING)
        if (visitId == 0) {
            visitId = doctorDAO.getCurrentExaminingVisitId(doctorId);
        }

        // Nếu không có ca nào đang khám -> Báo cảnh báo & đẩy về hàng chờ
        if (visitId == 0) {
            session.setAttribute("warningMsg", "Vui lòng chọn một bệnh nhân từ hàng chờ để bắt đầu khám!");
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
            return;
        }

        // Đổi trạng thái ca khám thành EXAMINING khi Bác sĩ bắt đầu khám
        doctorDAO.updateVisitStatus(visitId, doctorId, "EXAMINING");

        Visit visit = doctorDAO.getVisitById(visitId);
        if (visit == null) {
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
            return;
        }

        List<Medicine> medicineList = medicineDAO.getAllMedicines("");
        List<Visit> historyList = doctorDAO.getPatientVisitHistory(visit.getPatientId());

        request.setAttribute("visit", visit);
        request.setAttribute("medicineList", medicineList);
        request.setAttribute("historyList", historyList);

        request.getRequestDispatcher("/WEB-INF/views/doctor/examine.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Account accUser = (Account) session.getAttribute("accUser");
        int doctorId = (accUser != null) ? accUser.getAccountId() : 2;

        try {
            int visitId = Integer.parseInt(request.getParameter("visitId"));
            int patientId = Integer.parseInt(request.getParameter("patientId"));
            
            String symptoms = request.getParameter("symptoms");
            String diagnosis = request.getParameter("diagnosis");
            String bloodPressure = request.getParameter("bloodPressure");
            String note = request.getParameter("note");

            Double weight = parseDoubleOrNull(request.getParameter("weight"));
            Double temperature = parseDoubleOrNull(request.getParameter("temperature"));
            Date revisitDate = parseDateOrNull(request.getParameter("revisitDate"));

            Visit visit = new Visit();
            visit.setVisitId(visitId);
            visit.setPatientId(patientId);
            visit.setDoctorId(doctorId);
            visit.setSymptoms(symptoms);
            visit.setDiagnosis(diagnosis);
            visit.setWeight(weight);
            visit.setBloodPressure(bloodPressure);
            visit.setTemperature(temperature);
            visit.setRevisitDate(revisitDate);

            Prescription prescription = new Prescription();
            prescription.setVisitId(visitId);
            prescription.setDoctorId(doctorId);
            prescription.setNote(note);

            String[] medicineIds = request.getParameterValues("medicineId");
            String[] quantities = request.getParameterValues("quantity");
            String[] unitPrices = request.getParameterValues("unitPrice");
            String[] dosages = request.getParameterValues("dosage");

            List<PrescriptionDetail> details = new ArrayList<>();
            if (medicineIds != null && medicineIds.length > 0) {
                for (int i = 0; i < medicineIds.length; i++) {
                    if (medicineIds[i] != null && !medicineIds[i].trim().isEmpty()) {
                        PrescriptionDetail detail = new PrescriptionDetail();
                        detail.setMedicineId(Integer.parseInt(medicineIds[i]));
                        detail.setQuantity(Integer.parseInt(quantities[i]));
                        detail.setUnitPrice(Double.parseDouble(unitPrices[i]));
                        detail.setDosage(dosages[i]);
                        details.add(detail);
                    }
                }
            }

            boolean success = doctorDAO.completeExamination(visit, prescription, details);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/doctor/print?visitId=" + visitId);
            } else {
                request.setAttribute("errorMessage", "Lưu ca khám thất bại, vui lòng thử lại!");
                doGet(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
        }
    }

    private Double parseDoubleOrNull(String val) {
        try {
            if (val != null && !val.trim().isEmpty()) {
                return Double.parseDouble(val.trim());
            }
        } catch (NumberFormatException ignored) {}
        return null;
    }

    private Date parseDateOrNull(String val) {
        try {
            if (val != null && !val.trim().isEmpty()) {
                return Date.valueOf(val.trim());
            }
        } catch (IllegalArgumentException ignored) {}
        return null;
    }
}