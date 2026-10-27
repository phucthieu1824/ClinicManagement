package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import models.Account;

public class AccountDAO extends DBContext {

    /**
     * Lấy thông tin tài khoản theo Username (Phục vụ LoginController)
     */
    public Account GetAccountById(String username) {
        String sql = "SELECT AccountID, Username, Password, FullName, Phone, Email, RoleID, IsActive "
                   + "FROM Accounts WHERE Username = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Account(
                    rs.getInt("AccountID"),
                    rs.getString("Username"),
                    rs.getString("Password"),
                    rs.getString("FullName"),
                    rs.getString("Phone"),
                    rs.getString("Email"),
                    rs.getInt("RoleID"),
                    rs.getBoolean("IsActive")
                );
            }
        } catch (SQLException e) {
            System.out.println("Error GetAccountById: " + e.getMessage());
        }
        return null;
    }

    /**
     * Cập nhật thông tin cá nhân (FullName, Phone, Email) từ trang Profile
     */
    public boolean UpdateProfile(Account user) {
        String sql = "UPDATE Accounts SET FullName = ?, Phone = ?, Email = ? WHERE AccountID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, user.FullName);
            ps.setString(2, user.Phone);
            ps.setString(3, user.Email);
            ps.setInt(4, user.AccountId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error UpdateProfile: " + e.getMessage());
        }
        return false;
    }

    /**
     * Đổi mật khẩu tài khoản
     */
    public boolean ChangePassword(int accountId, String newPassword) {
        String sql = "UPDATE Accounts SET Password = ? WHERE AccountID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, newPassword);
            ps.setInt(2, accountId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error ChangePassword: " + e.getMessage());
        }
        return false;
    }
}