package controller;

import dal.UserDBContext;
import entity.User;
import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

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
        String display = request.getParameter("displayName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        UserDBContext db = new UserDBContext();
        User existing = db.getUserByAccountName(user);

        if (existing != null) {
            request.setAttribute("error", "Username already exists");
            request.getRequestDispatcher("/view/auth/register.jsp").forward(request, response);
        } else {
            db.registerUser(user, pass, display, email, phone);
            response.sendRedirect("login?register=success");
        }
    }
}
