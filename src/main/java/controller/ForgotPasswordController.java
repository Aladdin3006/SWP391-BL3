package controller;

import dal.UserDBContext;
import entity.User;
import util.EmailUtility;
import java.io.IOException;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name="ForgotPasswordController", urlPatterns={"/forgot-password"})
public class ForgotPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.getRequestDispatcher("/view/auth/forgot-password.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String email = request.getParameter("email");
        UserDBContext db = new UserDBContext();
        User user = db.getUserByEmail(email);

        if (user == null) {
            request.setAttribute("message", "If an account exists with that email, we have sent a reset link.");
        } else {
            String token = UUID.randomUUID().toString();
            db.updateToken(email, token);

            new Thread(() -> {
                EmailUtility.sendReset(email, token);
            }).start();
            
            request.setAttribute("message", "If an account exists with that email, we have sent a reset link.");
        }
        request.getRequestDispatcher("/view/auth/forgot-password.jsp").forward(request, response);
    }
}