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
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String search = req.getParameter("search");
        String status = req.getParameter("status") == null ? "all" : req.getParameter("status");

        int page = 1;
        if (req.getParameter("page") != null)
            page = Integer.parseInt(req.getParameter("page"));

        int pageSize = 5;

        List<Role> list = dao.getAll(search, status, page, pageSize);
        int total = dao.count(search, status);
        int totalPage = (int) Math.ceil(total / (double) pageSize);

        req.setAttribute("roles", list);
        req.setAttribute("search", search);
        req.setAttribute("status", status);
        req.setAttribute("page", page);
        req.setAttribute("totalPage", totalPage);

        req.getRequestDispatcher("/view/admin/manager-role.jsp").forward(req, resp);
    }

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
