package controller.admin;

import dal.RoleDAO;
import entity.Role;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewRoleListController", urlPatterns = {"/view-role-list"})
public class ViewRoleListController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String pageParam = request.getParameter("page");
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");

        int pageIndex = 1;
        int pageSize = PAGE_SIZE;

        if (pageParam != null) {
            try {
                pageIndex = Integer.parseInt(pageParam);
                if (pageIndex < 1) {
                    pageIndex = 1;
                }
            } catch (NumberFormatException e) {
                pageIndex = 1;
            }
        }

        RoleDAO dao = new RoleDAO();

        List<Role> roles = dao.getAllRoles(keyword, status, pageIndex, pageSize);
        int totalRecords = dao.countRoles(keyword, status);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        request.setAttribute("roles", roles);
        request.setAttribute("pageIndex", pageIndex);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("keyword", keyword == null ? "" : keyword);
        request.setAttribute("status", status == null ? "all" : status);

        request.getRequestDispatcher("/view/admin/role/view-role-list.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
        RoleDAO dao = new RoleDAO();

        if ("add".equals(action)) {
            String roleName = request.getParameter("roleName");
            String roleDescription = request.getParameter("roleDescription");
            String status = request.getParameter("status");

            if (roleName != null && !roleName.trim().isEmpty()) {
                Role role = new Role();
                role.setRoleName(roleName.trim());
                role.setRoleDescription(roleDescription != null ? roleDescription.trim() : "");
                role.setStatus(status != null ? status : "active");
                dao.insert(role);
            }
        }

        if ("edit".equals(action)) {
            String idParam = request.getParameter("roleId");
            String roleName = request.getParameter("roleName");
            String roleDescription = request.getParameter("roleDescription");
            String status = request.getParameter("status");

            if (idParam != null && roleName != null && !roleName.trim().isEmpty()) {
                try {
                    int roleId = Integer.parseInt(idParam);
                    Role role = new Role();
                    role.setRoleId(roleId);
                    role.setRoleName(roleName.trim());
                    role.setRoleDescription(roleDescription != null ? roleDescription.trim() : "");
                    role.setStatus(status != null ? status : "active");
                    dao.update(role);
                } catch (NumberFormatException e) {
                }
            }
        }

        if ("delete".equals(action)) {
            String idParam = request.getParameter("roleId");
            if (idParam != null) {
                try {
                    int roleId = Integer.parseInt(idParam);
                    dao.toggleStatus(roleId);
                } catch (NumberFormatException e) {
                }
            }
        }

        response.sendRedirect("view-role-list");
    }
}