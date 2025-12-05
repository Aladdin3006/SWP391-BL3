package controller;

import dal.UserDBContext;
import entity.User;
import java.io.IOException;
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
        // Load trang form thêm user
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
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String status = request.getParameter("status");
        String roleIdStr = request.getParameter("roleId");
        String workspaceIdStr = request.getParameter("workspaceId");

        UserDBContext db = new UserDBContext();
        String error = null;

        // Validate dữ liệu
        if (accountName == null || accountName.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                roleIdStr == null || workspaceIdStr == null) {
            error = "Required fields are missing.";
        }


        if (error == null && db.getUserByAccountName(accountName) != null) {
            error = "Username already exists.";
        }

        if (error != null) {
            request.setAttribute("error", error);
            request.setAttribute("accountName", accountName);
            request.setAttribute("displayName", displayName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/view/user/adduser.jsp").forward(request, response);
            return;
        }

        // Chuyển roleId và workspaceId về int
        int roleId = Integer.parseInt(roleIdStr);
        int workspaceId = Integer.parseInt(workspaceIdStr);

        // Tạo user mới
        User newUser = new User();
        newUser.setAccountName(accountName);
        newUser.setDisplayName(displayName);
        newUser.setPassword(password);
        newUser.setEmail(email);
        newUser.setPhone(phone);
        newUser.setRoleId(roleId);
        newUser.setWorkspaceId(workspaceId);
        newUser.setStatus(status);

        User createdUser = db.addNewUser(newUser);

        if (createdUser != null) {
            request.setAttribute("message", "Add user successful!");
        } else {
            request.setAttribute("error", "Failed to create new user.");
        }
    }
}
