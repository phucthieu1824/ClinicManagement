<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đơn Thuốc - ${visit.patientName}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI', Arial, sans-serif; }
        .prescription-box { max-width: 750px; margin: 30px auto; background: #fff; padding: 40px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        @media print {
            .no-print { display: none !important; }
            .prescription-box { box-shadow: none !important; margin: 0 !important; padding: 20px !important; max-width: 100% !important; }
            body { background: #fff !important; }
        }
    </style>
</head>
<body>

    <div class="container text-center mt-4 no-print">
        <button onclick="window.print()" class="btn btn-primary px-4 me-2">
            <i class="fa-solid fa-print me-2"></i>In Đơn Thuốc
        </button>
        <a href="${pageContext.request.contextPath}/doctor/dashboard" class="btn btn-outline-secondary px-4">
            <i class="fa-solid fa-arrow-left me-2"></i>Quay Về Hàng Chờ
        </a>
    </div>

    <div class="prescription-box">
        <div class="row border-bottom pb-3 mb-3">
            <div class="col-8">
                <h5 class="fw-bold text-uppercase text-primary mb-1">PHÒNG KHÁM ĐA KHOA CLINIC CARE</h5>
                <div class="small text-muted">Địa chỉ: 123 Nguyễn Trãi, Thanh Xuân, Hà Nội</div>
                <div class="small text-muted">Điện thoại cấp cứu / Đặt lịch: (024) 3838 9999</div>
            </div>
            <div class="col-4 text-end">
                <div class="fw-bold text-danger">Mã Ca: #VISIT-${visit.visitId}</div>
                <div class="small text-muted">
                    Ngày: <fmt:formatDate value="${visit.visitDate}" pattern="dd/MM/yyyy" />
                </div>
            </div>
        </div>

        <h3 class="text-center fw-bold text-uppercase my-3 tracking-wide">ĐƠN THUỐC</h3>

        <div class="row mb-3 small">
            <div class="col-7 mb-2"><strong>Họ và tên bệnh nhân:</strong> <span class="fs-6 fw-bold text-uppercase ms-1">${visit.patientName}</span></div>
            <div class="col-5 mb-2"><strong>Giới tính:</strong> ${visit.gender}</div>
            <div class="col-7 mb-2"><strong>Số điện thoại:</strong> ${visit.patientPhone}</div>
            <div class="col-5 mb-2"><strong>Cân nặng:</strong> ${not empty visit.weight ? visit.weight : '---'} kg</div>
            <div class="col-12 mb-2"><strong>Chẩn đoán bệnh:</strong> <span class="fw-semibold text-primary">${visit.diagnosis}</span></div>
            <c:if test="${not empty visit.allergies}">
                <div class="col-12 text-danger"><strong>Tiền sử dị ứng:</strong> ${visit.allergies}</div>
            </c:if>
        </div>

        <table class="table table-bordered align-middle my-3 small">
            <thead class="table-light text-center">
                <tr>
                    <th style="width: 8%;">STT</th>
                    <th style="width: 42%;">Tên Thuốc / Hàm Lượng</th>
                    <th style="width: 15%;">Số Lượng</th>
                    <th style="width: 35%;">Liều Dùng & Hướng Dẫn</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty details}">
                        <c:forEach var="d" items="${details}" varStatus="loop">
                            <tr>
                                <td class="text-center fw-bold">${loop.index + 1}</td>
                                <td>
                                    <div class="fw-bold">${d.medicineName}</div>
                                </td>
                                <td class="text-center fw-semibold">
                                    ${d.quantity} ${d.unit}
                                </td>
                                <td>${d.dosage}</td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="4" class="text-center text-muted italic">Không kê đơn thuốc kèm theo.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <div class="row mt-4 pt-2">
            <div class="col-7 small">
                <c:if test="${not empty prescription.note}">
                    <div class="mb-2"><strong>Lời dặn bác sĩ:</strong> ${prescription.note}</div>
                </c:if>
                <c:if test="${not empty visit.revisitDate}">
                    <div class="text-danger fw-bold"><i class="fa-regular fa-calendar-check me-1"></i>Hẹn tái khám ngày: <fmt:formatDate value="${visit.revisitDate}" pattern="dd/MM/yyyy" /></div>
                </c:if>
                <div class="mt-3 text-muted fst-italic" style="font-size: 11px;">
                    * Lưu ý: Đơn thuốc có giá trị mua tại các nhà thuốc đạt chuẩn GPP.
                </div>
            </div>
            
            <div class="col-5 text-center small">
                <div class="text-muted">Hà Nội, Ngày <fmt:formatDate value="${visit.visitDate}" pattern="dd" /> tháng <fmt:formatDate value="${visit.visitDate}" pattern="MM" /> năm <fmt:formatDate value="${visit.visitDate}" pattern="yyyy" /></div>
                <div class="fw-bold mt-1">BÁC SĨ KHÁM BỆNH</div>
                <div style="height: 60px;"></div>
                <div class="fw-bold text-uppercase text-primary">${visit.doctorName}</div>
            </div>
        </div>

    </div>

</body>
</html>