package entity;

public class Workspace {
    private int id;
    private String warehouseName;
    private int storekeeperId;
    private int employeeId;
    private boolean status;

    public Workspace() {}

    public Workspace(int id, String warehouseName, int storekeeperId, int employeeId, boolean status) {
        this.id = id;
        this.warehouseName = warehouseName;
        this.storekeeperId = storekeeperId;
        this.employeeId = employeeId;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getWarehouseName() { return warehouseName; }
    public void setWarehouseName(String warehouseName) { this.warehouseName = warehouseName; }
    public int getStorekeeperId() { return storekeeperId; }
    public void setStorekeeperId(int storekeeperId) { this.storekeeperId = storekeeperId; }
    public int getEmployeeId() { return employeeId; }
    public void setEmployeeId(int employeeId) { this.employeeId = employeeId; }
    public boolean isStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }
}