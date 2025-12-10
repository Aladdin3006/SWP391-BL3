package controller.auth;

import dal.UserDBContext;
import entity.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import util.RoleNavigationHelper;

@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String u = request.getParameter("username");
        String p = request.getParameter("password");

        UserDBContext db = new UserDBContext();
        User user = db.getUserByAccountName(u);

        if (user != null && user.getPassword().equals(p)) {
            if (!"active".equals(user.getStatus())) {
                request.setAttribute("error", "Please verify your email before logging in.");
                request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
                return;
            }
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            String roleName = (user.getRole() != null) ? user.getRole().getRoleName() : "User";
            String redirectPath = RoleNavigationHelper.getRedirectPath(roleName);
            response.sendRedirect(redirectPath);
        } else {
            request.setAttribute("error", "Invalid username or password.");
            request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
        }
    }
}