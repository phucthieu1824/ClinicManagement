<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="app-header d-flex align-items-center justify-content-between px-3 px-md-4">
    <!-- Brand Logo & Nút Hamburger Mobile -->
    <div class="d-flex align-items-center gap-2">
        <button class="btn btn-light d-lg-none border-0 fs-5" type="button" data-bs-toggle="offcanvas" data-bs-target="#sidebarOffcanvas">
            <i class="fa-solid fa-bars"></i>
        </button>
        <div class="fw-bold fs-5 text-primary d-flex align-items-center">
            <i class="fa-solid fa-hospital-user fs-4 me-2"></i>
            <span class="d-none d-sm-inline">CLINICMANAGEMENT</span>
        </div>
    </div>

    <!-- User Profile Dropdown -->
    <div class="dropdown">
        <button class="btn btn-light dropdown-toggle d-flex align-items-center gap-2 border-0 bg-transparent" type="button" data-bs-toggle="dropdown" aria-expanded="false">
            <i class="fa-solid fa-circle-user fs-4 text-secondary"></i>
            <span class="fw-semibold">${sessionScope.user != null ? sessionScope.user.fullName : 'Tài khoản'}</span>
        </button>
        <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-2">
            <li>
                <a class="dropdown-item py-2" href="${pageContext.request.contextPath}/profile">
                    <i class="fa-solid fa-id-card me-2 text-primary"></i>Hồ sơ cá nhân
                </a>
            </li>
            <li><hr class="dropdown-divider my-1"></li>
            <li>
                <a class="dropdown-item py-2 text-danger fw-medium" href="${pageContext.request.contextPath}/Logout">
                    <i class="fa-solid fa-right-from-bracket me-2"></i>Đăng xuất
                </a>
            </li>
        </ul>
    </div>
</header>