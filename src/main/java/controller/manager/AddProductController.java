package controller.manager;

import dal.ProductDAO;
import dal.CategoryDAO;
import dal.SupplierDAO;
import dal.ProductChangeDAO;
import entity.Product;
import entity.Category;
import entity.Supplier;
import entity.ProductChange;
import util.CloudinaryUploadUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.*;
import java.sql.Date;
import java.time.LocalDate;

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
    private final ProductChangeDAO productChangeDAO = new ProductChangeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = categoryDAO.getCategoriesForAddAndEditP(null);
        List<Supplier> suppliers = supplierDAO.getSuppliersForAddAndEditP(null);
        request.setAttribute("categories", categories);
        request.setAttribute("suppliers", suppliers);
        request.getRequestDispatcher("/view/manager/product/add-product.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Object userObj = session.getAttribute("user");
        if (userObj == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int createdBy = getUserIdFromSession(session, userObj);
        if (createdBy == 0) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Map<String, String[]> parameterMap = request.getParameterMap();
        List<String> productCodes = new ArrayList<>();
        List<String> names = new ArrayList<>();
        List<String> brands = new ArrayList<>();
        List<String> companies = new ArrayList<>();
        List<String> categoryIds = new ArrayList<>();
        List<String> units = new ArrayList<>();
        List<String> supplierIds = new ArrayList<>();

        for (Map.Entry<String, String[]> entry : parameterMap.entrySet()) {
            String key = entry.getKey();
            if (key.startsWith("productCode")) {
                productCodes.addAll(Arrays.asList(entry.getValue()));
            } else if (key.startsWith("name")) {
                names.addAll(Arrays.asList(entry.getValue()));
            } else if (key.startsWith("brand")) {
                brands.addAll(Arrays.asList(entry.getValue()));
            } else if (key.startsWith("company")) {
                companies.addAll(Arrays.asList(entry.getValue()));
            } else if (key.startsWith("categoryId")) {
                categoryIds.addAll(Arrays.asList(entry.getValue()));
            } else if (key.startsWith("unit")) {
                units.addAll(Arrays.asList(entry.getValue()));
            } else if (key.startsWith("supplierId")) {
                supplierIds.addAll(Arrays.asList(entry.getValue()));
            }
        }

        Collection<Part> imageParts = request.getParts();
        Map<String, Part> imageMap = new HashMap<>();
        for (Part part : imageParts) {
            if (part.getName().startsWith("imageFile") && part.getSize() > 0) {
                String name = part.getName();
                imageMap.put(name, part);
            }
        }

        boolean hasError = false;
        List<Product> validProducts = new ArrayList<>();
        Set<String> usedCodes = new HashSet<>();
        List<String> errorMessages = new ArrayList<>();

        int numProducts = Math.max(productCodes.size(),
                Math.max(names.size(),
                        Math.max(brands.size(),
                                Math.max(companies.size(),
                                        Math.max(categoryIds.size(),
                                                Math.max(units.size(), supplierIds.size()))))));

        for (int i = 0; i < numProducts; i++) {
            String pCode = i < productCodes.size() ? productCodes.get(i) : "";
            String name = i < names.size() ? names.get(i) : "";
            String brand = i < brands.size() ? brands.get(i) : "";
            String company = i < companies.size() ? companies.get(i) : "";
            String categoryIdStr = i < categoryIds.size() ? categoryIds.get(i) : "";
            String unitStr = i < units.size() ? units.get(i) : "";
            String supplierIdStr = i < supplierIds.size() ? supplierIds.get(i) : "";

            String imageKey = "imageFile" + (i > 0 ? "_" + i : "");
            Part imageFile = imageMap.get(imageKey);

            if (pCode == null || pCode.trim().isEmpty()) {
                errorMessages.add("Product #" + (i + 1) + ": Product code is required");
                hasError = true;
                continue;
            }

            if (usedCodes.contains(pCode.toLowerCase())) {
                errorMessages.add("Product #" + (i + 1) + ": Duplicate product code in this batch");
                hasError = true;
                continue;
            }

            if (productDAO.isProductCodeExist(pCode)) {
                errorMessages.add("Product #" + (i + 1) + ": Product code already exists");
                hasError = true;
                continue;
            }

            usedCodes.add(pCode.toLowerCase());

            if (name == null || name.trim().isEmpty()) {
                errorMessages.add("Product #" + (i + 1) + ": Product name is required");
                hasError = true;
                continue;
            }

            if (brand == null || brand.trim().isEmpty()) {
                errorMessages.add("Product #" + (i + 1) + ": Brand is required");
                hasError = true;
                continue;
            }

            if (company == null || company.trim().isEmpty()) {
                errorMessages.add("Product #" + (i + 1) + ": Company is required");
                hasError = true;
                continue;
            }

            if (imageFile == null || imageFile.getSize() == 0) {
                errorMessages.add("Product #" + (i + 1) + ": Image file is required");
                hasError = true;
                continue;
            }

            int categoryId = 0;
            int unit = 0;
            int supplierId = 0;
            try {
                categoryId = Integer.parseInt(categoryIdStr);
                if (categoryId <= 0) {
                    errorMessages.add("Product #" + (i + 1) + ": Please select a category");
                    hasError = true;
                    continue;
                }
            } catch (NumberFormatException e) {
                errorMessages.add("Product #" + (i + 1) + ": Invalid category");
                hasError = true;
                continue;
            }

            try {
                unit = Integer.parseInt(unitStr);
                if (unit < 0) {
                    errorMessages.add("Product #" + (i + 1) + ": Unit must be ≥ 0");
                    hasError = true;
                    continue;
                }
            } catch (NumberFormatException e) {
                errorMessages.add("Product #" + (i + 1) + ": Invalid unit");
                hasError = true;
                continue;
            }

            try {
                supplierId = Integer.parseInt(supplierIdStr);
                if (supplierId <= 0) {
                    errorMessages.add("Product #" + (i + 1) + ": Please select a supplier");
                    hasError = true;
                    continue;
                }
            } catch (NumberFormatException e) {
                errorMessages.add("Product #" + (i + 1) + ": Invalid supplier");
                hasError = true;
                continue;
            }

            String uploadedImageUrl = null;
            try {
                uploadedImageUrl = CloudinaryUploadUtil.uploadImage(imageFile);
                if (uploadedImageUrl == null) {
                    errorMessages.add("Product #" + (i + 1) + ": Failed to upload image");
                    hasError = true;
                    continue;
                }
            } catch (Exception e) {
                errorMessages.add("Product #" + (i + 1) + ": Image upload error: " + e.getMessage());
                hasError = true;
                continue;
            }

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
            validProducts.add(p);
        }

        if (hasError) {
            request.setAttribute("errorMessages", errorMessages);
            loadDropdownData(request);
            request.getRequestDispatcher("/view/manager/product/add-product.jsp").forward(request, response);
            return;
        }

        if (validProducts.isEmpty()) {
            request.setAttribute("errorMessage", "No valid products to save");
            loadDropdownData(request);
            request.getRequestDispatcher("/view/manager/product/add-product.jsp").forward(request, response);
            return;
        }

        boolean success = productDAO.insertMultipleProducts(validProducts);
        if (success) {
            for (Product p : validProducts) {
                if (p.getUnit() > 0) {
                    ProductChange productChange = new ProductChange();
                    productChange.setProductId(p.getId());  // This will now have the actual ID
                    productChange.setChangeType("MANUAL");
                    productChange.setChangeDate(Date.valueOf(LocalDate.now()));
                    productChange.setBeforeChange(0);
                    productChange.setAfterChange(p.getUnit());
                    productChange.setChangeAmount(p.getUnit());
                    productChange.setTicketId(null);
                    productChange.setNote("Initial stock from product creation");
                    productChange.setCreatedBy(createdBy);

                    productChangeDAO.insert(productChange);
                }
            }

            request.setAttribute("success", true);
            request.setAttribute("savedCount", validProducts.size());
            loadDropdownData(request);
            request.getRequestDispatcher("/view/manager/product/add-product.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Failed to save products");
            loadDropdownData(request);
            request.getRequestDispatcher("/view/manager/product/add-product.jsp").forward(request, response);
        }
    }

    private int getUserIdFromSession(HttpSession session, Object userObj) {
        int createdBy = 0;

        Integer sessionUserId = (Integer) session.getAttribute("userId");
        if (sessionUserId != null) {
            createdBy = sessionUserId;
        } else {
            try {
                java.lang.reflect.Method getUserIdMethod = userObj.getClass().getMethod("getUserId");
                Object result = getUserIdMethod.invoke(userObj);
                if (result instanceof Integer) {
                    createdBy = (Integer) result;
                }
            } catch (Exception e) {
                try {
                    java.lang.reflect.Method getIdMethod = userObj.getClass().getMethod("getId");
                    Object result = getIdMethod.invoke(userObj);
                    if (result instanceof Integer) {
                        createdBy = (Integer) result;
                    }
                } catch (Exception ex) {
                    return 0;
                }
            }
        }
        return createdBy;
    }

    private void loadDropdownData(HttpServletRequest request) {
        List<Category> categories = categoryDAO.getCategoriesForAddAndEditP(null);
        List<Supplier> suppliers = supplierDAO.getSuppliersForAddAndEditP(null);
        request.setAttribute("categories", categories);
        request.setAttribute("suppliers", suppliers);
    }
}