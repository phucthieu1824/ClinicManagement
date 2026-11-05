<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="bg-dark text-white p-3 sidebar-container">
    <!-- Logo & Nút Toggle trên Mobile -->
    <div class="d-flex align-items-center justify-content-between mb-3 mb-md-4">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="text-white text-decoration-none fs-5 fw-bold">
            <i class="fa-solid fa-hospital-user text-primary me-2"></i>CLINIC ADMIN
        </a>
        <button class="btn btn-outline-light btn-sm d-md-none" type="button" data-bs-toggle="collapse" data-bs-target="#sidebarMenu">
            <i class="fa-solid fa-bars"></i>
        </button>
    </div>
    
    <hr class="d-none d-md-block text-secondary">

    <!-- Danh sách Phân hệ Nghiệp vụ -->
    <div class="collapse d-md-block" id="sidebarMenu">
        <ul class="nav nav-pills flex-column mb-auto">
            <!-- 1. Báo cáo Tổng quan -->
            <li class="nav-item mb-1">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link text-white ${pageContext.request.requestURI.endsWith('dashboard.jsp') ? 'active bg-primary' : ''}">
                    <i class="fa-solid fa-chart-line me-2"></i>Dashboard Tổng Quan
                </a>
            </li>
            
            <!-- 2. Quản lý Kho thuốc -->
            <li class="nav-item mb-1">
                <a href="${pageContext.request.contextPath}/admin/medicines" class="nav-link text-white ${pageContext.request.requestURI.endsWith('medicines.jsp') ? 'active bg-primary' : ''}">
                    <i class="fa-solid fa-pills me-2"></i>Quản Lý Kho Thuốc
                </a>
            </li>
            
            <!-- 3. Quản lý Nhân sự -->
            <li class="nav-item mb-1">
                <a href="${pageContext.request.contextPath}/admin/accounts" class="nav-link text-white ${pageContext.request.requestURI.endsWith('accounts.jsp') ? 'active bg-primary' : ''}">
                    <i class="fa-solid fa-users-gear me-2"></i>Quản Lý Nhân Sự
                </a>
            </li>

            <!-- Sẵn sàng thêm các phân hệ tiếp theo ở đây (Bệnh nhân, Lịch hẹn, Dịch vụ...) -->
        </ul>
    </div>
</div>