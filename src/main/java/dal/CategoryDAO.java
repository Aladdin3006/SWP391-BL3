package dal;

import entity.Category;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO extends DBContext {

    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT categoryId, categoryName, description, status FROM category ORDER BY categoryName ASC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category c = new Category(
                        rs.getInt("categoryId"),
                        rs.getString("categoryName"),
                        rs.getString("description"),
                        rs.getInt("status")
                );
                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    public List<Category> searchCategory(String categoryName,
                                         String statusFilter,
                                         String sortField,
                                         String sortOrder) {

        List<Category> list = new ArrayList<>();

        // Whitelist sort field
        if (sortField == null || !(sortField.equals("categoryId") || sortField.equals("categoryName")))
            sortField = "categoryId";

        if (sortOrder == null || !(sortOrder.equalsIgnoreCase("asc") || sortOrder.equalsIgnoreCase("desc")))
            sortOrder = "asc";

        String sql = "SELECT categoryId, categoryName, description, status FROM category WHERE 1=1 ";

        if (categoryName != null && !categoryName.trim().isEmpty())
            sql += " AND categoryName LIKE ? ";

        // status = INT (1 / 0)
        if (statusFilter != null && !statusFilter.equalsIgnoreCase("all"))
            sql += " AND status = ? ";

        sql += " ORDER BY " + sortField + " " + sortOrder;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int idx = 1;

            if (categoryName != null && !categoryName.trim().isEmpty())
                ps.setString(idx++, "%" + categoryName.trim() + "%");

            if (statusFilter != null && !statusFilter.equalsIgnoreCase("all")) {
                int status = statusFilter.equalsIgnoreCase("active") ? 1 : 0;
                ps.setInt(idx++, status);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Category c = new Category(
                        rs.getInt("categoryId"),
                        rs.getString("categoryName"),
                        rs.getString("description"),
                        rs.getInt("status") // INT
                );
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int insertCategory(Category c) {
        String sql = "INSERT INTO category(categoryName, description, status) VALUES (?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, c.getCategoryName());
            ps.setString(2, c.getDescription());
            ps.setInt(3, c.getStatus());

            int affected = ps.executeUpdate();

            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) return rs.getInt(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }


    public boolean isCategoryNameExist(String categoryName) {
        String sql = "SELECT 1 FROM category WHERE categoryName = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, categoryName);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


}
