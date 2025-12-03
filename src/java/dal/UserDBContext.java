package dal;

import entity.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UserDBContext extends DBContext {

    public User getUserByAccountName(String accountName) {
        String sql = "SELECT userId, accountName, displayName, password, email, phone, role, status, workspaceId "
                + "FROM user WHERE accountName = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, accountName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new User(
                        rs.getInt("userId"),
                        rs.getString("accountName"),
                        rs.getString("displayName"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("role"),
                        rs.getBoolean("status"),
                        rs.getInt("workspaceId")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT userId, accountName, displayName, password, email, phone, role, status, workspaceId FROM user";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = new User(
                        rs.getInt("userId"),
                        rs.getString("accountName"),
                        rs.getString("displayName"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("role"),
                        rs.getBoolean("status"),
                        rs.getInt("workspaceId")
                );
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean checkEmailExists(String email) {
        String sql = "SELECT userId FROM User WHERE email = ?";
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

    public void registerUser(String accountName, String password, String displayName, String email, String phone, String code) {
        String sql = "INSERT INTO User (accountName, password, displayName, email, phone, role, status, workspaceId, verificationCode) VALUES (?, ?, ?, ?, ?, 'User', 0, 1, ?)";
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
        String sql = "UPDATE User SET status = 1, verificationCode = NULL WHERE verificationCode = ?";
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

    public static void main(String[] args) {
        UserDBContext dao = new UserDBContext();
        User user = dao.getUserByAccountName("admin");
        if (user != null) {
            System.out.println("Found: " + user.getDisplayName() + " - " + user.getRole());
        } else {
            System.out.println("Not found");
        }

        System.out.println("Total users: " + dao.getAllUsers().size());
    }
}
