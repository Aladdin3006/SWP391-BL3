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
        String sql = "SELECT categoryId, categoryName, description, status FROM category WHERE status = 1 ORDER BY categoryName ASC";

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
    public List<Category> getCategoriesForAddAndEditP(Integer currentCategoryId) {
        List<Category> list = new ArrayList<>();

        String sql = """
        SELECT categoryId, categoryName, description, status
        FROM category
        WHERE status = 1
    """;

        // Nếu đang EDIT → cho phép load thêm category hiện tại (kể cả inactive)
        if (currentCategoryId != null) {
            sql += " OR categoryId = ?";
        }

        sql += " ORDER BY categoryId ASC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (currentCategoryId != null) {
                ps.setInt(1, currentCategoryId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Category c = new Category(
                            rs.getInt("categoryId"),
                            rs.getString("categoryName"),
                            rs.getString("description"),
                            rs.getInt("status")
                    );
                    list.add(c);
                }
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

        if (sortField == null || !(sortField.equals("categoryId") || sortField.equals("categoryName"))) {
            sortField = "categoryId";
        }

        if (sortOrder == null || !(sortOrder.equalsIgnoreCase("asc") || sortOrder.equalsIgnoreCase("desc"))) {
            sortOrder = "asc";
        }

        String sql = "SELECT categoryId, categoryName, description, status FROM category WHERE 1=1";

        if (categoryName != null && !categoryName.trim().isEmpty()) {
            sql += " AND categoryName LIKE ?";
        }

        boolean filterStatus = false;
        int statusValue = -1;
        if (statusFilter != null && !statusFilter.equalsIgnoreCase("all")) {
            try {
                statusValue = Integer.parseInt(statusFilter);
                filterStatus = true;
                sql += " AND status = ?";
            } catch (NumberFormatException e) {
            }
        }

        sql += " ORDER BY " + sortField + " " + sortOrder;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int idx = 1;

            if (categoryName != null && !categoryName.trim().isEmpty()) {
                ps.setString(idx++, "%" + categoryName.trim() + "%");
            }

            if (filterStatus) {
                ps.setInt(idx++, statusValue);
            }

            ResultSet rs = ps.executeQuery();
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


    public boolean isCategoryNameExist(String categoryName, int categoryId) {
        String sql = "SELECT 1 FROM category WHERE categoryName = ?";
        if (categoryId > 0) {
            sql += " AND categoryId <> ?";
        }

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, categoryName);
            if (categoryId > 0) {
                ps.setInt(2, categoryId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int updateCategory(Category category) {
        String sql = "UPDATE category SET categoryName = ?, description = ?, status = ? WHERE categoryId = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            ps.setInt(3, category.getStatus());
            ps.setInt(4, category.getCategoryId());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                return category.getCategoryId();
            } else {
                return -1;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

}
