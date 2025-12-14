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

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        SupplierDBContext db = new SupplierDBContext();

        String action = request.getParameter("action");
        String idRaw = request.getParameter("id");

        if ("activate".equals(action) || "deactivate".equals(action)) {
            if (idRaw != null) {
                int id = Integer.parseInt(idRaw);
                db.updateStatus(id, "activate".equals(action) ? "active" : "inactive");
            }
            response.sendRedirect("supplier-list");
            return;
        }

        String pageRaw = request.getParameter("page");
        int page = pageRaw == null ? 1 : Integer.parseInt(pageRaw);

        String search = request.getParameter("search");
        String status = request.getParameter("status");

        List<Supplier> suppliers = db.getSupplierListWithPaging(search, status, page, PAGE_SIZE);
        int total = db.countSuppliers(search, status);
        int totalPages = (int) Math.ceil(total * 1.0 / PAGE_SIZE);

        request.setAttribute("suppliers", suppliers);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", search);
        request.setAttribute("status", status);

        request.setAttribute("activePage", "supplier-list");
        request.getRequestDispatcher("/view/manager/supplier/supplier-list.jsp").forward(request, response);
    }
}