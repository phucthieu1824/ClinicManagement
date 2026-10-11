<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Lịch Khám Bệnh</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-primary text-white text-center">
                        <h4 class="mb-0">ĐẶT LỊCH KHÁM BỆNH</h4>
                    </div>
                    <div class="card-body p-4">
                        <form action="PaymentCreate" method="POST">
                            <div class="mb-3">
                                <label class="form-label">Họ và tên bệnh nhân</label>
                                <input type="text" name="fullname" class="form-control" placeholder="Nguyễn Văn A" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Số điện thoại</label>
                                <input type="tel" name="phone" class="form-control" placeholder="0901234567" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Gói khám</label>
                                <select class="form-select" id="serviceSelect" onchange="updateAmount()">
                                    <option value="150000">Khám thường - 150.000 VNĐ</option>
                                    <option value="300000">Khám chuyên khoa - 300.000 VNĐ</option>
                                </select>
                            </div>

                            <!-- Input ẩn gửi giá tiền sang PaymentCreateController -->
                            <input type="hidden" name="amount" id="amountInput" value="150000">

                            <button type="submit" class="btn btn-success w-100 py-2 mt-3 fw-bold">
                                THANH TOÁN VNPAY
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function updateAmount() {
            var select = document.getElementById("serviceSelect");
            document.getElementById("amountInput").value = select.value;
        }
    </script>
</body>
</html>