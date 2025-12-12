package controller.auth;

import dal.UserDBContext;
import entity.User;
import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.UUID;
import util.EmailUtility;
import util.MD5;

@WebServlet(name="RegisterController", urlPatterns={"/register"})
public class RegisterController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        String confirmPass = request.getParameter("confirmPassword");
        String display = request.getParameter("displayName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        UserDBContext db = new UserDBContext();
        String error = null;

        if (user == null || user.trim().isEmpty() ||
                pass == null || pass.trim().isEmpty() ||
                email == null || email.trim().isEmpty()) {
            error = "Required fields are missing.";
        } else if (!pass.equals(confirmPass)) {
            error = "Passwords do not match.";
        } else if (db.getUserByAccountName(user) != null) {
            error = "Username already exists.";
        } else if (db.checkEmailExists(email)) {
            error = "Email is already registered.";
        }

        if (error != null) {
            request.setAttribute("error", error);
            request.setAttribute("username", user);
            request.setAttribute("displayName", display);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/view/auth/register.jsp").forward(request, response);
            return;
        }

        String hashedPassword = MD5.getMd5(pass);

        db.registerUser(user, hashedPassword, display, email, phone, null);

        request.setAttribute("message", "Registration successful! Your account is pending Admin approval.");
        request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
    }
}