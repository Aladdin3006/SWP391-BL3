package dal;

import entity.User;
import entity.Role;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UserDBContext extends DBContext {

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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.userId, u.accountName, u.displayName, u.password, u.email, u.phone, "
                + "u.roleId, u.status, u.workspaceId, u.verificationCode, "
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

                list.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
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

    public static void main(String[] args) {
        UserDBContext dao = new UserDBContext();
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