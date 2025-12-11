package entity;

public class User {
    private int userId;
    private String accountName;
    private String displayName;
    private String password;
    private String email;
    private String phone;
    private int roleId;
    private String status;
    private int departmentId;
    private String verificationCode;
    private String resetToken; 
    private Role role;

    public User() {}

    public User(int userId, String accountName, String displayName, String password,
                String email, String phone, int roleId, String status, int departmentId) {
        this.userId = userId;
        this.accountName = accountName;
        this.displayName = displayName;
        this.password = password;
        this.email = email;
        this.phone = phone;
        this.roleId = roleId;
        this.status = status;
        this.departmentId = departmentId;
    }

    public User(int userId, String accountName, String displayName, String password,
                String email, String phone, int roleId, String status, int departmentId, String verificationCode) {
        this.userId = userId;
        this.accountName = accountName;
        this.displayName = displayName;
        this.password = password;
        this.email = email;
        this.phone = phone;
        this.roleId = roleId;
        this.status = status;
        this.departmentId = departmentId;
        this.verificationCode = verificationCode;
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getAccountName() { return accountName; }
    public void setAccountName(String accountName) { this.accountName = accountName; }

    public String getDisplayName() { return displayName; }
    public void setDisplayName(String displayName) { this.displayName = displayName; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public int getRoleId() { return roleId; }
    public void setRoleId(int roleId) { this.roleId = roleId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getDepartmentId() { return departmentId; }
    public void setDepartmentId(int departmentId) { this.departmentId = departmentId; }

    public String getVerificationCode() { return verificationCode; }
    public void setVerificationCode(String verificationCode) { this.verificationCode = verificationCode; }

    public String getResetToken() { return resetToken; }
    public void setResetToken(String resetToken) { this.resetToken = resetToken; }

    public Role getRole() { return role; }
    public void setRole(Role role) { this.role = role; }

    public String getRoleName() {
        return role != null ? role.getRoleName() : "";
    }
}