<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/header.jsp" />

<div class="d-flex flex-column flex-md-row min-vh-100">
    <!-- Sidebar Responsive -->
    <jsp:include page="/WEB-INF/views/sidebar.jsp" />

    <!-- Nội dung chính -->
    <div class="flex-grow-1 bg-light">
        <jsp:include page="/WEB-INF/views/topnav.jsp" />

        <div class="container-fluid p-3 p-md-4">
            <!-- Header tiêu đề + Nút Thêm -->
            <div class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-2 mb-4">
                <div>
                    <h3 class="fw-bold text-primary mb-1">
                        <i class="fa-solid fa-pills me-2"></i>Quản Lý Kho Thuốc
                    </h3>
                    <p class="text-muted mb-0 small">Quản lý danh mục dược phẩm, tồn kho và đơn giá bán lẻ.</p>
                </div>
                <div>
                    <button type="button" class="btn btn-primary w-100 w-sm-auto" data-bs-toggle="modal" data-bs-target="#addMedicineModal">
                        <i class="fa-solid fa-plus me-1"></i>Thêm Thuốc Mới
                    </button>
                </div>
            </div>

            <!-- Thanh Tìm Kiếm Responsive -->
            <div class="card shadow-sm border-0 mb-4">
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/admin/medicines" method="GET" class="row g-2">
                        <div class="col-12 col-md-10">
                            <input type="text" name="keyword" class="form-control" placeholder="Tìm kiếm tên thuốc hoặc hướng dẫn sử dụng..." value="${keyword}">
                        </div>
                        <div class="col-12 col-md-2 d-grid">
                            <button type="submit" class="btn btn-secondary">
                                <i class="fa-solid fa-magnifying-glass me-1"></i>Tìm kiếm
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Bảng Dữ Liệu Responsive -->
            <div class="card shadow-sm border-0">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0 text-nowrap">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-3">ID</th>
                                    <th>Tên Thuốc</th>
                                    <th>Đơn Vị</th>
                                    <th>Giá Bán</th>
                                    <th>Tồn Kho</th>
                                    <th>Hướng Dẫn Sử Dụng</th>
                                    <th>Trạng Thái</th>
                                    <th class="text-center">Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="m" items="${medicineList}">
                                    <tr>
                                        <td class="ps-3 fw-bold text-muted">#${m.medicineId}</td>
                                        <td class="fw-bold text-dark">${m.medicineName}</td>
                                        <td><span class="badge bg-light text-dark border">${m.unit}</span></td>
                                        <td class="fw-bold text-success">
                                            <fmt:formatNumber value="${m.price}" type="currency" currencySymbol="VNĐ"/>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${m.stockQuantity <= 50}">
                                                    <span class="badge bg-danger">${m.stockQuantity} (Sắp hết)</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-info text-dark">${m.stockQuantity}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-muted small">${empty m.usageInstruction ? '---' : m.usageInstruction}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${m.isActive}">
                                                    <span class="badge bg-success-subtle text-success border border-success">Đang kinh doanh</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger-subtle text-danger border border-danger">Ngừng bán</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <button class="btn btn-sm btn-outline-primary me-1" data-bs-toggle="modal" data-bs-target="#editModal${m.medicineId}">
                                                <i class="fa-solid fa-pen"></i>
                                            </button>
                                            <form action="${pageContext.request.contextPath}/admin/medicines" method="POST" class="d-inline">
                                                <input type="hidden" name="action" value="toggle">
                                                <input type="hidden" name="medicineId" value="${m.medicineId}">
                                                <input type="hidden" name="currentStatus" value="${m.isActive}">
                                                <button type="submit" class="btn btn-sm ${m.isActive ? 'btn-outline-danger' : 'btn-outline-success'}">
                                                    <i class="fa-solid ${m.isActive ? 'fa-ban' : 'fa-check'}"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>

                                    <!-- Modal Edit Thuốc -->
                                    <div class="modal fade text-wrap" id="editModal${m.medicineId}" tabindex="-1">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <form action="${pageContext.request.contextPath}/admin/medicines" method="POST">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="medicineId" value="${m.medicineId}">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title fw-bold">Cập Nhật Thuốc #${m.medicineId}</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        <div class="mb-3">
                                                            <label class="form-label">Tên Thuốc</label>
                                                            <input type="text" name="medicineName" class="form-control" value="${m.medicineName}" required>
                                                        </div>
                                                        <div class="row g-2 mb-3">
                                                            <div class="col-12 col-md-6">
                                                                <label class="form-label">Đơn Vị Tính</label>
                                                                <input type="text" name="unit" class="form-control" value="${m.unit}" required>
                                                            </div>
                                                            <div class="col-12 col-md-6">
                                                                <label class="form-label">Số Lượng Tồn Kho</label>
                                                                <input type="number" name="stockQuantity" class="form-control" value="${m.stockQuantity}" required>
                                                            </div>
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label">Đơn Giá (VNĐ)</label>
                                                            <input type="number" step="0.01" name="price" class="form-control" value="${m.price}" required>
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label">Hướng Dẫn Sử Dụng</label>
                                                            <textarea name="usageInstruction" class="form-control" rows="2">${m.usageInstruction}</textarea>
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                                        <button type="submit" class="btn btn-primary">Lưu Thay Đổi</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/WEB-INF/views/footer.jsp" />
    </div>
</div>

<!-- Modal Add Thuốc Mới -->
<div class="modal fade" id="addMedicineModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/medicines" method="POST">
                <input type="hidden" name="action" value="add">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold text-primary">Thêm Thuốc Mới Vào Kho</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Tên Thuốc <span class="text-danger">*</span></label>
                        <input type="text" name="medicineName" class="form-control" placeholder="Ví dụ: Paracetamol 500mg" required>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-12 col-md-6">
                            <label class="form-label">Đơn Vị Tính <span class="text-danger">*</span></label>
                            <input type="text" name="unit" class="form-control" placeholder="Viên / Chai / Vỉ" required>
                        </div>
                        <div class="col-12 col-md-6">
                            <label class="form-label">Số Lượng Nhập <span class="text-danger">*</span></label>
                            <input type="number" name="stockQuantity" class="form-control" value="100" min="0" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Đơn Giá Bán (VNĐ) <span class="text-danger">*</span></label>
                        <input type="number" step="0.01" name="price" class="form-control" placeholder="5000" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Hướng Dẫn Sử Dụng Mặc Định</label>
                        <textarea name="usageInstruction" class="form-control" rows="2" placeholder="Uống sau ăn..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-primary">Thêm Thuốc</button>
                </div>
            </form>
        </div>
    </div>
</div>