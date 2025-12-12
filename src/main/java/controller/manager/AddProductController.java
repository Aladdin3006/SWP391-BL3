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

        request.getRequestDispatcher("/view/manager/product/add-product.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Lấy dữ liệu từ form
        String pCode = request.getParameter("productCode");
        String name = request.getParameter("name");
        String brand = request.getParameter("brand");
        String company = request.getParameter("company");
        String categoryIdStr = request.getParameter("categoryId");
        String unitStr = request.getParameter("unit");
        String supplierIdStr = request.getParameter("supplierId");
        String url = request.getParameter("url");

        // Validate tối thiểu: ProductCode & Name không được trống
        boolean hasError = false;

        // Chỉ check UNIQUE ProductCode
        if (productDAO.isProductCodeExist(pCode)) {
            request.setAttribute("errProductCode", "Product code already exists.");
            hasError = true;
        }

        if (hasError) {
            // Gửi lại dữ liệu đã nhập
            request.setAttribute("productCode", pCode);
            request.setAttribute("name", name);
            request.setAttribute("brand", brand);
            request.setAttribute("company", company);
            request.setAttribute("categoryId", categoryIdStr);
            request.setAttribute("unit", unitStr);
            request.setAttribute("supplierId", supplierIdStr);
            request.setAttribute("url", url);

            // Load dropdown lại
            loadDropdownData(request);

            // Forward lại để hiển thị lỗi
            request.getRequestDispatcher("/view/manager/product/add-product.jsp")
                    .forward(request, response);
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
        p.setProductCode(pCode);
        p.setName(name);
        p.setBrand(brand);
        p.setCompany(company);
        p.setCategoryId(categoryId);
        p.setUnit(unit);
        p.setSupplierId(supplierId);
        p.setStatus("active"); // mặc định actives
        p.setUrl(url);

        // Insert vào DB
        int newId = productDAO.insertProduct(p);
        if (newId > 0) {
            // Forward về add-product.jsp để hiện alert
            request.setAttribute("success", true);
            request.setAttribute("newProductId", newId);
            request.getRequestDispatcher("/view/manager/product/add-product.jsp")
                    .forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Failed to create new product.");
            loadDropdownData(request);
            request.getRequestDispatcher("/view/manager/product/add-product.jsp")
                    .forward(request, response);
        }



    }
    private void loadDropdownData(HttpServletRequest request) {
        List<Category> categories = categoryDAO.getAllCategories();
        List<Supplier> suppliers = supplierDAO.getAllSuppliers();
        request.setAttribute("categories", categories);
        request.setAttribute("suppliers", suppliers);
    }
}
