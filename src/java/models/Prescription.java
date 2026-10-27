package models;

import java.sql.Timestamp;

public class Prescription {

    public int PrescriptionId;
    public int VisitId;
    public int DoctorId;
    public String Note;
    public Timestamp CreatedAt;

    public Prescription() {
    }

    public Prescription(int PrescriptionId, int VisitId, int DoctorId, String Note, Timestamp CreatedAt) {
        this.PrescriptionId = PrescriptionId;
        this.VisitId = VisitId;
        this.DoctorId = DoctorId;
        this.Note = Note;
        this.CreatedAt = CreatedAt;
    }

    public int getPrescriptionId() {
        return PrescriptionId;
    }

    public void setPrescriptionId(int PrescriptionId) {
        this.PrescriptionId = PrescriptionId;
    }

    public int getVisitId() {
        return VisitId;
    }

    public void setVisitId(int VisitId) {
        this.VisitId = VisitId;
    }

    public int getDoctorId() {
        return DoctorId;
    }

    public void setDoctorId(int DoctorId) {
        this.DoctorId = DoctorId;
    }

    public String getNote() {
        return Note;
    }

    public void setNote(String Note) {
        this.Note = Note;
    }

    public Timestamp getCreatedAt() {
        return CreatedAt;
    }

    public void setCreatedAt(Timestamp CreatedAt) {
        this.CreatedAt = CreatedAt;
    }
}
