package dal;

import entity.Department;
import entity.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DepartmentDAO extends DBContext {

    public List<Department> getDepartmentListWithPaging(String search, String statusFilter, int page, int pageSize) {
        List<Department> list = new ArrayList<>();
        String sql = "SELECT id, departmentName, storekeeperId, status FROM Department WHERE 1=1";
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql += " AND departmentName LIKE ?";
            params.add("%" + search.trim() + "%");
        }
        if (statusFilter != null && !statusFilter.equals("all")) {
            sql += " AND status = ?";
            params.add(statusFilter);
        }

        sql += " ORDER BY id LIMIT ?, ?";
        params.add((page - 1) * pageSize);
        params.add(pageSize);

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Department d = new Department();
                d.setId(rs.getInt("id"));
                d.setDepartmentName(rs.getString("departmentName"));
                d.setStorekeeperId(rs.getInt("storekeeperId"));
                d.setStatus(rs.getString("status"));
                list.add(d);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countDepartments(String search, String statusFilter) {
        String sql = "SELECT COUNT(*) FROM Department WHERE 1=1";
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql += " AND departmentName LIKE ?";
            params.add("%" + search.trim() + "%");
        }
        if (statusFilter != null && !statusFilter.equals("all")) {
            sql += " AND status = ?";
            params.add(statusFilter);
        }

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<User> getStorekeepersNotInAnyDepartment() {
        List<User> list = new ArrayList<>();
        String sql = """
            SELECT u.userId, u.displayName 
            FROM user u
            JOIN role r ON u.roleId = r.roleId
            WHERE r.roleName = 'storekeeper'
              AND u.status = 'active'
              AND (u.departmentId = 0 OR u.departmentId IS NULL)
            """;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("userId"));
                u.setDisplayName(rs.getString("displayName"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<User> getStorekeepersForUpdate(int deptId) {
        List<User> list = new ArrayList<>();
        String sql = """
        SELECT u.userId, u.displayName 
        FROM user u
        JOIN role r ON u.roleId = r.roleId
        WHERE r.roleName = 'storekeeper'
          AND u.status = 'active'
          AND (u.departmentId = 0 OR u.departmentId IS NULL OR u.departmentId = ?)
        """;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, deptId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("userId"));
                u.setDisplayName(rs.getString("displayName"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<User> getAvailableEmployees() {
        List<User> list = new ArrayList<>();
        String sql = """
            SELECT u.userId, u.displayName 
            FROM user u
            JOIN role r ON u.roleId = r.roleId
            WHERE r.roleName = 'employee'
              AND u.status = 'active'
              AND (u.departmentId = 0 OR u.departmentId IS NULL)
            """;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("userId"));
                u.setDisplayName(rs.getString("displayName"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<User> getEmployeesNotInDepartment(int deptId) {
        List<User> list = new ArrayList<>();
        String sql = """
            SELECT u.userId, u.displayName 
            FROM user u
            JOIN role r ON u.roleId = r.roleId
            WHERE r.roleName = 'employee'
              AND u.status = 'active'
              AND (u.departmentId != ? OR u.departmentId IS NULL OR u.departmentId = 0)
            """;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, deptId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("userId"));
                u.setDisplayName(rs.getString("displayName"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<User> getEmployeesInDepartment(int deptId) {
        List<User> list = new ArrayList<>();
        String sql = """
            SELECT u.userId, u.displayName 
            FROM user u
            WHERE u.departmentId = ?
              AND u.userId IN (
                  SELECT userId FROM user 
                  JOIN role ON user.roleId = role.roleId 
                  WHERE role.roleName = 'employee'
              )
            """;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, deptId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("userId"));
                u.setDisplayName(rs.getString("displayName"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getEmployeeCount(int deptId) {
        String sql = """
            SELECT COUNT(*) 
            FROM user 
            WHERE departmentId = ? 
              AND userId IN (
                  SELECT userId FROM user 
                  JOIN role ON user.roleId = role.roleId 
                  WHERE role.roleName = 'employee'
              )
            """;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, deptId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public String getStorekeeperName(int userId) {
        String sql = "SELECT displayName FROM user WHERE userId = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("displayName");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "Unknown";
    }

    public Department getDepartmentById(int id) {
        String sql = "SELECT id, departmentName, storekeeperId, status FROM Department WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Department d = new Department();
                d.setId(rs.getInt("id"));
                d.setDepartmentName(rs.getString("departmentName"));
                d.setStorekeeperId(rs.getInt("storekeeperId"));
                d.setStatus(rs.getString("status"));
                return d;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void addDepartment(Department dept, List<Integer> employeeIds) {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            String sql = "INSERT INTO Department (departmentName, storekeeperId, status) VALUES (?, ?, ?)";
            int deptId = 0;

            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, dept.getDepartmentName());
                ps.setInt(2, dept.getStorekeeperId());
                ps.setString(3, dept.getStatus());
                ps.executeUpdate();

                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    deptId = rs.getInt(1);
                }
            }

            String updateStorekeeper = "UPDATE user SET departmentId = ? WHERE userId = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateStorekeeper)) {
                ps.setInt(1, deptId);
                ps.setInt(2, dept.getStorekeeperId());
                ps.executeUpdate();
            }

            if (employeeIds != null && !employeeIds.isEmpty()) {
                String updateEmployees = "UPDATE user SET departmentId = ? WHERE userId = ?";
                try (PreparedStatement ps = conn.prepareStatement(updateEmployees)) {
                    for (int empId : employeeIds) {
                        ps.setInt(1, deptId);
                        ps.setInt(2, empId);
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }

            conn.commit();
        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (Exception ex) {}
            throw new RuntimeException("Add department failed", e);
        } finally {
            try { if (conn != null) conn.setAutoCommit(true); } catch (Exception ex) {}
        }
    }

    public void updateDepartment(Department dept, List<Integer> employeeIds) {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            String sql = "UPDATE Department SET departmentName = ?, storekeeperId = ?, status = ? WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, dept.getDepartmentName());
                ps.setInt(2, dept.getStorekeeperId());
                ps.setString(3, dept.getStatus());
                ps.setInt(4, dept.getId());
                ps.executeUpdate();
            }

            String updateStorekeeper = "UPDATE user SET departmentId = ? WHERE userId = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateStorekeeper)) {
                ps.setInt(1, dept.getId());
                ps.setInt(2, dept.getStorekeeperId());
                ps.executeUpdate();
            }

            List<Integer> currentEmpIds = new ArrayList<>();
            String getCurrentEmployees = """
            SELECT u.userId 
            FROM user u
            JOIN role r ON u.roleId = r.roleId
            WHERE u.departmentId = ? AND r.roleName = 'employee'
            """;
            try (PreparedStatement ps = conn.prepareStatement(getCurrentEmployees)) {
                ps.setInt(1, dept.getId());
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    currentEmpIds.add(rs.getInt("userId"));
                }
            }

            String removeEmployees = "UPDATE user SET departmentId = 0 WHERE departmentId = ?";
            try (PreparedStatement ps = conn.prepareStatement(removeEmployees)) {
                ps.setInt(1, dept.getId());
                ps.executeUpdate();
            }

            if (employeeIds != null && !employeeIds.isEmpty()) {
                String addEmployees = "UPDATE user SET departmentId = ? WHERE userId = ?";
                try (PreparedStatement ps = conn.prepareStatement(addEmployees)) {
                    for (int empId : employeeIds) {
                        ps.setInt(1, dept.getId());
                        ps.setInt(2, empId);
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }

            String addStorekeeper = "UPDATE user SET departmentId = ? WHERE userId = ?";
            try (PreparedStatement ps = conn.prepareStatement(addStorekeeper)) {
                ps.setInt(1, dept.getId());
                ps.setInt(2, dept.getStorekeeperId());
                ps.executeUpdate();
            }

            conn.commit();
        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            throw new RuntimeException("Update failed", e);
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    public void updateStatus(int id, String status) {
        String sql = "UPDATE Department SET status = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public User getStorekeeperForDepartment(int deptId) {
        String sql = """
            SELECT u.userId, u.displayName 
            FROM user u
            JOIN Department d ON u.userId = d.storekeeperId
            WHERE d.id = ?
            """;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, deptId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("userId"));
                u.setDisplayName(rs.getString("displayName"));
                return u;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}