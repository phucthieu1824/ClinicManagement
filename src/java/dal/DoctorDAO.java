package dal;

import models.Visit;
import models.Prescription;
import models.PrescriptionDetail;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class DoctorDAO extends DBContext {

    private static final String SQL_GET_QUEUE_VISITS = 
        "SELECT v.VisitID, v.PatientID, v.DoctorID, v.VisitDate, v.Symptoms, v.Diagnosis, v.Weight, " +
        "       v.BloodPressure, v.Temperature, v.RevisitDate, v.UpdatedAt, v.Status, " +
        "       p.FullName AS PatientName, p.Phone AS PatientPhone, p.Gender, p.DateOfBirth, p.Allergies " +
        "FROM Visits v " +
        "JOIN Patients p ON v.PatientID = p.PatientID " +
        "WHERE (v.DoctorID = ? OR v.DoctorID IS NULL) " +
        "  AND CAST(v.VisitDate AS DATE) = CAST(GETDATE() AS DATE) " +
        "  AND v.Status IN ('WAITING', 'EXAMINING') " +
        "ORDER BY v.VisitID ASC";

    private static final String SQL_GET_VISIT_BY_ID = 
        "SELECT v.VisitID, v.PatientID, v.DoctorID, v.VisitDate, v.Symptoms, v.Diagnosis, v.Weight, " +
        "       v.BloodPressure, v.Temperature, v.RevisitDate, v.UpdatedAt, v.Status, " +
        "       p.FullName AS PatientName, p.Phone AS PatientPhone, p.Gender, p.DateOfBirth, p.Allergies, p.MedicalHistory " +
        "FROM Visits v " +
        "JOIN Patients p ON v.PatientID = p.PatientID " +
        "WHERE v.VisitID = ?";

    private static final String SQL_UPDATE_VISIT_EXAM = 
        "UPDATE Visits " +
        "SET DoctorID = ?, Symptoms = ?, Diagnosis = ?, Weight = ?, BloodPressure = ?, Temperature = ?, RevisitDate = ?, Status = 'COMPLETED', UpdatedAt = GETDATE() " +
        "WHERE VisitID = ?";

    private static final String SQL_INSERT_PRESCRIPTION = 
        "INSERT INTO Prescriptions (VisitID, DoctorID, Note, CreatedAt) VALUES (?, ?, ?, GETDATE())";

    private static final String SQL_INSERT_PRESCRIPTION_DETAIL = 
        "INSERT INTO PrescriptionDetails (PrescriptionID, MedicineID, Quantity, UnitPrice, Dosage) VALUES (?, ?, ?, ?, ?)";

    private static final String SQL_GET_PATIENT_VISIT_HISTORY = 
        "SELECT v.VisitID, v.PatientID, v.DoctorID, v.VisitDate, v.Symptoms, v.Diagnosis, v.Status, " +
        "       acc.FullName AS DoctorName " +
        "FROM Visits v " +
        "LEFT JOIN Accounts acc ON v.DoctorID = acc.AccountID " +
        "WHERE v.PatientID = ? AND v.Status = 'COMPLETED' " +
        "ORDER BY v.VisitDate DESC";

    private static final String SQL_GET_PRESCRIPTION_BY_VISIT = 
        "SELECT p.PrescriptionID, p.VisitID, p.DoctorID, p.Note, p.CreatedAt " +
        "FROM Prescriptions p WHERE p.VisitID = ?";

    private static final String SQL_GET_DETAILS_BY_PRESCRIPTION = 
        "SELECT pd.DetailID, pd.PrescriptionID, pd.MedicineID, pd.Quantity, pd.UnitPrice, pd.Dosage, " +
        "       m.MedicineName, m.Unit " +
        "FROM PrescriptionDetails pd " +
        "JOIN Medicines m ON pd.MedicineID = m.MedicineID " +
        "WHERE pd.PrescriptionID = ?";

    // 1. Lấy danh sách hàng chờ khám hôm nay
    public List<Visit> getQueueVisits(int doctorId) {
        List<Visit> list = new ArrayList<>();
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_QUEUE_VISITS)) {
            ps.setInt(1, doctorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Visit v = new Visit(
                        rs.getInt("VisitID"),
                        rs.getInt("PatientID"),
                        (Integer) rs.getObject("DoctorID"),
                        rs.getTimestamp("VisitDate"),
                        rs.getString("Symptoms"),
                        rs.getString("Diagnosis"),
                        (Double) rs.getObject("Weight"),
                        rs.getString("BloodPressure"),
                        (Double) rs.getObject("Temperature"),
                        rs.getDate("RevisitDate"),
                        rs.getTimestamp("UpdatedAt"),
                        rs.getString("Status")
                    );
                    v.setPatientName(rs.getString("PatientName"));
                    v.setPatientPhone(rs.getString("PatientPhone"));
                    v.setGender(rs.getString("Gender"));
                    v.setDateOfBirth(rs.getDate("DateOfBirth"));
                    v.setAllergies(rs.getString("Allergies"));
                    list.add(v);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Lấy chi tiết lượt khám theo VisitID
    public Visit getVisitById(int visitId) {
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_VISIT_BY_ID)) {
            ps.setInt(1, visitId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Visit v = new Visit(
                        rs.getInt("VisitID"),
                        rs.getInt("PatientID"),
                        (Integer) rs.getObject("DoctorID"),
                        rs.getTimestamp("VisitDate"),
                        rs.getString("Symptoms"),
                        rs.getString("Diagnosis"),
                        (Double) rs.getObject("Weight"),
                        rs.getString("BloodPressure"),
                        (Double) rs.getObject("Temperature"),
                        rs.getDate("RevisitDate"),
                        rs.getTimestamp("UpdatedAt"),
                        rs.getString("Status")
                    );
                    v.setPatientName(rs.getString("PatientName"));
                    v.setPatientPhone(rs.getString("PatientPhone"));
                    v.setGender(rs.getString("Gender"));
                    v.setDateOfBirth(rs.getDate("DateOfBirth"));
                    v.setAllergies(rs.getString("Allergies"));
                    v.setMedicalHistory(rs.getString("MedicalHistory"));
                    return v;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 3. Lấy ID ca khám đang dở dang (EXAMINING) của Bác sĩ
    public int getCurrentExaminingVisitId(int doctorId) {
        String sql = "SELECT TOP 1 VisitID FROM Visits WHERE DoctorID = ? AND Status = 'EXAMINING' ORDER BY UpdatedAt DESC";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("VisitID");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 4. Cập nhật trạng thái ca khám thành EXAMINING khi Bác sĩ tiếp nhận
    public void updateVisitStatus(int visitId, int doctorId, String status) {
        String sql = "UPDATE Visits SET DoctorID = ?, Status = ?, UpdatedAt = GETDATE() WHERE VisitID = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ps.setString(2, status);
            ps.setInt(3, visitId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 5. Lưu chẩn đoán & kê đơn (Transaction)
    public boolean completeExamination(Visit visit, Prescription prescription, List<PrescriptionDetail> details) {
        Connection conn = null;
        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement psVisit = conn.prepareStatement(SQL_UPDATE_VISIT_EXAM)) {
                psVisit.setInt(1, visit.getDoctorId());
                psVisit.setString(2, visit.getSymptoms());
                psVisit.setString(3, visit.getDiagnosis());
                psVisit.setObject(4, visit.getWeight());
                psVisit.setString(5, visit.getBloodPressure());
                psVisit.setObject(6, visit.getTemperature());
                psVisit.setDate(7, visit.getRevisitDate());
                psVisit.setInt(8, visit.getVisitId());
                psVisit.executeUpdate();
            }

            if (details != null && !details.isEmpty()) {
                int prescriptionId = 0;
                try (PreparedStatement psPres = conn.prepareStatement(SQL_INSERT_PRESCRIPTION, Statement.RETURN_GENERATED_KEYS)) {
                    psPres.setInt(1, visit.getVisitId());
                    psPres.setInt(2, visit.getDoctorId());
                    psPres.setString(3, prescription != null ? prescription.getNote() : "");
                    
                    psPres.executeUpdate();
                    try (ResultSet rs = psPres.getGeneratedKeys()) {
                        if (rs.next()) prescriptionId = rs.getInt(1);
                    }
                }

                if (prescriptionId == 0) {
                    conn.rollback();
                    return false;
                }

                try (PreparedStatement psDetail = conn.prepareStatement(SQL_INSERT_PRESCRIPTION_DETAIL)) {
                    for (PrescriptionDetail item : details) {
                        psDetail.setInt(1, prescriptionId);
                        psDetail.setInt(2, item.getMedicineId());
                        psDetail.setInt(3, item.getQuantity());
                        psDetail.setDouble(4, item.getUnitPrice());
                        psDetail.setString(5, item.getDosage());
                        psDetail.addBatch();
                    }
                    psDetail.executeBatch();
                }
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (Exception e) { e.printStackTrace(); }
            }
        }
        return false;
    }

    // 6. Lịch sử khám cũ của bệnh nhân
    public List<Visit> getPatientVisitHistory(int patientId) {
        List<Visit> list = new ArrayList<>();
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_PATIENT_VISIT_HISTORY)) {
            ps.setInt(1, patientId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Visit v = new Visit();
                    v.setVisitId(rs.getInt("VisitID"));
                    v.setPatientId(rs.getInt("PatientID"));
                    v.setDoctorId((Integer) rs.getObject("DoctorID"));
                    v.setVisitDate(rs.getTimestamp("VisitDate"));
                    v.setSymptoms(rs.getString("Symptoms"));
                    v.setDiagnosis(rs.getString("Diagnosis"));
                    v.setStatus(rs.getString("Status"));
                    v.setDoctorName(rs.getString("DoctorName"));
                    list.add(v);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 7. Truy vấn đơn thuốc để in
    public Prescription getPrescriptionByVisitId(int visitId) {
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_PRESCRIPTION_BY_VISIT)) {
            ps.setInt(1, visitId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Prescription(
                        rs.getInt("PrescriptionID"),
                        rs.getInt("VisitID"),
                        rs.getInt("DoctorID"),
                        rs.getString("Note"),
                        rs.getTimestamp("CreatedAt")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 8. Truy vấn danh sách thuốc chi tiết để in
    public List<PrescriptionDetail> getPrescriptionDetails(int prescriptionId) {
        List<PrescriptionDetail> list = new ArrayList<>();
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_DETAILS_BY_PRESCRIPTION)) {
            ps.setInt(1, prescriptionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PrescriptionDetail item = new PrescriptionDetail(
                        rs.getInt("DetailID"),
                        rs.getInt("PrescriptionID"),
                        rs.getInt("MedicineID"),
                        rs.getInt("Quantity"),
                        rs.getDouble("UnitPrice"),
                        rs.getString("Dosage")
                    );
                    item.setMedicineName(rs.getString("MedicineName"));
                    item.setUnit(rs.getString("Unit"));
                    list.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}