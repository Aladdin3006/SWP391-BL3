package entity;

public class User {
    private int userId;
    private String accountName;
    private String displayName;
    private String password;
    private String email;
    private String phone;
    private String role;
    private boolean status;
    private int workspaceId;

    public User() {}

    public User(int userId, String accountName, String displayName, String password,
                String email, String phone, String role, boolean status, int workspaceId) {
        this.userId = userId;
        this.accountName = accountName;
        this.displayName = displayName;
        this.password = password;
        this.email = email;
        this.phone = phone;
        this.role = role;
        this.status = status;
        this.workspaceId = workspaceId;
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

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public boolean isStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }

    public int getWorkspaceId() { return workspaceId; }
    public void setWorkspaceId(int workspaceId) { this.workspaceId = workspaceId; }
}