package models;

import java.sql.Date;
import java.sql.Timestamp;

public class Visit {

    public int VisitId;
    public int PatientId;
    public int DoctorId;
    public Timestamp VisitDate;
    public String Symptoms;
    public String Diagnosis;
    public Double Weight;
    public String BloodPressure;
    public Double Temperature;
    public Date RevisitDate;
    public Timestamp UpdatedAt;
    public String Status;

    public Visit() {
    }

    public Visit(int VisitId, int PatientId, int DoctorId, Timestamp VisitDate, String Symptoms, String Diagnosis, Double Weight, String BloodPressure, Double Temperature, Date RevisitDate, Timestamp UpdatedAt, String Status) {
        this.VisitId = VisitId;
        this.PatientId = PatientId;
        this.DoctorId = DoctorId;
        this.VisitDate = VisitDate;
        this.Symptoms = Symptoms;
        this.Diagnosis = Diagnosis;
        this.Weight = Weight;
        this.BloodPressure = BloodPressure;
        this.Temperature = Temperature;
        this.RevisitDate = RevisitDate;
        this.UpdatedAt = UpdatedAt;
        this.Status = Status;
    }

    public int getVisitId() {
        return VisitId;
    }

    public void setVisitId(int VisitId) {
        this.VisitId = VisitId;
    }

    public int getPatientId() {
        return PatientId;
    }

    public void setPatientId(int PatientId) {
        this.PatientId = PatientId;
    }

    public int getDoctorId() {
        return DoctorId;
    }

    public void setDoctorId(int DoctorId) {
        this.DoctorId = DoctorId;
    }

    public Timestamp getVisitDate() {
        return VisitDate;
    }

    public void setVisitDate(Timestamp VisitDate) {
        this.VisitDate = VisitDate;
    }

    public String getSymptoms() {
        return Symptoms;
    }

    public void setSymptoms(String Symptoms) {
        this.Symptoms = Symptoms;
    }

    public String getDiagnosis() {
        return Diagnosis;
    }

    public void setDiagnosis(String Diagnosis) {
        this.Diagnosis = Diagnosis;
    }

    public Double getWeight() {
        return Weight;
    }

    public void setWeight(Double Weight) {
        this.Weight = Weight;
    }

    public String getBloodPressure() {
        return BloodPressure;
    }

    public void setBloodPressure(String BloodPressure) {
        this.BloodPressure = BloodPressure;
    }

    public Double getTemperature() {
        return Temperature;
    }

    public void setTemperature(Double Temperature) {
        this.Temperature = Temperature;
    }

    public Date getRevisitDate() {
        return RevisitDate;
    }

    public void setRevisitDate(Date RevisitDate) {
        this.RevisitDate = RevisitDate;
    }

    public Timestamp getUpdatedAt() {
        return UpdatedAt;
    }

    public void setUpdatedAt(Timestamp UpdatedAt) {
        this.UpdatedAt = UpdatedAt;
    }

    public String getStatus() {
        return Status;
    }

    public void setStatus(String Status) {
        this.Status = Status;
    }
}
