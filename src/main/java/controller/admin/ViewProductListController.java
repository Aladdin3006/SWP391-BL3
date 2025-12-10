package controller.admin;
import dal.ProductDAO;
import entity.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewProductListController", urlPatterns = {"/view-product-list"})
public class ViewProductListController extends HttpServlet {


    private final ProductDAO productDAO = new ProductDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String productCode = request.getParameter("productCode");
        String productName = request.getParameter("productName");
        String brand = request.getParameter("brand");
        String company = request.getParameter("company");
        String categoryName = request.getParameter("categoryName");
        String statusFilter = request.getParameter("status");
        String sortField = request.getParameter("sortField");
        String sortOrder = request.getParameter("sortOrder");

        // Nếu null thì dùng mặc định
        if (sortField == null) sortField = "id";
        if (sortOrder == null) sortOrder = "asc";


        // ----------- PAGING -----------
        int pageIndex = 1;
        int pageSize = 10;

        try {
            pageIndex = Integer.parseInt(request.getParameter("pageIndex"));
        } catch (Exception ignored) {}

        // ----------- GET DATA -----------
        List<Product> products = productDAO.getAllProducts(
                productCode,
                productName,
                brand,
                company,
                categoryName,
                statusFilter,
                pageIndex,
                pageSize,
                sortField,
                sortOrder
        );

        int totalRecords = productDAO.countProducts(
                productCode,
                productName,
                brand,
                company,
                categoryName,
                statusFilter
        );

        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        // ----------- SET ATTRIBUTE -----------
        request.setAttribute("products", products);

        request.setAttribute("productCode", productCode);
        request.setAttribute("productName", productName);
        request.setAttribute("brand", brand);
        request.setAttribute("company", company);
        request.setAttribute("categoryName", categoryName);
        request.setAttribute("status", statusFilter);

        request.setAttribute("sortField", sortField);
        request.setAttribute("sortOrder", sortOrder);
        request.setAttribute("pageIndex", pageIndex);
        request.setAttribute("totalPages", totalPages);

        // ----------- FORWARD -----------
        request.getRequestDispatcher("/view/admin/product/view-product-list.jsp")
                .forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }
}
