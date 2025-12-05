package dal;

import entity.Role;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoleDAO extends DBContext {

    public List<Role> getAll(String search, String status, int page, int pageSize) {
        List<Role> list = new ArrayList<>();

        String sql = "SELECT * FROM role WHERE 1=1";

        if (search != null && !search.isEmpty())
            sql += " AND roleName LIKE ?";

        if (status != null && !status.equals("all"))
            sql += " AND status = ?";

        sql += " LIMIT ?,?";

        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            int i = 1;

            if (search != null && !search.isEmpty())
                ps.setString(i++, "%" + search + "%");

            if (status != null && !status.equals("all"))
                ps.setString(i++, status);

            ps.setInt(i++, (page - 1) * pageSize);
            ps.setInt(i, pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new Role(
                        rs.getInt("roleId"),
                        rs.getString("roleName"),
                        rs.getString("roleDescription"),
                        rs.getString("status")
                ));
            }

        } catch (Exception ex) { ex.printStackTrace(); }

        return list;
    }

    public int count(String search, String status) {
        String sql = "SELECT COUNT(*) FROM role WHERE 1=1";

        if (search != null && !search.isEmpty())
            sql += " AND roleName LIKE ?";

        if (status != null && !status.equals("all"))
            sql += " AND status = ?";

        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            int i = 1;

            if (search != null && !search.isEmpty())
                ps.setString(i++, "%" + search + "%");

            if (status != null && !status.equals("all"))
                ps.setString(i++, status);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) { e.printStackTrace(); }

        return 0;
    }

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