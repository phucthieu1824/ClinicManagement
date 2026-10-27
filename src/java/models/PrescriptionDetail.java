package models;

public class PrescriptionDetail {

    public int DetailId;
    public int PrescriptionId;
    public int MedicineId;
    public int Quantity;
    public double UnitPrice;
    public String Dosage;

    public PrescriptionDetail() {
    }

    public PrescriptionDetail(int DetailId, int PrescriptionId, int MedicineId, int Quantity, double UnitPrice, String Dosage) {
        this.DetailId = DetailId;
        this.PrescriptionId = PrescriptionId;
        this.MedicineId = MedicineId;
        this.Quantity = Quantity;
        this.UnitPrice = UnitPrice;
        this.Dosage = Dosage;
    }

    public int getDetailId() {
        return DetailId;
    }

    public void setDetailId(int DetailId) {
        this.DetailId = DetailId;
    }

    public int getPrescriptionId() {
        return PrescriptionId;
    }

    public void setPrescriptionId(int PrescriptionId) {
        this.PrescriptionId = PrescriptionId;
    }

    public int getMedicineId() {
        return MedicineId;
    }

    public void setMedicineId(int MedicineId) {
        this.MedicineId = MedicineId;
    }

    public int getQuantity() {
        return Quantity;
    }

    public void setQuantity(int Quantity) {
        this.Quantity = Quantity;
    }

    public double getUnitPrice() {
        return UnitPrice;
    }

    public void setUnitPrice(double UnitPrice) {
        this.UnitPrice = UnitPrice;
    }

    public String getDosage() {
        return Dosage;
    }

    public void setDosage(String Dosage) {
        this.Dosage = Dosage;
    }
}
