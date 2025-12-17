package dal;

import entity.Evaluate;
import entity.User;
import entity.Department;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class EvaluateDAO extends DBContext {

    public List<Evaluate> getEvaluateListWithPaging(int evaluatorId, String search, String sort, String dateFilter, int page, int pageSize) {
        List<Evaluate> list = new ArrayList<>();
        String sql = """
        SELECT e.id, e.employeeId, e.createdBy, e.period, e.performance, 
               e.accuracy, e.safetyCompliance, e.teamwork, e.avgStar, e.createdAt,
               u.userId as empUserId, u.displayName as empDisplayName,
               d.id as deptId, d.departmentName
        FROM Evaluate e
        JOIN user u ON e.employeeId = u.userId
        JOIN Department d ON u.departmentId = d.id
        WHERE e.createdBy = ?
        """;

        List<Object> params = new ArrayList<>();
        params.add(evaluatorId);

        if (search != null && !search.trim().isEmpty()) {
            sql += " AND (u.displayName LIKE ? OR d.departmentName LIKE ?)";
            params.add("%" + search.trim() + "%");
            params.add("%" + search.trim() + "%");
        }

        if (dateFilter != null && !dateFilter.trim().isEmpty()) {
            sql += " AND DATE(e.createdAt) = ?";
            params.add(dateFilter);
        }

        if ("oldest".equals(sort)) {
            sql += " ORDER BY e.createdAt ASC";
        } else {
            sql += " ORDER BY e.createdAt DESC";
        }

        sql += " LIMIT ?, ?";
        params.add((page - 1) * pageSize);
        params.add(pageSize);

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Evaluate eval = new Evaluate();
                eval.setId(rs.getInt("id"));
                eval.setEmployeeId(rs.getInt("employeeId"));
                eval.setCreatedBy(rs.getInt("createdBy"));
                eval.setPeriod(rs.getString("period"));
                eval.setPerformance(rs.getInt("performance"));
                eval.setAccuracy(rs.getInt("accuracy"));
                eval.setSafetyCompliance(rs.getInt("safetyCompliance"));
                eval.setTeamwork(rs.getInt("teamwork"));
                eval.setAvgStar(rs.getDouble("avgStar"));
                eval.setCreatedAt(rs.getTimestamp("createdAt"));

                User employee = new User();
                employee.setUserId(rs.getInt("empUserId"));
                employee.setDisplayName(rs.getString("empDisplayName"));
                eval.setEmployee(employee);

                Department dept = new Department();
                dept.setId(rs.getInt("deptId"));
                dept.setDepartmentName(rs.getString("departmentName"));
                eval.setDepartment(dept);

                list.add(eval);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countEvaluates(int evaluatorId, String search, String dateFilter) {
        String sql = """
        SELECT COUNT(*) 
        FROM Evaluate e
        JOIN user u ON e.employeeId = u.userId
        JOIN Department d ON u.departmentId = d.id
        WHERE e.createdBy = ?
        """;

        List<Object> params = new ArrayList<>();
        params.add(evaluatorId);

        if (search != null && !search.trim().isEmpty()) {
            sql += " AND (u.displayName LIKE ? OR d.departmentName LIKE ?)";
            params.add("%" + search.trim() + "%");
            params.add("%" + search.trim() + "%");
        }

        if (dateFilter != null && !dateFilter.trim().isEmpty()) {
            sql += " AND DATE(e.createdAt) = ?";
            params.add(dateFilter);
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

    public List<User> getEmployeesInSameDepartment(int evaluatorId) {
        List<User> list = new ArrayList<>();
        String sql = """
        SELECT u.userId, u.displayName, d.departmentName
        FROM user u
        JOIN user evaluator ON evaluator.departmentId = u.departmentId
        JOIN Department d ON u.departmentId = d.id
        JOIN role r ON u.roleId = r.roleId
        WHERE evaluator.userId = ?
          AND u.userId != ?
          AND r.roleName = 'employee'
          AND u.status = 'active'
          AND d.status = 'active'
        ORDER BY u.displayName
        """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, evaluatorId);
            ps.setInt(2, evaluatorId);
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

    public Map<String, Object> getEvaluateByIdWithDetails(int id) {
        String sql = """
        SELECT e.*, 
               u.displayName as empName, 
               d.departmentName,
               evaluator.displayName as evaluatorName,
               evaluator.userId as evaluatorId
        FROM Evaluate e
        JOIN user u ON e.employeeId = u.userId
        JOIN Department d ON u.departmentId = d.id
        JOIN user evaluator ON e.createdBy = evaluator.userId
        WHERE e.id = ?
        """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Evaluate eval = new Evaluate();
                eval.setId(rs.getInt("id"));
                eval.setEmployeeId(rs.getInt("employeeId"));
                eval.setCreatedBy(rs.getInt("createdBy"));
                eval.setPeriod(rs.getString("period"));
                eval.setPerformance(rs.getInt("performance"));
                eval.setAccuracy(rs.getInt("accuracy"));
                eval.setSafetyCompliance(rs.getInt("safetyCompliance"));
                eval.setTeamwork(rs.getInt("teamwork"));
                eval.setAvgStar(rs.getDouble("avgStar"));
                eval.setCreatedAt(rs.getTimestamp("createdAt"));

                User employee = new User();
                employee.setUserId(rs.getInt("employeeId"));
                employee.setDisplayName(rs.getString("empName"));
                eval.setEmployee(employee);

                Department dept = new Department();
                dept.setDepartmentName(rs.getString("departmentName"));
                eval.setDepartment(dept);

                Map<String, Object> result = new HashMap<>();
                result.put("evaluate", eval);
                result.put("evaluatorName", rs.getString("evaluatorName"));
                result.put("evaluatorId", rs.getInt("evaluatorId"));
                result.put("departmentName", rs.getString("departmentName"));

                return result;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Evaluate getEvaluateById(int id) {
        String sql = """
            SELECT e.*, u.displayName as empName, d.departmentName,
                   evaluator.displayName as createdByName
            FROM Evaluate e
            JOIN user u ON e.employeeId = u.userId
            JOIN Department d ON u.departmentId = d.id
            JOIN user evaluator ON e.createdBy = evaluator.userId
            WHERE e.id = ?
            """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Evaluate eval = new Evaluate();
                eval.setId(rs.getInt("id"));
                eval.setEmployeeId(rs.getInt("employeeId"));
                eval.setCreatedBy(rs.getInt("createdBy"));
                eval.setPeriod(rs.getString("period"));
                eval.setPerformance(rs.getInt("performance"));
                eval.setAccuracy(rs.getInt("accuracy"));
                eval.setSafetyCompliance(rs.getInt("safetyCompliance"));
                eval.setTeamwork(rs.getInt("teamwork"));
                eval.setAvgStar(rs.getDouble("avgStar"));
                eval.setCreatedAt(rs.getTimestamp("createdAt"));

                User employee = new User();
                employee.setUserId(rs.getInt("employeeId"));
                employee.setDisplayName(rs.getString("empName"));
                eval.setEmployee(employee);

                Department dept = new Department();
                dept.setDepartmentName(rs.getString("departmentName"));
                eval.setDepartment(dept);

                return eval;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void addEvaluate(Evaluate eval) {
        String sql = """
            INSERT INTO Evaluate (employeeId, createdBy, period, performance, 
                                 accuracy, safetyCompliance, teamwork, avgStar, createdAt)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eval.getEmployeeId());
            ps.setInt(2, eval.getCreatedBy());
            ps.setString(3, eval.getPeriod());
            ps.setInt(4, eval.getPerformance());
            ps.setInt(5, eval.getAccuracy());
            ps.setInt(6, eval.getSafetyCompliance());
            ps.setInt(7, eval.getTeamwork());
            ps.setDouble(8, eval.getAvgStar());
            ps.setTimestamp(9, new Timestamp(eval.getCreatedAt().getTime()));
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateEvaluate(Evaluate eval) {
        String sql = """
            UPDATE Evaluate 
            SET employeeId = ?, period = ?, performance = ?, accuracy = ?, 
                safetyCompliance = ?, teamwork = ?, avgStar = ?, createdAt = ?
            WHERE id = ?
            """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eval.getEmployeeId());
            ps.setString(2, eval.getPeriod());
            ps.setInt(3, eval.getPerformance());
            ps.setInt(4, eval.getAccuracy());
            ps.setInt(5, eval.getSafetyCompliance());
            ps.setInt(6, eval.getTeamwork());
            ps.setDouble(7, eval.getAvgStar());
            ps.setTimestamp(8, new Timestamp(eval.getCreatedAt().getTime()));
            ps.setInt(9, eval.getId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteEvaluate(int id) {
        String sql = "DELETE FROM Evaluate WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean hasEvaluateForPeriod(int employeeId, String period, int evaluatorId) {
        String sql = """
            SELECT COUNT(*) 
            FROM Evaluate 
            WHERE employeeId = ? AND period = ? AND createdBy = ?
            """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setString(2, period);
            ps.setInt(3, evaluatorId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public double getAverageRatingForEmployee(int employeeId) {
        String sql = "SELECT AVG(avgStar) as avgRating FROM Evaluate WHERE employeeId = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("avgRating");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }
}