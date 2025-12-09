package entity;

import java.sql.Date;
import java.util.List;

public class ActualTransferTicket {
    private int id;
    private String ticketCode;
    private int requestTransferId;
    private Date transferDate;
    private String status;
    private int confirmedBy;
    private String note;
    private List<ProductTransferItem> productTransfers;

    public ActualTransferTicket() {}

    public ActualTransferTicket(int id, String ticketCode, int requestTransferId, Date transferDate,
                                String status, int confirmedBy, String note, List<ProductTransferItem> productTransfers) {
        this.id = id;
        this.ticketCode = ticketCode;
        this.requestTransferId = requestTransferId;
        this.transferDate = transferDate;
        this.status = status;
        this.confirmedBy = confirmedBy;
        this.note = note;
        this.productTransfers = productTransfers;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTicketCode() { return ticketCode; }
    public void setTicketCode(String ticketCode) { this.ticketCode = ticketCode; }
    public int getRequestTransferId() { return requestTransferId; }
    public void setRequestTransferId(int requestTransferId) { this.requestTransferId = requestTransferId; }
    public Date getTransferDate() { return transferDate; }
    public void setTransferDate(Date transferDate) { this.transferDate = transferDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public int getConfirmedBy() { return confirmedBy; }
    public void setConfirmedBy(int confirmedBy) { this.confirmedBy = confirmedBy; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public List<ProductTransferItem> getProductTransfers() { return productTransfers; }
    public void setProductTransfers(List<ProductTransferItem> productTransfers) { this.productTransfers = productTransfers; }
}