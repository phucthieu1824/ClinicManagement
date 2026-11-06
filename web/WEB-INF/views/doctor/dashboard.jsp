<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/header.jsp" />

<div class="d-flex flex-column flex-md-row min-vh-100">
    <jsp:include page="/WEB-INF/views/sidebar.jsp" />

    <div class="flex-grow-1 bg-light">
        <jsp:include page="/WEB-INF/views/topnav.jsp" />

        <div class="container-fluid p-3 p-md-4">
            
            <c:if test="${not empty sessionScope.warningMsg}">
                <div class="alert alert-warning alert-dismissible fade show mb-3" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>${sessionScope.warningMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="warningMsg" scope="session" />
            </c:if>

            <div class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-2 mb-4">
                <div>
                    <h3 class="fw-bold text-primary mb-1">
                        <i class="fa-solid fa-clipboard-user me-2"></i>Hàng Chờ Khám Bệnh
                    </h3>
                    <p class="text-muted mb-0 small">Danh sách bệnh nhân chờ bác sĩ gọi vào khám.</p>
                </div>
            </div>

            <div class="row g-3 mb-4">
                <div class="col-12 col-sm-6 col-md-4">
                    <div class="card border-0 shadow-sm border-start border-4 border-warning">
                        <div class="card-body p-3 d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted small fw-semibold">Đang Chờ Khám</span>
                                <h3 class="fw-bold text-warning mb-0">${waitingCount}</h3>
                            </div>
                            <i class="fa-solid fa-clock fs-2 text-warning opacity-50"></i>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-md-4">
                    <div class="card border-0 shadow-sm border-start border-4 border-primary">
                        <div class="card-body p-3 d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted small fw-semibold">Đang Khám</span>
                                <h3 class="fw-bold text-primary mb-0">${examiningCount}</h3>
                            </div>
                            <i class="fa-solid fa-user-doctor fs-2 text-primary opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card shadow-sm border-0">
                <div class="card-header bg-white py-3">
                    <h5 class="card-title fw-bold text-dark mb-0">
                        <i class="fa-solid fa-list-ol me-2 text-primary"></i>Danh Sách Bệnh Nhân Tiếp Nhận
                    </h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0 text-nowrap">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-3">STT</th>
                                    <th>Mã Ca Khám</th>
                                    <th>Họ và Tên Bệnh Nhân</th>
                                    <th>Giới Tính</th>
                                    <th>Số Điện Thoại</th>
                                    <th>Triệu Chứng Ban Đầu</th>
                                    <th>Trạng Thái</th>
                                    <th class="text-center">Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty queueList}">
                                        <c:forEach var="v" items="${queueList}" varStatus="loop">
                                            <tr>
                                                <td class="ps-3 fw-bold text-primary">${loop.index + 1}</td>
                                                <td><span class="badge bg-light text-dark border">#VISIT-${v.visitId}</span></td>
                                                <td class="fw-bold text-dark">${v.patientName}</td>
                                                <td>${v.gender}</td>
                                                <td>${v.patientPhone}</td>
                                                <td class="text-truncate" style="max-width: 250px;">
                                                    ${not empty v.symptoms ? v.symptoms : 'Chưa nhập triệu chứng'}
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${v.status == 'EXAMINING'}">
                                                            <span class="badge bg-primary-subtle text-primary border border-primary">Đang khám</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-warning-subtle text-warning border border-warning">Đang chờ</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center">
                                                    <a href="${pageContext.request.contextPath}/doctor/examine?visitId=${v.visitId}" class="btn btn-sm btn-primary px-3">
                                                        <i class="fa-solid fa-stethoscopes me-1"></i>Vào Khám
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="8" class="text-center py-4 text-muted">
                                                <i class="fa-solid fa-circle-check text-success fs-3 mb-2 d-block"></i>
                                                Hiện tại không có bệnh nhân nào trong hàng chờ!
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/WEB-INF/views/footer.jsp" />
    </div>
</div>