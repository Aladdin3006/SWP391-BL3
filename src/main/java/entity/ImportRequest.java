package entity;

import java.sql.Date;

public class ImportRequest {
    private int id;
    private int employeeId;
    private int storekeeperId;
    private Date requestDate;
    private String status;
    private String note;
    private Integer importId;

    public ImportRequest() {}

    public ImportRequest(int id, int employeeId, int storekeeperId, Date requestDate, String status, String note, Integer importId) {
        this.id = id;
        this.employeeId = employeeId;
        this.storekeeperId = storekeeperId;
        this.requestDate = requestDate;
        this.status = status;
        this.note = note;
        this.importId = importId;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getEmployeeId() { return employeeId; }
    public void setEmployeeId(int employeeId) { this.employeeId = employeeId; }
    public int getStorekeeperId() { return storekeeperId; }
    public void setStorekeeperId(int storekeeperId) { this.storekeeperId = storekeeperId; }
    public Date getRequestDate() { return requestDate; }
    public void setRequestDate(Date requestDate) { this.requestDate = requestDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public Integer getImportId() { return importId; }
    public void setImportId(Integer importId) { this.importId = importId; }
}