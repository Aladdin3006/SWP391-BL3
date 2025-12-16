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
import java.util.List;
import java.sql.Date;
import java.time.LocalDate;

@WebServlet(name = "EditProductController", urlPatterns = {"/edit-product"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 100
)
public class EditProductController extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final SupplierDAO supplierDAO = new SupplierDAO();
    private final ProductChangeDAO productChangeDAO = new ProductChangeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        int id = 0;
        try { id = Integer.parseInt(idStr); } catch (NumberFormatException ignored) {}

        Product product = productDAO.getProductByPId(id);
        if (product == null) {
            request.setAttribute("error", "Product not found");
            request.getRequestDispatcher("/view/manager/product/edit-product.jsp").forward(request, response);
            return;
        }

        List<Category> categories = categoryDAO.getCategoriesForUpdate();
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

        HttpSession session = request.getSession();

        Object userObj = session.getAttribute("user");
        if (userObj == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

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
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }
            }
        }

        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String brand = request.getParameter("brand");
        String company = request.getParameter("company");
        String categoryIdStr = request.getParameter("categoryId");
        String supplierIdStr = request.getParameter("supplierId");
        String unitStr = request.getParameter("unit");
        String status = request.getParameter("status");
        String note = request.getParameter("note");
        Part imageFile = request.getPart("imageFile");

        int id = 0, categoryId = 0, supplierId = 0, unit = 0;
        try { id = Integer.parseInt(idStr); } catch (NumberFormatException ignored) {}
        try { categoryId = Integer.parseInt(categoryIdStr); } catch (NumberFormatException ignored) {}
        try { supplierId = Integer.parseInt(supplierIdStr); } catch (NumberFormatException ignored) {}
        try { unit = Integer.parseInt(unitStr); } catch (NumberFormatException ignored) {}

        boolean hasError = false;
        if (name == null || name.isBlank()) hasError = true;
        if (brand == null || brand.isBlank()) hasError = true;
        if (company == null || company.isBlank()) hasError = true;

        Product existingProduct = productDAO.getProductByPId(id);
        String uploadedImageUrl = existingProduct.getUrl();

        if (imageFile != null && imageFile.getSize() > 0) {
            try {
                if (existingProduct.getUrl() != null) {
                    String oldPublicId = CloudinaryUploadUtil.extractPublicIdFromUrl(existingProduct.getUrl());
                    if (oldPublicId != null) {
                        CloudinaryUploadUtil.deleteImage(oldPublicId);
                    }
                }
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
            uploadedImageUrl = existingProduct.getUrl();
        }

        if (hasError) {
            request.setAttribute("error", "Please fill all required fields correctly.");
            request.setAttribute("product", existingProduct);
            request.setAttribute("categories", categoryDAO.getCategoriesForUpdate());
            request.setAttribute("suppliers", supplierDAO.getAllSuppliers());
            request.getRequestDispatcher("/view/manager/product/edit-product.jsp").forward(request, response);
            return;
        }

        Product p = new Product();
        p.setId(id);
        p.setProductCode(existingProduct.getProductCode());
        p.setName(name);
        p.setBrand(brand);
        p.setCompany(company);
        p.setCategoryId(categoryId);
        p.setSupplierId(supplierId);
        p.setUnit(unit);
        p.setStatus(status);
        p.setUrl(uploadedImageUrl);

        boolean updated = productDAO.updateProduct(p);

        if (updated) {
            int oldUnit = existingProduct.getUnit();
            int newUnit = unit;

            if (oldUnit != newUnit) {
                ProductChange productChange = new ProductChange();
                productChange.setProductId(id);
                productChange.setChangeType("MANUAL");
                productChange.setChangeDate(Date.valueOf(LocalDate.now()));
                productChange.setBeforeChange(oldUnit);
                productChange.setAfterChange(newUnit);
                productChange.setChangeAmount(newUnit - oldUnit);
                productChange.setTicketId(null);
                productChange.setNote(note);
                productChange.setCreatedBy(createdBy);

                productChangeDAO.insert(productChange);
            }

            response.sendRedirect(request.getContextPath() + "/view-product-detail?id=" + id + "&updated=1");
        } else {
            request.setAttribute("error", "Update failed.");
            request.setAttribute("product", p);
            request.setAttribute("categories", categoryDAO.getCategoriesForUpdate());
            request.setAttribute("suppliers", supplierDAO.getAllSuppliers());
            request.getRequestDispatcher("/view/manager/product/edit-product.jsp").forward(request, response);
        }
    }
}