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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/department-add")
public class AddDepartmentController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        DepartmentDBContext db = new DepartmentDBContext();
        List<User> storekeepers = db.getStorekeepersNotInAnyDepartment();
        List<User> employees = db.getAvailableEmployees();

        request.setAttribute("storekeepers", storekeepers);
        request.setAttribute("employees", employees);
        request.setAttribute("activePage", "department-list");
        request.getRequestDispatcher("/view/manager/department/add-department.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("departmentName");
        String skIdRaw = request.getParameter("storekeeperId");
        String[] empIds = request.getParameterValues("employeeIds");

        if (name == null || name.trim().isEmpty() || skIdRaw == null) {
            request.setAttribute("error", "Department name and storekeeper are required");
            doGet(request, response);
            return;
        }

        Department dept = new Department();
        dept.setDepartmentName(name.trim());
        dept.setStorekeeperId(Integer.parseInt(skIdRaw));
        dept.setStatus("active");

        List<Integer> employeeIdList = new ArrayList<>();
        if (empIds != null) {
            for (String id : empIds) {
                if (!id.isEmpty()) employeeIdList.add(Integer.parseInt(id));
            }
        }

        try {
            DepartmentDBContext db = new DepartmentDBContext();
            db.addDepartment(dept, employeeIdList);
            response.sendRedirect("../department-list");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Cannot add department. Storekeeper may already be assigned.");
            doGet(request, response);
        }
    }
}