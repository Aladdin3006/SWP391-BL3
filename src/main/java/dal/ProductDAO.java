package dal;

import entity.Product;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO extends DBContext {

    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM product WHERE status = 'active' ORDER BY name";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setProductCode(rs.getString("productCode"));
                p.setName(rs.getString("name"));
                p.setBrand(rs.getString("brand"));
                p.setCompany(rs.getString("company"));
                p.setCategoryName(rs.getString("categoryName"));
                p.setUnit(rs.getInt("unit"));
                p.setSupplierId(rs.getInt("supplierId"));
                p.setStatus(rs.getString("status"));
                p.setUrl(rs.getString("url"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Product getProductById(int id) {
        String sql = "SELECT * FROM product WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setProductCode(rs.getString("productCode"));
                p.setName(rs.getString("name"));
                p.setBrand(rs.getString("brand"));
                p.setCompany(rs.getString("company"));
                p.setCategoryName(rs.getString("categoryName"));
                p.setUnit(rs.getInt("unit"));
                p.setSupplierId(rs.getInt("supplierId"));
                p.setStatus(rs.getString("status"));
                p.setUrl(rs.getString("url"));
                return p;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}

