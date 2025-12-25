package controller.manager;

import dal.DepartmentDAO;
import entity.Department;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "DepartmentListController", urlPatterns = {"/department-list"})
public class DepartmentListController extends HttpServlet {

    private static final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        DepartmentDAO db = new DepartmentDAO();

        String action = request.getParameter("action");
        String idRaw = request.getParameter("id");

        if ("activate".equals(action) || "deactivate".equals(action)) {
            if (idRaw != null) {
                int id = Integer.parseInt(idRaw);
                db.updateStatus(id, "activate".equals(action) ? "active" : "inactive");
            }
            response.sendRedirect("department-list");
            return;
        }

        String pageRaw = request.getParameter("page");
        int page = pageRaw == null ? 1 : Integer.parseInt(pageRaw);

        String search = request.getParameter("search");
        String status = request.getParameter("status");

        List<Department> departments = db.getDepartmentListWithPaging(search, status, page, PAGE_SIZE);
        int total = db.countDepartments(search, status);
        int totalPages = (int) Math.ceil(total * 1.0 / PAGE_SIZE);

        if (totalPages == 0) {
            totalPages = 1;
        }

        if (page > totalPages) {
            page = totalPages;
            departments = db.getDepartmentListWithPaging(search, status, page, PAGE_SIZE);
        }

        for (Department d : departments) {
            String skName = db.getStorekeeperName(d.getStorekeeperId());
            int empCount = db.getEmployeeCount(d.getId());
            d.setStorekeeperName(skName);
            d.setEmployeeCount(empCount);
        }

        request.setAttribute("department", departments);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", search);
        request.setAttribute("status", status);

        request.setAttribute("activePage", "department-list");
        request.getRequestDispatcher("/view/manager/department/department-list.jsp").forward(request, response);
    }
}