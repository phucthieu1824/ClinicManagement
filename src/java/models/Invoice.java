package models;

import java.sql.Timestamp;

public class Invoice {

    public int InvoiceId;
    public int VisitId;
    public int CashierId;
    public String InvoiceType;
    public double TotalAmount;
    public String PaymentMethod;
    public String PaymentStatus;
    public String TransactionNo;
    public Timestamp CreatedAt;

    public Invoice() {
    }

    public Invoice(int InvoiceId, int VisitId, int CashierId, String InvoiceType, double TotalAmount, String PaymentMethod, String PaymentStatus, String TransactionNo, Timestamp CreatedAt) {
        this.InvoiceId = InvoiceId;
        this.VisitId = VisitId;
        this.CashierId = CashierId;
        this.InvoiceType = InvoiceType;
        this.TotalAmount = TotalAmount;
        this.PaymentMethod = PaymentMethod;
        this.PaymentStatus = PaymentStatus;
        this.TransactionNo = TransactionNo;
        this.CreatedAt = CreatedAt;
    }

    public int getInvoiceId() {
        return InvoiceId;
    }

    public void setInvoiceId(int InvoiceId) {
        this.InvoiceId = InvoiceId;
    }

    public int getVisitId() {
        return VisitId;
    }

    public void setVisitId(int VisitId) {
        this.VisitId = VisitId;
    }

    public int getCashierId() {
        return CashierId;
    }

    public void setCashierId(int CashierId) {
        this.CashierId = CashierId;
    }

    public String getInvoiceType() {
        return InvoiceType;
    }

    public void setInvoiceType(String InvoiceType) {
        this.InvoiceType = InvoiceType;
    }

    public double getTotalAmount() {
        return TotalAmount;
    }

    public void setTotalAmount(double TotalAmount) {
        this.TotalAmount = TotalAmount;
    }

    public String getPaymentMethod() {
        return PaymentMethod;
    }

    public void setPaymentMethod(String PaymentMethod) {
        this.PaymentMethod = PaymentMethod;
    }

    public String getPaymentStatus() {
        return PaymentStatus;
    }

    public void setPaymentStatus(String PaymentStatus) {
        this.PaymentStatus = PaymentStatus;
    }

    public String getTransactionNo() {
        return TransactionNo;
    }

    public void setTransactionNo(String TransactionNo) {
        this.TransactionNo = TransactionNo;
    }

    public Timestamp getCreatedAt() {
        return CreatedAt;
    }

    public void setCreatedAt(Timestamp CreatedAt) {
        this.CreatedAt = CreatedAt;
    }
}
