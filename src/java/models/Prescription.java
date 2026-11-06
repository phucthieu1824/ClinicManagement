package models;

import java.sql.Timestamp;

public class Prescription {

    private int prescriptionId;
    private int visitId;
    private int doctorId;
    private String note;
    private Timestamp createdAt;

    public Prescription() {
    }

    public Prescription(int prescriptionId, int visitId, int doctorId, String note, Timestamp createdAt) {
        this.prescriptionId = prescriptionId;
        this.visitId = visitId;
        this.doctorId = doctorId;
        this.note = note;
        this.createdAt = createdAt;
    }

    public int getPrescriptionId() {
        return prescriptionId;
    }

    public void setPrescriptionId(int prescriptionId) {
        this.prescriptionId = prescriptionId;
    }

    public int getVisitId() {
        return visitId;
    }

    public void setVisitId(int visitId) {
        this.visitId = visitId;
    }

    public int getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
