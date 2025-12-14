package entity;

import java.sql.Date;
import java.sql.Timestamp;

public class ProductChange {
    private int id;
    private int productId;
    private String changeType;  // MANUAL or TRANSFER-TICKET
    private Date changeDate;
    private int beforeChange;
    private int afterChange;
    private int changeAmount;
    private String ticketId;
    private String note;
    private Timestamp createdAt;
    private int createdBy;

    public ProductChange() {}

    public ProductChange(int id, int productId, String changeType, Date changeDate,
                         int beforeChange, int afterChange, int changeAmount, String ticketId,
                         String note, Timestamp createdAt, int createdBy) {
        this.id = id;
        this.productId = productId;
        this.changeType = changeType;
        this.changeDate = changeDate;
        this.beforeChange = beforeChange;
        this.afterChange = afterChange;
        this.changeAmount = changeAmount;
        this.ticketId = ticketId;
        this.note = note;
        this.createdAt = createdAt;
        this.createdBy = createdBy;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public String getChangeType() { return changeType; }
    public void setChangeType(String changeType) { this.changeType = changeType; }
    public Date getChangeDate() { return changeDate; }
    public void setChangeDate(Date changeDate) { this.changeDate = changeDate; }
    public int getBeforeChange() { return beforeChange; }
    public void setBeforeChange(int beforeChange) { this.beforeChange = beforeChange; }
    public int getAfterChange() { return afterChange; }
    public void setAfterChange(int afterChange) { this.afterChange = afterChange; }
    public int getChangeAmount() { return changeAmount; }
    public void setChangeAmount(int changeAmount) { this.changeAmount = changeAmount; }
    public String getTicketId() { return ticketId; }
    public void setTicketId(String ticketId) { this.ticketId = ticketId; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }
}