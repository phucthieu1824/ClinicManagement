<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="navbar navbar-expand bg-white border-bottom shadow-sm px-3 px-md-4 py-2 sticky-top">
    <!-- Brand Title & Nút Nút Hamburger Mobile (Khớp ID #sidebarMenu) -->
    <div class="d-flex align-items-center gap-2">
        <button class="btn btn-outline-secondary d-md-none border-0 fs-5" type="button" data-bs-toggle="collapse" data-bs-target="#sidebarMenu" aria-controls="sidebarMenu" aria-expanded="false" aria-label="Toggle navigation">
            <i class="fa-solid fa-bars"></i>
        </button>
        <div class="fw-bold fs-5 text-primary d-flex align-items-center">
            <i class="fa-solid fa-hospital-user fs-4 me-2"></i>
            <span class="d-none d-sm-inline text-uppercase tracking-wide fw-extrabold">Clinic Management</span>
        </div>
    </div>

    <!-- User Profile Dropdown & Notifications -->
    <div class="d-flex align-items-center ms-auto gap-2 gap-md-3">
        
        <!-- Chuông thông báo hệ thống -->
        <div class="dropdown">
            <button class="btn btn-light rounded-circle position-relative border-0 p-2" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                <i class="fa-regular fa-bell text-secondary fs-5"></i>
                <span class="position-absolute top-0 start-100 translate-middle p-1 bg-danger border border-light rounded-circle">
                    <span class="visually-hidden">Thông báo mới</span>
                </span>
            </button>
            <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2 p-2" style="width: 280px;">
                <li class="dropdown-header fw-bold text-dark px-2">Thông báo mới</li>
                <li><hr class="dropdown-divider my-1"></li>
                <li class="px-2 py-2 small text-muted text-center">Không có thông báo mới nào.</li>
            </ul>
        </div>

        <!-- Tự động bắt cặp đối tượng user từ Session (accUser hoặc user) -->
        <c:set var="currentUser" value="${not empty sessionScope.accUser ? sessionScope.accUser : sessionScope.user}" />

        <!-- User Dropdown Menu -->
        <div class="dropdown">
            <button class="btn btn-light dropdown-toggle d-flex align-items-center gap-2 border-0 bg-transparent px-2 py-1 rounded-3" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                <!-- Avatar tự động lấy chữ cái đầu của Họ Tên -->
                <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center fw-bold shadow-sm" style="width: 36px; height: 36px; font-size: 14px;">
                    <c:choose>
                        <c:when test="${not empty currentUser.fullName}">
                            ${currentUser.fullName.substring(0, 1).toUpperCase()}
                        </c:when>
                        <c:otherwise>A</c:otherwise>
                    </c:choose>
                </div>
                
                <!-- Tên người dùng và Vai trò trên Desktop -->
                <div class="text-start d-none d-sm-block me-1">
                    <div class="fw-semibold text-dark lh-1 small">
                        ${not empty currentUser.fullName ? currentUser.fullName : 'Tài khoản'}
                    </div>
                    <div class="text-muted mt-1" style="font-size: 11px;">
                        <c:choose>
                            <c:when test="${not empty currentUser.roleName}">${currentUser.roleName}</c:when>
                            <c:when test="${currentUser.roleId == 1}">Quản trị viên</c:when>
                            <c:otherwise>Nhân viên</c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </button>

            <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2 p-1" style="min-width: 210px;">
                <!-- Thông tin rút gọn trên Mobile -->
                <li class="px-3 py-2 bg-light rounded-2 mb-1 d-sm-none">
                    <div class="fw-bold text-dark small">${not empty currentUser.fullName ? currentUser.fullName : 'Tài khoản'}</div>
                    <div class="text-muted" style="font-size: 11px;">
                        ${not empty currentUser.roleName ? currentUser.roleName : 'Nhân viên'}
                    </div>
                </li>
                
                <!-- Menu item Hồ sơ cá nhân -->
                <li>
                    <a class="dropdown-item py-2 rounded-2" href="${pageContext.request.contextPath}/profile">
                        <i class="fa-solid fa-id-card me-2 text-primary"></i>Hồ sơ cá nhân
                    </a>
                </li>
                
                <li><hr class="dropdown-divider my-1"></li>
                
                <!-- Menu item Đăng xuất -->
                <li>
                    <a class="dropdown-item py-2 text-danger fw-medium rounded-2" href="${pageContext.request.contextPath}/logout">
                        <i class="fa-solid fa-right-from-bracket me-2"></i>Đăng xuất
                    </a>
                </li>
            </ul>
        </div>

    </div>
</header>