package controller.admin;

import dal.RoleDAO;
import dal.UserDAO;
import entity.Role;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/user/update")
public class UpdateUserController extends HttpServlet {

    private UserDAO userDB = new UserDAO();
    private RoleDAO roleDAO = new RoleDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        if (idParam == null) {
            resp.sendRedirect(req.getContextPath() + "/user-list");
            return;
        }

        int userId;
        try {
            userId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/user-list");
            return;
        }

        User user = userDB.getUserById(userId);
        List<Role> roles = roleDAO.getAllRoles();

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/user-list");
            return;
        }

        req.setAttribute("user", user);
        req.setAttribute("roles", roles);
        req.getRequestDispatcher("/view/admin/user/updateuser.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String idParam = req.getParameter("id");
        String displayName = req.getParameter("displayName");
        String phone = req.getParameter("phone");
        String status = req.getParameter("status");
        String roleIdStr = req.getParameter("roleId");

        if (idParam == null || displayName == null || status == null || roleIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/user-list");
            return;
        }

        try {
            int userId = Integer.parseInt(idParam);
            int roleId = Integer.parseInt(roleIdStr);

            User user = userDB.getUserById(userId);
            if (user == null) {
                resp.sendRedirect(req.getContextPath() + "/user-list");
                return;
            }

            user.setDisplayName(displayName);
            user.setPhone(phone);
            user.setStatus(status);
            user.setRoleId(roleId);

            boolean success = userDB.updateUserInfo(user);

            resp.sendRedirect(req.getContextPath() + "/user-list");

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/user-list");
        }
    }
}