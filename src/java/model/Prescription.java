package model;

import java.util.ArrayList;
import java.util.List;

public class Prescription {
    public int id, patientId;
    public String patientName, allergies, history, doctorName, diagnosis, symptoms, note, status, payMethod;
    public List<PrescriptionItem> items = new ArrayList<>();

    public double getTotal() {
        double t = 0;
        for (PrescriptionItem i : items) t += i.price * i.quantity;
        return t;
    }
}