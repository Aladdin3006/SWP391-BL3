package entity;

public class Department {
    private int id;
    private String departmentName;
    private int storekeeperId;
    private String status;
    private String storekeeperName;
    private int employeeCount;

    public Department() {}

    public Department(int id, String departmentName, int storekeeperId, String status) {
        this.id = id;
        this.departmentName = departmentName;
        this.storekeeperId = storekeeperId;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    public int getStorekeeperId() { return storekeeperId; }
    public void setStorekeeperId(int storekeeperId) { this.storekeeperId = storekeeperId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getStorekeeperName() { return storekeeperName; }
    public void setStorekeeperName(String storekeeperName) { this.storekeeperName = storekeeperName; }

    public int getEmployeeCount() { return employeeCount; }
    public void setEmployeeCount(int employeeCount) { this.employeeCount = employeeCount; }
}