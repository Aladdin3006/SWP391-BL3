package dal;

import entity.Supplier;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class SupplierDAO extends DBContext {

    public List<Supplier> getAllSuppliers() {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = "SELECT id, supplierCode, name, contactPerson, phone, email, address, status FROM supplier WHERE status = 'active'";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Supplier s = new Supplier();
                s.setId(rs.getInt("id"));
                s.setSupplierCode(rs.getString("supplierCode"));
                s.setName(rs.getString("name"));
                s.setContactPerson(rs.getString("contactPerson"));
                s.setPhone(rs.getString("phone"));
                s.setEmail(rs.getString("email"));
                s.setAddress(rs.getString("address"));
                s.setStatus(rs.getString("status"));

                suppliers.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return suppliers;
    }
    public List<Supplier> getSuppliersForAddAndEditP(Integer currentSupplierId) {
        List<Supplier> suppliers = new ArrayList<>();

        String sql = """
        SELECT id, supplierCode, name, contactPerson, phone, email, address, status
        FROM supplier
        WHERE status = 'active'
    """;

        // Nếu đang EDIT → cho phép load thêm supplier hiện tại (kể cả inactive)
        if (currentSupplierId != null) {
            sql += " OR id = ?";
        }

        sql += " ORDER BY name ASC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (currentSupplierId != null) {
                ps.setInt(1, currentSupplierId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Supplier s = new Supplier();
                    s.setId(rs.getInt("id"));
                    s.setSupplierCode(rs.getString("supplierCode"));
                    s.setName(rs.getString("name"));
                    s.setContactPerson(rs.getString("contactPerson"));
                    s.setPhone(rs.getString("phone"));
                    s.setEmail(rs.getString("email"));
                    s.setAddress(rs.getString("address"));
                    s.setStatus(rs.getString("status"));

                    suppliers.add(s);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return suppliers;
    }


}
