package controller.manager;

import dal.ProductDAO;
import dal.CategoryDAO;
import dal.SupplierDAO;
import entity.Product;
import entity.Category;
import entity.Supplier;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "EditProductController", urlPatterns = {"/edit-product"})
public class EditProductController extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final SupplierDAO supplierDAO = new SupplierDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        int id = 0;
        try { id = Integer.parseInt(idStr); } catch (NumberFormatException ignored) {}

        Product product = productDAO.getProductByPId(id); // cần viết method trong DAO
        if (product == null) {
            request.setAttribute("error", "Product not found");
            request.getRequestDispatcher("/view/manager/product/edit-product.jsp").forward(request, response);
            return;
        }

        // Load dropdown data
        List<Category> categories = categoryDAO.getAllCategories();
        List<Supplier> suppliers = supplierDAO.getAllSuppliers();
        request.setAttribute("categories", categories);
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("product", product);

        request.getRequestDispatcher("/view/manager/product/edit-product.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Lấy dữ liệu từ form
        String idStr = request.getParameter("id");
        String productCode = request.getParameter("productCode");
        String name = request.getParameter("name");
        String brand = request.getParameter("brand");
        String company = request.getParameter("company");
        String categoryIdStr = request.getParameter("categoryId");
        String supplierIdStr = request.getParameter("supplierId");
        String unitStr = request.getParameter("unit");
        String status = request.getParameter("status");
        String url = request.getParameter("url");

        int id = 0, categoryId = 0, supplierId = 0, unit = 0;
        try { id = Integer.parseInt(idStr); } catch (NumberFormatException ignored) {}
        try { categoryId = Integer.parseInt(categoryIdStr); } catch (NumberFormatException ignored) {}
        try { supplierId = Integer.parseInt(supplierIdStr); } catch (NumberFormatException ignored) {}
        try { unit = Integer.parseInt(unitStr); } catch (NumberFormatException ignored) {}

        // Validate cơ bản
        boolean hasError = false;
        if (productCode == null || productCode.isBlank()) hasError = true;
        if (name == null || name.isBlank()) hasError = true;
        if (brand == null || brand.isBlank()) hasError = true;
        if (company == null || company.isBlank()) hasError = true;
        if (url == null || url.isBlank() || url.length() > 255) hasError = true;

        if (hasError) {
            request.setAttribute("error", "Please fill all required fields correctly.");
            request.setAttribute("product", productDAO.getProductByPId(id));
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.setAttribute("suppliers", supplierDAO.getAllSuppliers());
            request.getRequestDispatcher("/view/manager/product/edit-product.jsp").forward(request, response);
            return;
        }

        Product existingProduct = productDAO.getProductByPId(id);

        // Tạo product object để update
        Product p = new Product();
        p.setId(id);
        //không cho đổi productCode
        p.setProductCode(existingProduct.getProductCode());
        p.setName(name);
        p.setBrand(brand);
        p.setCompany(company);
        p.setCategoryId(categoryId);
        p.setSupplierId(supplierId);
        p.setUnit(unit);
        p.setStatus(status);
        p.setUrl(url);

        boolean updated = productDAO.updateProduct(p);

        if (updated) {
            // Redirect về detail với thông báo success
            response.sendRedirect(request.getContextPath() + "/view-product-detail?id=" + id + "&updated=1");
        } else {
            request.setAttribute("error", "Update failed.");
            request.setAttribute("product", p);
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.setAttribute("suppliers", supplierDAO.getAllSuppliers());
            request.getRequestDispatcher("/view/manager/product/edit-product.jsp").forward(request, response);
        }
    }
}
