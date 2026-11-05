package controller;

import dal.AccountDAO;
import models.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class ProfileController extends HttpServlet {

    private final AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Account accUser = (Account) session.getAttribute("accUser");

        // Giả lập Admin nếu chưa đăng nhập (để test)
        if (accUser == null) {
            accUser = new Account(1, "admin", "123456", "Quản Trị Viên", "0901111222", "admin@clinic.com", 1, true);
            session.setAttribute("accUser", accUser);
        }

        request.setAttribute("user", accUser);
        request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Account accUser = (Account) session.getAttribute("accUser");

        if (accUser == null) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        String action = request.getParameter("action");

        if ("updateInfo".equals(action)) {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            accUser.setFullName(fullName);
            accUser.setEmail(email);
            accUser.setPhone(phone);

            // Gọi DAO trong package dal để cập nhật DB
            boolean isUpdated = accountDAO.updateProfile(accUser);

            if (isUpdated) {
                session.setAttribute("accUser", accUser); // Cập nhật lại session
                request.setAttribute("message", "Cập nhật thông tin cá nhân thành công!");
            } else {
                request.setAttribute("error", "Cập nhật thất bại, vui lòng thử lại!");
            }

        } else if ("changePassword".equals(action)) {
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (!oldPassword.equals(accUser.getPassword())) {
                request.setAttribute("error", "Mật khẩu hiện tại không đúng!");
            } else if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "Mật khẩu mới và Xác nhận mật khẩu không khớp!");
            } else {
                boolean isPasswordChanged = accountDAO.changePassword(accUser.getAccountId(), newPassword);
                if (isPasswordChanged) {
                    accUser.setPassword(newPassword);
                    session.setAttribute("accUser", accUser);
                    request.setAttribute("message", "Đổi mật khẩu thành công!");
                } else {
                    request.setAttribute("error", "Không thể đổi mật khẩu, vui lòng thử lại!");
                }
            }
        }

        request.setAttribute("user", accUser);
        request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
    }
}