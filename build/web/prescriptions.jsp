<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,model.*" %>
<%@ include file="menu.jsp" %>
<%
    List<Prescription> list = (List<Prescription>) request.getAttribute("list");
    String error = (String) request.getAttribute("error");
    boolean pending = "pending".equals(request.getAttribute("status"));
%>
<h1><%= pending ? "Đơn chờ thanh toán" : "Đơn đã hoàn thành" %></h1>
<% if (error != null) { %><p class="err"><%= error %></p><% } %>

<% if (list == null || list.isEmpty()) { %>
    <p>Chưa có đơn nào.</p>
<% } else { for (Prescription rx : list) { %>
<div class="box">
    <h3>Đơn #<%= rx.id %> – <%= rx.patientName %></h3>
    <p>Bác sĩ: <%= rx.doctorName %> | Chẩn đoán: <%= rx.diagnosis %></p>
    <table>
        <tr><th>Thuốc</th><th>Số lượng</th><th>Đơn giá</th><th>Cách dùng</th></tr>
        <% for (PrescriptionItem it : rx.items) { %>
        <tr>
            <td><%= it.name %></td>
            <td><%= it.quantity %> <%= it.unit %></td>
            <td><%= String.format("%,.0f", it.price) %> đ</td>
            <td><%= it.usage %></td>
        </tr>
        <% } %>
    </table>
    <p><b>Tổng: <%= String.format("%,.0f", rx.getTotal()) %> đ</b></p>

    <% if (pending) { %>
    <form method="post" action="prescriptions" style="display:inline">
        <input type="hidden" name="action" value="pay">
        <input type="hidden" name="id" value="<%= rx.id %>">
        <select name="method">
            <option value="CASH">Tiền mặt</option>
            <option value="TRANSFER">Chuyển khoản</option>
        </select>
        <button>Thanh toán</button>
    </form>
    <form method="post" action="prescriptions" style="display:inline" onsubmit="return confirm('Hủy đơn này? Thuốc sẽ được trả lại kho.')">
        <input type="hidden" name="action" value="cancel">
        <input type="hidden" name="id" value="<%= rx.id %>">
        <button>Hủy đơn</button>
    </form>
    <% } else { %>
    <p>Đã thanh toán bằng <%= "CASH".equals(rx.payMethod) ? "tiền mặt" : "chuyển khoản" %></p>
    <% } %>
</div>
<% } } %>
</div></body></html>