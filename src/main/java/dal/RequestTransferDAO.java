package dal;

import entity.ProductTransferItem;
import entity.RequestTransferTicket;
import entity.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
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

    public List<RequestTransferTicket> getAll(String search, String status, int page, int pageSize) {
        return getAll(search, status, page, pageSize, null, null);
    }
    
    public List<RequestTransferTicket> getAll(String search, String status, int page, int pageSize, Integer employeeId) {
        return getAll(search, status, page, pageSize, employeeId, null);
    }
    
    public List<RequestTransferTicket> getAll(String search, String status, int page, int pageSize, Integer employeeId, Integer departmentId) {
        List<RequestTransferTicket> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT r.*, ")
                .append("cb.displayName as creatorName, ")
                .append("emp.displayName as employeeName ")
                .append("FROM request_transfer_ticket r ")
                .append("LEFT JOIN user cb ON r.createdBy = cb.userId ")
                .append("LEFT JOIN user emp ON r.employeeId = emp.userId ")
                .append("WHERE 1=1 ");
        
        List<Object> params = new ArrayList<>();
        
        if (departmentId != null && departmentId > 0) {
            // Filter by department: show tickets where assigned employee or creator is in same department
            sql.append("AND (r.employeeId IN (SELECT userId FROM user WHERE departmentId = ?) ")
               .append("OR r.createdBy IN (SELECT userId FROM user WHERE departmentId = ?)) ");
            params.add(departmentId);
            params.add(departmentId);
        } else if (employeeId != null && employeeId > 0) {
            // Fallback: filter by specific employee
            sql.append("AND (r.employeeId = ? OR r.createdBy = ?) ");
            params.add(employeeId);
            params.add(employeeId);
        }
        
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (r.ticketCode LIKE ? OR r.note LIKE ?) ");
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }
        
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND r.status = ? ");
            params.add(status);
        }
        
        sql.append("ORDER BY r.createdAt DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RequestTransferTicket r = new RequestTransferTicket();
                r.setId(rs.getInt("id"));
                r.setTicketCode(rs.getString("ticketCode"));
                r.setType(rs.getString("type"));
                r.setRequestDate(rs.getDate("requestDate"));
                r.setStatus(rs.getString("status"));
                r.setCreatedBy(rs.getInt("createdBy"));
                r.setNote(rs.getString("note"));
                r.setEmployeeId(rs.getInt("employeeId"));
                r.setEmployeeName(rs.getString("employeeName"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int count(String search, String status) {
        return count(search, status, null, null);
    }
    
    public int count(String search, String status, Integer employeeId) {
        return count(search, status, employeeId, null);
    }
    
    public int count(String search, String status, Integer employeeId, Integer departmentId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM request_transfer_ticket WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        
        if (departmentId != null && departmentId > 0) {
            // Filter by department
            sql.append("AND (employeeId IN (SELECT userId FROM user WHERE departmentId = ?) ")
               .append("OR createdBy IN (SELECT userId FROM user WHERE departmentId = ?)) ");
            params.add(departmentId);
            params.add(departmentId);
        } else if (employeeId != null && employeeId > 0) {
            // Fallback: filter by specific employee
            sql.append("AND (employeeId = ? OR createdBy = ?) ");
            params.add(employeeId);
            params.add(employeeId);
        }
        
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (ticketCode LIKE ? OR note LIKE ?) ");
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }
        
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND status = ? ");
            params.add(status);
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

    public RequestTransferTicket getById(int id) {
        RequestTransferTicket ticket = null;
        String sql = "SELECT r.*, "
                + "cb.displayName as creatorName, "
                + "emp.displayName as employeeName "
                + "FROM request_transfer_ticket r "
                + "LEFT JOIN user cb ON r.createdBy = cb.userId "
                + "LEFT JOIN user emp ON r.employeeId = emp.userId "
                + "WHERE r.id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ticket = new RequestTransferTicket();
                ticket.setId(rs.getInt("id"));
                ticket.setTicketCode(rs.getString("ticketCode"));
                ticket.setType(rs.getString("type"));
                ticket.setRequestDate(rs.getDate("requestDate"));
                ticket.setStatus(rs.getString("status"));
                ticket.setCreatedBy(rs.getInt("createdBy"));
                ticket.setNote(rs.getString("note"));
                ticket.setEmployeeId(rs.getInt("employeeId"));
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
                + "FROM product_transfer_item i "
                + "JOIN product p ON i.product_id = p.id "
                + "WHERE i.ticket_id = ? AND i.ticket_type = 'request'";
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

    public String generateTicketCode() {
        String sql = "SELECT ticketCode FROM request_transfer_ticket ORDER BY id DESC LIMIT 1";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
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

    public boolean insert(RequestTransferTicket ticket) {
        String sql = "INSERT INTO request_transfer_ticket (ticketCode, type, requestDate, status, createdBy, note, employeeId) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);
            
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, ticket.getTicketCode());
            ps.setString(2, ticket.getType());
            ps.setDate(3, ticket.getRequestDate());
            ps.setString(4, ticket.getStatus());
            ps.setInt(5, ticket.getCreatedBy());
            ps.setString(6, ticket.getNote());
            ps.setInt(7, ticket.getEmployeeId());
            
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int ticketId = rs.getInt(1);
                    
                    // Insert product items
                    if (ticket.getProductTransfers() != null && !ticket.getProductTransfers().isEmpty()) {
                        String itemSql = "INSERT INTO product_transfer_item (ticket_id, ticket_type, product_id, quantity) VALUES (?, 'request', ?, ?)";
                        PreparedStatement itemPs = conn.prepareStatement(itemSql);
                        for (ProductTransferItem item : ticket.getProductTransfers()) {
                            itemPs.setInt(1, ticketId);
                            itemPs.setInt(2, item.getProductId());
                            itemPs.setInt(3, item.getQuantity());
                            itemPs.addBatch();
                        }
                        itemPs.executeBatch();
                    }
                    
                    conn.commit();
                    return true;
                }
            }
            conn.rollback();
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        return false;
    }

    public boolean update(RequestTransferTicket ticket) {
        String sql = "UPDATE request_transfer_ticket SET type = ?, requestDate = ?, status = ?, note = ?, employeeId = ? WHERE id = ?";
        
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, ticket.getType());
            ps.setDate(2, ticket.getRequestDate());
            ps.setString(3, ticket.getStatus());
            ps.setString(4, ticket.getNote());
            ps.setInt(5, ticket.getEmployeeId());
            ps.setInt(6, ticket.getId());
            
            int rows = ps.executeUpdate();
            if (rows > 0) {
                // Delete existing items
                String deleteSql = "DELETE FROM product_transfer_item WHERE ticket_id = ? AND ticket_type = 'request'";
                PreparedStatement deletePs = conn.prepareStatement(deleteSql);
                deletePs.setInt(1, ticket.getId());
                deletePs.executeUpdate();
                
                // Insert new items
                if (ticket.getProductTransfers() != null && !ticket.getProductTransfers().isEmpty()) {
                    String itemSql = "INSERT INTO product_transfer_item (ticket_id, ticket_type, product_id, quantity) VALUES (?, 'request', ?, ?)";
                    PreparedStatement itemPs = conn.prepareStatement(itemSql);
                    for (ProductTransferItem item : ticket.getProductTransfers()) {
                        itemPs.setInt(1, ticket.getId());
                        itemPs.setInt(2, item.getProductId());
                        itemPs.setInt(3, item.getQuantity());
                        itemPs.addBatch();
                    }
                    itemPs.executeBatch();
                }
                
                conn.commit();
                return true;
            }
            conn.rollback();
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        return false;
    }

    public List<User> getEmployeesByDepartment(int departmentId) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.userId, u.accountName, u.displayName "
                + "FROM user u "
                + "JOIN role r ON u.roleId = r.roleId "
                + "WHERE u.departmentId = ? AND u.status = 'active' AND r.roleName = 'employee'";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, departmentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("userId"));
                user.setAccountName(rs.getString("accountName"));
                user.setDisplayName(rs.getString("displayName"));
                list.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<User> getStorekeepersByDepartment(int departmentId) {
        List<User> list = new ArrayList<>();
        String sql = """
        SELECT u.userId, u.accountName, u.displayName 
        FROM user u 
        JOIN role r ON u.roleId = r.roleId 
        JOIN Department d ON u.departmentId = d.id
        WHERE u.departmentId = ? 
          AND u.status = 'active' 
          AND r.roleName = 'storekeeper'
          AND d.status = 'active'
        """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, departmentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("userId"));
                user.setAccountName(rs.getString("accountName"));
                user.setDisplayName(rs.getString("displayName"));
                list.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public List<RequestTransferTicket> getAllByTypeAndDate(String type, String dateFrom, String dateTo, String search, int page, int pageSize) {
        List<RequestTransferTicket> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT r.*, ")
                .append("cb.displayName as creatorName, ")
                .append("emp.displayName as employeeName ")
                .append("FROM request_transfer_ticket r ")
                .append("LEFT JOIN user cb ON r.createdBy = cb.userId ")
                .append("LEFT JOIN user emp ON r.employeeId = emp.userId ")
                .append("WHERE r.type = ? ");
        
        List<Object> params = new ArrayList<>();
        params.add(type);
        
        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            sql.append("AND r.requestDate >= ? ");
            params.add(dateFrom);
        }
        
        if (dateTo != null && !dateTo.trim().isEmpty()) {
            sql.append("AND r.requestDate <= ? ");
            params.add(dateTo);
        }
        
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (r.ticketCode LIKE ? OR r.note LIKE ?) ");
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }
        
        sql.append("ORDER BY r.requestDate DESC, r.createdAt DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RequestTransferTicket r = new RequestTransferTicket();
                r.setId(rs.getInt("id"));
                r.setTicketCode(rs.getString("ticketCode"));
                r.setType(rs.getString("type"));
                r.setRequestDate(rs.getDate("requestDate"));
                r.setStatus(rs.getString("status"));
                r.setCreatedBy(rs.getInt("createdBy"));
                r.setNote(rs.getString("note"));
                r.setEmployeeId(rs.getInt("employeeId"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public int countByTypeAndDate(String type, String dateFrom, String dateTo, String search) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM request_transfer_ticket WHERE type = ? ");
        List<Object> params = new ArrayList<>();
        params.add(type);
        
        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            sql.append("AND requestDate >= ? ");
            params.add(dateFrom);
        }
        
        if (dateTo != null && !dateTo.trim().isEmpty()) {
            sql.append("AND requestDate <= ? ");
            params.add(dateTo);
        }
        
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (ticketCode LIKE ? OR note LIKE ?) ");
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
    
    public List<RequestTransferTicket> getAllByTypeAndDateAndStorekeeper(String type, String dateFrom, String dateTo, String search, Integer storekeeperId, int page, int pageSize) {
        List<RequestTransferTicket> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT r.*, ")
                .append("cb.displayName as creatorName, ")
                .append("emp.displayName as employeeName ")
                .append("FROM request_transfer_ticket r ")
                .append("LEFT JOIN user cb ON r.createdBy = cb.userId ")
                .append("LEFT JOIN user emp ON r.employeeId = emp.userId ")
                .append("WHERE r.type = ? AND r.employeeId = ? ");
        
        List<Object> params = new ArrayList<>();
        params.add(type);
        params.add(storekeeperId);
        
        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            sql.append("AND r.requestDate >= ? ");
            params.add(dateFrom);
        }
        
        if (dateTo != null && !dateTo.trim().isEmpty()) {
            sql.append("AND r.requestDate <= ? ");
            params.add(dateTo);
        }
        
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (r.ticketCode LIKE ? OR r.note LIKE ?) ");
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }
        
        sql.append("ORDER BY r.requestDate DESC, r.createdAt DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RequestTransferTicket r = new RequestTransferTicket();
                r.setId(rs.getInt("id"));
                r.setTicketCode(rs.getString("ticketCode"));
                r.setType(rs.getString("type"));
                r.setRequestDate(rs.getDate("requestDate"));
                r.setStatus(rs.getString("status"));
                r.setCreatedBy(rs.getInt("createdBy"));
                r.setNote(rs.getString("note"));
                r.setEmployeeId(rs.getInt("employeeId"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public int countByTypeAndDateAndStorekeeper(String type, String dateFrom, String dateTo, String search, Integer storekeeperId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM request_transfer_ticket WHERE type = ? AND employeeId = ? ");
        List<Object> params = new ArrayList<>();
        params.add(type);
        params.add(storekeeperId);
        
        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            sql.append("AND requestDate >= ? ");
            params.add(dateFrom);
        }
        
        if (dateTo != null && !dateTo.trim().isEmpty()) {
            sql.append("AND requestDate <= ? ");
            params.add(dateTo);
        }
        
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (ticketCode LIKE ? OR note LIKE ?) ");
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
