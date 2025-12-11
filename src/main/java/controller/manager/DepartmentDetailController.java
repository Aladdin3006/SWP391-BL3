package controller.manager;

import dal.DepartmentDBContext;
import entity.Department;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/department-detail")
public class DepartmentDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idRaw = request.getParameter("id");
        if (idRaw == null) {
            response.sendRedirect("../department-list");
            return;
        }

        int id = Integer.parseInt(idRaw);
        DepartmentDBContext db = new DepartmentDBContext();

        Department dept = db.getDepartmentById(id);
        if (dept == null) {
            response.sendRedirect("department-list?error=Department not found");
            return;
        }

        String storekeeperName = db.getStorekeeperName(dept.getStorekeeperId());
        int employeeCount = db.getEmployeeCount(id);
        List<User> employees = db.getEmployeesInDepartment(id);

        request.setAttribute("dept", dept);
        request.setAttribute("storekeeperName", storekeeperName);
        request.setAttribute("employeeCount", employeeCount);
        request.setAttribute("employees", employees);
        request.setAttribute("activePage", "departments-list");

        request.getRequestDispatcher("/view/manager/department/department-detail.jsp").forward(request, response);
    }
}