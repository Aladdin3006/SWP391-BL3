package controller.common;

import dal.UserDAO;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "EmailChangeController", urlPatterns = {"/verify-email-change"})
public class EmailChangeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");
        String newEmail = request.getParameter("email");
        int userId = 0;

        try {
            userId = Integer.parseInt(request.getParameter("userId"));
        } catch (NumberFormatException e) {
            response.sendRedirect("profile?error=Invalid verification link");
            return;
        }

        UserDAO db = new UserDAO();
        User user = db.getUserById(userId);

        if (user != null && token != null && token.equals(user.getVerificationCode())) {
            user.setEmail(newEmail);
            user.setVerificationCode(null);

            boolean updated = db.updateUser(user);

            if (updated) {
                HttpSession session = request.getSession();
                User updatedUser = db.getUserById(userId);
                session.setAttribute("user", updatedUser);
                response.sendRedirect("profile?message=Email changed successfully!");
            } else {
                response.sendRedirect("profile?error=Failed to update email");
            }
        } else {
            response.sendRedirect("profile?error=Invalid verification link");
        }
    }
}