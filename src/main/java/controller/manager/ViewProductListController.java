package controller.manager;

import dal.ProductDAO;
import dal.CategoryDAO;
import entity.Product;
import entity.Category;

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
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ----------- GET FILTER + SORT PARAMETERS -----------
        String productCode = request.getParameter("productCode");
        String productName = request.getParameter("productName");
        String brand = request.getParameter("brand");
        String company = request.getParameter("company");
        String categoryId = request.getParameter("categoryId"); // dùng categoryId cho filter
        if ("0".equals(categoryId)) categoryId = null;
        String statusParam = request.getParameter("status");
        String sortField = request.getParameter("sortField");
        String sortOrder = request.getParameter("sortOrder");

        // default sort
        if (sortField == null) sortField = "id";
        if (sortOrder == null) sortOrder = "asc";

        // ----------- PAGING -----------
        int pageIndex = 1;
        int pageSize = 10;
        try {
            pageIndex = Integer.parseInt(request.getParameter("pageIndex"));
        } catch (Exception ignored) {}

        // ----------- GET DATA -----------
        List<Product> products = productDAO.getProducts(
                productCode,
                productName,
                brand,
                company,
                categoryId,
                statusParam,
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
                categoryId,
                statusParam
        );

        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        // ----------- GET CATEGORY LIST FOR DROPDOWN -----------
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);

        // ----------- SET ATTRIBUTE -----------
        request.setAttribute("products", products);
        request.setAttribute("productCode", productCode);
        request.setAttribute("productName", productName);
        request.setAttribute("brand", brand);
        request.setAttribute("company", company);
        request.setAttribute("categoryId", categoryId); // để dropdown giữ giá trị
        request.setAttribute("status", statusParam);
        request.setAttribute("sortField", sortField);
        request.setAttribute("sortOrder", sortOrder);
        request.setAttribute("pageIndex", pageIndex);
        request.setAttribute("totalPages", totalPages);

        // ----------- FORWARD TO JSP -----------
        request.getRequestDispatcher("/view/manager/product/view-product-list.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu có xử lý form POST thì thêm ở đây
    }
}
