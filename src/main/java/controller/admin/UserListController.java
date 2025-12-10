package controller.admin;

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

@WebServlet(name = "UserListController", urlPatterns = {"/user-list"})
public class UserListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserDBContext db = new UserDBContext();


        String action = request.getParameter("action");
        String idStr = request.getParameter("userId");

        if (action != null && idStr != null) {
            try {
                int uid = Integer.parseInt(idStr);
                if (action.equals("activate")) db.updateUserStatus(uid, "active");
                if (action.equals("deactivate")) db.updateUserStatus(uid, "inactive");

                response.sendRedirect("user-list");
                return;
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }



        String searchName = request.getParameter("searchName");
        String searchEmail = request.getParameter("searchEmail");
        String roleIdRaw = request.getParameter("roleId");
        String status = request.getParameter("status");

        Integer roleId = (roleIdRaw == null || roleIdRaw.equals("0") || roleIdRaw.isEmpty()) ? null : Integer.parseInt(roleIdRaw);
        String statusFilter = (status == null) ? "all" : status;


        List<User> listUser = db.getUsersWithFilter(searchName, searchEmail, roleId, statusFilter);
        List<Role> listRole = db.getAllRoles();

        request.setAttribute("users", listUser);
        request.setAttribute("roles", listRole);

        request.setAttribute("searchName", searchName);
        request.setAttribute("searchEmail", searchEmail);
        request.setAttribute("selectedRoleId", roleId == null ? 0 : roleId);
        request.setAttribute("selectedStatus", statusFilter);

        request.getRequestDispatcher("view/admin/user/user-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}