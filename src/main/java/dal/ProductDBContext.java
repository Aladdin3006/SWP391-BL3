package dal;

import entity.Product;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductDBContext extends DBContext {

    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM product";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setProductCode(rs.getString("productCode"));
                product.setName(rs.getString("name"));
                product.setBrand(rs.getString("brand"));
                product.setCompany(rs.getString("company"));
                product.setCategoryName(rs.getString("categoryName"));
                product.setUnit(rs.getInt("unit"));
                products.add(product);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return products;
    }

    public List<Product> searchProducts(String searchTerm, String category, String company, String brand) {
        List<Product> products = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM product WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR productCode LIKE ?)");
            String term = "%" + searchTerm + "%";
            params.add(term);
            params.add(term);
        }

        if (category != null && !category.trim().isEmpty()) {
            sql.append(" AND categoryName = ?");
            params.add(category);
        }

        if (company != null && !company.trim().isEmpty()) {
            sql.append(" AND company = ?");
            params.add(company);
        }

        if (brand != null && !brand.trim().isEmpty()) {
            sql.append(" AND brand = ?");
            params.add(brand);
        }

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Product product = new Product();
                    product.setId(rs.getInt("id"));
                    product.setProductCode(rs.getString("productCode"));
                    product.setName(rs.getString("name"));
                    product.setBrand(rs.getString("brand"));
                    product.setCompany(rs.getString("company"));
                    product.setCategoryName(rs.getString("categoryName"));
                    product.setUnit(rs.getInt("unit"));
                    products.add(product);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return products;
    }

    public List<String> getAllCategories() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT categoryName FROM product WHERE categoryName IS NOT NULL";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                categories.add(rs.getString("categoryName"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categories;
    }

    public List<String> getAllCompanies() {
        List<String> companies = new ArrayList<>();
        String sql = "SELECT DISTINCT company FROM product WHERE company IS NOT NULL";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                companies.add(rs.getString("company"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return companies;
    }

    public List<String> getAllBrands() {
        List<String> brands = new ArrayList<>();
        String sql = "SELECT DISTINCT brand FROM product WHERE brand IS NOT NULL";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                brands.add(rs.getString("brand"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return brands;
    }
}