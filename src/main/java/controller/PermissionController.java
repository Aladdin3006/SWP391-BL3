package controller;

import dal.PermissionDAO;
import entity.Permission;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet({"/permission"})
public class PermissionController extends HttpServlet {

    PermissionDAO dao = new PermissionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String search = req.getParameter("search") == null ? "" : req.getParameter("search");
        String sort = req.getParameter("sort") == null ? "permissionId" : req.getParameter("sort");
        String dir  = req.getParameter("dir") == null ? "ASC" : req.getParameter("dir");

        int page = req.getParameter("page") == null ? 1 : Integer.parseInt(req.getParameter("page"));
        int pageSize = 15;

        int total = dao.count(search);
        int totalPage = (int) Math.ceil(total * 1.0 / pageSize);

        req.setAttribute("permissions", dao.getAll(search, sort, dir, page, pageSize));
        req.setAttribute("search", search);
        req.setAttribute("sort", sort);
        req.setAttribute("dir", dir);
        req.setAttribute("page", page);
        req.setAttribute("totalPage", totalPage);

        req.getRequestDispatcher("view/admin/permission-list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if (action.equals("add")) {
            Permission p = new Permission(
                    0,
                    req.getParameter("permissionName"),
                    req.getParameter("url"),
                    req.getParameter("description")
            );
            dao.insert(p);
        }

        if (action.equals("edit")) {
            Permission p = new Permission(
                    Integer.parseInt(req.getParameter("permissionId")),
                    req.getParameter("permissionName"),
                    req.getParameter("url"),
                    req.getParameter("description")
            );
            dao.update(p);
        }

        if (action.equals("delete")) {
            dao.delete(Integer.parseInt(req.getParameter("permissionId")));
        }

        resp.sendRedirect("permission");
    }
}