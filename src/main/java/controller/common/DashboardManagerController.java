package controller.common;

import dal.ProductDAO;
import dal.SupplierDAO;
import dal.DepartmentDAO;
import dal.InventoryDAO;
import dal.UserDAO;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@WebServlet(name = "DashboardManagerController", urlPatterns = {"/dashboard-manager"})
public class DashboardManagerController extends HttpServlet {

    private ProductDAO productDAO;
    private SupplierDAO supplierDAO;
    private DepartmentDAO departmentDAO;
    private InventoryDAO inventoryDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        supplierDAO = new SupplierDAO();
        departmentDAO = new DepartmentDAO();
        inventoryDAO = new InventoryDAO();
        userDAO = new UserDAO();
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
        if (user.getRole() == null || !user.getRole().getRoleName().equalsIgnoreCase("Manager")) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        LocalDate now = LocalDate.now();
        LocalDate startOfMonth = now.withDayOfMonth(1);
        LocalDate endOfMonth = now.withDayOfMonth(now.lengthOfMonth());

        List<entity.Product> allProducts = productDAO.getAllProducts();
        long activeProducts = allProducts.stream()
                .filter(p -> "active".equalsIgnoreCase(p.getStatus()))
                .count();
        long inactiveProducts = allProducts.stream()
                .filter(p -> "inactive".equalsIgnoreCase(p.getStatus()))
                .count();

        long lowStockProducts = allProducts.stream()
                .filter(p -> p.getUnit() < 10)
                .count();

        List<entity.Supplier> allSuppliers = supplierDAO.getAllSuppliers();
        long activeSuppliers = allSuppliers.stream()
                .filter(s -> "active".equalsIgnoreCase(s.getStatus()))
                .count();
        long inactiveSuppliers = allSuppliers.stream()
                .filter(s -> "inactive".equalsIgnoreCase(s.getStatus()))
                .count();

        List<entity.Department> allDepartments = departmentDAO.getDepartmentListWithPaging("", "all", 1, Integer.MAX_VALUE);
        long activeDepartments = allDepartments.stream()
                .filter(d -> "active".equalsIgnoreCase(d.getStatus()))
                .count();
        long inactiveDepartments = allDepartments.stream()
                .filter(d -> "inactive".equalsIgnoreCase(d.getStatus()))
                .count();

        int totalEmployees = allDepartments.stream()
                .mapToInt(d -> departmentDAO.getEmployeeCount(d.getId()))
                .sum();

        List<Map<String, Object>> monthlyInventory = inventoryDAO.getInventoryReport(
                null,
                null,
                Date.valueOf(startOfMonth),
                Date.valueOf(endOfMonth),
                1,
                Integer.MAX_VALUE
        );

        int totalImports = 0;
        int totalExports = 0;
        for (Map<String, Object> item : monthlyInventory) {
            totalImports += (int) item.get("import_period");
            totalExports += (int) item.get("export_period");
        }

        List<User> allUsers = userDAO.getAllUsers();
        long totalEmployeesAll = allUsers.stream()
                .filter(u -> u.getRole() != null && "Employee".equalsIgnoreCase(u.getRole().getRoleName()))
                .count();
        long totalStorekeepers = allUsers.stream()
                .filter(u -> u.getRole() != null && "Storekeeper".equalsIgnoreCase(u.getRole().getRoleName()))
                .count();

        request.setAttribute("totalProducts", allProducts.size());
        request.setAttribute("activeProducts", activeProducts);
        request.setAttribute("inactiveProducts", inactiveProducts);
        request.setAttribute("lowStockProducts", lowStockProducts);

        request.setAttribute("totalSuppliers", allSuppliers.size());
        request.setAttribute("activeSuppliers", activeSuppliers);
        request.setAttribute("inactiveSuppliers", inactiveSuppliers);

        request.setAttribute("totalDepartments", allDepartments.size());
        request.setAttribute("activeDepartments", activeDepartments);
        request.setAttribute("inactiveDepartments", inactiveDepartments);
        request.setAttribute("totalEmployeesInDepartments", totalEmployees);

        request.setAttribute("monthlyImports", totalImports);
        request.setAttribute("monthlyExports", totalExports);

        request.setAttribute("totalEmployeesAll", totalEmployeesAll);
        request.setAttribute("totalStorekeepers", totalStorekeepers);

        request.setAttribute("currentMonth", now.getMonth().toString());
        request.setAttribute("currentYear", now.getYear());

        request.getRequestDispatcher("view/fragments/dashboard-manager.jsp").forward(request, response);
    }
}