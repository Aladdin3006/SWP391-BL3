package dal;

import entity.User;
import entity.Role;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UserDBContext extends DBContext {

    // --- CÁC PHƯƠNG THỨC CŨ CỦA BẠN (GIỮ NGUYÊN) ---
    public User getUserByAccountName(String accountName) {
        String sql = "SELECT u.userId, u.accountName, u.displayName, u.password, u.email, u.phone, "
                + "u.roleId, u.status, u.workspaceId, u.verificationCode, "
                + "r.roleId as r_roleId, r.roleName, r.roleDescription, r.status as r_status "
                + "FROM user u "
                + "LEFT JOIN role r ON u.roleId = r.roleId "
                + "WHERE u.accountName = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, accountName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapUserFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<User> getAllUsers() {
        // Có thể tái sử dụng hàm getUsersWithFilter để code gọn hơn
        return getUsersWithFilter(null, null, null, null);
    }

    public boolean checkEmailExists(String email) {
        String sql = "SELECT userId FROM user WHERE email = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void registerUser(String accountName, String password, String displayName,
                             String email, String phone, String code) {
        String sql = "INSERT INTO user (accountName, password, displayName, email, phone, "
                + "roleId, status, workspaceId, verificationCode) "
                + "VALUES (?, ?, ?, ?, ?, 3, 'inactive', 1, ?)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, accountName);
            ps.setString(2, password);
            ps.setString(3, displayName);
            ps.setString(4, email);
            ps.setString(5, phone);
            ps.setString(6, code);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean verifyAccount(String code) {
        String sql = "UPDATE user SET status = 'active', verificationCode = NULL WHERE verificationCode = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public User getUserById(int userId) {
        String sql = "SELECT u.userId, u.accountName, u.displayName, u.password, u.email, u.phone, "
                + "u.roleId, u.status, u.workspaceId, u.verificationCode, "
                + "r.roleId as r_roleId, r.roleName, r.roleDescription, r.status as r_status "
                + "FROM user u "
                + "LEFT JOIN role r ON u.roleId = r.roleId "
                + "WHERE u.userId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapUserFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateUser(User user) {
        String sql = "UPDATE user SET displayName = ?, email = ?, phone = ? WHERE userId = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getDisplayName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setInt(4, user.getUserId());
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // --- CÁC PHƯƠNG THỨC MỚI CẦN THÊM CHO CHỨC NĂNG VIEW USER LIST ---

    // 1. Lấy danh sách user có kết hợp bộ lọc (Tên, Email, Role, Status)
    public List<User> getUsersWithFilter(String searchName, String searchEmail, Integer roleId, String status) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.userId, u.accountName, u.displayName, u.password, u.email, u.phone, "
                + "u.roleId, u.status, u.workspaceId, u.verificationCode, "
                + "r.roleId as r_roleId, r.roleName, r.roleDescription, r.status as r_status "
                + "FROM user u "
                + "LEFT JOIN role r ON u.roleId = r.roleId "
                + "WHERE 1=1 ";

        List<Object> params = new ArrayList<>();

        if (searchName != null && !searchName.trim().isEmpty()) {
            sql += " AND u.displayName LIKE ?";
            params.add("%" + searchName + "%");
        }
        if (searchEmail != null && !searchEmail.trim().isEmpty()) {
            sql += " AND u.email LIKE ?";
            params.add("%" + searchEmail + "%");
        }
        if (roleId != null && roleId != 0) {
            sql += " AND u.roleId = ?";
            params.add(roleId);
        }
        if (status != null && !status.equals("all") && !status.isEmpty()) {
            sql += " AND u.status = ?";
            params.add(status);
        }

        sql += " ORDER BY u.userId ASC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapUserFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Lấy danh sách tất cả các Role (để hiển thị trong dropdown)
    public List<Role> getAllRoles() {
        List<Role> list = new ArrayList<>();
        String sql = "SELECT * FROM role";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Role role = new Role(
                        rs.getInt("roleId"),
                        rs.getString("roleName"),
                        rs.getString("roleDescription"),
                        rs.getString("status")
                );
                list.add(role);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. Cập nhật trạng thái User (Vô hiệu hóa / Kích hoạt)
    public void updateUserStatus(int userId, String newStatus) {
        String sql = "UPDATE user SET status = ? WHERE userId = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Hàm phụ trợ để map ResultSet sang User (tránh lặp code)
    private User mapUserFromResultSet(ResultSet rs) throws Exception {
        User user = new User(
                rs.getInt("userId"),
                rs.getString("accountName"),
                rs.getString("displayName"),
                rs.getString("password"),
                rs.getString("email"),
                rs.getString("phone"),
                rs.getInt("roleId"),
                rs.getString("status"),
                rs.getInt("workspaceId"),
                rs.getString("verificationCode")
        );
        if (rs.getInt("r_roleId") > 0) {
            Role role = new Role(
                    rs.getInt("r_roleId"),
                    rs.getString("roleName"),
                    rs.getString("roleDescription"),
                    rs.getString("r_status")
            );
            user.setRole(role);
        }
        return user;
    }
}