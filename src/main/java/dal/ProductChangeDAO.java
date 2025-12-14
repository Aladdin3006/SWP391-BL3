package dal;

import entity.ProductChange;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class ProductChangeDAO extends DBContext {

    public boolean insert(ProductChange productChange) {
        String sql = "INSERT INTO product_change (product_id, change_type, change_date, " +
                "before_change, after_change, change_amount, ticket_id, note, created_at, created_by) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productChange.getProductId());
            ps.setString(2, productChange.getChangeType());
            ps.setDate(3, productChange.getChangeDate());
            ps.setInt(4, productChange.getBeforeChange());
            ps.setInt(5, productChange.getAfterChange());
            ps.setInt(6, productChange.getChangeAmount());

            if (productChange.getTicketId() != null) {
                ps.setString(7, productChange.getTicketId());
            } else {
                ps.setNull(7, java.sql.Types.VARCHAR);
            }

            ps.setString(8, productChange.getNote());
            ps.setTimestamp(9, new Timestamp(System.currentTimeMillis()));
            ps.setInt(10, productChange.getCreatedBy());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<ProductChange> getProductChangesByProductId(int productId) {
        List<ProductChange> list = new ArrayList<>();
        String sql = "SELECT * FROM product_change WHERE product_id = ? ORDER BY change_date DESC, created_at DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ProductChange pc = new ProductChange();
                pc.setId(rs.getInt("id"));
                pc.setProductId(rs.getInt("product_id"));
                pc.setChangeType(rs.getString("change_type"));
                pc.setChangeDate(rs.getDate("change_date"));
                pc.setBeforeChange(rs.getInt("before_change"));
                pc.setAfterChange(rs.getInt("after_change"));
                pc.setChangeAmount(rs.getInt("change_amount"));
                pc.setTicketId(rs.getString("ticket_id"));
                pc.setNote(rs.getString("note"));
                pc.setCreatedAt(rs.getTimestamp("created_at"));
                pc.setCreatedBy(rs.getInt("created_by"));

                list.add(pc);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}