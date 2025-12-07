package entity;

import java.sql.Date;

public class RequestTransferTicket {
    private int id;
    private String ticketCode;
    private String type;
    private Date requestDate;
    private String status;
    private int createdBy;
    private String note;

    public RequestTransferTicket() {}

    public RequestTransferTicket(int id, String ticketCode, String type, Date requestDate, String status, int createdBy, String note) {
        this.id = id;
        this.ticketCode = ticketCode;
        this.type = type;
        this.requestDate = requestDate;
        this.status = status;
        this.createdBy = createdBy;
        this.note = note;
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
}