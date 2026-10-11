<%@page import="java.net.URLEncoder"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="controller.Config"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kết Quả Thanh Toán</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center vh-100">
    <%
        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                fields.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        fields.remove("vnp_SecureHashType");
        fields.remove("vnp_SecureHash");

        List<String> fieldNames = new ArrayList<>(fields.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = fields.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                hashData.append(fieldName).append('=').append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                if (itr.hasNext()) hashData.append('&');
            }
        }

        String signValue = Config.hmacSHA512(Config.vnp_HashSecret, hashData.toString());
        boolean checkSignature = signValue.equalsIgnoreCase(vnp_SecureHash);
        String responseCode = request.getParameter("vnp_ResponseCode");
        boolean isSuccess = checkSignature && "00".equals(responseCode);
    %>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow text-center p-4">
                    <div class="card-body">
                        <% if (isSuccess) { %>
                            <h3 class="text-success fw-bold">Thanh Toán Thành Công!</h3>
                            <p class="text-muted">Lịch hẹn của bạn đã được xác nhận.</p>
                        <% } else { %>
                            <h3 class="text-danger fw-bold">Thanh Toán Thất Bại!</h3>
                            <p class="text-muted">Giao dịch không thành công hoặc bị hủy.</p>
                        <% } %>

                        <ul class="list-group text-start my-4">
                            <li class="list-group-item d-flex justify-content-between">
                                <span>Mã giao dịch:</span>
                                <strong><%= request.getParameter("vnp_TxnRef") %></strong>
                            </li>
                            <li class="list-group-item d-flex justify-content-between">
                                <span>Số tiền:</span>
                                <strong><%= String.format("%,d", Long.parseLong(request.getParameter("vnp_Amount")) / 100) %> VNĐ</strong>
                            </li>
                        </ul>

                        <a href="index.jsp" class="btn btn-primary">Quay lại trang chủ</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>