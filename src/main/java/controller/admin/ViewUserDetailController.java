package controller.admin;

import dal.UserDAO;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/user/detail")
public class ViewUserDetailController extends HttpServlet {

    private UserDAO userDB = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        if (idParam == null) {
            resp.sendRedirect(req.getContextPath() + "/user-list");
            return;
        }

        int userId;
        try {
            userId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/user-list");
            return;
        }

        User user = userDB.getUserById(userId);

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/user-list");
            return;
        }

        req.setAttribute("user", user);

        req.getRequestDispatcher("/view/admin/user/userdetail.jsp")
                .forward(req, resp);
    }
}
