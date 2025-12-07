package controller;

import dal.RoleDAO;
import dal.UserDBContext;
import entity.Role;
import entity.User;
import java.io.IOException;
import java.util.List;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AddUserController", urlPatterns = {"/user/adduser"})
public class AddUserController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RoleDAO roleDB = new RoleDAO();
        List<Role> roles = roleDB.getAllRoles();

        request.setAttribute("roles", roles);
        request.getRequestDispatcher("/view/user/adduser.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Lấy dữ liệu từ form
        String accountName = request.getParameter("accountName");
        String displayName = request.getParameter("displayName");
        String password = request.getParameter("password");
        String cfpassword = request.getParameter("cfpassword");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String roleIdStr = request.getParameter("roleId");
        UserDBContext db = new UserDBContext();
        if (db.getUserByAccountName(accountName) != null) {
            request.setAttribute("errAccountName", "Username already exists.");

            // Gửi lại dữ liệu đã nhập
            request.setAttribute("accountName", accountName);
            request.setAttribute("displayName", displayName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);

            request.getRequestDispatcher("/view/user/adduser.jsp").forward(request, response);
            return;
        }


        // Chuyển roleId và workspaceId về int
        int roleId = Integer.parseInt(roleIdStr);

        // Tạo user mới
        User newUser = new User();
        newUser.setAccountName(accountName);
        newUser.setDisplayName(displayName);
        newUser.setPassword(password);
        newUser.setEmail(email);
        newUser.setPhone(phone);
        newUser.setRoleId(roleId);
        newUser.setStatus("active");
        newUser.setWorkspaceId(1);
        User createdUser = db.addNewUser(newUser);

        if (createdUser != null) {
            request.setAttribute("successMessage", "User added successfully!");
            request.setAttribute("newUserId", createdUser.getUserId());
        } else {
            request.setAttribute("errorMessage", "Failed to create new user.");
        }
        request.getRequestDispatcher("/view/user/adduser.jsp").forward(request, response);
    }
}
