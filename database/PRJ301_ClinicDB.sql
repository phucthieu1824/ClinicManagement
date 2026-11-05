USE ClinicDB;
GO

-- 1. Khai báo biến lưu ID tự tăng
DECLARE @NewVisitID INT;
DECLARE @NewPrescriptionID INT;

-- 2. Thêm 1 ca khám đã hoàn thành (COMPLETED) cho Bệnh nhân #1 và Bác sĩ #2
INSERT INTO Visits (PatientID, DoctorID, VisitDate, Symptoms, Diagnosis, Weight, BloodPressure, Temperature, RevisitDate, Status)
VALUES (1, 2, GETDATE(), N'Ho kéo dài, đau họng, sốt nhẹ', N'Viêm phế quản cấp', 66.0, '120/80', 37.8, '2026-11-20', 'COMPLETED');

SET @NewVisitID = SCOPE_IDENTITY();

-- 3. Thêm Đơn thuốc tương ứng với Ca khám vừa tạo
INSERT INTO Prescriptions (VisitID, DoctorID, Note, CreatedAt)
VALUES (@NewPrescriptionID, @NewVisitID, 2, N'Uống nhiều nước ấm, súc họng bằng nước muối sinh lý hàng ngày.', GETDATE());

SET @NewPrescriptionID = SCOPE_IDENTITY();

-- 4. Thêm Chi tiết các thuốc được kê trong đơn (Thuốc #1 Paracetamol & Thuốc #2 Amoxicillin)
INSERT INTO PrescriptionDetails (PrescriptionID, MedicineID, Quantity, UnitPrice, Dosage)
VALUES 
(@NewPrescriptionID, 1, 10, 2000.00, N'Uống 1 viên/lần x 2 lần/ngày khi sốt > 38.5 độ'),
(@NewPrescriptionID, 2, 14, 3500.00, N'Uống 1 viên/lần x 2 lần/ngày sau ăn sáng - tối');

-- 5. Truy vấn kiểm tra ngay dữ liệu vừa thêm
SELECT 
    v.VisitID, 
    p.FullName AS PatientName, 
    acc.FullName AS DoctorName, 
    v.Symptoms, 
    v.Diagnosis, 
    v.Status, 
    pr.Note AS DoctorNote
FROM Visits v
JOIN Patients p ON v.PatientID = p.PatientID
LEFT JOIN Accounts acc ON v.DoctorID = acc.AccountID
WHERE v.VisitID = @NewVisitID;

SELECT 
    pd.DetailID, 
    m.MedicineName, 
    pd.Quantity, 
    m.Unit, 
    pd.UnitPrice, 
    pd.Dosage
FROM PrescriptionDetails pd
JOIN Medicines m ON pd.MedicineID = m.MedicineID
WHERE pd.PrescriptionID = @NewPrescriptionID;