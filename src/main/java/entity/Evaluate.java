package entity;

import java.util.Date;

public class Evaluate {
    private int id;
    private int employeeId;
    private int createdBy;
    private String period;
    private int performance;
    private int accuracy;
    private int safetyCompliance;
    private int teamwork;
    private double avgStar;
    private Date createdAt;

    private User employee;
    private Department department;

    public Evaluate() {}

    public Evaluate(int id, int employeeId, int createdBy, String period,
                    int performance, int accuracy, int safetyCompliance,
                    int teamwork, double avgStar, Date createdAt) {
        this.id = id;
        this.employeeId = employeeId;
        this.createdBy = createdBy;
        this.period = period;
        this.performance = performance;
        this.accuracy = accuracy;
        this.safetyCompliance = safetyCompliance;
        this.teamwork = teamwork;
        this.avgStar = avgStar;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getEmployeeId() { return employeeId; }
    public void setEmployeeId(int employeeId) { this.employeeId = employeeId; }

    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }

    public String getPeriod() { return period; }
    public void setPeriod(String period) { this.period = period; }

    public int getPerformance() { return performance; }
    public void setPerformance(int performance) { this.performance = performance; }

    public int getAccuracy() { return accuracy; }
    public void setAccuracy(int accuracy) { this.accuracy = accuracy; }

    public int getSafetyCompliance() { return safetyCompliance; }
    public void setSafetyCompliance(int safetyCompliance) { this.safetyCompliance = safetyCompliance; }

    public int getTeamwork() { return teamwork; }
    public void setTeamwork(int teamwork) { this.teamwork = teamwork; }

    public double getAvgStar() { return avgStar; }
    public void setAvgStar(double avgStar) { this.avgStar = avgStar; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public User getEmployee() { return employee; }
    public void setEmployee(User employee) { this.employee = employee; }

    public Department getDepartment() { return department; }
    public void setDepartment(Department department) { this.department = department; }
}