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
    public List<Role> getAllRoles(String keyword, String statusFilter, int pageIndex, int pageSize) {
        List<Role> list = new ArrayList<>();

        String sql = "SELECT roleId, roleName, roleDescription, status " +
                "FROM role WHERE 1 = 1 ";

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND roleName LIKE ? ";
        }

        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"all".equalsIgnoreCase(statusFilter)) {
            sql += " AND status = ? ";
        }

        // pagination MySQL
        sql += " ORDER BY roleId LIMIT ?, ? ";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int idx = 1;

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(idx++, "%" + keyword.trim() + "%");
            }

            if (statusFilter != null && !statusFilter.trim().isEmpty() && !"all".equalsIgnoreCase(statusFilter)) {
                ps.setString(idx++, statusFilter.trim());
            }

            int offset = (pageIndex - 1) * pageSize;
            ps.setInt(idx++, offset);
            ps.setInt(idx++, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Role r = new Role(
                            rs.getInt("roleId"),
                            rs.getString("roleName"),
                            rs.getString("roleDescription"),
                            rs.getString("status")
                    );
                    list.add(r);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countRoles(String keyword, String statusFilter) {
        String sql = "SELECT COUNT(*) AS total FROM role WHERE 1 = 1 ";

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND roleName LIKE ? ";
        }

        if (statusFilter != null && !statusFilter.trim().isEmpty() &&
                !"all".equalsIgnoreCase(statusFilter)) {
            sql += " AND status = ? ";
        }

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int idx = 1;

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(idx++, "%" + keyword.trim() + "%");
            }

            if (statusFilter != null && !statusFilter.trim().isEmpty() &&
                    !"all".equalsIgnoreCase(statusFilter)) {
                ps.setString(idx++, statusFilter.trim());
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }
    public List<Role> getAllRoles() {
        List<Role> list = new ArrayList<>();
        String sql = "SELECT roleId, roleName, roleDescription, status FROM role";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Role r = new Role(
                        rs.getInt("roleId"),
                        rs.getString("roleName"),
                        rs.getString("roleDescription"),
                        rs.getString("status")
                );
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}