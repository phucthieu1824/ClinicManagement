<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,model.*" %>
<%@ include file="menu.jsp" %>
<%
    List<Medicine> list = (List<Medicine>) request.getAttribute("list");
    String error = (String) request.getAttribute("error");
%>
<h1>Kho thuốc</h1>
<% if (error != null) { %><p class="err"><%= error %></p><% } %>

<div class="box">
    <h3>Thêm loại thuốc mới</h3>
    <form method="post" action="medicines">
        <input type="hidden" name="action" value="add">
        <input name="name" placeholder="Tên thuốc" required>
        <input name="unit" placeholder="Đơn vị" size="8" required>
        <input type="number" name="price" min="1" step="any" placeholder="Giá" required>
        <input type="number" name="stock" min="0" value="0" required>
        <input name="usage" placeholder="Hướng dẫn sử dụng" size="30">
        <button>Thêm</button>
    </form>
</div>

<table>
    <tr><th>ID</th><th>Tên thuốc</th><th>Đơn vị</th><th>Giá</th><th>Tồn kho</th><th>Điều chỉnh số lượng</th><th></th></tr>
    <% if (list != null) { for (Medicine m : list) { %>
    <tr>
        <td><%= m.id %></td>
        <td><%= m.name %></td>
        <td><%= m.unit %></td>
        <td><%= String.format("%,.0f", m.price) %> đ</td>
        <td><%= m.stock %> <% if (m.stock <= 50) { %><span class="warn">(sắp hết)</span><% } %></td>
        <td>
            <form method="post" action="medicines">
                <input type="hidden" name="action" value="adjust">
                <input type="hidden" name="id" value="<%= m.id %>">
                <select name="mode">
                    <option value="add">Nhập thêm</option>
                    <option value="sub">Giảm</option>
                    <option value="set">Đặt lại</option>
                </select>
                <input type="number" name="qty" min="0" value="0" style="width:70px">
                <button>Lưu</button>
            </form>
        </td>
        <td>
            <form method="post" action="medicines" onsubmit="return confirm('Xóa thuốc này khỏi kho?')">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" value="<%= m.id %>">
                <button>Xóa</button>
            </form>
        </td>
    </tr>
    <% } } %>
</table>
</div></body></html>