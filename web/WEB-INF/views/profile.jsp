v<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/header.jsp" />

<div class="d-flex flex-column flex-md-row min-vh-100">
    <!-- Sidebar Responsive -->
    <jsp:include page="/WEB-INF/views/sidebar.jsp" />

    <!-- Nội dung chính -->
    <div class="flex-grow-1 bg-light">
        <jsp:include page="/WEB-INF/views/topnav.jsp" />

        <div class="container-fluid p-3 p-md-4">
            <!-- Header Tiêu đề -->
            <div class="mb-4">
                <h3 class="fw-bold text-primary mb-1">
                    <i class="fa-solid fa-id-card me-2"></i>Hồ Sơ Cá Nhân
                </h3>
                <p class="text-muted mb-0 small">Quản lý thông tin tài khoản và đổi mật khẩu hệ thống.</p>
            </div>

            <!-- Thông báo thành công / thất bại -->
            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show shadow-sm mb-4" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show shadow-sm mb-4" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Bố cục Grid Responsive -->
            <div class="row g-4">
                
                <!-- Cột trái: Avatar & Thông tin tổng quan -->
                <div class="col-12 col-lg-4">
                    <div class="card shadow-sm border-0 text-center p-3 h-100">
                        <div class="card-body d-flex flex-column align-items-center justify-content-center">
                            <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center mb-3 shadow" style="width: 100px; height: 100px; font-size: 40px;">
                                <i class="fa-solid fa-user-doctor"></i>
                            </div>
                            <h5 class="fw-bold text-dark mb-1">${user.fullName}</h5>
                            <p class="badge bg-primary-subtle text-primary border border-primary mb-3">@${user.username}</p>
                            
                            <hr class="w-100 text-muted">

                            <div class="w-100 text-start small">
                                <div class="mb-2">
                                    <strong class="text-muted"><i class="fa-solid fa-shield-halved me-2"></i>Vai trò:</strong> 
                                    <span class="fw-semibold text-dark">
                                        <c:choose>
                                            <c:when test="${not empty user.roleName}">${user.roleName}</c:when>
                                            <c:when test="${user.roleId == 1}">Quản Trị Viên</c:when>
                                            <c:otherwise>Nhân viên</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="mb-2">
                                    <strong class="text-muted"><i class="fa-solid fa-envelope me-2"></i>Email:</strong> 
                                    <span class="text-dark">${empty user.email ? 'Chưa cập nhật' : user.email}</span>
                                </div>
                                <div>
                                    <strong class="text-muted"><i class="fa-solid fa-phone me-2"></i>SĐT:</strong> 
                                    <span class="text-dark">${empty user.phone ? 'Chưa cập nhật' : user.phone}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Cột phải: Form cập nhật thông tin & Đổi mật khẩu -->
                <div class="col-12 col-lg-8">
                    
                    <!-- Card 1: Cập nhật thông tin cá nhân -->
                    <div class="card shadow-sm border-0 mb-4">
                        <div class="card-header bg-white py-3">
                            <h5 class="card-title fw-bold text-primary mb-0">
                                <i class="fa-solid fa-user-pen me-2"></i>Cập Nhật Thông Tin Profile
                            </h5>
                        </div>
                        <div class="card-body p-4">
                            <form action="${pageContext.request.contextPath}/profile" method="POST">
                                <!-- Chú ý: action = updateInfo khớp với ProfileController -->
                                <input type="hidden" name="action" value="updateInfo">
                                
                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Tên đăng nhập (Username)</label>
                                    <input type="text" class="form-control bg-light" value="${user.username}" readonly>
                                    <div class="form-text">Tài khoản đăng nhập không thể thay đổi.</div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Họ và Tên <span class="text-danger">*</span></label>
                                    <input type="text" name="fullName" class="form-control" value="${user.fullName}" required>
                                </div>

                                <div class="row g-3 mb-3">
                                    <div class="col-12 col-md-6">
                                        <label class="form-label fw-semibold">Số Điện Thoại</label>
                                        <input type="text" name="phone" class="form-control" value="${user.phone}" placeholder="0901234567">
                                    </div>
                                    <div class="col-12 col-md-6">
                                        <label class="form-label fw-semibold">Địa chỉ Email</label>
                                        <input type="email" name="email" class="form-control" value="${user.email}" placeholder="example@clinic.com">
                                    </div>
                                </div>

                                <div class="text-end mt-4">
                                    <button type="submit" class="btn btn-primary w-100 w-sm-auto">
                                        <i class="fa-solid fa-floppy-disk me-1"></i>Lưu Thay Đổi
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Card 2: Đổi mật khẩu -->
                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-white py-3">
                            <h5 class="card-title fw-bold text-danger mb-0">
                                <i class="fa-solid fa-key me-2"></i>Đổi Mật Khẩu
                            </h5>
                        </div>
                        <div class="card-body p-4">
                            <form action="${pageContext.request.contextPath}/profile" method="POST">
                                <input type="hidden" name="action" value="changePassword">

                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Mật Khẩu Hiện Tại <span class="text-danger">*</span></label>
                                    <input type="password" name="oldPassword" class="form-control" required placeholder="••••••••">
                                </div>

                                <div class="row g-3 mb-3">
                                    <div class="col-12 col-md-6">
                                        <label class="form-label fw-semibold">Mật Khẩu Mới <span class="text-danger">*</span></label>
                                        <input type="password" name="newPassword" class="form-control" required placeholder="••••••••">
                                    </div>
                                    <div class="col-12 col-md-6">
                                        <label class="form-label fw-semibold">Xác Nhận Mật Khẩu Mới <span class="text-danger">*</span></label>
                                        <input type="password" name="confirmPassword" class="form-control" required placeholder="••••••••">
                                    </div>
                                </div>

                                <div class="text-end mt-4">
                                    <button type="submit" class="btn btn-danger w-100 w-sm-auto">
                                        <i class="fa-solid fa-shield-halved me-1"></i>Đổi Mật Khẩu
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <jsp:include page="/WEB-INF/views/footer.jsp" />
    </div>
</div>