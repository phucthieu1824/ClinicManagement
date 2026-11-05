package controller;

import dal.AccountDAO;
import models.Account;
import models.Role;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class AccountController extends HttpServlet {

    private final AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        String roleIdStr = request.getParameter("roleId");
        Integer roleId = (roleIdStr != null && !roleIdStr.trim().isEmpty()) ? Integer.parseInt(roleIdStr) : null;

        List<Account> accountList = accountDAO.getAllAccounts(keyword, roleId);
        List<Role> roleList = accountDAO.getAllRoles();

        request.setAttribute("accountList", accountList);
        request.setAttribute("roleList", roleList);
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedRoleId", roleId);

        request.getRequestDispatcher("/WEB-INF/views/admin/accounts.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                String username = request.getParameter("username");
                String pass = request.getParameter("password");
                String fullName = request.getParameter("fullName");
                String phone = request.getParameter("phone");
                String email = request.getParameter("email");
                int roleId = Integer.parseInt(request.getParameter("roleId"));

                Account acc = new Account(0, username, pass, fullName, phone, email, roleId, true);
                accountDAO.addAccount(acc);

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("accountId"));
                String fullName = request.getParameter("fullName");
                String phone = request.getParameter("phone");
                String email = request.getParameter("email");
                int roleId = Integer.parseInt(request.getParameter("roleId"));

                Account acc = new Account();
                acc.setAccountId(id);
                acc.setFullName(fullName);
                acc.setPhone(phone);
                acc.setEmail(email);
                acc.setRoleId(roleId);

                accountDAO.updateAccount(acc);

            } else if ("toggle".equals(action)) {
                int id = Integer.parseInt(request.getParameter("accountId"));
                boolean currentStatus = Boolean.parseBoolean(request.getParameter("currentStatus"));
                accountDAO.toggleAccountStatus(id, currentStatus);

            } else if ("resetPass".equals(action)) {
                int id = Integer.parseInt(request.getParameter("accountId"));
                String newPass = request.getParameter("newPassword");
                accountDAO.resetPassword(id, newPass);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Mô hình Post-Redirect-Get
        response.sendRedirect(request.getContextPath() + "/admin/accounts");
    }
}