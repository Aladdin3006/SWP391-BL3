package controller.manager;

import dal.ProductDAO;
import dal.CategoryDAO;
import dal.SupplierDAO;
import entity.Product;
import entity.Category;
import entity.Supplier;
import util.CloudinaryUploadUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AddProductController", urlPatterns = {"/add-product"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 100
)
public class AddProductController extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final SupplierDAO supplierDAO = new SupplierDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = categoryDAO.getCategoriesForUpdate();
        List<Supplier> suppliers = supplierDAO.getAllSuppliers();
        request.setAttribute("categories", categories);
        request.setAttribute("suppliers", suppliers);
        request.getRequestDispatcher("/view/manager/product/add-product.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String pCode = request.getParameter("productCode");
        String name = request.getParameter("name");
        String brand = request.getParameter("brand");
        String company = request.getParameter("company");
        String categoryIdStr = request.getParameter("categoryId");
        String unitStr = request.getParameter("unit");
        String supplierIdStr = request.getParameter("supplierId");
        Part imageFile = request.getPart("imageFile");

        boolean hasError = false;
        if (productDAO.isProductCodeExist(pCode)) {
            request.setAttribute("errProductCode", "Product code already exists.");
            hasError = true;
        }

        String uploadedImageUrl = null;
        if (imageFile != null && imageFile.getSize() > 0) {
            try {
                uploadedImageUrl = CloudinaryUploadUtil.uploadImage(imageFile);
                if (uploadedImageUrl == null) {
                    request.setAttribute("errImage", "Failed to upload image. Please try again.");
                    hasError = true;
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errImage", "Failed to upload image: " + e.getMessage());
                hasError = true;
            }
        } else {
            request.setAttribute("errImage", "Please upload an image file.");
            hasError = true;
        }

        if (hasError) {
            request.setAttribute("productCode", pCode);
            request.setAttribute("name", name);
            request.setAttribute("brand", brand);
            request.setAttribute("company", company);
            request.setAttribute("categoryId", categoryIdStr);
            request.setAttribute("unit", unitStr);
            request.setAttribute("supplierId", supplierIdStr);
            loadDropdownData(request);
            request.getRequestDispatcher("/view/manager/product/add-product.jsp").forward(request, response);
            return;
        }

        int categoryId = 0;
        int unit = 0;
        int supplierId = 0;
        try { categoryId = Integer.parseInt(categoryIdStr); } catch (NumberFormatException ignored) {}
        try { unit = Integer.parseInt(unitStr); } catch (NumberFormatException ignored) {}
        try { supplierId = Integer.parseInt(supplierIdStr); } catch (NumberFormatException ignored) {}

        Product p = new Product();
        p.setProductCode(pCode);
        p.setName(name);
        p.setBrand(brand);
        p.setCompany(company);
        p.setCategoryId(categoryId);
        p.setUnit(unit);
        p.setSupplierId(supplierId);
        p.setStatus("active");
        p.setUrl(uploadedImageUrl);

        int newId = productDAO.insertProduct(p);
        if (newId > 0) {
            request.setAttribute("success", true);
            request.setAttribute("newProductId", newId);
            request.getRequestDispatcher("/view/manager/product/add-product.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Failed to create new product.");
            loadDropdownData(request);
            request.getRequestDispatcher("/view/manager/product/add-product.jsp").forward(request, response);
        }
    }

    private void loadDropdownData(HttpServletRequest request) {
        List<Category> categories = categoryDAO.getCategoriesForUpdate();
        List<Supplier> suppliers = supplierDAO.getAllSuppliers();
        request.setAttribute("categories", categories);
        request.setAttribute("suppliers", suppliers);
    }
}