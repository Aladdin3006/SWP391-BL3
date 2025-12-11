package dal;

import entity.ActualTransferTicket;
import entity.ProductTransferItem;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ActualTransferDAO extends DBContext {
    public List<ActualTransferTicket> getAll(String search, String status, int page, int pageSize) {
        List<ActualTransferTicket> list = new ArrayList<>();
        String sql = "SELECT a.*, u.displayName " +
                     "FROM actual_transfer_ticket a " +
                     "LEFT JOIN user u ON a.confirmedBy = u.userId " +
                     "WHERE 1=1 ";

        if (search != null && !search.isEmpty()) {
            sql += " AND a.ticketCode LIKE ? ";
        }
        if (status != null && !status.equals("all") && !status.isEmpty()) {
            sql += " AND a.status = ? ";
        }

        sql += " ORDER BY a.createdAt DESC LIMIT ? OFFSET ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int paramIndex = 1;
            if (search != null && !search.isEmpty()) {
                ps.setString(paramIndex++, "%" + search + "%");
            }
            if (status != null && !status.equals("all") && !status.isEmpty()) {
                ps.setString(paramIndex++, status);
            }
            ps.setInt(paramIndex++, pageSize);
            ps.setInt(paramIndex++, (page - 1) * pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ActualTransferTicket ticket = new ActualTransferTicket();
                ticket.setId(rs.getInt("id"));
                ticket.setTicketCode(rs.getString("ticketCode"));
                ticket.setRequestTransferId(rs.getInt("requestTransferId"));
                ticket.setTransferDate(rs.getDate("transferDate"));
                ticket.setStatus(rs.getString("status"));
                ticket.setConfirmedBy(rs.getInt("confirmedBy"));
                ticket.setNote(rs.getString("note"));
                
                list.add(ticket);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int count(String search, String status) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM actual_transfer_ticket a WHERE 1=1 ";

        if (search != null && !search.isEmpty()) {
            sql += " AND a.ticketCode LIKE ? ";
        }
        if (status != null && !status.equals("all") && !status.isEmpty()) {
            sql += " AND a.status = ? ";
        }

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int paramIndex = 1;
            if (search != null && !search.isEmpty()) {
                ps.setString(paramIndex++, "%" + search + "%");
            }
            if (status != null && !status.equals("all") && !status.isEmpty()) {
                ps.setString(paramIndex++, status);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    public ActualTransferTicket getById(int id) {
        String sql = "SELECT * FROM actual_transfer_ticket WHERE id = ?";
        ActualTransferTicket ticket = null;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ticket = new ActualTransferTicket();
                ticket.setId(rs.getInt("id"));
                ticket.setTicketCode(rs.getString("ticketCode"));
                ticket.setRequestTransferId(rs.getInt("requestTransferId"));
                ticket.setTransferDate(rs.getDate("transferDate"));
                ticket.setStatus(rs.getString("status"));
                ticket.setConfirmedBy(rs.getInt("confirmedBy"));
                ticket.setNote(rs.getString("note"));

                ticket.setProductTransfers(getProductsByTicketId(id));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ticket;
    }

    private List<ProductTransferItem> getProductsByTicketId(int ticketId) {
        List<ProductTransferItem> list = new ArrayList<>();
        String sql = "SELECT i.id, i.product_id, i.quantity, p.productCode, p.name " +
                     "FROM actual_transfer_item i " +
                     "JOIN product p ON i.product_id = p.id " +
                     "WHERE i.actual_ticket_id = ?";
        
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ticketId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductTransferItem item = new ProductTransferItem();
                item.setId(rs.getInt("id"));
                item.setProductId(rs.getInt("product_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setProductCode(rs.getString("productCode"));
                item.setProductName(rs.getString("name"));
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
