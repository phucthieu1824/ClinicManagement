package models;

public class VisitService {

    public int VisitServiceId;
    public int VisitId;
    public int ServiceId;
    public int Quantity;
    public double UnitPrice;
    public String Status;

    public VisitService() {
    }

    public VisitService(int VisitServiceId, int VisitId, int ServiceId, int Quantity, double UnitPrice, String Status) {
        this.VisitServiceId = VisitServiceId;
        this.VisitId = VisitId;
        this.ServiceId = ServiceId;
        this.Quantity = Quantity;
        this.UnitPrice = UnitPrice;
        this.Status = Status;
    }

    public int getVisitServiceId() {
        return VisitServiceId;
    }

    public void setVisitServiceId(int VisitServiceId) {
        this.VisitServiceId = VisitServiceId;
    }

    public int getVisitId() {
        return VisitId;
    }

    public void setVisitId(int VisitId) {
        this.VisitId = VisitId;
    }

    public int getServiceId() {
        return ServiceId;
    }

    public void setServiceId(int ServiceId) {
        this.ServiceId = ServiceId;
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

    public String getStatus() {
        return Status;
    }

    public void setStatus(String Status) {
        this.Status = Status;
    }
}
