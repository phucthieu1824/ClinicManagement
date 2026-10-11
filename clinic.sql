-- 1. Tạo Database mới
CREATE DATABASE BetaClinic;
GO

-- 2. Chỉ định sử dụng Database vừa tạo
USE BetaClinic;
GO

-- 3. Tạo bảng Role (Vai trò phân quyền)
CREATE TABLE [Role] (
    RoleID INT PRIMARY KEY IDENTITY(1,1),
    RoleName NVARCHAR(50) NOT NULL
);
GO

-- 4. Tạo bảng Account (Gộp chung Nhân viên & Bệnh nhân)
CREATE TABLE [Account] (
    AccountID INT PRIMARY KEY IDENTITY(1,1),
    RoleID INT FOREIGN KEY REFERENCES [Role](RoleID),
    Email VARCHAR(100) UNIQUE NOT NULL, 
    Password VARCHAR(255) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    Phone VARCHAR(15) UNIQUE NOT NULL,
    Gender BIT, 
    DOB DATE,   
    Address NVARCHAR(255),
    Status BIT DEFAULT 1 
);
GO

-- 5. Bảng Specialty (Chuyên khoa)
CREATE TABLE [Specialty] (
    SpecialtyID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL
);
GO

-- 6. Bảng DoctorInfo (Thông tin riêng của Bác sĩ)
CREATE TABLE [DoctorInfo] (
    AccountID INT PRIMARY KEY FOREIGN KEY REFERENCES [Account](AccountID),
    SpecialtyID INT FOREIGN KEY REFERENCES [Specialty](SpecialtyID),
    ConsultationFee DECIMAL(10, 2) NOT NULL -- Phí khám bệnh (để Lễ tân tính tiền)
);
GO

-- 7. Bảng Medicine (Kho thuốc)
CREATE TABLE [Medicine] (
    MedicineID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Unit NVARCHAR(20) NOT NULL,        -- Đơn vị: Viên, Vỉ, Hộp, Lọ...
    Price DECIMAL(10, 2) NOT NULL,     -- Giá bán
    StockQuantity INT DEFAULT 0        -- Số lượng tồn kho
);
GO

-- 8. Bảng Visit (Phiếu khám bệnh - Lễ tân phân Chuyên khoa)
CREATE TABLE [Visit] (
    VisitID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT FOREIGN KEY REFERENCES [Account](AccountID),      -- Bệnh nhân
    SpecialtyID INT FOREIGN KEY REFERENCES [Specialty](SpecialtyID),-- Khoa do Lễ tân chọn
    DoctorID INT FOREIGN KEY REFERENCES [Account](AccountID),       -- Bác sĩ khám (mặc định NULL)
    
    VisitDate DATETIME DEFAULT GETDATE(),
    Symptoms NVARCHAR(MAX),               -- Triệu chứng (Lễ tân nhập)
    Diagnosis NVARCHAR(MAX),              -- Chẩn đoán (Bác sĩ nhập)
    
    -- Trạng thái: 'Waiting' -> 'Examining' -> 'Pending_Payment' -> 'Completed'
    Status VARCHAR(50) DEFAULT 'Waiting' 
);
GO

-- 9. Bảng PrescriptionDetail (Chi tiết đơn thuốc - Đã tinh gọn, bỏ Dosage)
CREATE TABLE [PrescriptionDetail] (
    VisitID INT FOREIGN KEY REFERENCES [Visit](VisitID),
    MedicineID INT FOREIGN KEY REFERENCES [Medicine](MedicineID),
    Quantity INT NOT NULL,                -- Số lượng thuốc kê (Dùng để tính tiền & trừ kho)
    
    PRIMARY KEY (VisitID, MedicineID)     -- Đảm bảo 1 ca khám không lặp lại cùng 1 loại thuốc
);
GO

-- 10. Bảng Bill (Hóa đơn thanh toán)
CREATE TABLE [Bill] (
    BillID INT PRIMARY KEY IDENTITY(1,1),
    VisitID INT UNIQUE FOREIGN KEY REFERENCES [Visit](VisitID), -- Quan hệ 1-1 với ca khám
    
    TotalFee DECIMAL(10, 2) NOT NULL,    -- Tổng tiền = Phí khám + Tổng tiền thuốc
    PaymentMethod VARCHAR(50),           -- 'Cash' hoặc 'VNPay'
    PaymentDate DATETIME,                -- Ngày giờ ghi nhận thanh toán thành công
    
    Status BIT DEFAULT 0                 -- 0: Chưa thanh toán, 1: Đã thanh toán
);
GO

USE BetaClinic;
GO

-- 1. Thêm dữ liệu vai trò (Role)
INSERT INTO [Role] (RoleName) VALUES 
(N'Admin'),        -- RoleID = 1
(N'Receptionist'), -- RoleID = 2
(N'Doctor'),       -- RoleID = 3
(N'Pharmacist'),   -- RoleID = 4
(N'Patient');      -- RoleID = 5
GO

-- 2. Thêm danh mục Chuyên khoa (Specialty)
INSERT INTO [Specialty] (Name) VALUES 
(N'Khoa Nội tổng hợp'),  -- SpecialtyID = 1
(N'Khoa Nhi'),           -- SpecialtyID = 2
(N'Khoa Tai Mũi Họng'),  -- SpecialtyID = 3
(N'Khoa Da liễu');       -- SpecialtyID = 4
GO

-- 3. Thêm tài khoản hệ thống & bệnh nhân (Account)
INSERT INTO [Account] (RoleID, Email, Password, FullName, Phone, Gender, DOB, Address, Status) VALUES 
-- Admin (AccountID = 1)
(1, 'admin@betaclinic.com', '123456', N'Quản Trị Viên', '0901000001', 1, '1990-01-01', N'Hà Nội', 1),

-- Lễ tân (AccountID = 2)
(2, 'letan@betaclinic.com', '123456', N'Nguyễn Thị Lễ Tân', '0901000002', 0, '1995-05-10', N'Hà Nội', 1),

-- Bác sĩ Khoa Nội (AccountID = 3)
(3, 'bs.nam@betaclinic.com', '123456', N'BS. Trần Văn Nam', '0901000003', 1, '1985-03-20', N'Hà Nội', 1),

-- Bác sĩ Khoa Nhi (AccountID = 4)
(3, 'bs.lan@betaclinic.com', '123456', N'BS. Lê Thị Lan', '0901000004', 0, '1988-11-15', N'Hà Nội', 1),

-- Dược sĩ (AccountID = 5)
(4, 'duocsi@betaclinic.com', '123456', N'Phạm Văn Dược', '0901000005', 1, '1992-08-08', N'Hà Nội', 1),

-- Bệnh nhân 1 (AccountID = 6)
(5, 'nguyenvana@gmail.com', '123456', N'Nguyễn Văn A', '0912345678', 1, '1998-04-12', N'123 Cầu Giấy, Hà Nội', 1),

-- Bệnh nhân 2 (AccountID = 7)
(5, 'tranthib@gmail.com', '123456', N'Trần Thị B', '0987654321', 0, '2001-09-25', N'456 Đống Đa, Hà Nội', 1);
GO

-- 4. Thêm phí khám & khoa cho bác sĩ (DoctorInfo)
INSERT INTO [DoctorInfo] (AccountID, SpecialtyID, ConsultationFee) VALUES 
(3, 1, 150000.00), -- BS Nam - Khoa Nội - Phí: 150.000 VNĐ
(4, 2, 200000.00); -- BS Lan - Khoa Nhi - Phí: 200.000 VNĐ
GO

-- 5. Thêm kho thuốc mẫu (Medicine)
INSERT INTO [Medicine] (Name, Unit, Price, StockQuantity) VALUES 
(N'Paracetamol 500mg', N'Viên', 1500.00, 500),
(N'Amoxicillin 500mg', N'Viên', 3000.00, 300),
(N'Siro Ho Prospan', N'Lọ', 85000.00, 50),
(N'Vitamin C 500mg', N'Viên', 1000.00, 1000),
(N'Telfast 180mg', N'Viên', 8000.00, 200);
GO

-- 6. Thêm ca khám mẫu (Visit)
-- Ca 1: Đã khám xong & thanh toán thành công (Completed)
INSERT INTO [Visit] (PatientID, SpecialtyID, DoctorID, Symptoms, Diagnosis, Status) VALUES 
(6, 1, 3, N'Đau đầu, sốt nhẹ 38 độ, mệt mỏi', N'Cảm cúm thông thường', 'Completed'); -- VisitID = 1

-- Ca 2: Bệnh nhân mới check-in tại quầy, đang chờ bác sĩ gọi (Waiting)
INSERT INTO [Visit] (PatientID, SpecialtyID, DoctorID, Symptoms, Diagnosis, Status) VALUES 
(7, 2, NULL, N'Sốt cao, ho hắng kéo dài 2 ngày', NULL, 'Waiting'); -- VisitID = 2
GO

-- 7. Thêm chi tiết đơn thuốc cho VisitID = 1 (PrescriptionDetail)
INSERT INTO [PrescriptionDetail] (VisitID, MedicineID, Quantity) VALUES 
(1, 1, 10), -- Paracetamol x 10 viên (15.000 VNĐ)
(1, 4, 10); -- Vitamin C x 10 viên (10.000 VNĐ)
GO

-- 8. Thêm hóa đơn cho VisitID = 1 (Bill)
-- Tổng tiền = Phí khám Khoa Nội (150.000) + Thuốc (25.000) = 175.000 VNĐ
INSERT INTO [Bill] (VisitID, TotalFee, PaymentMethod, PaymentDate, Status) VALUES 
(1, 175000.00, 'VNPay', GETDATE(), 1);
GO