package models;

public class Medicine {

    public int MedicineId;
    public String MedicineName;
    public String Unit;
    public double Price;
    public int StockQuantity;
    public String UsageInstruction;
    public boolean IsActive;

    public Medicine() {
    }

    public Medicine(int MedicineId, String MedicineName, String Unit, double Price, int StockQuantity, String UsageInstruction, boolean IsActive) {
        this.MedicineId = MedicineId;
        this.MedicineName = MedicineName;
        this.Unit = Unit;
        this.Price = Price;
        this.StockQuantity = StockQuantity;
        this.UsageInstruction = UsageInstruction;
        this.IsActive = IsActive;
    }

    public int getMedicineId() {
        return MedicineId;
    }

    public void setMedicineId(int MedicineId) {
        this.MedicineId = MedicineId;
    }

    public String getMedicineName() {
        return MedicineName;
    }

    public void setMedicineName(String MedicineName) {
        this.MedicineName = MedicineName;
    }

    public String getUnit() {
        return Unit;
    }

    public void setUnit(String Unit) {
        this.Unit = Unit;
    }

    public double getPrice() {
        return Price;
    }

    public void setPrice(double Price) {
        this.Price = Price;
    }

    public int getStockQuantity() {
        return StockQuantity;
    }

    public void setStockQuantity(int StockQuantity) {
        this.StockQuantity = StockQuantity;
    }

    public String getUsageInstruction() {
        return UsageInstruction;
    }

    public void setUsageInstruction(String UsageInstruction) {
        this.UsageInstruction = UsageInstruction;
    }

    public boolean isIsActive() {
        return IsActive;
    }

    public void setIsActive(boolean IsActive) {
        this.IsActive = IsActive;
    }
}
