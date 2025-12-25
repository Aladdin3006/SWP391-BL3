package dal;

import entity.RolePermission;

import java.sql.*;
import java.util.*;

public class RolePermissionDAO extends DBContext {

    public List<Integer> getAssignedPermissionIds(int roleId) {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT permissionId FROM role_permission WHERE roleId=?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, roleId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getInt("permissionId"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean assign(int roleId, int permissionId) {
        String sql = "INSERT INTO role_permission(roleId, permissionId) VALUES (?, ?)";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, roleId);
            ps.setInt(2, permissionId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean remove(int roleId, int permissionId) {
        String sql = "DELETE FROM role_permission WHERE roleId=? AND permissionId=?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, roleId);
            ps.setInt(2, permissionId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<String> getPermissionUrlsByRoleId(int roleId) {
        List<String> urls = new ArrayList<>();
        String sql = "SELECT p.url FROM role_permission rp "
                + "JOIN permission p ON rp.permissionId = p.permissionId "
                + "WHERE rp.roleId = ?";

        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, roleId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                urls.add(rs.getString("url"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return urls;
    }

    public Map<Integer, Set<Integer>> getAllRolePermissionMappings() {
        Map<Integer, Set<Integer>> map = new HashMap<>();
        String sql = "SELECT roleId, permissionId FROM role_permission";

        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int roleId = rs.getInt("roleId");
                int permissionId = rs.getInt("permissionId");

                map.putIfAbsent(roleId, new HashSet<>());
                map.get(roleId).add(permissionId);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }
}