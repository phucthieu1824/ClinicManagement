<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="bg-dark text-white p-3 sidebar-container" style="min-width: 240px; min-height: 100vh;">
    <div class="d-flex align-items-center justify-content-between mb-3 mb-md-4">
        <a href="${pageContext.request.contextPath}/doctor/dashboard" class="text-white text-decoration-none fs-5 fw-bold">
            <i class="fa-solid fa-hospital-user text-primary me-2"></i>CLINIC SYSTEM
        </a>
        <button class="btn btn-outline-light btn-sm d-md-none" type="button" data-bs-toggle="collapse" data-bs-target="#sidebarMenu">
            <i class="fa-solid fa-bars"></i>
        </button>
    </div>
    
    <hr class="d-none d-md-block text-secondary">

    <c:set var="uri" value="${pageContext.request.requestURI}" />
    <c:set var="userRole" value="${sessionScope.accUser.roleId}" />

    <div class="collapse d-md-block" id="sidebarMenu">
        <ul class="nav nav-pills flex-column mb-auto">

            <!-- PHÂN HỆ BÁC SĨ -->
            <c:if test="${userRole == 2 || fn:contains(uri, '/doctor/')}">
                <li class="nav-item mb-1 text-uppercase text-muted small fw-bold px-2 pt-1">Bác Sĩ Khám Bệnh</li>
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/doctor/dashboard" 
                       class="nav-link text-white ${fn:contains(uri, '/doctor/dashboard') ? 'active bg-primary' : ''}">
                        <i class="fa-solid fa-clipboard-list me-2"></i>Hàng Chờ Khám
                    </a>
                </li>
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/doctor/examine" 
                       class="nav-link text-white ${fn:contains(uri, '/doctor/examine') ? 'active bg-primary' : ''}">
                        <i class="fa-solid fa-stethoscopes me-2"></i>Phòng Khám Bệnh
                    </a>
                </li>
            </c:if>

            <!-- PHÂN HỆ QUẢN TRỊ -->
            <c:if test="${userRole == 1 || fn:contains(uri, '/admin/')}">
                <c:if test="${userRole == 2 || fn:contains(uri, '/doctor/')}">
                    <hr class="text-secondary my-2">
                </c:if>
                <li class="nav-item mb-1 text-uppercase text-muted small fw-bold px-2 pt-1">Quản Trị Viên</li>
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" 
                       class="nav-link text-white ${fn:contains(uri, '/admin/dashboard') ? 'active bg-primary' : ''}">
                        <i class="fa-solid fa-chart-line me-2"></i>Dashboard Tổng Quan
                    </a>
                </li>
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/admin/medicines" 
                       class="nav-link text-white ${fn:contains(uri, '/admin/medicines') ? 'active bg-primary' : ''}">
                        <i class="fa-solid fa-pills me-2"></i>Quản Lý Kho Thuốc
                    </a>
                </li>
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/admin/accounts" 
                       class="nav-link text-white ${fn:contains(uri, '/admin/accounts') ? 'active bg-primary' : ''}">
                        <i class="fa-solid fa-users-gear me-2"></i>Quản Lý Nhân Sự
                    </a>
                </li>
            </c:if>

        </ul>
    </div>
</div>