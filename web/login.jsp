<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Quản lý Phòng khám</title>
    <!-- Bootstrap 5 CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome Icon -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- File CSS riêng -->
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="d-flex align-items-center vh-100">

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5 col-lg-4">
                <div class="card border-0">
                    <div class="card-body p-4">
                        <div class="text-center mb-4">
                            <i class="fa-solid fa-user-doctor text-primary display-4"></i>
                            <h3 class="fw-bold mt-2">Đăng Nhập</h3>
                            <p class="text-muted small">Hệ thống Quản lý Phòng khám PRJ301</p>
                        </div>

                        <form action="LoginServlet" method="POST">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Tên đăng nhập / Email</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light"><i class="fa-solid fa-user text-muted"></i></span>
                                    <input type="text" name="username" class="form-control" placeholder="Username" required>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Mật khẩu</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light"><i class="fa-solid fa-lock text-muted"></i></span>
                                    <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Vai trò</label>
                                <select name="role" class="form-select">
                                    <option value="PATIENT">Bệnh nhân</option>
                                    <option value="DOCTOR">Bác sĩ</option>
                                    <option value="RECEPTIONIST">Lễ tân / Thu ngân</option>
                                    <option value="ADMIN">Quản trị viên (Admin)</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-primary w-100 py-2 mt-2 fw-semibold">Đăng nhập</button>
                        </form>

                        <div class="text-center mt-3">
                            <a href="index.jsp" class="text-decoration-none small text-secondary"><i class="fa-solid fa-arrow-left me-1"></i>Quay lại trang chủ</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>