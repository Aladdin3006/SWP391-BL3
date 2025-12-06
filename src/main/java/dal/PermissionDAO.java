package dal;

import entity.Permission;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PermissionDAO extends DBContext {

    // Count total for paging
    public int count(String search) {
        String sql = "SELECT COUNT(*) FROM permission WHERE permissionName LIKE ?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, "%" + search + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // Paging + sorting + search
    public List<Permission> getAll(String search, String sortField, String sortDir, int page, int pageSize) {
        List<Permission> list = new ArrayList<>();

        if (sortField == null || sortField.isEmpty()) sortField = "permissionId";
        if (sortDir == null || sortDir.isEmpty()) sortDir = "ASC";

        int offset = (page - 1) * pageSize;

        String sql = "SELECT * FROM permission WHERE permissionName LIKE ? "
                + "ORDER BY " + sortField + " " + sortDir + " LIMIT ? OFFSET ?";

        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, "%" + search + "%");
            ps.setInt(2, pageSize);
            ps.setInt(3, offset);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Permission(
                        rs.getInt("permissionId"),
                        rs.getString("permissionName"),
                        rs.getString("url"),
                        rs.getString("description")
                ));
            }

        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public Permission getById(int id) {
        String sql = "SELECT * FROM permission WHERE permissionId=?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new Permission(
                        rs.getInt("permissionId"),
                        rs.getString("permissionName"),
                        rs.getString("url"),
                        rs.getString("description")
                );
            }

        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public boolean insert(Permission p) {
        String sql = "INSERT INTO permission(permissionName, url, description) VALUES (?,?,?)";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, p.getPermissionName());
            ps.setString(2, p.getUrl());
            ps.setString(3, p.getDescription());
            return ps.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean update(Permission p) {
        String sql = "UPDATE permission SET permissionName=?, url=?, description=? WHERE permissionId=?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, p.getPermissionName());
            ps.setString(2, p.getUrl());
            ps.setString(3, p.getDescription());
            ps.setInt(4, p.getPermissionId());
            return ps.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM permission WHERE permissionId=?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
}