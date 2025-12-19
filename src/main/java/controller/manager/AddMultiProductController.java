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
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AddMultiProductController", urlPatterns = {"/add-multi-product"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 200
)
public class AddMultiProductController extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final SupplierDAO supplierDAO = new SupplierDAO();

    // ==========================
    // GET
    // ==========================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        loadDropdownData(request);
        request.getRequestDispatcher("/view/manager/product/add-multi-product.jsp")
                .forward(request, response);
    }

    // ==========================
    // POST
    // ==========================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String[] productCodes = request.getParameterValues("productCode");
        String[] names = request.getParameterValues("name");
        String[] brands = request.getParameterValues("brand");
        String[] companies = request.getParameterValues("company");
        String[] categoryIds = request.getParameterValues("categoryId");
        String[] units = request.getParameterValues("unit");
        String[] supplierIds = request.getParameterValues("supplierId");

        List<Part> imageFiles = (List<Part>) request.getParts()
                .stream()
                .filter(p -> "imageFile".equals(p.getName()))
                .toList();

        List<Product> products = new ArrayList<>();
        List<String> rowErrors = new ArrayList<>();

        boolean hasError = false;

        for (int i = 0; i < productCodes.length; i++) {

            String pCode = productCodes[i];
            String name = names[i];
            String brand = brands[i];
            String company = companies[i];

            int categoryId = parseInt(categoryIds[i]);
            int unit = parseInt(units[i]);
            int supplierId = parseInt(supplierIds[i]);

            // ---- Validate ----
            if (productDAO.isProductCodeExist(pCode)) {
                rowErrors.add("Row " + (i + 1) + ": Product code already exists.");
                hasError = true;
                continue;
            }

            // ---- Upload image ----
            String imageUrl = null;
            Part imageFile = imageFiles.size() > i ? imageFiles.get(i) : null;

            if (imageFile != null && imageFile.getSize() > 0) {
                try {
                    imageUrl = CloudinaryUploadUtil.uploadImage(imageFile);
                    if (imageUrl == null) {
                        rowErrors.add("Row " + (i + 1) + ": Image upload failed.");
                        hasError = true;
                        continue;
                    }
                } catch (Exception e) {
                    rowErrors.add("Row " + (i + 1) + ": Image upload error.");
                    hasError = true;
                    continue;
                }
            } else {
                rowErrors.add("Row " + (i + 1) + ": Image is required.");
                hasError = true;
                continue;
            }

            // ---- Build Product ----
            Product p = new Product();
            p.setProductCode(pCode);
            p.setName(name);
            p.setBrand(brand);
            p.setCompany(company);
            p.setCategoryId(categoryId);
            p.setUnit(unit);
            p.setSupplierId(supplierId);
            p.setStatus("active");
            p.setUrl(imageUrl);

            products.add(p);
        }

        // ==========================
        // HANDLE ERROR
        // ==========================
        if (hasError) {
            request.setAttribute("rowErrors", rowErrors);
            loadDropdownData(request);
            request.getRequestDispatcher("/view/manager/product/add-multi-product.jsp")
                    .forward(request, response);
            return;
        }

        // ==========================
        // BATCH INSERT
        // ==========================
        int inserted = productDAO.insertProducts(products);

        if (inserted > 0) {
            request.setAttribute("success", true);
            request.setAttribute("insertedCount", inserted);
        } else {
            request.setAttribute("errorMessage", "Failed to insert products.");
        }

        loadDropdownData(request);
        request.getRequestDispatcher("/view/manager/product/add-multi-product.jsp")
                .forward(request, response);
    }

    // ==========================
    // HELPERS
    // ==========================
    private int parseInt(String val) {
        try {
            return Integer.parseInt(val);
        } catch (Exception e) {
            return 0;
        }
    }

    private void loadDropdownData(HttpServletRequest request) {
        List<Category> categories = categoryDAO.getCategoriesForAddAndEditP(null);
        List<Supplier> suppliers = supplierDAO.getSuppliersForAddAndEditP(null);
        request.setAttribute("categories", categories);
        request.setAttribute("suppliers", suppliers);
    }
}
