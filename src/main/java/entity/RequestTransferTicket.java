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
    private int storekeeperId;
    private List<ProductTransferItem> productTransfers;

    private String storekeeperName;

    public RequestTransferTicket() {}

    public RequestTransferTicket(int id, String ticketCode, String type, Date requestDate, String status,
                                 int createdBy, String note, int storekeeperId, List<ProductTransferItem> productTransfers) {
        this.id = id;
        this.ticketCode = ticketCode;
        this.type = type;
        this.requestDate = requestDate;
        this.status = status;
        this.createdBy = createdBy;
        this.note = note;
        this.storekeeperId = storekeeperId;
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
    public int getStorekeeperId() { return storekeeperId; }
    public void setStorekeeperId(int storekeeperId) { this.storekeeperId = storekeeperId; }
    public List<ProductTransferItem> getProductTransfers() { return productTransfers; }
    public void setProductTransfers(List<ProductTransferItem> productTransfers) { this.productTransfers = productTransfers; }
    public String getStorekeeperName() { return storekeeperName; }
    public void setStorekeeperName(String storekeeperName) { this.storekeeperName = storekeeperName; }
}