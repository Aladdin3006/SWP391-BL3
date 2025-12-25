package controller.manager;

import dal.DepartmentDAO;
import dal.EvaluateDAO;
import entity.Department;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/department-update")
public class UpdateDepartmentController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect("../department-list");
            return;
        }

        try {
            int deptId = Integer.parseInt(idParam);
            DepartmentDAO db = new DepartmentDAO();
            EvaluateDAO evaluateDAO = new EvaluateDAO();

            Department dept = db.getDepartmentById(deptId);
            if (dept == null) {
                response.sendRedirect("../department-list");
                return;
            }

            List<User> storekeepers = db.getStorekeepersForUpdate(deptId);
            List<User> currentEmployees = db.getEmployeesInDepartment(deptId);
            List<User> availableEmployees = db.getEmployeesNotInDepartment(deptId);

            Map<Integer, Double> currentEmployeeRatings = new HashMap<>();
            for (User emp : currentEmployees) {
                double avgStar = evaluateDAO.getAverageRatingForEmployee(emp.getUserId());
                currentEmployeeRatings.put(emp.getUserId(), avgStar);
            }

            Map<Integer, Double> availableEmployeeRatings = new HashMap<>();
            for (User emp : availableEmployees) {
                double avgStar = evaluateDAO.getAverageRatingForEmployee(emp.getUserId());
                availableEmployeeRatings.put(emp.getUserId(), avgStar);
            }

            request.setAttribute("dept", dept);
            request.setAttribute("storekeepers", storekeepers);
            request.setAttribute("currentEmployees", currentEmployees);
            request.setAttribute("availableEmployees", availableEmployees);
            request.setAttribute("currentEmployeeRatings", currentEmployeeRatings);
            request.setAttribute("availableEmployeeRatings", availableEmployeeRatings);
            request.setAttribute("activePage", "department-list");
            request.getRequestDispatcher("/view/manager/department/update-department.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("../department-list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String idParam = request.getParameter("id");
        String name = request.getParameter("departmentName");
        String skIdRaw = request.getParameter("storekeeperId");
        String status = request.getParameter("status");
        String[] empIds = request.getParameterValues("employeeIds");

        if (idParam == null || name == null || name.trim().isEmpty() || skIdRaw == null) {
            request.setAttribute("error", "Required fields are missing");
            doGet(request, response);
            return;
        }

        try {
            int deptId = Integer.parseInt(idParam);
            Department dept = new Department();
            dept.setId(deptId);
            dept.setDepartmentName(name.trim());
            dept.setStorekeeperId(Integer.parseInt(skIdRaw));
            dept.setStatus(status != null ? status : "active");

            List<Integer> employeeIdList = new ArrayList<>();
            if (empIds != null) {
                for (String id : empIds) {
                    if (!id.isEmpty()) employeeIdList.add(Integer.parseInt(id));
                }
            }

            DepartmentDAO db = new DepartmentDAO();
            db.updateDepartment(dept, employeeIdList);
            response.sendRedirect("../department-list");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Update failed: " + e.getMessage());
            doGet(request, response);
        }
    }
}