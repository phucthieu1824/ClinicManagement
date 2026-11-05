<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/header.jsp" />

<div class="d-flex flex-column flex-md-row min-vh-100">
    <jsp:include page="/WEB-INF/views/sidebar.jsp" />

    <div class="flex-grow-1 bg-light">
        <jsp:include page="/WEB-INF/views/topnav.jsp" />

        <div class="container-fluid p-3 p-md-4">
            
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show mb-3" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center border-bottom pb-3 mb-4 gap-2">
                <div>
                    <h4 class="fw-bold text-primary mb-1">
                        <i class="fa-solid fa-user-stethoscope me-2"></i>Thực Hiện Khám Bệnh
                    </h4>
                    <span class="badge bg-primary-subtle text-primary border me-2">Mã Ca Khám: #VISIT-${visit.visitId}</span>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/doctor/dashboard" class="btn btn-outline-secondary btn-sm">
                        <i class="fa-solid fa-arrow-left me-1"></i>Quay lại hàng chờ
                    </a>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/doctor/examine" method="POST">
                <input type="hidden" name="visitId" value="${visit.visitId}">
                <input type="hidden" name="patientId" value="${visit.patientId}">

                <div class="row g-3">
                    
                    <!-- CỘT 1: THÔNG TIN BỆNH NHÂN & SINH HIỆU -->
                    <div class="col-12 col-lg-3">
                        <div class="card shadow-sm border-0 h-100">
                            <div class="card-header bg-primary text-white py-2">
                                <h6 class="card-title fw-bold mb-0">
                                    <i class="fa-solid fa-address-card me-2"></i>Thông Tin Bệnh Nhân
                                </h6>
                            </div>
                            <div class="card-body">
                                <div class="text-center mb-3">
                                    <div class="rounded-circle bg-primary-subtle text-primary d-inline-flex align-items-center justify-content-center mb-2" style="width: 55px; height: 55px; font-size: 22px;">
                                        <i class="fa-solid fa-user"></i>
                                    </div>
                                    <h5 class="fw-bold mb-0 text-dark">${visit.patientName}</h5>
                                    <span class="text-muted small">SĐT: ${visit.patientPhone}</span>
                                </div>

                                <hr class="my-2 text-muted">

                                <div class="small mb-3">
                                    <div class="mb-1"><strong class="text-muted">Giới tính:</strong> <span class="fw-semibold">${visit.gender}</span></div>
                                    <div class="mb-1"><strong class="text-muted">Ngày sinh:</strong> <span>${visit.dateOfBirth}</span></div>
                                    <c:if test="${not empty visit.allergies}">
                                        <div class="mt-2">
                                            <strong class="text-danger"><i class="fa-solid fa-triangle-exclamation me-1"></i>Tiền sử dị ứng:</strong>
                                            <div class="p-2 bg-danger-subtle text-danger border border-danger rounded mt-1">${visit.allergies}</div>
                                        </div>
                                    </c:if>
                                </div>

                                <h6 class="fw-bold text-dark border-bottom pb-1 small"><i class="fa-solid fa-heart-pulse text-danger me-1"></i>Chỉ Số Sinh Hiệu</h6>
                                <div class="row g-2 mb-3">
                                    <div class="col-6">
                                        <label class="form-label small mb-0">Cân nặng (kg)</label>
                                        <input type="number" step="0.1" name="weight" class="form-control form-control-sm" value="${visit.weight}" placeholder="VD: 65.5">
                                    </div>
                                    <div class="col-6">
                                        <label class="form-label small mb-0">Nhiệt độ (°C)</label>
                                        <input type="number" step="0.1" name="temperature" class="form-control form-control-sm" value="${visit.temperature}" placeholder="VD: 37.5">
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label small mb-0">Huyết áp (mmHg)</label>
                                        <input type="text" name="bloodPressure" class="form-control form-control-sm" value="${visit.bloodPressure}" placeholder="VD: 120/80">
                                    </div>
                                </div>

                                <button type="button" class="btn btn-outline-info btn-sm w-100" data-bs-toggle="modal" data-bs-target="#historyModal">
                                    <i class="fa-solid fa-clock-rotate-left me-1"></i>Xem Lịch Sử Lần Khám Cũ
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- CỘT 2: KHÁM & CHẨN ĐOÁN -->
                    <div class="col-12 col-lg-4">
                        <div class="card shadow-sm border-0 h-100">
                            <div class="card-header bg-white py-2 border-bottom">
                                <h6 class="card-title fw-bold text-primary mb-0">
                                    <i class="fa-solid fa-notes-medical me-2"></i>Chẩn Đoán Lâm Sàng
                                </h6>
                            </div>
                            <div class="card-body d-flex flex-column gap-3">
                                <div>
                                    <label class="form-label fw-semibold small">Triệu Chứng Bệnh Lý <span class="text-danger">*</span></label>
                                    <textarea name="symptoms" class="form-control" rows="3" placeholder="Nhập mô tả triệu chứng..." required>${visit.symptoms}</textarea>
                                </div>

                                <div>
                                    <label class="form-label fw-semibold small">Chẩn Đoán / Kết Luận Bệnh <span class="text-danger">*</span></label>
                                    <textarea name="diagnosis" class="form-control" rows="3" placeholder="Nhập kết luận bệnh lý..." required>${visit.diagnosis}</textarea>
                                </div>

                                <div>
                                    <label class="form-label fw-semibold small">Ngày Tái Khám (Nếu có)</label>
                                    <input type="date" name="revisitDate" class="form-control" value="${visit.revisitDate}">
                                </div>

                                <div>
                                    <label class="form-label fw-semibold small">Lời Dặn Dành Cho Bệnh Nhân</label>
                                    <textarea name="note" class="form-control" rows="2" placeholder="VD: Nghỉ ngơi, uống nhiều nước ấm..."></textarea>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- CỘT 3: KÊ ĐƠN THUỐC MUA NGOÀI -->
                    <div class="col-12 col-lg-5">
                        <div class="card shadow-sm border-0 h-100 d-flex flex-column">
                            <div class="card-header bg-white py-2 border-bottom d-flex justify-content-between align-items-center">
                                <h6 class="card-title fw-bold text-success mb-0">
                                    <i class="fa-solid fa-pills me-2"></i>Đơn Thuốc Chỉ Định
                                </h6>
                                <button type="button" class="btn btn-success btn-sm" onclick="addMedicineRow()">
                                    <i class="fa-solid fa-plus me-1"></i>Thêm Dòng Thuốc
                                </button>
                            </div>

                            <div class="card-body p-0 flex-grow-1 overflow-auto" style="max-height: 420px;">
                                <table class="table table-hover align-middle mb-0 small" id="prescriptionTable">
                                    <thead class="table-light">
                                        <tr>
                                            <th style="width: 35%;">Tên Thuốc</th>
                                            <th style="width: 15%;">Số Lượng</th>
                                            <th style="width: 40%;">Liều Dùng & Hướng Dẫn</th>
                                            <th style="width: 10%;" class="text-center">Xóa</th>
                                        </tr>
                                    </thead>
                                    <tbody id="prescriptionBody">
                                    </tbody>
                                </table>
                            </div>

                            <div class="p-3 bg-light border-top mt-auto">
                                <button type="submit" class="btn btn-success btn-lg w-100 fs-6 fw-bold">
                                    <i class="fa-solid fa-check-circle me-1"></i>Hoàn Tất Khám & In Đơn Thuốc
                                </button>
                            </div>
                        </div>
                    </div>

                </div>
            </form>
        </div>

        <jsp:include page="/WEB-INF/views/footer.jsp" />
    </div>
</div>

<!-- Modal xem Lịch Sử Lần Khám Cũ -->
<div class="modal fade" id="historyModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold text-primary">Lịch Sử Các Lần Khám Trước</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="table-responsive">
                    <table class="table table-bordered small">
                        <thead class="table-light">
                            <tr>
                                <th>Ngày Khám</th>
                                <th>Bác Sĩ Khám</th>
                                <th>Triệu Chứng</th>
                                <th>Chẩn Đoán</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty historyList}">
                                    <c:forEach var="h" items="${historyList}">
                                        <tr>
                                            <td><fmt:formatDate value="${h.visitDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                            <td>${h.doctorName}</td>
                                            <td>${h.symptoms}</td>
                                            <td class="fw-semibold text-primary">${h.diagnosis}</td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" class="text-center text-muted">Chưa có lịch sử khám nào trước đây.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    const medicinesData = [
        <c:forEach var="m" items="${medicineList}" varStatus="s">
            { id: ${m.medicineId}, name: "${m.medicineName}", unit: "${m.unit}", price: ${m.price}, dosage: "${m.usageInstruction}" }<c:if test="${!s.last}">,</c:if>
        </c:forEach>
    ];

    function addMedicineRow() {
        const tbody = document.getElementById("prescriptionBody");
        const rowId = Date.now();

        let selectOptions = `<option value="">-- Chọn thuốc --</option>`;
        medicinesData.forEach(m => {
            selectOptions += `<option value="${m.id}" data-price="${m.price}" data-dosage="${m.dosage}">${m.name} (${m.unit})</option>`;
        });

        const tr = document.createElement("tr");
        tr.id = `row-${rowId}`;
        tr.innerHTML = `
            <td>
                <select name="medicineId" class="form-select form-select-sm" required onchange="onMedicineSelect(this, ${rowId})">
                    ${selectOptions}
                </select>
                <input type="hidden" name="unitPrice" id="price-${rowId}" value="0">
            </td>
            <td>
                <input type="number" name="quantity" class="form-control form-control-sm text-center" value="1" min="1" required>
            </td>
            <td>
                <input type="text" name="dosage" id="dosage-${rowId}" class="form-control form-control-sm" placeholder="VD: Uống 1 viên x 2 lần/ngày" required>
            </td>
            <td class="text-center">
                <button type="button" class="btn btn-link text-danger btn-sm p-0" onclick="removeRow(${rowId})">
                    <i class="fa-solid fa-trash"></i>
                </button>
            </td>
        `;
        tbody.appendChild(tr);
    }

    function onMedicineSelect(selectElem, rowId) {
        const selectedOption = selectElem.options[selectElem.selectedIndex];
        const price = selectedOption.getAttribute("data-price") || 0;
        const defaultDosage = selectedOption.getAttribute("data-dosage") || "";

        document.getElementById(`price-${rowId}`).value = price;
        const dosageInput = document.getElementById(`dosage-${rowId}`);
        if (!dosageInput.value && defaultDosage) {
            dosageInput.value = defaultDosage;
        }
    }

    function removeRow(rowId) {
        const row = document.getElementById(`row-${rowId}`);
        if (row) row.remove();
    }

    window.onload = function() {
        addMedicineRow();
    };
</script>