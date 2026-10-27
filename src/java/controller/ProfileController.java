package controller;

import dal.AccountDAO;
import models.Account;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ProfileController extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");

        // Chưa đăng nhập -> Chuyển về trang login index.jsp
        if (user == null) {
            RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
            rd.forward(request, response);
            return;
        }

        // Đã đăng nhập -> Forward sang trang profile.jsp
        RequestDispatcher rd = request.getRequestDispatcher("WEB-INF/views/profile.jsp");
        rd.forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");

        if (user == null) {
            RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
            rd.forward(request, response);
            return;
        }

        String action = request.getParameter("action");
        AccountDAO dao = new AccountDAO();

        if ("updateInfo".equals(action)) {
            // Lấy dữ liệu cập nhật từ view
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            // Cập nhật thuộc tính vào object user
            user.FullName = fullName;
            user.Email = email;
            user.Phone = phone;

            boolean isUpdated = dao.UpdateProfile(user);

            if (isUpdated) {
                session.setAttribute("user", user); // Đồng bộ lại session
                request.setAttribute("mess", "Cập nhật thông tin cá nhân thành công!");
            } else {
                request.setAttribute("error", "Cập nhật thất bại. Vui lòng thử lại!");
            }

        } else if ("changePassword".equals(action)) {
            // Lấy dữ liệu đổi mật khẩu
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (!user.Password.equals(oldPassword)) {
                request.setAttribute("error", "Mật khẩu hiện tại không đúng!");
            } else if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "Mật khẩu xác nhận không trùng khớp!");
            } else {
                boolean isChanged = dao.ChangePassword(user.AccountId, newPassword);

                if (isChanged) {
                    user.Password = newPassword;
                    session.setAttribute("user", user); // Đồng bộ session
                    request.setAttribute("mess", "Đổi mật khẩu thành công!");
                } else {
                    request.setAttribute("error", "Đổi mật khẩu thất bại. Vui lòng thử lại!");
                }
            }
        }

        RequestDispatcher rd = request.getRequestDispatcher("WEB-INF/views/profile.jsp");
        rd.forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "ProfileController handles profile details and password changes.";
    }
}