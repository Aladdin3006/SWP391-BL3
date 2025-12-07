package controller.common;

import dal.UserDBContext;
import entity.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ProfileController", urlPatterns = {"/profile"})
public class ProfileController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserDBContext db = new UserDBContext();
        User user;

        HttpSession session = request.getSession();
        User sessionUser = (User) session.getAttribute("user");

        if (sessionUser != null) {
            user = db.getUserById(sessionUser.getUserId());
        } else {
            user = db.getUserById(1);
            if (user == null) {
                response.sendRedirect("login");
                return;
            }
        }

        request.setAttribute("profileUser", user);
        request.getRequestDispatcher("/view/profile/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        UserDBContext db = new UserDBContext();
        HttpSession session = request.getSession();

        if ("update".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String displayName = request.getParameter("displayName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            User user = db.getUserById(userId);
            if (user != null) {
                user.setDisplayName(displayName);
                user.setEmail(email);
                user.setPhone(phone);

                boolean success = db.updateUser(user);
                if (success) {
                    request.setAttribute("message", "Profile updated successfully!");
                    User updatedUser = db.getUserById(userId);
                    session.setAttribute("user", updatedUser);
                } else {
                    request.setAttribute("error", "Failed to update profile.");
                }

                request.setAttribute("profileUser", user);
                request.getRequestDispatcher("/view/profile/profile.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("profile");
        }
    }
}