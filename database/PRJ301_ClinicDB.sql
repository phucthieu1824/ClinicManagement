CREATE DATABASE ClinicDB;
GO
USE ClinicDB;
GO

-- 1. Roles
CREATE TABLE Roles (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL
);

-- 2. Accounts
CREATE TABLE Accounts (
    AccountID INT IDENTITY(1,1) PRIMARY KEY,
    Username VARCHAR(50) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    Email VARCHAR(100),
    RoleID INT FOREIGN KEY REFERENCES Roles(RoleID),
    IsActive BIT DEFAULT 1
);

-- 3. Patients
CREATE TABLE Patients (
    PatientID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Phone VARCHAR(15) NOT NULL UNIQUE, -- Đã thêm UNIQUE chống trùng
    IdentityCard VARCHAR(20),
    Gender NVARCHAR(10),
    DateOfBirth DATE,
    Address NVARCHAR(255),
    Allergies NVARCHAR(255) NULL,
    MedicalHistory NVARCHAR(500) NULL,
    GuardianName NVARCHAR(100) NULL,
    GuardianPhone VARCHAR(15) NULL,
    GuardianRelation NVARCHAR(50) NULL,
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- 4. Services
CREATE TABLE Services (
    ServiceID INT IDENTITY(1,1) PRIMARY KEY,
    ServiceName NVARCHAR(150) NOT NULL,
    Price DECIMAL(18,2) NOT NULL,
    Description NVARCHAR(255),
    IsActive BIT DEFAULT 1
);

-- 5. Medicines
CREATE TABLE Medicines (
    MedicineID INT IDENTITY(1,1) PRIMARY KEY,
    MedicineName NVARCHAR(150) NOT NULL,
    Unit NVARCHAR(20),
    Price DECIMAL(18,2) NOT NULL,
    StockQuantity INT DEFAULT 0 CHECK (StockQuantity >= 0), -- Đã thêm CK chống âm kho
    UsageInstruction NVARCHAR(255),
    IsActive BIT DEFAULT 1
);

-- 6. Visits (Đã fix lỗi cú pháp ở UpdatedAt)
CREATE TABLE Visits (
    VisitID INT IDENTITY(1,1) PRIMARY KEY,
    PatientID INT FOREIGN KEY REFERENCES Patients(PatientID),
    DoctorID INT FOREIGN KEY REFERENCES Accounts(AccountID),
    VisitDate DATETIME DEFAULT GETDATE(),
    Symptoms NVARCHAR(500),
    Diagnosis NVARCHAR(500),
    Weight DECIMAL(5,2) NULL,        
    BloodPressure VARCHAR(20) NULL,  
    Temperature DECIMAL(4,1) NULL,   
    RevisitDate DATE NULL,           
    UpdatedAt DATETIME DEFAULT GETDATE(), -- Đã sửa dấu ; thành ,
    Status VARCHAR(30) NOT NULL DEFAULT 'WAITING'
);

-- 7. VisitServices
CREATE TABLE VisitServices (
    VisitServiceID INT IDENTITY(1,1) PRIMARY KEY,
    VisitID INT FOREIGN KEY REFERENCES Visits(VisitID),
    ServiceID INT FOREIGN KEY REFERENCES Services(ServiceID),
    Quantity INT DEFAULT 1,
    UnitPrice DECIMAL(18,2),
    Status VARCHAR(20) DEFAULT 'PENDING'
);

-- 8. Prescriptions
CREATE TABLE Prescriptions (
    PrescriptionID INT IDENTITY(1,1) PRIMARY KEY,
    VisitID INT UNIQUE FOREIGN KEY REFERENCES Visits(VisitID),
    DoctorID INT FOREIGN KEY REFERENCES Accounts(AccountID),
    Note NVARCHAR(500),
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- 9. PrescriptionDetails (Đã thêm Cascade Delete)
CREATE TABLE PrescriptionDetails (
    DetailID INT IDENTITY(1,1) PRIMARY KEY,
    PrescriptionID INT FOREIGN KEY REFERENCES Prescriptions(PrescriptionID) ON DELETE CASCADE,
    MedicineID INT FOREIGN KEY REFERENCES Medicines(MedicineID),
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(18,2) NOT NULL,
    Dosage NVARCHAR(200)
);

-- 10. Invoices
CREATE TABLE Invoices (
    InvoiceID INT IDENTITY(1,1) PRIMARY KEY,
    VisitID INT FOREIGN KEY REFERENCES Visits(VisitID),
    CashierID INT FOREIGN KEY REFERENCES Accounts(AccountID),
    InvoiceType VARCHAR(30),
    TotalAmount DECIMAL(18,2) NOT NULL,
    PaymentMethod VARCHAR(20),
    PaymentStatus VARCHAR(20) DEFAULT 'PENDING',
    TransactionNo VARCHAR(100),
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- =============================================
-- INDEXES TỐI ƯU HIỆU NĂNG TÌM KIẾM
-- =============================================
CREATE INDEX IX_Visits_Status ON Visits(Status);
CREATE INDEX IX_Visits_PatientID ON Visits(PatientID);
CREATE INDEX IX_Patients_Phone ON Patients(Phone);
CREATE INDEX IX_Invoices_VisitID ON Invoices(VisitID);
GO

-- =============================================
-- SEED DATA (DỮ LIỆU MẪU)
-- =============================================

-- 1. Roles
SET IDENTITY_INSERT Roles ON;
INSERT INTO Roles (RoleID, RoleName) VALUES 
(1, N'Quản trị viên (Admin)'),
(2, N'Bác sĩ (Doctor)'),
(3, N'Lễ tân (Receptionist)'),
(4, N'Thu ngân (Cashier)'),
(5, N'Dược sĩ (Pharmacist)'),
(6, N'Kỹ thuật viên xét nghiệm (Technician)');
SET IDENTITY_INSERT Roles OFF;
GO

-- 2. Accounts
SET IDENTITY_INSERT Accounts ON;
INSERT INTO Accounts (AccountID, Username, Password, FullName, Phone, Email, RoleID, IsActive) VALUES 
(1, 'admin', '123456', N'Quản Trị Viên', '0901111222', 'admin@clinic.com', 1, 1),
(2, 'dr_hung', '123456', N'BS. Nguyễn Văn Hùng', '0902222333', 'hungnv@clinic.com', 2, 1),
(3, 'letan1', '123456', N'Trần Thị Mai', '0903333444', 'maitt@clinic.com', 3, 1),
(4, 'thungan1', '123456', N'Lê Văn Tâm', '0904444555', 'tamlv@clinic.com', 4, 1),
(5, 'duocsi1', '123456', N'Phạm Thị Hoa', '0905555666', 'hoapt@clinic.com', 5, 1),
(6, 'pharmacist1', '123456', N'Nguyễn Thị Dược', '0906667788', 'duocst@clinic.com', 5, 1),
(7, 'tech_hung', '123456', N'Vũ Mạnh Hùng', '0907778899', 'hungkt@clinic.com', 6, 1),
(8, 'dr_phuong', '123456', N'BS. Hoàng Mai Phương', '0908889900', 'phuongbm@clinic.com', 2, 1);
SET IDENTITY_INSERT Accounts OFF;
GO

-- 3. Patients
SET IDENTITY_INSERT Patients ON;
INSERT INTO Patients (PatientID, FullName, Phone, IdentityCard, Gender, DateOfBirth, Address, Allergies, MedicalHistory, GuardianName, GuardianPhone, GuardianRelation) VALUES 
(1, N'Nguyễn Văn An', '0911111111', '001090001111', N'Nam', '1990-05-15', N'123 Cầu Giấy, Hà Nội', NULL, NULL, NULL, NULL, NULL),
(2, N'Trần Thị Bình', '0922222222', '001195002222', N'Nữ', '1995-08-20', N'456 Đống Đa, Hà Nội', NULL, NULL, NULL, NULL, NULL),
(3, N'Lê Hoàng Cường', '0933333333', '001088003333', N'Nam', '1988-11-10', N'789 Thanh Xuân, Hà Nội', NULL, NULL, NULL, NULL, NULL),
(4, N'Hoàng Văn Nam', '0912345678', '001185004567', N'Nam', '1985-07-22', N'15 Nguyễn Trãi, Hà Nội', N'Dị ứng hải sản', N'Huyết áp cao', NULL, NULL, NULL),
(5, N'Nguyễn Thị Thu Hà', '0987654321', '001198007890', N'Nữ', '1998-12-05', N'88 Ba Đình, Hà Nội', NULL, NULL, NULL, NULL, NULL),
(6, N'Cháu Đỗ Bảo An', '0933445566', NULL, N'Nữ', '2022-06-10', N'22 Tây Sơn, Hà Nội', NULL, NULL, N'Đỗ Văn Minh', '0933445566', N'Bố');
SET IDENTITY_INSERT Patients OFF;
GO

-- 4. Services
SET IDENTITY_INSERT Services ON;
INSERT INTO Services (ServiceID, ServiceName, Price, Description, IsActive) VALUES 
(1, N'Khám Nội tổng quát', 150000.00, N'Khám và tư vấn bệnh lý nội khoa', 1),
(2, N'Khám Tai Mũi Họng', 150000.00, N'Chẩn đoán bệnh lý tai mũi họng', 1),
(3, N'Siêu âm ổ bụng', 200000.00, N'Siêu âm tổng quát các cơ quan ổ bụng', 1),
(4, N'Xét nghiệm công thức máu', 100000.00, N'Phân tích các chỉ số tế bào máu', 1),
(5, N'Chụp X-Quang Phổi', 180000.00, N'Chụp X-quang kỹ thuật số lồng ngực', 1),
(6, N'Đo mật độ xương', 350000.00, N'Kiểm tra loãng xương', 1),
(7, N'Khám nhi tổng quát', 150000.00, N'Khám sức khỏe chuyên khoa nhi', 1);
SET IDENTITY_INSERT Services OFF;
GO

-- 5. Medicines
SET IDENTITY_INSERT Medicines ON;
INSERT INTO Medicines (MedicineID, MedicineName, Unit, Price, StockQuantity, UsageInstruction, IsActive) VALUES 
(1, N'Paracetamol 500mg', N'Viên', 2000.00, 500, N'Uống 1 viên khi sốt > 38.5 độ', 1),
(2, N'Amoxicillin 500mg', N'Viên', 3500.00, 300, N'Uống 1 viên/lần x 2 lần/ngày sau ăn', 1),
(3, N'Ibuprofen 400mg', N'Viên', 3000.00, 200, N'Uống 1 viên khi đau nhiều', 1),
(4, N'Siro Ho Prospan', N'Chai', 75000.00, 50, N'Uống 5ml/lần x 3 lần/ngày', 1),
(5, N'Berberin 50mg', N'Viên', 1000.00, 400, N'Uống 4 viên/lần x 2 lần/ngày', 1),
(6, N'Panadol Extra', N'Viên', 3000.00, 400, N'Uống 1-2 viên/lần khi đau đầu, sốt', 1),
(7, N'Cefuroxim 500mg', N'Viên', 6000.00, 250, N'Uống sáng 1 viên, tối 1 viên sau ăn', 1),
(8, N'Smecta', N'Gói', 5000.00, 300, N'Pha với nước ấm, uống ngày 2-3 gói', 1);
SET IDENTITY_INSERT Medicines OFF;
GO

-- 6. Visits
SET IDENTITY_INSERT Visits ON;
INSERT INTO Visits (VisitID, PatientID, DoctorID, VisitDate, Symptoms, Diagnosis, Weight, BloodPressure, Temperature, RevisitDate, Status) VALUES 
(1, 1, 2, GETDATE(), N'Sốt nhẹ, đau họng', N'Viêm họng cấp', 65.0, '120/80', 37.8, NULL, 'COMPLETED'),
(2, 2, 2, GETDATE(), N'Đau bụng vùng thượng vị', N'Viêm dạ dày nhẹ', 50.0, '110/70', 36.5, NULL, 'EXAMINING'),
(3, 4, 8, GETDATE(), N'Chóng mặt, đau đầu, mệt mỏi', N'Thiếu máu não nhẹ', 68.0, '140/90', 36.7, '2026-11-10', 'WAITING'),
(4, 5, 2, GETDATE(), N'Ho khan kéo dài, tức ngực', N'Viêm họng cấp', 52.0, '115/75', 37.2, NULL, 'COMPLETED'),
(5, 6, 2, GETDATE(), N'Sốt cao, quấy khóc', N'Sốt virus', 12.5, NULL, 38.9, '2026-11-02', 'COMPLETED');
SET IDENTITY_INSERT Visits OFF;
GO

-- 7. VisitServices
SET IDENTITY_INSERT VisitServices ON;
INSERT INTO VisitServices (VisitServiceID, VisitID, ServiceID, Quantity, UnitPrice, Status) VALUES 
(1, 1, 1, 1, 150000.00, 'COMPLETED'),
(2, 1, 2, 1, 150000.00, 'COMPLETED'),
(3, 2, 1, 1, 150000.00, 'COMPLETED'),
(4, 2, 3, 1, 200000.00, 'PENDING'),
(5, 3, 1, 1, 150000.00, 'PENDING'),
(6, 3, 4, 1, 100000.00, 'PENDING'),
(7, 4, 5, 1, 180000.00, 'COMPLETED');
SET IDENTITY_INSERT VisitServices OFF;
GO

-- 8. Prescriptions
SET IDENTITY_INSERT Prescriptions ON;
INSERT INTO Prescriptions (PrescriptionID, VisitID, DoctorID, Note, CreatedAt) VALUES 
(1, 1, 2, N'Nghỉ ngơi, uống nhiều nước ấm.', GETDATE()),
(2, 4, 2, N'Tránh nước đá, uống nhiều nước ấm.', GETDATE()),
(3, 5, 2, N'Theo dõi nhiệt độ liên tục cho bé.', GETDATE());
SET IDENTITY_INSERT Prescriptions OFF;
GO

-- 9. PrescriptionDetails
SET IDENTITY_INSERT PrescriptionDetails ON;
INSERT INTO PrescriptionDetails (DetailID, PrescriptionID, MedicineID, Quantity, UnitPrice, Dosage) VALUES 
(1, 1, 1, 10, 2000.00, N'Uống 1 viên/lần khi sốt'),
(2, 1, 2, 14, 3500.00, N'Uống 1 viên/lần x 2 lần/ngày'),
(3, 2, 6, 10, 3000.00, N'Uống 1 viên khi ho hoặc đau họng'),
(4, 2, 7, 10, 6000.00, N'Uống sáng 1 viên, tối 1 viên'),
(5, 3, 1, 5, 2000.00, N'Uống theo chỉ định khi sốt trên 38.5 độ');
SET IDENTITY_INSERT PrescriptionDetails OFF;
GO

-- 10. Invoices
SET IDENTITY_INSERT Invoices ON;
INSERT INTO Invoices (InvoiceID, VisitID, CashierID, InvoiceType, TotalAmount, PaymentMethod, PaymentStatus, TransactionNo, CreatedAt) VALUES 
(1, 1, 4, N'SERVICE_AND_MEDICINE', 369000.00, N'CASH', 'PAID', NULL, GETDATE()),
(2, 4, 5, N'SERVICE_AND_MEDICINE', 249000.00, N'TRANSFER', 'PAID', 'TXN20261026002', GETDATE()),
(3, 5, 5, N'SERVICE_AND_MEDICINE', 160000.00, N'CASH', 'PENDING', NULL, GETDATE());
SET IDENTITY_INSERT Invoices OFF;
GO