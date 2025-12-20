package controller.manager;

import dal.SupplierDBContext;
import entity.Supplier;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/supplier-list")
public class SupplierListController extends HttpServlet {

    private static final int PAGE_SIZE = 5; // This should match the value used in JSP calculation

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        SupplierDBContext db = new SupplierDBContext();

        String action = request.getParameter("action");
        String idRaw = request.getParameter("id");

        if ("activate".equals(action) || "deactivate".equals(action)) {
            if (idRaw != null) {
                try {
                    int id = Integer.parseInt(idRaw);
                    db.updateStatus(id, "activate".equals(action) ? "active" : "inactive");
                    String successMsg = "activate".equals(action) ? "activated" : "deactivated";
                    response.sendRedirect("supplier-list?success=" + successMsg);
                } catch (NumberFormatException e) {
                    response.sendRedirect("supplier-list?error=Invalid supplier ID");
                }
            }
            return;
        }

        String pageRaw = request.getParameter("page");
        int page = 1;
        try {
            if (pageRaw != null && !pageRaw.trim().isEmpty()) {
                page = Integer.parseInt(pageRaw);
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        String search = request.getParameter("search");
        String status = request.getParameter("status");

        List<Supplier> suppliers = db.getSupplierListWithPaging(search, status, page, PAGE_SIZE);
        int total = db.countSuppliers(search, status);
        int totalPages = (int) Math.ceil(total * 1.0 / PAGE_SIZE);

        // Handle page bounds - FIXED
        if (totalPages == 0) {
            totalPages = 1;
            page = 1; // Reset to page 1 when no results
        } else if (page > totalPages) {
            page = totalPages; // Go to last available page
            // Re-fetch data for the corrected page
            suppliers = db.getSupplierListWithPaging(search, status, page, PAGE_SIZE);
        }

        request.setAttribute("suppliers", suppliers);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", search != null ? search : "");
        request.setAttribute("status", status != null ? status : "all");

        request.setAttribute("activePage", "supplier-list");
        request.getRequestDispatcher("/view/manager/supplier/supplier-list.jsp").forward(request, response);
    }
}