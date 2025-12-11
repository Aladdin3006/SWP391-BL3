package dal;

import entity.Product;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO extends DBContext {

    private final List<String> ALLOWED_SORT_FIELDS = List.of(
            "id", "productCode", "name", "brand", "company", "categoryId", "unit", "status"
    );

    public List<Product> getAllProducts(String productCode, String productName, String brand,
                                        String company, String cateId, String statusFilter,
                                        int pageIndex, int pageSize,
                                        String sortField, String sortOrder) {

        List<Product> list = new ArrayList<>();

        // Thêm p. vào sortField để tránh ambiguous nếu sort theo categoryId hoặc status
        if (sortField == null || !ALLOWED_SORT_FIELDS.contains(sortField)) sortField = "p.id";
        else sortField = "p." + sortField; // Đảm bảo sort cũng dùng alias p.

        if (sortOrder == null || !(sortOrder.equalsIgnoreCase("asc") || sortOrder.equalsIgnoreCase("desc")))
            sortOrder = "asc";

        // --- SỬA CÂU SQL TẠI ĐÂY ---
        String sql =
                "SELECT p.id, p.productCode, p.name, p.brand, p.company, " +
                        "p.categoryId, c.categoryName, p.unit, p.supplierId, p.status, p.url " +
                        "FROM product p " +
                        "LEFT JOIN category c ON p.categoryId = c.categoryId " +
                        "WHERE 1=1 ";

        // Thêm 'p.' vào trước các tên cột
        if (productCode != null && !productCode.trim().isEmpty()) sql += " AND p.productCode LIKE ? ";
        if (productName != null && !productName.trim().isEmpty()) sql += " AND p.name LIKE ? ";
        if (brand != null && !brand.trim().isEmpty()) sql += " AND p.brand LIKE ? ";
        if (company != null && !company.trim().isEmpty()) sql += " AND p.company LIKE ? ";

        if (cateId != null && !cateId.trim().isEmpty()) sql += " AND p.categoryId = ? ";

        // Nên thêm p.status để an toàn
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"all".equalsIgnoreCase(statusFilter))
            sql += " AND p.status = ? ";

        sql += " ORDER BY " + sortField + " " + sortOrder + " LIMIT ?, ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int idx = 1;
            if (productCode != null && !productCode.trim().isEmpty()) ps.setString(idx++, "%" + productCode.trim() + "%");
            if (productName != null && !productName.trim().isEmpty()) ps.setString(idx++, "%" + productName.trim() + "%");
            if (brand != null && !brand.trim().isEmpty()) ps.setString(idx++, "%" + brand.trim() + "%");
            if (company != null && !company.trim().isEmpty()) ps.setString(idx++, "%" + company.trim() + "%");

            // Parse int cho categoryId
            if (cateId != null && !cateId.trim().isEmpty()) ps.setInt(idx++, Integer.parseInt(cateId));

            if (statusFilter != null && !statusFilter.trim().isEmpty() && !"all".equalsIgnoreCase(statusFilter))
                ps.setString(idx++, statusFilter.trim());

            int offset = (pageIndex - 1) * pageSize;
            ps.setInt(idx++, offset);
            ps.setInt(idx++, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setId(rs.getInt("id"));
                    p.setProductCode(rs.getString("productCode"));
                    p.setName(rs.getString("name"));
                    p.setBrand(rs.getString("brand"));
                    p.setCompany(rs.getString("company"));
                    p.setCategoryId(rs.getInt("categoryId"));
                    p.setCategoryName(rs.getString("categoryName"));
                    p.setUnit(rs.getInt("unit"));
                    p.setSupplierId(rs.getInt("supplierId"));
                    p.setStatus(rs.getString("status"));
                    p.setUrl(rs.getString("url"));

                    list.add(p);
                }
            }
        } catch (Exception e) {
            // Bạn nên in e.getMessage() để thấy rõ lỗi ambiguous nếu nó xảy ra
            e.printStackTrace();
        }

        return list;
    }

    public int countProducts(String productCode, String productName, String brand,
                             String company, String cateId, String statusFilter) {

        int total = 0;
        String sql = "SELECT COUNT(*) FROM product WHERE 1=1 ";
        if (productCode != null && !productCode.trim().isEmpty()) sql += " AND productCode LIKE ? ";
        if (productName != null && !productName.trim().isEmpty()) sql += " AND name LIKE ? ";
        if (brand != null && !brand.trim().isEmpty()) sql += " AND brand LIKE ? ";
        if (company != null && !company.trim().isEmpty()) sql += " AND company LIKE ? ";
        if (cateId != null && !cateId.trim().isEmpty()) sql += " AND categoryId = ? ";
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"all".equalsIgnoreCase(statusFilter))
            sql += " AND status = ? ";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int idx = 1;
            if (productCode != null && !productCode.trim().isEmpty()) ps.setString(idx++, "%" + productCode.trim() + "%");
            if (productName != null && !productName.trim().isEmpty()) ps.setString(idx++, "%" + productName.trim() + "%");
            if (brand != null && !brand.trim().isEmpty()) ps.setString(idx++, "%" + brand.trim() + "%");
            if (company != null && !company.trim().isEmpty()) ps.setString(idx++, "%" + company.trim() + "%");
            if (cateId != null && !cateId.trim().isEmpty()) ps.setInt(idx++, Integer.parseInt(cateId));
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

    public void insertProduct(Product p) {
        String sql = "INSERT INTO product (productCode, name, brand, company, categoryId, unit, supplierId, status, url) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getProductCode());
            ps.setString(2, p.getName());
            ps.setString(3, p.getBrand());
            ps.setString(4, p.getCompany());
            ps.setInt(5, p.getCategoryId());
            ps.setInt(6, p.getUnit());
            ps.setInt(7, p.getSupplierId());
            ps.setString(8, p.getStatus());
            ps.setString(9, p.getUrl());

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
