package controller.common;

import dal.UserDAO;
import dal.RoleDAO;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.stream.Collectors;

@WebServlet(name = "DashboardAdminController", urlPatterns = {"/dashboard-admin"})
public class DashboardAdminController extends HttpServlet {

    private UserDAO userDAO;
    private RoleDAO roleDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        roleDAO = new RoleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user.getRole() == null || !user.getRole().getRoleName().equalsIgnoreCase("Admin")) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        List<User> allUsers = userDAO.getAllUsers();
        List<User> activeUsers = allUsers.stream()
                .filter(u -> "active".equalsIgnoreCase(u.getStatus()))
                .collect(Collectors.toList());
        List<User> inactiveUsers = allUsers.stream()
                .filter(u -> "inactive".equalsIgnoreCase(u.getStatus()))
                .collect(Collectors.toList());

        Map<String, Long> usersByRole = allUsers.stream()
                .filter(u -> u.getRole() != null)
                .collect(Collectors.groupingBy(
                        u -> u.getRole().getRoleName(),
                        Collectors.counting()
                ));

        List<User> recentUsers = allUsers.stream()
                .limit(10)
                .collect(Collectors.toList());

        List<entity.Role> allRoles = roleDAO.getAllRoles();

        Map<String, Integer> statusCount = new HashMap<>();
        statusCount.put("total", allUsers.size());
        statusCount.put("active", activeUsers.size());
        statusCount.put("inactive", inactiveUsers.size());

        request.setAttribute("totalUsers", allUsers.size());
        request.setAttribute("activeUsers", activeUsers.size());
        request.setAttribute("inactiveUsers", inactiveUsers.size());
        request.setAttribute("usersByRole", usersByRole);
        request.setAttribute("recentUsers", recentUsers);
        request.setAttribute("allRoles", allRoles);
        request.setAttribute("statusCount", statusCount);

        request.getRequestDispatcher("view/fragments/dashboard-admin.jsp").forward(request, response);
    }
}