package dal;

import entity.User;
import entity.Role;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class UserDAO extends DBContext {

    public User getUserByAccountName(String accountName) {
        String sql = "SELECT u.userId, u.accountName, u.displayName, u.password, u.email, u.phone, "
                + "u.roleId, u.status, u.departmentId, u.verificationCode, "
                + "r.roleId as r_roleId, r.roleName, r.roleDescription, r.status as r_status "
                + "FROM user u "
                + "LEFT JOIN role r ON u.roleId = r.roleId "
                + "WHERE u.accountName = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, accountName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User(
                        rs.getInt("userId"),
                        rs.getString("accountName"),
                        rs.getString("displayName"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getInt("roleId"),
                        rs.getString("status"),
                        rs.getInt("departmentId"),
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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.userId, u.accountName, u.displayName, u.password, u.email, u.phone, "
                + "u.roleId, u.status, u.departmentId, u.verificationCode, "
                + "r.roleId as r_roleId, r.roleName, r.roleDescription, r.status as r_status "
                + "FROM user u "
                + "LEFT JOIN role r ON u.roleId = r.roleId "
                + "ORDER BY u.userId";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User user = new User(
                        rs.getInt("userId"),
                        rs.getString("accountName"),
                        rs.getString("displayName"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getInt("roleId"),
                        rs.getString("status"),
                        rs.getInt("departmentId"),
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

                list.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public User getUserByEmail(String email) {
        String sql = "SELECT u.userId, u.accountName, u.displayName, u.password, u.email, u.phone, "
                + "u.roleId, u.status, u.departmentId, u.verificationCode, u.reset_token, "
                + "r.roleId as r_roleId, r.roleName, r.roleDescription, r.status as r_status "
                + "FROM user u "
                + "LEFT JOIN role r ON u.roleId = r.roleId "
                + "WHERE u.email = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapUserFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
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
                + "roleId, status, departmentId, verificationCode) "
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
                + "u.roleId, u.status, u.departmentId, u.verificationCode, "
                + "r.roleId as r_roleId, r.roleName, r.roleDescription, r.status as r_status "
                + "FROM user u "
                + "LEFT JOIN role r ON u.roleId = r.roleId "
                + "WHERE u.userId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User(
                        rs.getInt("userId"),
                        rs.getString("accountName"),
                        rs.getString("displayName"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getInt("roleId"),
                        rs.getString("status"),
                        rs.getInt("departmentId"),
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
    public void updateToken(String email, String token) {
        String sql = "UPDATE user SET reset_token = ? WHERE email = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.setString(2, email);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
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
                rs.getInt("departmentId"),
                rs.getString("verificationCode")
        );

        try {
            user.setResetToken(rs.getString("reset_token"));
        } catch (java.sql.SQLException e) {

        }

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
    public User getUserByToken(String token) {
        String sql = "SELECT u.userId, u.accountName, u.displayName, u.password, u.email, u.phone, "
                + "u.roleId, u.status, u.departmentId, u.verificationCode, u.reset_token, "
                + "r.roleId as r_roleId, r.roleName, r.roleDescription, r.status as r_status "
                + "FROM user u "
                + "LEFT JOIN role r ON u.roleId = r.roleId "
                + "WHERE u.reset_token = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapUserFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
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
    public List<User> getUsersWithFilter(String searchName, String searchEmail, Integer roleId, String status, int offset, int limit) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.userId, u.accountName, u.displayName, u.password, u.email, u.phone, "
                + "u.roleId, u.status, u.departmentId, u.verificationCode, u.reset_token, "
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

        sql += " ORDER BY u.userId ASC LIMIT ? OFFSET ?";
        params.add(limit);
        params.add(offset);

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
    public int countUsersWithFilter(String searchName, String searchEmail, Integer roleId, String status) {
        String sql = "SELECT COUNT(*) as total FROM user u WHERE 1=1 ";
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

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean updateUserInfo(User user) {
        String sql = "UPDATE user SET displayName = ?, phone = ?, status = ?, roleId = ? WHERE userId = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getDisplayName());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getStatus());
            ps.setInt(4, user.getRoleId());
            ps.setInt(5, user.getUserId());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
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
    public void updatePassword(int userId, String newPassword) {
        String sql = "UPDATE user SET password = ?, reset_token = NULL WHERE userId = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPassword);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public User addNewUser(User user) {
        String sql = "INSERT INTO user (accountName, displayName, password, email, phone, "
                + "roleId, status, departmentId, verificationCode) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, user.getAccountName());
            ps.setString(2, user.getDisplayName());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhone());
            ps.setInt(6, user.getRoleId());
            ps.setString(7, user.getStatus());
            ps.setInt(8, user.getDepartmentId());
            ps.setString(9, user.getVerificationCode());

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        user.setUserId(rs.getInt(1));
                    }
                }
                return user;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean updateUserWithVerification(User user) {
        String sql = "UPDATE user SET displayName = ?, phone = ?, verificationCode = ? WHERE userId = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getDisplayName());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getVerificationCode());
            ps.setInt(4, user.getUserId());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static void main(String[] args) {
        UserDAO dao = new UserDAO();
        User user = dao.getUserByAccountName("admin");
        if (user != null) {
            System.out.println("Found: " + user.getDisplayName() +
                    " - Role: " + (user.getRole() != null ? user.getRole().getRoleName() : "No role"));
        } else {
            System.out.println("Not found");
        }

        System.out.println("Total users: " + dao.getAllUsers().size());
    }
}