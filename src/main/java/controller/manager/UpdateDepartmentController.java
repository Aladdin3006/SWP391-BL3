package controller.manager;

import dal.DepartmentDAO;
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

@WebServlet("/department-update")
public class UpdateDepartmentController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idRaw = request.getParameter("id");
        if (idRaw == null) {
            response.sendRedirect("../department-list");
            return;
        }

        int id = Integer.parseInt(idRaw);
        DepartmentDAO db = new DepartmentDAO();

        Department dept = db.getDepartmentById(id);
        if (dept == null) {
            response.sendRedirect("../department-list");
            return;
        }

        List<User> storekeepers = db.getStorekeepersForUpdate(id);
        User currentSK = null;
        for (User sk : storekeepers) {
            if (sk.getUserId() == dept.getStorekeeperId()) {
                currentSK = sk;
                break;
            }
        }
        if (currentSK == null) {
            currentSK = new User();
            currentSK.setUserId(dept.getStorekeeperId());
            currentSK.setDisplayName(db.getStorekeeperName(dept.getStorekeeperId()));
            storekeepers.add(0, currentSK);
        }

        List<User> employees = db.getEmployeesInDepartment(id);
        List<User> availableEmployees = db.getEmployeesNotInDepartment(id);

        request.setAttribute("dept", dept);
        request.setAttribute("storekeepers", storekeepers);
        request.setAttribute("currentEmployees", employees);
        request.setAttribute("availableEmployees", availableEmployees);
        request.setAttribute("activePage", "departments-list");

        request.getRequestDispatcher("/view/manager/department/update-department.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idRaw = request.getParameter("id");
        String name = request.getParameter("departmentName");
        String skIdRaw = request.getParameter("storekeeperId");
        String[] empIds = request.getParameterValues("employeeIds");

        Department dept = new Department();
        dept.setId(Integer.parseInt(idRaw));
        dept.setDepartmentName(name);
        dept.setStorekeeperId(Integer.parseInt(skIdRaw));
        dept.setStatus(request.getParameter("status"));

        List<Integer> employeeIdList = new ArrayList<>();
        if (empIds != null) {
            for (String id : empIds) {
                if (!id.isEmpty()) employeeIdList.add(Integer.parseInt(id));
            }
        }

        DepartmentDAO db = new DepartmentDAO();
        db.updateDepartment(dept, employeeIdList);

        response.sendRedirect("department-list?success=updated");
    }
}