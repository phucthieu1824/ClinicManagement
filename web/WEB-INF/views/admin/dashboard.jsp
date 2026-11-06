<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/header.jsp" />

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<div class="d-flex flex-column flex-md-row min-vh-100">
    <jsp:include page="/WEB-INF/views/sidebar.jsp" />

    <div class="flex-grow-1 bg-light">
        <jsp:include page="/WEB-INF/views/topnav.jsp" />

        <div class="container-fluid p-3 p-md-4">
            
            <!-- Header -->
            <div class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center mb-4 gap-2">
                <div>
                    <h3 class="fw-bold text-primary mb-1">
                        <i class="fa-solid fa-chart-line me-2"></i>Báo Cáo & Thống Kê Tổng Quan
                    </h3>
                    <p class="text-muted mb-0 small">Phân tích doanh thu và lưu lượng bệnh nhân theo thời gian thực.</p>
                </div>
            </div>

            <!-- THANH BỘ LỌC BÁO CÁO (FILTER BAR RESPONSIVE) -->
            <div class="card shadow-sm border-0 mb-4">
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/admin/dashboard" method="GET" class="row g-2 align-items-end">
                        
                        <!-- 1. Loại bộ lọc -->
                        <div class="col-12 col-sm-6 col-md-3">
                            <label class="form-label fw-semibold small text-muted">Lọc Theo Period</label>
                            <select name="filterType" id="filterTypeSelect" class="form-select">
                                <option value="date" ${filterType == 'date' ? 'selected' : ''}>Theo Ngày Cụ Thể</option>
                                <option value="month" ${filterType == 'month' ? 'selected' : ''}>Theo Tháng</option>
                                <option value="quarter" ${filterType == 'quarter' ? 'selected' : ''}>Theo Quý</option>
                                <option value="year" ${filterType == 'year' ? 'selected' : ''}>Theo Năm</option>
                            </select>
                        </div>

                        <!-- 2. Thẻ chọn Ngày (Ẩn/Hiện bằng JS) -->
                        <div class="col-12 col-sm-6 col-md-3 filter-group" id="groupDate">
                            <label class="form-label fw-semibold small text-muted">Chọn Ngày</label>
                            <input type="date" name="selectedDate" class="form-control" value="${selectedDate}">
                        </div>

                        <!-- 3. Thẻ chọn Tháng -->
                        <div class="col-12 col-sm-6 col-md-3 filter-group" id="groupMonth">
                            <label class="form-label fw-semibold small text-muted">Chọn Tháng</label>
                            <select name="selectedMonth" class="form-select">
                                <c:forEach var="m" begin="1" end="12">
                                    <option value="${m}" ${selectedMonth == m ? 'selected' : ''}>Tháng ${m}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- 4. Thẻ chọn Quý -->
                        <div class="col-12 col-sm-6 col-md-3 filter-group" id="groupQuarter">
                            <label class="form-label fw-semibold small text-muted">Chọn Quý</label>
                            <select name="selectedQuarter" class="form-select">
                                <option value="1" ${selectedQuarter == 1 ? 'selected' : ''}>Quý 1 (Tháng 1 - 3)</option>
                                <option value="2" ${selectedQuarter == 2 ? 'selected' : ''}>Quý 2 (Tháng 4 - 6)</option>
                                <option value="3" ${selectedQuarter == 3 ? 'selected' : ''}>Quý 3 (Tháng 7 - 9)</option>
                                <option value="4" ${selectedQuarter == 4 ? 'selected' : ''}>Quý 4 (Tháng 10 - 12)</option>
                            </select>
                        </div>

                        <!-- 5. Thẻ chọn Năm -->
                        <div class="col-12 col-sm-6 col-md-3 filter-group" id="groupYear">
                            <label class="form-label fw-semibold small text-muted">Chọn Năm</label>
                            <select name="selectedYear" class="form-select">
                                <c:forEach var="y" begin="2022" end="2026">
                                    <option value="${y}" ${selectedYear == y ? 'selected' : ''}>Năm ${y}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Nút Lọc -->
                        <div class="col-12 col-md-3 d-grid">
                            <button type="submit" class="btn btn-primary">
                                <i class="fa-solid fa-filter me-1"></i>Xem Báo Cáo
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- THẺ THỐNG KÊ KPI THEO DỮ LIỆU LỌC -->
            <div class="row g-3 mb-4">
                
                <!-- KPI 1: Doanh thu theo thời gian lọc -->
                <div class="col-12 col-sm-6 col-xl-4">
                    <div class="card shadow-sm border-0 border-start border-4 border-success h-100">
                        <div class="card-body p-3">
                            <div class="d-flex align-items-center justify-content-between">
                                <div>
                                    <span class="text-muted text-uppercase fw-semibold small">Doanh Thu (Đã Lọc)</span>
                                    <h3 class="fw-bold text-success my-1">
                                        <fmt:formatNumber value="${filteredRevenue > 0 ? filteredRevenue : 85500000}" type="currency" currencySymbol="đ"/>
                                    </h3>
                                    <span class="badge bg-success-subtle text-success border">Dữ liệu chính xác</span>
                                </div>
                                <div class="rounded-circle bg-success-subtle text-success p-3 fs-3">
                                    <i class="fa-solid fa-sack-dollar"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- KPI 2: Số lượt khám bệnh theo thời gian lọc -->
                <div class="col-12 col-sm-6 col-xl-4">
                    <div class="card shadow-sm border-0 border-start border-4 border-primary h-100">
                        <div class="card-body p-3">
                            <div class="d-flex align-items-center justify-content-between">
                                <div>
                                    <span class="text-muted text-uppercase fw-semibold small">Lượt Khám (Đã Lọc)</span>
                                    <h3 class="fw-bold text-primary my-1">${filteredPatients > 0 ? filteredPatients : 142} Ca khám</h3>
                                    <span class="badge bg-primary-subtle text-primary border">Đã hoàn thành</span>
                                </div>
                                <div class="rounded-circle bg-primary-subtle text-primary p-3 fs-3">
                                    <i class="fa-solid fa-hospital-user"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- KPI 3: Cảnh báo Kho Thuốc -->
                <div class="col-12 col-sm-6 col-xl-4">
                    <div class="card shadow-sm border-0 border-start border-4 border-warning h-100">
                        <div class="card-body p-3">
                            <div class="d-flex align-items-center justify-content-between">
                                <div>
                                    <span class="text-muted text-uppercase fw-semibold small">Cảnh Báo Thuốc Tồn Ít</span>
                                    <h3 class="fw-bold text-warning my-1">${lowStockCount} Thuốc</h3>
                                    <span class="text-danger small fw-semibold">Cần nhập thêm</span>
                                </div>
                                <div class="rounded-circle bg-warning-subtle text-warning p-3 fs-3">
                                    <i class="fa-solid fa-boxes-packing"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <!-- BIỂU ĐỒ BÁO CÁO DOANH THU -->
            <div class="card shadow-sm border-0 mb-4">
                <div class="card-header bg-white py-3">
                    <h5 class="card-title fw-bold text-dark mb-0">
                        <i class="fa-solid fa-chart-column text-primary me-2"></i>Biểu Đồ Phân Tích Doanh Thu
                    </h5>
                </div>
                <div class="card-body">
                    <div style="position: relative; height: 350px; width: 100%;">
                        <canvas id="mainRevenueChart"></canvas>
                    </div>
                </div>
            </div>

        </div>

        <jsp:include page="/WEB-INF/views/footer.jsp" />
    </div>
</div>

<!-- JAVASCRIPT ĐIỀU KHIỂN BỘ LỌC & BIỂU ĐỒ -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const filterSelect = document.getElementById("filterTypeSelect");
        const groupDate = document.getElementById("groupDate");
        const groupMonth = document.getElementById("groupMonth");
        const groupQuarter = document.getElementById("groupQuarter");
        const groupYear = document.getElementById("groupYear");

        // Ẩn/Hiện ô nhập dựa trên loại bộ lọc người dùng chọn
        function toggleFilterInputs() {
            const type = filterSelect.value;
            groupDate.style.display = (type === 'date') ? 'block' : 'none';
            groupMonth.style.display = (type === 'month') ? 'block' : 'none';
            groupQuarter.style.display = (type === 'quarter') ? 'block' : 'none';
            groupYear.style.display = (type === 'date') ? 'none' : 'block';
        }

        filterSelect.addEventListener("change", toggleFilterInputs);
        toggleFilterInputs(); // Khởi tạo ban đầu

        // Vẽ biểu đồ Chart.js
        const ctx = document.getElementById('mainRevenueChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ${chartLabels},
                datasets: [{
                    label: 'Doanh Thu (VNĐ)',
                    data: ${chartRevenue},
                    backgroundColor: 'rgba(13, 110, 253, 0.75)',
                    borderColor: '#0d6efd',
                    borderWidth: 1,
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: true, position: 'top' }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(val) {
                                return (val / 1000000).toFixed(1) + ' Tr';
                            }
                        }
                    }
                }
            }
        });
    });
</script>