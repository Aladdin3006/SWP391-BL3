package controller;


import dal.RoleDAO;
import entity.Role;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/role")
public class RoleController extends HttpServlet {

    RoleDAO dao = new RoleDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        switch (action) {

            case "add":
                Role r1 = new Role(
                        0,
                        req.getParameter("roleName"),
                        req.getParameter("roleDescription"),
                        "active"
                );
                dao.insert(r1);
                break;

            case "edit":
                Role r2 = new Role(
                        Integer.parseInt(req.getParameter("roleId")),
                        req.getParameter("roleName"),
                        req.getParameter("roleDescription"),
                        req.getParameter("status")
                );
                dao.update(r2);
                break;

            case "toggle":
                dao.toggleStatus(Integer.parseInt(req.getParameter("id")));
                break;
        }

        resp.sendRedirect("role");
    }
}
