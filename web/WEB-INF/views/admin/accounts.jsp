<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/header.jsp" />

<div class="d-flex flex-column flex-md-row min-vh-100">
    <!-- Sidebar Responsive -->
    <jsp:include page="/WEB-INF/views/sidebar.jsp" />

    <!-- Nội dung chính -->
    <div class="flex-grow-1 bg-light">
        <jsp:include page="/WEB-INF/views/topnav.jsp" />

        <div class="container-fluid p-3 p-md-4">
            <!-- Header Tiêu Đề + Nút Tạo Mới -->
            <div class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-2 mb-4">
                <div>
                    <h3 class="fw-bold text-primary mb-1">
                        <i class="fa-solid fa-users-gear me-2"></i>Quản Lý Nhân Sự & Tài Khoản
                    </h3>
                    <p class="text-muted mb-0 small">Quản lý danh sách tài khoản bác sĩ, lễ tân, thu ngân và phân quyền hệ thống.</p>
                </div>
                <div>
                    <button type="button" class="btn btn-primary w-100 w-sm-auto" data-bs-toggle="modal" data-bs-target="#addAccountModal">
                        <i class="fa-solid fa-user-plus me-1"></i>Tạo Tài Khoản Mới
                    </button>
                </div>
            </div>

            <!-- Thanh Lọc & Tìm Kiếm Responsive -->
            <div class="card shadow-sm border-0 mb-4">
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/admin/accounts" method="GET" class="row g-2">
                        <div class="col-12 col-md-6">
                            <input type="text" name="keyword" class="form-control" placeholder="Tìm kiếm theo username, họ tên, số điện thoại, email..." value="${keyword}">
                        </div>
                        <div class="col-12 col-md-4">
                            <select name="roleId" class="form-select">
                                <option value="">-- Tất cả vai trò --</option>
                                <c:forEach var="r" items="${roleList}">
                                    <option value="${r.roleId}" ${selectedRoleId == r.roleId ? 'selected' : ''}>${r.roleName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-12 col-md-2 d-grid">
                            <button type="submit" class="btn btn-secondary">
                                <i class="fa-solid fa-filter me-1"></i>Lọc
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Bảng Danh Sách Tài Khoản Responsive -->
            <div class="card shadow-sm border-0">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0 text-nowrap">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-3">ID</th>
                                    <th>Tài Khoản</th>
                                    <th>Họ và Tên</th>
                                    <th>Vai Trò</th>
                                    <th>Liên Hệ</th>
                                    <th>Trạng Thái</th>
                                    <th class="text-center">Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="a" items="${accountList}">
                                    <tr>
                                        <td class="ps-3 fw-bold text-muted">#${a.accountId}</td>
                                        <td class="fw-bold text-dark">@${a.username}</td>
                                        <td>${a.fullName}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${a.roleId == 1}"><span class="badge bg-danger">${a.roleName}</span></c:when>
                                                <c:when test="${a.roleId == 2}"><span class="badge bg-primary">${a.roleName}</span></c:when>
                                                <c:when test="${a.roleId == 3}"><span class="badge bg-info text-dark">${a.roleName}</span></c:when>
                                                <c:when test="${a.roleId == 4}"><span class="badge bg-warning text-dark">${a.roleName}</span></c:when>
                                                <c:when test="${a.roleId == 5}"><span class="badge bg-success">${a.roleName}</span></c:when>
                                                <c:otherwise><span class="badge bg-secondary">${a.roleName}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="small">
                                            <div><i class="fa-solid fa-phone me-1 text-muted"></i>${empty a.phone ? '---' : a.phone}</div>
                                            <div><i class="fa-solid fa-envelope me-1 text-muted"></i>${empty a.email ? '---' : a.email}</div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${a.isActive}">
                                                    <span class="badge bg-success-subtle text-success border border-success">Hoạt động</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger-subtle text-danger border border-danger">Bị khóa</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <button class="btn btn-sm btn-outline-primary me-1" title="Sửa thông tin" data-bs-toggle="modal" data-bs-target="#editAccModal${a.accountId}">
                                                <i class="fa-solid fa-pen"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-warning me-1" title="Reset Mật Khẩu" data-bs-toggle="modal" data-bs-target="#resetPassModal${a.accountId}">
                                                <i class="fa-solid fa-key"></i>
                                            </button>
                                            <form action="${pageContext.request.contextPath}/admin/accounts" method="POST" class="d-inline">
                                                <input type="hidden" name="action" value="toggle">
                                                <input type="hidden" name="accountId" value="${a.accountId}">
                                                <input type="hidden" name="currentStatus" value="${a.isActive}">
                                                <button type="submit" class="btn btn-sm ${a.isActive ? 'btn-outline-danger' : 'btn-outline-success'}" title="${a.isActive ? 'Khóa tài khoản' : 'Kích hoạt'}">
                                                    <i class="fa-solid ${a.isActive ? 'fa-lock' : 'fa-lock-open'}"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>

                                    <!-- Modal Sửa Thông Tin -->
                                    <div class="modal fade text-wrap" id="editAccModal${a.accountId}" tabindex="-1">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <form action="${pageContext.request.contextPath}/admin/accounts" method="POST">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="accountId" value="${a.accountId}">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title fw-bold">Sửa Tài Khoản @${a.username}</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        <div class="mb-3">
                                                            <label class="form-label">Họ và Tên</label>
                                                            <input type="text" name="fullName" class="form-control" value="${a.fullName}" required>
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label">Vai Trò</label>
                                                            <select name="roleId" class="form-select" required>
                                                                <c:forEach var="r" items="${roleList}">
                                                                    <option value="${r.roleId}" ${a.roleId == r.roleId ? 'selected' : ''}>${r.roleName}</option>
                                                                </c:forEach>
                                                            </select>
                                                        </div>
                                                        <div class="row g-2 mb-3">
                                                            <div class="col-12 col-md-6">
                                                                <label class="form-label">Số Điện Thoại</label>
                                                                <input type="text" name="phone" class="form-control" value="${a.phone}">
                                                            </div>
                                                            <div class="col-12 col-md-6">
                                                                <label class="form-label">Email</label>
                                                                <input type="email" name="email" class="form-control" value="${a.email}">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                                        <button type="submit" class="btn btn-primary">Lưu Cập Nhật</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Modal Reset Mật Khẩu -->
                                    <div class="modal fade text-wrap" id="resetPassModal${a.accountId}" tabindex="-1">
                                        <div class="modal-dialog modal-sm">
                                            <div class="modal-content">
                                                <form action="${pageContext.request.contextPath}/admin/accounts" method="POST">
                                                    <input type="hidden" name="action" value="resetPass">
                                                    <input type="hidden" name="accountId" value="${a.accountId}">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title fw-bold text-warning">Cấp Mật Khẩu Mới</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        <p class="small text-muted mb-2">Đặt lại mật khẩu cho tài khoản <strong>@${a.username}</strong>:</p>
                                                        <input type="password" name="newPassword" class="form-control" placeholder="Mật khẩu mới..." value="123456" required>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Hủy</button>
                                                        <button type="submit" class="btn btn-warning btn-sm">Xác Nhận Reset</button>
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

<!-- Modal Thêm Tài Khoản Mới -->
<div class="modal fade text-wrap" id="addAccountModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/accounts" method="POST">
                <input type="hidden" name="action" value="add">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold text-primary">Tạo Tài Khoản Nhân Sự Mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-2 mb-3">
                        <div class="col-12 col-md-6">
                            <label class="form-label">Username <span class="text-danger">*</span></label>
                            <input type="text" name="username" class="form-control" required placeholder="dr_hung">
                        </div>
                        <div class="col-12 col-md-6">
                            <label class="form-label">Mật khẩu ban đầu <span class="text-danger">*</span></label>
                            <input type="password" name="password" class="form-control" value="123456" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Họ và Tên <span class="text-danger">*</span></label>
                        <input type="text" name="fullName" class="form-control" required placeholder="BS. Nguyễn Văn A">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Vai Trò <span class="text-danger">*</span></label>
                        <select name="roleId" class="form-select" required>
                            <c:forEach var="r" items="${roleList}">
                                <option value="${r.roleId}">${r.roleName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-12 col-md-6">
                            <label class="form-label">Số Điện Thoại</label>
                            <input type="text" name="phone" class="form-control" placeholder="0901234567">
                        </div>
                        <div class="col-12 col-md-6">
                            <label class="form-label">Email</label>
                            <input type="email" name="email" class="form-control" placeholder="user@clinic.com">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">Tạo Tài Khoản</button>
                </div>
            </form>
        </div>
    </div>
</div>