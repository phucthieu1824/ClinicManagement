package models;

import java.sql.Date;
import java.sql.Timestamp;

public class Patient {

    private int patientId;
    private String fullName;
    private String phone;
    private String identityCard;
    private String gender;
    private Date dateOfBirth;
    private String address;
    private String allergies;
    private String medicalHistory;
    private String guardianName;
    private String guardianPhone;
    private String guardianRelation;
    private Timestamp createdAt;

    public Patient() {
    }

    public Patient(int patientId, String fullName, String phone, String identityCard, String gender, Date dateOfBirth, String address, String allergies, String medicalHistory, String guardianName, String guardianPhone, String guardianRelation, Timestamp createdAt) {
        this.patientId = patientId;
        this.fullName = fullName;
        this.phone = phone;
        this.identityCard = identityCard;
        this.gender = gender;
        this.dateOfBirth = dateOfBirth;
        this.address = address;
        this.allergies = allergies;
        this.medicalHistory = medicalHistory;
        this.guardianName = guardianName;
        this.guardianPhone = guardianPhone;
        this.guardianRelation = guardianRelation;
        this.createdAt = createdAt;
    }

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getIdentityCard() {
        return identityCard;
    }

    public void setIdentityCard(String identityCard) {
        this.identityCard = identityCard;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getAllergies() {
        return allergies;
    }

    public void setAllergies(String allergies) {
        this.allergies = allergies;
    }

    public String getMedicalHistory() {
        return medicalHistory;
    }

    public void setMedicalHistory(String medicalHistory) {
        this.medicalHistory = medicalHistory;
    }

    public String getGuardianName() {
        return guardianName;
    }

    public void setGuardianName(String guardianName) {
        this.guardianName = guardianName;
    }

    public String getGuardianPhone() {
        return guardianPhone;
    }

    public void setGuardianPhone(String guardianPhone) {
        this.guardianPhone = guardianPhone;
    }

    public String getGuardianRelation() {
        return guardianRelation;
    }

    public void setGuardianRelation(String guardianRelation) {
        this.guardianRelation = guardianRelation;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
