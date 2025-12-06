package dal;

import entity.Role;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoleDAO extends DBContext {

    public boolean insert(Role r) {
        String sql = "INSERT INTO role(roleName, roleDescription, status) VALUES (?,?,?)";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, r.getRoleName());
            ps.setString(2, r.getRoleDescription());
            ps.setString(3, r.getStatus());
            return ps.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean update(Role r) {
        String sql = "UPDATE role SET roleName=?, roleDescription=?, status=? WHERE roleId=?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, r.getRoleName());
            ps.setString(2, r.getRoleDescription());
            ps.setString(3, r.getStatus());
            ps.setInt(4, r.getRoleId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public Role getById(int id) {
        String sql = "SELECT * FROM role WHERE roleId=?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new Role(
                        rs.getInt("roleId"),
                        rs.getString("roleName"),
                        rs.getString("roleDescription"),
                        rs.getString("status")
                );
            }

        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public void toggleStatus(int id) {
        String sql = "UPDATE role SET status = IF(status='active','inactive','active') WHERE roleId=?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (Exception e) { e.printStackTrace(); }
    }
}