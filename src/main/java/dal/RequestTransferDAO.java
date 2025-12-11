package dal;

import entity.ProductTransferItem;
import entity.RequestTransferTicket;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class RequestTransferDAO extends DBContext {

    public List<RequestTransferTicket> getAvailableForActual() {
        List<RequestTransferTicket> list = new ArrayList<>();
        String sql = "SELECT id, ticketCode, requestDate FROM request_transfer_ticket "
                + "WHERE id NOT IN (SELECT requestTransferId FROM actual_transfer_ticket) "
                + "AND status != 'Rejected' "
                + "ORDER BY createdAt DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RequestTransferTicket r = new RequestTransferTicket();
                r.setId(rs.getInt("id"));
                r.setTicketCode(rs.getString("ticketCode"));
                r.setRequestDate(rs.getDate("requestDate"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public RequestTransferTicket getById(int id) {
        RequestTransferTicket ticket = null;
        String sql = "SELECT * FROM request_transfer_ticket WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ticket = new RequestTransferTicket();
                ticket.setId(rs.getInt("id"));
                ticket.setTicketCode(rs.getString("ticketCode"));
                ticket.setProductTransfers(getItems(id));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ticket;
    }

    public List<ProductTransferItem> getItems(int reqId) {
        List<ProductTransferItem> items = new ArrayList<>();
        String sql = "SELECT i.product_id, i.quantity, p.productCode, p.name "
                + "FROM request_transfer_item i "
                + "JOIN product p ON i.product_id = p.id "
                + "WHERE i.request_ticket_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reqId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductTransferItem item = new ProductTransferItem();
                item.setProductId(rs.getInt("product_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setProductCode(rs.getString("productCode"));
                item.setProductName(rs.getString("name"));
                items.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return items;
    }
}
