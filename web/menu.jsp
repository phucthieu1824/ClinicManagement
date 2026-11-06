<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Quầy dược</title>
<style>
 body{margin:0;font-family:"Segoe UI",Arial,sans-serif;background:#f3f6f4;color:#17302b;display:flex;min-height:100vh}
 .side{width:220px;background:#093a3c;padding:20px 12px;flex:none}
 .side h2{margin:0 0 20px;color:#fff;font-size:20px}
 .side a{display:block;color:#d6e6e5;text-decoration:none;padding:10px 12px;border-radius:8px;margin-bottom:4px}
 .side a:hover{background:#0d4a4c}
 .main{flex:1;padding:24px;max-width:1000px}
 table{width:100%;border-collapse:collapse;background:#fff;margin-bottom:10px}
 th,td{border:1px solid #d5e0dc;padding:8px;text-align:left}
 th{background:#e3f1ee}
 .box{background:#fff;border:1px solid #d5e0dc;border-radius:8px;padding:14px;margin-bottom:14px}
 input,select{padding:6px;margin:2px}
 button{padding:6px 12px;cursor:pointer}
 .err{color:#b3261e;font-weight:bold}
 .warn{color:#b45309}
</style>
</head>
<body>
<div class="side">
 <h2>Quầy Dược</h2>
 <a href="prescriptions?status=pending">Đơn chờ thanh toán</a>
 <a href="prescriptions?status=done">Đơn đã hoàn thành</a>
 <a href="create-prescription">Tạo đơn thuốc</a>
 <a href="medicines">Kho thuốc</a>
</div>
<div class="main">