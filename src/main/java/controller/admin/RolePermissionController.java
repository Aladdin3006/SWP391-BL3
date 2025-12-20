package controller.admin;

import dal.PermissionDAO;
import dal.RoleDAO;
import dal.RolePermissionDAO;
import entity.Permission;
import entity.Role;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet({"/role-permission"})
public class RolePermissionController extends HttpServlet {

    PermissionDAO pdao = new PermissionDAO();
    RolePermissionDAO rpdao = new RolePermissionDAO();
    RoleDAO rdao = new RoleDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<Role> allRoles = rdao.getAllRoles();
        req.setAttribute("allRoles", allRoles);

        List<Permission> allPermissions = pdao.getAll("", "permissionId", "ASC", 1, Integer.MAX_VALUE);
        req.setAttribute("allPermissions", allPermissions);

        Map<Integer, Set<Integer>> rolePermissionsMap = rpdao.getAllRolePermissionMappings();
        req.setAttribute("rolePermissionsMap", rolePermissionsMap);

        req.getRequestDispatcher("view/admin/permission/role-permission.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        int roleId = Integer.parseInt(req.getParameter("roleId"));
        int permissionId = Integer.parseInt(req.getParameter("permissionId"));

        if ("assign".equals(action)) {
            rpdao.assign(roleId, permissionId);
        } else if ("remove".equals(action)) {
            rpdao.remove(roleId, permissionId);
        }

        resp.sendRedirect("role-permission");
    }
}