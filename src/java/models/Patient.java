package models;

import java.sql.Date;
import java.sql.Timestamp;

public class Patient {

    public int PatientId;
    public String FullName;
    public String Phone;
    public String IdentityCard;
    public String Gender;
    public Date DateOfBirth;
    public String Address;
    public String Allergies;
    public String MedicalHistory;
    public String GuardianName;
    public String GuardianPhone;
    public String GuardianRelation;
    public Timestamp CreatedAt;

    public Patient() {
    }

    public Patient(int PatientId, String FullName, String Phone, String IdentityCard, String Gender, Date DateOfBirth, String Address, String Allergies, String MedicalHistory, String GuardianName, String GuardianPhone, String GuardianRelation, Timestamp CreatedAt) {
        this.PatientId = PatientId;
        this.FullName = FullName;
        this.Phone = Phone;
        this.IdentityCard = IdentityCard;
        this.Gender = Gender;
        this.DateOfBirth = DateOfBirth;
        this.Address = Address;
        this.Allergies = Allergies;
        this.MedicalHistory = MedicalHistory;
        this.GuardianName = GuardianName;
        this.GuardianPhone = GuardianPhone;
        this.GuardianRelation = GuardianRelation;
        this.CreatedAt = CreatedAt;
    }

    public int getPatientId() {
        return PatientId;
    }

    public void setPatientId(int PatientId) {
        this.PatientId = PatientId;
    }

    public String getFullName() {
        return FullName;
    }

    public void setFullName(String FullName) {
        this.FullName = FullName;
    }

    public String getPhone() {
        return Phone;
    }

    public void setPhone(String Phone) {
        this.Phone = Phone;
    }

    public String getIdentityCard() {
        return IdentityCard;
    }

    public void setIdentityCard(String IdentityCard) {
        this.IdentityCard = IdentityCard;
    }

    public String getGender() {
        return Gender;
    }

    public void setGender(String Gender) {
        this.Gender = Gender;
    }

    public Date getDateOfBirth() {
        return DateOfBirth;
    }

    public void setDateOfBirth(Date DateOfBirth) {
        this.DateOfBirth = DateOfBirth;
    }

    public String getAddress() {
        return Address;
    }

    public void setAddress(String Address) {
        this.Address = Address;
    }

    public String getAllergies() {
        return Allergies;
    }

    public void setAllergies(String Allergies) {
        this.Allergies = Allergies;
    }

    public String getMedicalHistory() {
        return MedicalHistory;
    }

    public void setMedicalHistory(String MedicalHistory) {
        this.MedicalHistory = MedicalHistory;
    }

    public String getGuardianName() {
        return GuardianName;
    }

    public void setGuardianName(String GuardianName) {
        this.GuardianName = GuardianName;
    }

    public String getGuardianPhone() {
        return GuardianPhone;
    }

    public void setGuardianPhone(String GuardianPhone) {
        this.GuardianPhone = GuardianPhone;
    }

    public String getGuardianRelation() {
        return GuardianRelation;
    }

    public void setGuardianRelation(String GuardianRelation) {
        this.GuardianRelation = GuardianRelation;
    }

    public Timestamp getCreatedAt() {
        return CreatedAt;
    }

    public void setCreatedAt(Timestamp CreatedAt) {
        this.CreatedAt = CreatedAt;
    }
}
