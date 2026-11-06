package dal;

import models.Account;
import models.Role;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AccountDAO extends DBContext {

    // ------------------ SQL KHAI BÁO HẰNG SỐ (PRIVATE STATIC FINAL) ------------------
    
    // SQL Dành cho Profile Cá Nhân
    private static final String SQL_UPDATE_PROFILE = 
        "UPDATE Accounts SET FullName = ?, Email = ?, Phone = ? WHERE AccountID = ?";
    
    private static final String SQL_CHANGE_PASSWORD = 
        "UPDATE Accounts SET Password = ? WHERE AccountID = ?";

    // SQL Dành cho Admin Quản Lý Nhân Sự
    private static final String SQL_SELECT_ALL_WITH_ROLE = 
        "SELECT a.AccountID, a.Username, a.Password, a.FullName, a.Phone, a.Email, a.RoleID, a.IsActive, r.RoleName " +
        "FROM Accounts a JOIN Roles r ON a.RoleID = r.RoleID WHERE 1=1";
    
    private static final String SQL_INSERT_ACCOUNT = 
        "INSERT INTO Accounts (Username, Password, FullName, Phone, Email, RoleID, IsActive) VALUES (?, ?, ?, ?, ?, ?, 1)";
    
    private static final String SQL_UPDATE_ACCOUNT_BY_ADMIN = 
        "UPDATE Accounts SET FullName = ?, Phone = ?, Email = ?, RoleID = ? WHERE AccountID = ?";
    
    private static final String SQL_TOGGLE_STATUS = 
        "UPDATE Accounts SET IsActive = ? WHERE AccountID = ?";
    
    private static final String SQL_SELECT_ROLES = 
        "SELECT RoleID, RoleName FROM Roles";


    // =================================================================================
    // PART 1: CHỨC NĂNG HỒ SƠ CÁ NHÂN (DÙNG CHO ProfileController)
    // =================================================================================

    /**
     * Cập nhật thông tin cá nhân (Họ tên, Email, SĐT) cho user đang đăng nhập
     */
    public boolean updateProfile(Account acc) {
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_UPDATE_PROFILE)) {
            ps.setString(1, acc.getFullName());
            ps.setString(2, acc.getEmail());
            ps.setString(3, acc.getPhone());
            ps.setInt(4, acc.getAccountId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Đổi mật khẩu cá nhân / Đặt lại mật khẩu
     */
    public boolean changePassword(int accountId, String newPassword) {
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_CHANGE_PASSWORD)) {
            ps.setString(1, newPassword);
            ps.setInt(2, accountId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


    // =================================================================================
    // PART 2: CHỨC NĂNG QUẢN LÝ TÀI KHOẢN (DÙNG CHO AccountController)
    // =================================================================================

    public List<Account> getAllAccounts(String keyword, Integer roleId) {
        List<Account> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(SQL_SELECT_ALL_WITH_ROLE);

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (a.Username LIKE ? OR a.FullName LIKE ? OR a.Phone LIKE ? OR a.Email LIKE ?)");
        }
        if (roleId != null && roleId > 0) {
            sql.append(" AND a.RoleID = ?");
        }
        sql.append(" ORDER BY a.AccountID DESC");

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String pattern = "%" + keyword.trim() + "%";
                ps.setString(paramIndex++, pattern);
                ps.setString(paramIndex++, pattern);
                ps.setString(paramIndex++, pattern);
                ps.setString(paramIndex++, pattern);
            }
            if (roleId != null && roleId > 0) {
                ps.setInt(paramIndex++, roleId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Account acc = new Account(
                        rs.getInt("AccountID"),
                        rs.getString("Username"),
                        rs.getString("Password"),
                        rs.getString("FullName"),
                        rs.getString("Phone"),
                        rs.getString("Email"),
                        rs.getInt("RoleID"),
                        rs.getBoolean("IsActive")
                    );
                    acc.setRoleName(rs.getString("RoleName"));
                    list.add(acc);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Role> getAllRoles() {
        List<Role> list = new ArrayList<>();
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_SELECT_ROLES);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Role(rs.getInt("RoleID"), rs.getString("RoleName")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addAccount(Account acc) {
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_INSERT_ACCOUNT)) {
            ps.setString(1, acc.getUsername());
            ps.setString(2, acc.getPassword());
            ps.setString(3, acc.getFullName());
            ps.setString(4, acc.getPhone());
            ps.setString(5, acc.getEmail());
            ps.setInt(6, acc.getRoleId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateAccount(Account acc) {
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_UPDATE_ACCOUNT_BY_ADMIN)) {
            ps.setString(1, acc.getFullName());
            ps.setString(2, acc.getPhone());
            ps.setString(3, acc.getEmail());
            ps.setInt(4, acc.getRoleId());
            ps.setInt(5, acc.getAccountId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean toggleAccountStatus(int accountId, boolean currentStatus) {
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_TOGGLE_STATUS)) {
            ps.setBoolean(1, !currentStatus);
            ps.setInt(2, accountId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Tái sử dụng hàm changePassword cho Admin khi Reset Password
    public boolean resetPassword(int accountId, String newPassword) {
        return changePassword(accountId, newPassword);
    }
}