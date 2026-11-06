<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,model.*" %>
<%@ include file="menu.jsp" %>
<%
    Prescription rx = (Prescription) request.getAttribute("rx");
    List<Medicine> meds = (List<Medicine>) request.getAttribute("meds");
    String error = (String) request.getAttribute("error");
    String pid = request.getParameter("patientId");
%>
<h1>Tạo đơn thuốc</h1>

<form method="get" action="create-prescription">
    ID bệnh nhân:
    <input type="number" name="patientId" min="1" required value="<%= pid == null ? "" : pid %>">
    <button>Tìm</button>
</form>

<% if (error != null) { %><p class="err"><%= error %></p><% } %>

<% if (request.getAttribute("searched") != null && rx == null) { %>
    <p class="err">Không có đơn thuốc nào của bác sĩ đang chờ cho bệnh nhân này.</p>
<% } %>

<% if (rx != null) { %>
<div class="box">
    <p><b>Bệnh nhân:</b> <%= rx.patientName %> (ID <%= rx.patientId %>)</p>
    <p><b>Bác sĩ khám:</b> <%= rx.doctorName %></p>
    <p><b>Chẩn đoán:</b> <%= rx.diagnosis %> | <b>Triệu chứng:</b> <%= rx.symptoms %></p>
    <% if (!rx.allergies.isEmpty()) { %><p class="err">Dị ứng: <%= rx.allergies %></p><% } %>
    <% if (!rx.history.isEmpty()) { %><p class="warn">Tiền sử bệnh: <%= rx.history %></p><% } %>
    <% if (!rx.note.isEmpty()) { %><p>Lời dặn của bác sĩ: <%= rx.note %></p><% } %>
</div>

<form method="post" action="create-prescription">
    <input type="hidden" name="rxId" value="<%= rx.id %>">
    <input type="hidden" name="patientId" value="<%= rx.patientId %>">
    <table>
        <tr><th>Thuốc</th><th>Số lượng (0 = bỏ thuốc)</th><th>Cách dùng</th></tr>

        <% for (PrescriptionItem it : rx.items) { %>
        <tr>
            <td><%= it.name %> (<%= it.unit %>)<input type="hidden" name="medId" value="<%= it.medicineId %>"></td>
            <td><input type="number" name="qty" min="0" value="<%= it.quantity %>"></td>
            <td><input name="usage" size="40" value="<%= it.usage %>"></td>
        </tr>
        <% } %>

        <!-- Dòng thêm thuốc khác: nhập số lượng lớn hơn 0 để thêm -->
        <tr>
            <td>
                <select name="medId">
                    <% for (Medicine m : meds) { %>
                    <option value="<%= m.id %>"><%= m.name %> (còn <%= m.stock %>)</option>
                    <% } %>
                </select>
            </td>
            <td><input type="number" name="qty" min="0" value="0"></td>
            <td><input name="usage" size="40" placeholder="Cách dùng của thuốc thêm"></td>
        </tr>
    </table>
    <button>Tạo đơn, chuyển sang chờ thanh toán</button>
</form>
<% } %>
</div></body></html>