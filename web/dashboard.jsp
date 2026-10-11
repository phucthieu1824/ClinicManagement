<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng Điều Khiển - Phòng Khám PRJ301</title>
    <!-- Bootstrap 5 CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome Icon -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- File CSS Tùy biến -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <div class="wrapper">
        <!-- Sidebar Navigation -->
        <nav id="sidebar">
            <div class="sidebar-header d-flex align-items-center">
                <i class="fa-solid fa-hospital-user text-primary fs-3 me-2"></i>
                <h5 class="m-0 fw-bold text-white">ClinicSystem</h5>
            </div>

            <ul class="list-unstyled components">
                <li class="active">
                    <a href="dashboard.jsp"><i class="fa-solid fa-chart-pie"></i>Tổng quan</a>
                </li>
                <li>
                    <a href="#"><i class="fa-regular fa-calendar-check"></i>Quản lý Lịch hẹn</a>
                </li>
                <li>
                    <a href="#"><i class="fa-solid fa-user-injured"></i>Hồ sơ Bệnh nhân</a>
                </li>
                <li>
                    <a href="#"><i class="fa-solid fa-user-doctor"></i>Danh sách Bác sĩ</a>
                </li>
                <li>
                    <a href="#"><i class="fa-solid fa-capsules"></i>Quản lý Kho thuốc</a>
                </li>
                <li>
                    <a href="#"><i class="fa-solid fa-file-invoice-dollar"></i>Hóa đơn & Sandbox</a>
                </li>
                <li>
                    <a href="#"><i class="fa-solid fa-sliders"></i>Cấu hình hệ thống</a>
                </li>
            </ul>
        </nav>

        <!-- Main Content Area -->
        <div id="content">
            <!-- Top Header Bar -->
            <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
                <div>
                    <h4 class="fw-bold mb-1">Quản Lý Phòng Khám</h4>
                    <p class="text-muted small m-0">Chào mừng trở lại, Bác sĩ / Admin!</p>
                </div>
                <div class="d-flex align-items-center gap-3">
                    <button class="btn btn-light rounded-circle shadow-sm position-relative">
                        <i class="fa-regular fa-bell"></i>
                        <span class="position-absolute top-0 start-100 translate-middle p-1 bg-danger border border-light rounded-circle"></span>
                    </button>
                    <div class="d-flex align-items-center gap-2">
                        <div class="avatar-circle">AD</div>
                        <div class="d-none d-md-block">
                            <div class="fw-semibold small">Admin System</div>
                            <div class="text-muted extra-small" style="font-size: 0.75rem;">admin@clinic.com</div>
                        </div>
                    </div>
                    <a href="LogoutServlet" class="btn btn-outline-danger btn-sm ms-2"><i class="fa-solid fa-arrow-right-from-bracket"></i></a>
                </div>
            </div>

            <!-- Stats Widgets Row -->
            <div class="row g-3 mb-4">
                <div class="col-md-3">
                    <div class="card stat-card p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted small d-block">Lịch hẹn hôm nay</span>
                                <h3 class="fw-bold m-0 mt-1">24</h3>
                            </div>
                            <div class="icon-box bg-primary text-white">
                                <i class="fa-regular fa-calendar-check"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted small d-block">Bệnh nhân chờ khám</span>
                                <h3 class="fw-bold m-0 mt-1">8</h3>
                            </div>
                            <div class="icon-box bg-warning text-white">
                                <i class="fa-solid fa-clock-rotate-left"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted small d-block">Đã hoàn thành</span>
                                <h3 class="fw-bold m-0 mt-1">16</h3>
                            </div>
                            <div class="icon-box bg-success text-white">
                                <i class="fa-solid fa-circle-check"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted small d-block">Doanh thu ngày</span>
                                <h3 class="fw-bold m-0 mt-1">4.2M</h3>
                            </div>
                            <div class="icon-box bg-info text-white">
                                <i class="fa-solid fa-wallet"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Data Table Section -->
            <div class="custom-table shadow-sm">
                <div class="p-3 bg-white d-flex justify-content-between align-items-center border-bottom">
                    <h6 class="fw-bold m-0"><i class="fa-solid fa-list me-2 text-primary"></i>Danh Sách Đặt Lịch Gần Đây</h6>
                    <button class="btn btn-primary btn-sm px-3"><i class="fa-solid fa-plus me-1"></i>Tạo Lịch Khám Mới</button>
                </div>
                <div class="table-responsive">
                    <table class="table align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Mã Đặt Lịch</th>
                                <th>Bệnh Nhân</th>
                                <th>Số Điện Thoại</th>
                                <th>Chuyên Khoa</th>
                                <th>Ngày Khám</th>
                                <th>Trạng Thái</th>
                                <th class="text-end">Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="fw-bold text-primary">#LH-1092</td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle">NV</div>
                                        <div>
                                            <div class="fw-semibold">Nguyễn Văn An</div>
                                            <span class="text-muted extra-small" style="font-size: 0.75rem;">Nam • 28 tuổi</span>
                                        </div>
                                    </div>
                                </td>
                                <td>0901234567</td>
                                <td>Nội Khoa</td>
                                <td>10/10/2026 - 09:30</td>
                                <td><span class="badge badge-soft-warning px-2 py-1 rounded-pill"><i class="fa-solid fa-circle me-1 small"></i>Chờ khám</span></td>
                                <td class="text-end">
                                    <button class="btn btn-light btn-sm text-primary" title="Xem chi tiết"><i class="fa-solid fa-eye"></i></button>
                                    <button class="btn btn-light btn-sm text-success" title="Duyệt / Khám"><i class="fa-solid fa-check"></i></button>
                                    <button class="btn btn-light btn-sm text-danger" title="Hủy lịch"><i class="fa-solid fa-xmark"></i></button>
                                </td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">#LH-1093</td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-circle" style="background:#fce7f3; color:#ec4899;">TT</div>
                                        <div>
                                            <div class="fw-semibold">Trần Thị Bình</div>
                                            <span class="text-muted extra-small" style="font-size: 0.75rem;">Nữ • 34 tuổi</span>
                                        </div>
                                    </div>
                                </td>
                                <td>0988776655</td>
                                <td>Răng Hàm Mặt</td>
                                <td>10/10/2026 - 10:15</td>
                                <td><span class="badge badge-soft-success px-2 py-1 rounded-pill"><i class="fa-solid fa-circle me-1 small"></i>Đã xong</span></td>
                                <td class="text-end">
                                    <button class="btn btn-light btn-sm text-primary" title="Xem chi tiết"><i class="fa-solid fa-eye"></i></button>
                                    <button class="btn btn-light btn-sm text-success" title="Duyệt / Khám"><i class="fa-solid fa-check"></i></button>
                                    <button class="btn btn-light btn-sm text-danger" title="Hủy lịch"><i class="fa-solid fa-xmark"></i></button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>

    <!-- Bootstrap 5 JS CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>