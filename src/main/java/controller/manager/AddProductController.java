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

@WebServlet(name = "AddProductController", urlPatterns = {"/add-product"})
public class AddProductController extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private  final SupplierDAO supplierDAO = new SupplierDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy danh sách category để hiển thị dropdown
        List<Category> categories = categoryDAO.getAllCategories();
        List<Supplier> suppliers = supplierDAO.getAllSuppliers();

        request.setAttribute("categories", categories);
        request.setAttribute("suppliers", suppliers);

        request.getRequestDispatcher("/view/admin/product/add-Product.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Lấy dữ liệu từ form
        String productCode = request.getParameter("productCode");
        String name = request.getParameter("name");
        String brand = request.getParameter("brand");
        String company = request.getParameter("company");
        String categoryIdStr = request.getParameter("categoryId");
        String unitStr = request.getParameter("unit");
        String supplierIdStr = request.getParameter("supplierId");
        String url = request.getParameter("url");

        // Validate tối thiểu: ProductCode & Name không được trống
        String error = null;
        if (productCode == null || productCode.isEmpty()) error = "Product code is required.";
        else if (name == null || name.isEmpty()) error = "Product name is required.";

        if (error != null) {
            request.setAttribute("error", error);
            // Gửi lại dữ liệu đã nhập
            request.setAttribute("productCode", productCode);
            request.setAttribute("name", name);
            request.setAttribute("brand", brand);
            request.setAttribute("company", company);
            request.setAttribute("categoryId", categoryIdStr);
            request.setAttribute("unit", unitStr);
            request.setAttribute("supplierId", supplierIdStr);
            request.setAttribute("url", url);

            // Load lại danh sách category
            List<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("categories", categories);

            request.getRequestDispatcher("/view/manager/product/add-Product.jsp").forward(request, response);
            return;
        }

        // Chuyển dữ liệu sang kiểu int nếu cần
        int categoryId = 0;
        int unit = 0;
        int supplierId = 0;
        try { categoryId = Integer.parseInt(categoryIdStr); } catch (NumberFormatException ignored) {}
        try { unit = Integer.parseInt(unitStr); } catch (NumberFormatException ignored) {}
        try { supplierId = Integer.parseInt(supplierIdStr); } catch (NumberFormatException ignored) {}

        // Tạo product mới
        Product p = new Product();
        p.setProductCode(productCode);
        p.setName(name);
        p.setBrand(brand);
        p.setCompany(company);
        p.setCategoryId(categoryId);
        p.setUnit(unit);
        p.setSupplierId(supplierId);
        p.setStatus("active"); // mặc định actives
        p.setUrl(url);

        // Insert vào DB
        productDAO.insertProduct(p);

        request.setAttribute("message", "Add product successful!");
        // Chuyển hướng về danh sách sản phẩm hoặc quay lại form
        response.sendRedirect("view-product-list");
    }
}
