package dal;

import entity.ActualTransferTicket;
import entity.ProductTransferItem;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ActualTransferDAO extends DBContext {

    public List<ActualTransferTicket> getAll(String search, String status, int page, int pageSize) {
        List<ActualTransferTicket> list = new ArrayList<>();
        String sql = "SELECT a.*, u.displayName "
                + "FROM actual_transfer_ticket a "
                + "LEFT JOIN user u ON a.confirmedBy = u.userId "
                + "WHERE 1=1 ";

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
            if (rs.next()) {
                count = rs.getInt(1);
            }
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
        String sql = "SELECT i.id, i.product_id, i.quantity, p.productCode, p.name "
                + "FROM product_transfer_item i "
                + "JOIN product p ON i.product_id = p.id "
                + "WHERE i.ticket_id = ?";

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

    public void insert(ActualTransferTicket ticket) {
        Connection conn = null;
        PreparedStatement psTicket = null;
        PreparedStatement psItem = null;
        String sqlTicket = "INSERT INTO actual_transfer_ticket "
                + "(ticketCode, requestTransferId, transferDate, status, confirmedBy, note) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        String sqlItem = "INSERT INTO product_transfer_item (ticket_id, product_id, quantity) VALUES (?, ?, ?)";

        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            psTicket = conn.prepareStatement(sqlTicket, java.sql.Statement.RETURN_GENERATED_KEYS);
            psTicket.setString(1, ticket.getTicketCode());
            psTicket.setInt(2, ticket.getRequestTransferId());
            psTicket.setDate(3, ticket.getTransferDate());
            psTicket.setString(4, ticket.getStatus());
            psTicket.setInt(5, ticket.getConfirmedBy());
            psTicket.setString(6, ticket.getNote());
            psTicket.executeUpdate();

            ResultSet rs = psTicket.getGeneratedKeys();
            int generatedId = 0;
            if (rs.next()) {
                generatedId = rs.getInt(1);
            }

            psItem = conn.prepareStatement(sqlItem);
            for (ProductTransferItem item : ticket.getProductTransfers()) {
                psItem.setInt(1, generatedId);
                psItem.setInt(2, item.getProductId());
                psItem.setInt(3, item.getQuantity());
                psItem.addBatch();
            }
            psItem.executeBatch();

            conn.commit();
        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
            }
        } finally {
            try {
                if (psItem != null) {
                    psItem.close();
                }
            } catch (SQLException e) {
            }
            try {
                if (psTicket != null) {
                    psTicket.close();
                }
            } catch (SQLException e) {
            }
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
            }
        }
    }

    public void update(ActualTransferTicket ticket) {
        Connection conn = null;
        String sqlUpdateTicket = "UPDATE actual_transfer_ticket SET transferDate=?, status=?, note=? WHERE id=?";
        String sqlDeleteItems = "DELETE FROM product_transfer_item WHERE ticket_id=?";
        String sqlInsertItems = "INSERT INTO product_transfer_item (ticket_id, product_id, quantity) VALUES (?, ?, ?)";

        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(sqlUpdateTicket)) {
                ps.setDate(1, ticket.getTransferDate());
                ps.setString(2, ticket.getStatus());
                ps.setString(3, ticket.getNote());
                ps.setInt(4, ticket.getId());
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(sqlDeleteItems)) {
                ps.setInt(1, ticket.getId());
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(sqlInsertItems)) {
                for (ProductTransferItem item : ticket.getProductTransfers()) {
                    ps.setInt(1, ticket.getId());
                    ps.setInt(2, item.getProductId());
                    ps.setInt(3, item.getQuantity());
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            conn.commit();
        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
            }
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
            }
        }
    }
    
    public List<ActualTransferTicket> getAllByTypeAndDateAndStorekeeper(String type, String dateFrom, String dateTo, String search, Integer storekeeperId, int page, int pageSize) {
        List<ActualTransferTicket> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT a.*, ")
                .append("cb.displayName as confirmedByName, ")
                .append("r.ticketCode as requestTicketCode, ")
                .append("r.type as requestType ")
                .append("FROM actual_transfer_ticket a ")
                .append("LEFT JOIN user cb ON a.confirmedBy = cb.userId ")
                .append("LEFT JOIN request_transfer_ticket r ON a.requestTransferId = r.id ")
                .append("WHERE r.type = ? AND r.employeeId = ? ");
        
        List<Object> params = new ArrayList<>();
        params.add(type);
        params.add(storekeeperId);
        
        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            sql.append("AND a.transferDate >= ? ");
            params.add(dateFrom);
        }
        
        if (dateTo != null && !dateTo.trim().isEmpty()) {
            sql.append("AND a.transferDate <= ? ");
            params.add(dateTo);
        }
        
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (a.ticketCode LIKE ? OR a.note LIKE ?) ");
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }
        
        sql.append("ORDER BY a.transferDate DESC, a.createdAt DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ActualTransferTicket a = new ActualTransferTicket();
                a.setId(rs.getInt("id"));
                a.setTicketCode(rs.getString("ticketCode"));
                a.setRequestTransferId(rs.getInt("requestTransferId"));
                a.setTransferDate(rs.getDate("transferDate"));
                a.setStatus(rs.getString("status"));
                a.setConfirmedBy(rs.getInt("confirmedBy"));
                a.setConfirmedByName(rs.getString("confirmedByName"));
                a.setRequestTicketCode(rs.getString("requestTicketCode"));
                a.setNote(rs.getString("note"));
                list.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public int countByTypeAndDateAndStorekeeper(String type, String dateFrom, String dateTo, String search, Integer storekeeperId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM actual_transfer_ticket a ")
                .append("LEFT JOIN request_transfer_ticket r ON a.requestTransferId = r.id ")
                .append("WHERE r.type = ? AND r.employeeId = ? ");
        List<Object> params = new ArrayList<>();
        params.add(type);
        params.add(storekeeperId);
        
        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            sql.append("AND a.transferDate >= ? ");
            params.add(dateFrom);
        }
        
        if (dateTo != null && !dateTo.trim().isEmpty()) {
            sql.append("AND a.transferDate <= ? ");
            params.add(dateTo);
        }
        
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (a.ticketCode LIKE ? OR a.note LIKE ?) ");
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
