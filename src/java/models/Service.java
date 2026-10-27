package models;

public class Service {

    public int ServiceId;
    public String ServiceName;
    public double Price;
    public String Description;
    public boolean IsActive;

    public Service() {
    }

    public Service(int ServiceId, String ServiceName, double Price, String Description, boolean IsActive) {
        this.ServiceId = ServiceId;
        this.ServiceName = ServiceName;
        this.Price = Price;
        this.Description = Description;
        this.IsActive = IsActive;
    }

    public int getServiceId() {
        return ServiceId;
    }

    public void setServiceId(int ServiceId) {
        this.ServiceId = ServiceId;
    }

    public String getServiceName() {
        return ServiceName;
    }

    public void setServiceName(String ServiceName) {
        this.ServiceName = ServiceName;
    }

    public double getPrice() {
        return Price;
    }

    public void setPrice(double Price) {
        this.Price = Price;
    }

    public String getDescription() {
        return Description;
    }

    public void setDescription(String Description) {
        this.Description = Description;
    }

    public boolean isIsActive() {
        return IsActive;
    }

    public void setIsActive(boolean IsActive) {
        this.IsActive = IsActive;
    }
}
