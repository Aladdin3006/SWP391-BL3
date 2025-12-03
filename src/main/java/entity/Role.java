package entity;

public class Role {
    private int roleId;
    private String roleName;
    private String roleDescription;
    private String status;

    public Role() {}

    public Role(int roleId, String roleName, String roleDescription, String status) {
        this.roleId = roleId;
        this.roleName = roleName;
        this.roleDescription = roleDescription;
        this.status = status;
    }

    public int getRoleId() { return roleId; }
    public void setRoleId(int roleId) { this.roleId = roleId; }

    public String getRoleName() { return roleName; }
    public void setRoleName(String roleName) { this.roleName = roleName; }

    public String getRoleDescription() { return roleDescription; }
    public void setRoleDescription(String roleDescription) { this.roleDescription = roleDescription; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}