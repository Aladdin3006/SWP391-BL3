/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;


public class RolePermission {
    private int roleId;
    private int permissionId;

    public RolePermission() {}

    public RolePermission(int roleId, int permissionId) {
        this.roleId = roleId;
        this.permissionId = permissionId;
    }

    public int getRoleId() { return roleId; }
    public void setRoleId(int roleId) { this.roleId = roleId; }

    public int getPermissionId() { return permissionId; }
    public void setPermissionId(int permissionId) { this.permissionId = permissionId; }
}