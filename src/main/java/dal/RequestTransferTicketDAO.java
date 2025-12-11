package dal;

import entity.Product;
import entity.ProductTransferItem;
import entity.RequestTransferTicket;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RequestTransferTicketDAO extends DBContext {

    // Get all tickets with filters
    public List<RequestTransferTicket> getAllTickets(String search, String type, String status, int page, int pageSize) {
        List<RequestTransferTicket> list = new ArrayList<>();
        
        String sql = "SELECT r.*, " +
                    "creator.displayName as createdByName, " +
                    "emp.displayName as employeeName " +
                    "FROM request_transfer_ticket r " +
                    "LEFT JOIN user creator ON r.createdBy = creator.userId " +
                    "LEFT JOIN user emp ON r.employeeId = emp.userId " +
                    "WHERE 1=1";
        
        if (search != null && !search.isEmpty()) {
            sql += " AND (r.ticketCode LIKE ? OR r.note LIKE ?)";
        }
        
        if (type != null && !type.equals("all")) {
            sql += " AND r.type = ?";
        }
        
        if (status != null && !status.equals("all")) {
            sql += " AND r.status = ?";
        }
        
        sql += " ORDER BY r.createdAt DESC LIMIT ?, ?";
        
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            
            int paramIndex = 1;
            
            if (search != null && !search.isEmpty()) {
                ps.setString(paramIndex++, "%" + search + "%");
                ps.setString(paramIndex++, "%" + search + "%");
            }
            
            if (type != null && !type.equals("all")) {
                ps.setString(paramIndex++, type);
            }
            
            if (status != null && !status.equals("all")) {
                ps.setString(paramIndex++, status);
            }
            
            ps.setInt(paramIndex++, (page - 1) * pageSize);
            ps.setInt(paramIndex, pageSize);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                RequestTransferTicket ticket = new RequestTransferTicket();
                ticket.setId(rs.getInt("id"));
                ticket.setTicketCode(rs.getString("ticketCode"));
                ticket.setType(rs.getString("type"));
                ticket.setRequestDate(rs.getDate("requestDate"));
                ticket.setStatus(rs.getString("status"));
                ticket.setCreatedBy(rs.getInt("createdBy"));
                ticket.setNote(rs.getString("note"));
                ticket.setEmployeeId(rs.getInt("employeeId"));
                ticket.setCreatedAt(rs.getTimestamp("createdAt"));
                ticket.setCreatedByName(rs.getString("createdByName"));
                ticket.setEmployeeName(rs.getString("employeeName"));
                
                list.add(ticket);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return list;
    }

    // Count tickets with filters
    public int countTickets(String search, String type, String status) {
        String sql = "SELECT COUNT(*) FROM request_transfer_ticket r WHERE 1=1";
        
        if (search != null && !search.isEmpty()) {
            sql += " AND (r.ticketCode LIKE ? OR r.note LIKE ?)";
        }
        
        if (type != null && !type.equals("all")) {
            sql += " AND r.type = ?";
        }
        
        if (status != null && !status.equals("all")) {
            sql += " AND r.status = ?";
        }
        
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            
            int paramIndex = 1;
            
            if (search != null && !search.isEmpty()) {
                ps.setString(paramIndex++, "%" + search + "%");
                ps.setString(paramIndex++, "%" + search + "%");
            }
            
            if (type != null && !type.equals("all")) {
                ps.setString(paramIndex++, type);
            }
            
            if (status != null && !status.equals("all")) {
                ps.setString(paramIndex++, status);
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

    // Get ticket by ID with full details
    public RequestTransferTicket getTicketById(int id) {
        String sql = "SELECT r.*, " +
                    "creator.displayName as createdByName, " +
                    "emp.displayName as employeeName " +
                    "FROM request_transfer_ticket r " +
                    "LEFT JOIN user creator ON r.createdBy = creator.userId " +
                    "LEFT JOIN user emp ON r.employeeId = emp.userId " +
                    "WHERE r.id = ?";
        
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                RequestTransferTicket ticket = new RequestTransferTicket();
                ticket.setId(rs.getInt("id"));
                ticket.setTicketCode(rs.getString("ticketCode"));
                ticket.setType(rs.getString("type"));
                ticket.setRequestDate(rs.getDate("requestDate"));
                ticket.setStatus(rs.getString("status"));
                ticket.setCreatedBy(rs.getInt("createdBy"));
                ticket.setNote(rs.getString("note"));
                ticket.setEmployeeId(rs.getInt("employeeId"));
                ticket.setCreatedAt(rs.getTimestamp("createdAt"));
                ticket.setCreatedByName(rs.getString("createdByName"));
                ticket.setEmployeeName(rs.getString("employeeName"));
                
                // Load items
                ticket.setItems(getItemsByTicketId(id));
                
                return ticket;
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return null;
    }

    // Get items for a ticket
    public List<ProductTransferItem> getItemsByTicketId(int ticketId) {
        List<ProductTransferItem> items = new ArrayList<>();
        
        String sql = "SELECT pti.*, p.* " +
                    "FROM product_transfer_item pti " +
                    "JOIN product p ON pti.product_id = p.id " +
                    "WHERE pti.ticket_id = ? AND pti.ticket_type = 'request'";
        
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            
            ps.setInt(1, ticketId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                ProductTransferItem item = new ProductTransferItem();
                item.setId(rs.getInt("pti.id"));
                item.setTicketId(rs.getInt("ticket_id"));
                item.setTicketType(rs.getString("ticket_type"));
                item.setProductId(rs.getInt("product_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setCreatedAt(rs.getTimestamp("created_at"));
                
                // Set product info
                Product product = new Product();
                product.setId(rs.getInt("p.id"));
                product.setProductCode(rs.getString("productCode"));
                product.setName(rs.getString("name"));
                product.setBrand(rs.getString("brand"));
                product.setCompany(rs.getString("company"));
                product.setCategoryName(rs.getString("categoryName"));
                product.setUnit(rs.getInt("unit"));
                
                item.setProduct(product);
                items.add(item);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return items;
    }

    // Insert new ticket with items (transaction)
    public boolean insertTicket(RequestTransferTicket ticket, List<ProductTransferItem> items) {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);
            
            // Insert ticket
            String sqlTicket = "INSERT INTO request_transfer_ticket " +
                             "(ticketCode, type, requestDate, status, createdBy, note, employeeId) " +
                             "VALUES (?, ?, ?, ?, ?, ?, ?)";
            
            PreparedStatement psTicket = conn.prepareStatement(sqlTicket, Statement.RETURN_GENERATED_KEYS);
            psTicket.setString(1, ticket.getTicketCode());
            psTicket.setString(2, ticket.getType());
            psTicket.setDate(3, ticket.getRequestDate());
            psTicket.setString(4, ticket.getStatus());
            psTicket.setInt(5, ticket.getCreatedBy());
            psTicket.setString(6, ticket.getNote());
            psTicket.setInt(7, ticket.getEmployeeId());
            
            int affected = psTicket.executeUpdate();
            if (affected == 0) {
                conn.rollback();
                return false;
            }
            
            // Get generated ticket ID
            ResultSet generatedKeys = psTicket.getGeneratedKeys();
            int ticketId = 0;
            if (generatedKeys.next()) {
                ticketId = generatedKeys.getInt(1);
            }
            
            // Insert items
            String sqlItem = "INSERT INTO product_transfer_item " +
                           "(ticket_id, ticket_type, product_id, quantity) " +
                           "VALUES (?, 'request', ?, ?)";
            
            PreparedStatement psItem = conn.prepareStatement(sqlItem);
            for (ProductTransferItem item : items) {
                psItem.setInt(1, ticketId);
                psItem.setInt(2, item.getProductId());
                psItem.setInt(3, item.getQuantity());
                psItem.addBatch();
            }
            psItem.executeBatch();
            
            conn.commit();
            return true;
            
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return false;
    }

    // Update ticket (only if status is Pending)
    public boolean updateTicket(RequestTransferTicket ticket, List<ProductTransferItem> items) {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);
            
            // Update ticket
            String sqlTicket = "UPDATE request_transfer_ticket SET " +
                             "type = ?, requestDate = ?, note = ?, employeeId = ? " +
                             "WHERE id = ? AND status = 'Pending'";
            
            PreparedStatement psTicket = conn.prepareStatement(sqlTicket);
            psTicket.setString(1, ticket.getType());
            psTicket.setDate(2, ticket.getRequestDate());
            psTicket.setString(3, ticket.getNote());
            psTicket.setInt(4, ticket.getEmployeeId());
            psTicket.setInt(5, ticket.getId());
            
            int affected = psTicket.executeUpdate();
            if (affected == 0) {
                conn.rollback();
                return false;
            }
            
            // Delete old items
            String sqlDelete = "DELETE FROM product_transfer_item WHERE ticket_id = ? AND ticket_type = 'request'";
            PreparedStatement psDelete = conn.prepareStatement(sqlDelete);
            psDelete.setInt(1, ticket.getId());
            psDelete.executeUpdate();
            
            // Insert new items
            String sqlItem = "INSERT INTO product_transfer_item " +
                           "(ticket_id, ticket_type, product_id, quantity) " +
                           "VALUES (?, 'request', ?, ?)";
            
            PreparedStatement psItem = conn.prepareStatement(sqlItem);
            for (ProductTransferItem item : items) {
                psItem.setInt(1, ticket.getId());
                psItem.setInt(2, item.getProductId());
                psItem.setInt(3, item.getQuantity());
                psItem.addBatch();
            }
            psItem.executeBatch();
            
            conn.commit();
            return true;
            
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return false;
    }

    // Generate unique ticket code
    public String generateTicketCode() {
        String sql = "SELECT ticketCode FROM request_transfer_ticket ORDER BY id DESC LIMIT 1";
        
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String lastCode = rs.getString("ticketCode");
                int num = Integer.parseInt(lastCode.substring(3)) + 1;
                return String.format("REQ%03d", num);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return "REQ001";
    }

    // Get all products for dropdown
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM product WHERE status = 'active'";
        
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setProductCode(rs.getString("productCode"));
                p.setName(rs.getString("name"));
                p.setBrand(rs.getString("brand"));
                p.setCompany(rs.getString("company"));
                p.setCategoryName(rs.getString("categoryName"));
                p.setUnit(rs.getInt("unit"));
                products.add(p);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return products;
    }
}

