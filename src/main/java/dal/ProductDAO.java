package dal;

import entity.Product;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO extends DBContext {

    // danh sách các field được phép sort
    private final List<String> ALLOWED_SORT_FIELDS = List.of("id", "productCode", "name", "brand", "company", "categoryName", "unit", "status");

    public List<Product> getAllProducts(String productCode, String productName, String brand,
                                        String company, String cateName, String statusFilter,
                                        int pageIndex, int pageSize,
                                        String sortField, String sortOrder) {

        List<Product> list = new ArrayList<>();

        // validate sortField và sortOrder
        if (sortField == null || !ALLOWED_SORT_FIELDS.contains(sortField)) sortField = "id";
        if (sortOrder == null || !(sortOrder.equalsIgnoreCase("asc") || sortOrder.equalsIgnoreCase("desc")))
            sortOrder = "asc";

        String sql = "SELECT id, productCode, name, brand, company, categoryName, unit, supplierId, status, url " +
                "FROM product WHERE 1 = 1 ";

        if (productCode != null && !productCode.trim().isEmpty()) {
            sql += " AND productCode LIKE ? ";
        }
        if (productName != null && !productName.trim().isEmpty()) {
            sql += " AND name LIKE ? ";
        }
        if (brand != null && !brand.trim().isEmpty()) {
            sql += " AND brand LIKE ? ";
        }
        if (company != null && !company.trim().isEmpty()) {
            sql += " AND company LIKE ? ";
        }
        if (cateName != null && !cateName.trim().isEmpty()) {
            sql += " AND categoryName LIKE ? ";
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"all".equalsIgnoreCase(statusFilter)) {
            sql += " AND status = ? ";
        }

        // thêm sort
        sql += " ORDER BY " + sortField + " " + sortOrder;
        // phân trang MySQL
        sql += " LIMIT ?, ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int idx = 1;
            if (productCode != null && !productCode.trim().isEmpty()) ps.setString(idx++, "%" + productCode.trim() + "%");
            if (productName != null && !productName.trim().isEmpty()) ps.setString(idx++, "%" + productName.trim() + "%");
            if (brand != null && !brand.trim().isEmpty()) ps.setString(idx++, "%" + brand.trim() + "%");
            if (company != null && !company.trim().isEmpty()) ps.setString(idx++, "%" + company.trim() + "%");
            if (cateName != null && !cateName.trim().isEmpty()) ps.setString(idx++, "%" + cateName.trim() + "%");
            if (statusFilter != null && !statusFilter.trim().isEmpty() && !"all".equalsIgnoreCase(statusFilter))
                ps.setString(idx++, statusFilter.trim());

            int offset = (pageIndex - 1) * pageSize;
            ps.setInt(idx++, offset);
            ps.setInt(idx++, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product(
                            rs.getInt("id"),
                            rs.getString("productCode"),
                            rs.getString("name"),
                            rs.getString("brand"),
                            rs.getString("company"),
                            rs.getString("categoryName"),
                            rs.getInt("unit"),
                            rs.getInt("supplierId"),
                            rs.getString("status"),
                            rs.getString("url")
                    );
                    list.add(p);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countProducts(String productCode, String productName, String brand,
                             String company, String cateName, String statusFilter) {

        int total = 0;
        String sql = "SELECT COUNT(*) FROM product WHERE 1 = 1 ";

        if (productCode != null && !productCode.trim().isEmpty()) sql += " AND productCode LIKE ? ";
        if (productName != null && !productName.trim().isEmpty()) sql += " AND name LIKE ? ";
        if (brand != null && !brand.trim().isEmpty()) sql += " AND brand LIKE ? ";
        if (company != null && !company.trim().isEmpty()) sql += " AND company LIKE ? ";
        if (cateName != null && !cateName.trim().isEmpty()) sql += " AND categoryName LIKE ? ";
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"all".equalsIgnoreCase(statusFilter))
            sql += " AND status = ? ";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int idx = 1;
            if (productCode != null && !productCode.trim().isEmpty()) ps.setString(idx++, "%" + productCode.trim() + "%");
            if (productName != null && !productName.trim().isEmpty()) ps.setString(idx++, "%" + productName.trim() + "%");
            if (brand != null && !brand.trim().isEmpty()) ps.setString(idx++, "%" + brand.trim() + "%");
            if (company != null && !company.trim().isEmpty()) ps.setString(idx++, "%" + company.trim() + "%");
            if (cateName != null && !cateName.trim().isEmpty()) ps.setString(idx++, "%" + cateName.trim() + "%");
            if (statusFilter != null && !statusFilter.trim().isEmpty() && !"all".equalsIgnoreCase(statusFilter))
                ps.setString(idx++, statusFilter.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) total = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return total;
    }
}
