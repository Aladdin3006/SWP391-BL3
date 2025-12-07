package entity;

public class Department {
    private int id;
    private String departmentName;
    private int storekeeperId;
    private int employeeId;
    private String status;

    public Department() {}

    public Department(int id, String departmentName, int storekeeperId, int employeeId, String status) {
        this.id = id;
        this.departmentName = departmentName;
        this.storekeeperId = storekeeperId;
        this.employeeId = employeeId;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }
    public int getStorekeeperId() { return storekeeperId; }
    public void setStorekeeperId(int storekeeperId) { this.storekeeperId = storekeeperId; }
    public int getEmployeeId() { return employeeId; }
    public void setEmployeeId(int employeeId) { this.employeeId = employeeId; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}