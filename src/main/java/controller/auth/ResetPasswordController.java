package controller.auth;

import dal.UserDBContext;
import entity.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name="ResetPasswordController", urlPatterns={"/reset-password"})
public class ResetPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String token = request.getParameter("token");
        UserDBContext db = new UserDBContext();
        User user = db.getUserByToken(token);

        if (user == null) {
            request.setAttribute("error", "Invalid or expired password reset token.");
            request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
            return;
        }
        
        request.setAttribute("token", token);
        request.getRequestDispatcher("/view/auth/reset-password.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String token = request.getParameter("token");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.setAttribute("token", token);
            request.getRequestDispatcher("/view/auth/reset-password.jsp").forward(request, response);
            return;
        }
        
        UserDBContext db = new UserDBContext();
        User user = db.getUserByToken(token);
        
        if (user != null) {
            db.updatePassword(user.getUserId(), password);
            request.setAttribute("message", "Password reset successful. Please login.");
            request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Invalid token.");
            request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
        }
    }
}