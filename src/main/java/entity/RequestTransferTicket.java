package entity;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;

public class RequestTransferTicket {
    private int id;
    private String ticketCode;
    private String type; // Import or Export
    private Date requestDate;
    private String status; // Pending, Approved, Completed, Rejected
    private int createdBy;
    private String note;
    private int employeeId;
    private Timestamp createdAt;
    
    // For display purposes
    private String createdByName;
    private String employeeName;
    private List<ProductTransferItem> items;

    public RequestTransferTicket() {}

    public RequestTransferTicket(int id, String ticketCode, String type, Date requestDate, 
                                String status, int createdBy, String note, int employeeId, Timestamp createdAt) {
        this.id = id;
        this.ticketCode = ticketCode;
        this.type = type;
        this.requestDate = requestDate;
        this.status = status;
        this.createdBy = createdBy;
        this.note = note;
        this.employeeId = employeeId;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTicketCode() { return ticketCode; }
    public void setTicketCode(String ticketCode) { this.ticketCode = ticketCode; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public Date getRequestDate() { return requestDate; }
    public void setRequestDate(Date requestDate) { this.requestDate = requestDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public int getEmployeeId() { return employeeId; }
    public void setEmployeeId(int employeeId) { this.employeeId = employeeId; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getCreatedByName() { return createdByName; }
    public void setCreatedByName(String createdByName) { this.createdByName = createdByName; }

    public String getEmployeeName() { return employeeName; }
    public void setEmployeeName(String employeeName) { this.employeeName = employeeName; }

    public List<ProductTransferItem> getItems() { return items; }
    public void setItems(List<ProductTransferItem> items) { this.items = items; }
}
