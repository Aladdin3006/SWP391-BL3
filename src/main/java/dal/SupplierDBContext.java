package dal;

import entity.Supplier;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SupplierDBContext extends DBContext {

    public List<Supplier> getSupplierListWithPaging(String search, String statusFilter, int page, int pageSize) {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT id, supplierCode, name, contactPerson, phone, email, address, status FROM Supplier WHERE 1=1";
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql += " AND (name LIKE ? OR supplierCode LIKE ? OR contactPerson LIKE ?)";
            params.add("%" + search.trim() + "%");
            params.add("%" + search.trim() + "%");
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
                Supplier s = new Supplier();
                s.setId(rs.getInt("id"));
                s.setSupplierCode(rs.getString("supplierCode"));
                s.setName(rs.getString("name"));
                s.setContactPerson(rs.getString("contactPerson"));
                s.setPhone(rs.getString("phone"));
                s.setEmail(rs.getString("email"));
                s.setAddress(rs.getString("address"));
                s.setStatus(rs.getString("status"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countSuppliers(String search, String statusFilter) {
        String sql = "SELECT COUNT(*) FROM Supplier WHERE 1=1";
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql += " AND (name LIKE ? OR supplierCode LIKE ? OR contactPerson LIKE ?)";
            params.add("%" + search.trim() + "%");
            params.add("%" + search.trim() + "%");
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

    public Supplier getSupplierById(int id) {
        String sql = "SELECT id, supplierCode, name, contactPerson, phone, email, address, status FROM Supplier WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Supplier s = new Supplier();
                s.setId(rs.getInt("id"));
                s.setSupplierCode(rs.getString("supplierCode"));
                s.setName(rs.getString("name"));
                s.setContactPerson(rs.getString("contactPerson"));
                s.setPhone(rs.getString("phone"));
                s.setEmail(rs.getString("email"));
                s.setAddress(rs.getString("address"));
                s.setStatus(rs.getString("status"));
                return s;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Supplier getSupplierByCode(String code) {
        String sql = "SELECT id, supplierCode, name, contactPerson, phone, email, address, status FROM Supplier WHERE supplierCode = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Supplier s = new Supplier();
                s.setId(rs.getInt("id"));
                s.setSupplierCode(rs.getString("supplierCode"));
                s.setName(rs.getString("name"));
                s.setContactPerson(rs.getString("contactPerson"));
                s.setPhone(rs.getString("phone"));
                s.setEmail(rs.getString("email"));
                s.setAddress(rs.getString("address"));
                s.setStatus(rs.getString("status"));
                return s;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void addSupplier(Supplier supplier) {
        String sql = "INSERT INTO Supplier (supplierCode, name, contactPerson, phone, email, address, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, supplier.getSupplierCode());
            ps.setString(2, supplier.getName());
            ps.setString(3, supplier.getContactPerson());
            ps.setString(4, supplier.getPhone());
            ps.setString(5, supplier.getEmail());
            ps.setString(6, supplier.getAddress());
            ps.setString(7, supplier.getStatus());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Add supplier failed", e);
        }
    }

    public void updateSupplier(Supplier supplier) {
        String sql = "UPDATE Supplier SET supplierCode = ?, name = ?, contactPerson = ?, phone = ?, email = ?, address = ?, status = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, supplier.getSupplierCode());
            ps.setString(2, supplier.getName());
            ps.setString(3, supplier.getContactPerson());
            ps.setString(4, supplier.getPhone());
            ps.setString(5, supplier.getEmail());
            ps.setString(6, supplier.getAddress());
            ps.setString(7, supplier.getStatus());
            ps.setInt(8, supplier.getId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Update supplier failed", e);
        }
    }

    public void updateStatus(int id, String status) {
        String sql = "UPDATE Supplier SET status = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean isSupplierCodeExists(String code, int excludeId) {
        String sql = "SELECT COUNT(*) FROM Supplier WHERE supplierCode = ? AND id != ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            ps.setInt(2, excludeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}