package entity;

import java.sql.Date;
import java.util.List;

public class RequestTransferTicket {
    private int id;
    private String ticketCode;
    private String type;
    private Date requestDate;
    private String status;
    private int createdBy;
    private String note;
    private int employeeId;
    private List<ProductTransferItem> productTransfers;
    
    // Additional fields for display
    private String employeeName;

    public RequestTransferTicket() {}

    public RequestTransferTicket(int id, String ticketCode, String type, Date requestDate, String status,
                                 int createdBy, String note, int employeeId, List<ProductTransferItem> productTransfers) {
        this.id = id;
        this.ticketCode = ticketCode;
        this.type = type;
        this.requestDate = requestDate;
        this.status = status;
        this.createdBy = createdBy;
        this.note = note;
        this.employeeId = employeeId;
        this.productTransfers = productTransfers;
    }

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
    public List<ProductTransferItem> getProductTransfers() { return productTransfers; }
    public void setProductTransfers(List<ProductTransferItem> productTransfers) { this.productTransfers = productTransfers; }
    public String getEmployeeName() { return employeeName; }
    public void setEmployeeName(String employeeName) { this.employeeName = employeeName; }
}