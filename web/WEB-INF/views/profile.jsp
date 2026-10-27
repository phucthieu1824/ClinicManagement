<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Hồ sơ cá nhân - ClinicManagement</title>
    <!-- Include Header chung -->
    <%@ include file="header.jsp" %>
</head>
<body class="d-flex flex-column min-vh-100">

    <!-- Include Topnav chung -->
    <%@ include file="topnav.jsp" %>

    <div class="container py-4 flex-grow-1">
        
        <!-- Thông báo thành công / lỗi -->
        <c:if test="${not empty mess}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i>${mess}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="row g-4">
            <!-- Cột trái: Card thông tin tổng quan -->
            <div class="col-md-4">
                <div class="card-custom p-4 text-center">
                    <div class="mb-3">
                        <i class="fa-solid fa-circle-user text-primary display-1"></i>
                    </div>
                    <h5 class="fw-bold mb-1">${sessionScope.user.fullName}</h5>
                    <p class="text-muted mb-2">@${sessionScope.user.username}</p>
                    <span class="badge bg-primary px-3 py-2 rounded-pill text-uppercase fs-6">
                        ${sessionScope.user.role}
                    </span>
                    <hr class="my-4">
                    <div class="text-start fs-6">
                        <p class="mb-2"><i class="fa-solid fa-envelope text-muted me-2"></i>${sessionScope.user.email}</p>
                        <p class="mb-0"><i class="fa-solid fa-phone text-muted me-2"></i>${sessionScope.user.phone}</p>
                    </div>
                </div>
            </div>

            <!-- Cột phải: Form Cập nhật & Đổi mật khẩu -->
            <div class="col-md-8">
                <!-- Tab chuyển đổi -->
                <ul class="nav nav-pills mb-3" id="profileTab" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active fw-semibold" id="info-tab" data-bs-toggle="pill" data-bs-target="#info-pane" type="button" role="tab">
                            <i class="fa-solid fa-user-pen me-2"></i>Thông tin cá nhân
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link fw-semibold" id="password-tab" data-bs-toggle="pill" data-bs-target="#password-pane" type="button" role="tab">
                            <i class="fa-solid fa-key me-2"></i>Đổi mật khẩu
                        </button>
                    </li>
                </ul>

                <div class="tab-content" id="profileTabContent">
                    
                    <!-- TAB 1: Cập nhật thông tin -->
                    <div class="tab-pane fade show active" id="info-pane" role="tabpanel">
                        <div class="card-custom p-4">
                            <h6 class="fw-bold mb-3 text-primary">Cập nhật thông tin cá nhân</h6>
                            <form action="${pageContext.request.contextPath}/profile" method="POST">
                                <input type="hidden" name="action" value="updateInfo">
                                
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label fw-medium">Tên tài khoản</label>
                                        <input type="text" class="form-control bg-light" value="${sessionScope.user.username}" readonly>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-medium">Chức vụ (Role)</label>
                                        <input type="text" class="form-control bg-light" value="${sessionScope.user.role}" disabled>
                                    </div>
                                    <div class="col-md-12">
                                        <label class="form-label fw-medium">Họ và tên</label>
                                        <input type="text" name="fullName" class="form-control" value="${sessionScope.user.fullName}" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-medium">Email</label>
                                        <input type="email" name="email" class="form-control" value="${sessionScope.user.email}" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-medium">Số điện thoại</label>
                                        <input type="tel" name="phone" class="form-control" value="${sessionScope.user.phone}" required>
                                    </div>
                                </div>
                                <div class="mt-4 text-end">
                                    <button type="submit" class="btn btn-primary px-4 fw-medium">
                                        <i class="fa-solid fa-floppy-disk me-2"></i>Lưu thay đổi
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- TAB 2: Đổi mật khẩu -->
                    <div class="tab-pane fade" id="password-pane" role="tabpanel">
                        <div class="card-custom p-4">
                            <h6 class="fw-bold mb-3 text-primary">Đổi mật khẩu tài khoản</h6>
                            <form action="${pageContext.request.contextPath}/profile" method="POST">
                                <input type="hidden" name="action" value="changePassword">
                                
                                <div class="mb-3">
                                    <label class="form-label fw-medium">Mật khẩu hiện tại</label>
                                    <input type="password" name="oldPassword" class="form-control" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-medium">Mật khẩu mới</label>
                                    <input type="password" name="newPassword" class="form-control" required minlength="6">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-medium">Xác nhận mật khẩu mới</label>
                                    <input type="password" name="confirmPassword" class="form-control" required minlength="6">
                                </div>
                                <div class="mt-4 text-end">
                                    <button type="submit" class="btn btn-warning text-white px-4 fw-medium">
                                        <i class="fa-solid fa-key me-2"></i>Cập nhật mật khẩu
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <!-- Include Footer chung -->
    <%@ include file="footer.jsp" %>

</body>
</html>