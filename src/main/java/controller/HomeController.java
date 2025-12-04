package controller;

import dal.UserDBContext;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "HomeController", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            String roleName = (user.getRole() != null) ? user.getRole().getRoleName() : "User";

            response.sendRedirect("dashboard?role=" + roleName);
            return;
        }

        request.getRequestDispatcher("/view/home/home.jsp").forward(request, response);
    }
}