package controller.admin;

import dal.PermissionDAO;
import dal.RoleDAO;
import dal.RolePermissionDAO;
import entity.Permission;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet({"/role-permission"})
public class RolePermissionController extends HttpServlet {

    PermissionDAO pdao = new PermissionDAO();
    RolePermissionDAO rpdao = new RolePermissionDAO();
    RoleDAO rdao = new RoleDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int roleId = Integer.parseInt(req.getParameter("roleId"));

        String search = req.getParameter("search") == null ? "" : req.getParameter("search");
        String sort = req.getParameter("sort") == null ? "permissionId" : req.getParameter("sort");
        String dir = req.getParameter("dir") == null ? "ASC" : req.getParameter("dir");

        int page = req.getParameter("page") == null ? 1 : Integer.parseInt(req.getParameter("page"));
        int pageSize = 15;

        int total = pdao.count(search);
        int totalPage = (int) Math.ceil(total * 1.0 / pageSize);

        List<Permission> list = pdao.getAll(search, sort, dir, page, pageSize);
        List<Integer> assigned = rpdao.getAssignedPermissionIds(roleId);

        req.setAttribute("role", rdao.getById(roleId));
        req.setAttribute("roleId", roleId);

        req.setAttribute("permissions", list);
        req.setAttribute("assigned", assigned);

        req.setAttribute("search", search);
        req.setAttribute("sort", sort);
        req.setAttribute("dir", dir);

        req.setAttribute("page", page);
        req.setAttribute("totalPage", totalPage);

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
        }
        if ("remove".equals(action)) {
            rpdao.remove(roleId, permissionId);
        }

        resp.sendRedirect("role-permission?roleId=" + roleId);
    }
}