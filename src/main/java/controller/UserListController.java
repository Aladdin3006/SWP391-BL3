package controller;

import dal.UserDBContext;
import entity.User;
import entity.Role;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "UserListController", urlPatterns = {"/users"})
public class UserListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserDBContext db = new UserDBContext();

        // vô hiệu hóa và kích hoạt
        String action = request.getParameter("action");
        String idStr = request.getParameter("userId");

        if (action != null && idStr != null) {
            try {
                int uid = Integer.parseInt(idStr);
                if (action.equals("activate")) db.updateUserStatus(uid, "active");
                if (action.equals("deactivate")) db.updateUserStatus(uid, "inactive");

                response.sendRedirect("users");
                return;
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // tìm kiếm và hiển thị


        String searchName = request.getParameter("searchName");
        String searchEmail = request.getParameter("searchEmail");
        String roleIdRaw = request.getParameter("roleId");
        String status = request.getParameter("status");

        Integer roleId = (roleIdRaw == null || roleIdRaw.equals("0") || roleIdRaw.isEmpty()) ? null : Integer.parseInt(roleIdRaw);
        String statusFilter = (status == null) ? "all" : status;

        // gọi DB lấy danh sách User và danh sách Role
        List<User> listUser = db.getUsersWithFilter(searchName, searchEmail, roleId, statusFilter);
        List<Role> listRole = db.getAllRoles();

        request.setAttribute("users", listUser);
        request.setAttribute("roles", listRole);

        request.setAttribute("searchName", searchName);
        request.setAttribute("searchEmail", searchEmail);
        request.setAttribute("selectedRoleId", roleId == null ? 0 : roleId);
        request.setAttribute("selectedStatus", statusFilter);

        // chuyển hướng sang file JSP
        request.getRequestDispatcher("view/admin/user-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}