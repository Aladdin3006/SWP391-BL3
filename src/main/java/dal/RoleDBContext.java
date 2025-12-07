package dal;

import entity.Role;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RoleDBContext extends DBContext {
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

}
