package entity;

import java.sql.Date;

public class ExportRequest {
    private int id;
    private int employeeId;
    private int storekeeperId;
    private Date requestDate;
    private String status;
    private String note;
    private Integer exportId;

    public ExportRequest() {}

    public ExportRequest(int id, int employeeId, int storekeeperId, Date requestDate, String status, String note, Integer exportId) {
        this.id = id;
        this.employeeId = employeeId;
        this.storekeeperId = storekeeperId;
        this.requestDate = requestDate;
        this.status = status;
        this.note = note;
        this.exportId = exportId;
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
    public Integer getExportId() { return exportId; }
    public void setExportId(Integer exportId) { this.exportId = exportId; }
}