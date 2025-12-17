package controller.manager;

import dal.CategoryDAO;
import entity.Category;
import entity.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "EditCategoryController", urlPatterns = {"/edit-category"})

public class EditCategoryController extends HttpServlet {
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("categoryId");
        String name = request.getParameter("categoryName");
        String desc = request.getParameter("description");
        String statusStr = request.getParameter("status");

        int categoryId = 0;
        int status = 1;

        try {
            categoryId = Integer.parseInt(idStr);
            status = Integer.parseInt(statusStr);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid category ID or status.");
            forwardToList(request, response);
            return;
        }

        boolean hasError = false;

        // Check duy nhất: categoryName đã tồn tại (trừ chính category đang edit)
        if (categoryDAO.isCategoryNameExist(name.trim(), categoryId)) {
            request.setAttribute("nameErrorId", categoryId);
            request.setAttribute("nameErrorMsg", "Category name already exists.");

            hasError = true;
        }

        if (hasError) {

            List<Category> list = categoryDAO.searchCategory(null, null, null, null);

            for (Category cat : list) {
                if (cat.getCategoryId() == categoryId) {
                    cat.setCategoryName(name);
                    cat.setDescription(desc);
                    cat.setStatus(status);
                    break;
                }
            }

            request.setAttribute("categoryList", list);

            request.setAttribute("openEditModal", true);
            request.setAttribute("editCategoryId", categoryId);
            request.setAttribute("nameErrorId", categoryId);
            request.setAttribute("nameErrorMsg", "Category name already exists.");

            request.getRequestDispatcher("/view/manager/category/view-category-list.jsp")
                    .forward(request, response);
            return;
        }


        // Update
        Category c = new Category();
        c.setCategoryId(categoryId);
        c.setCategoryName(name.trim());
        c.setDescription(desc != null ? desc.trim() : "");
        c.setStatus(status);

        int updatedId = categoryDAO.updateCategory(c);

        if (updatedId > 0) {
            request.setAttribute("success", true);
            request.setAttribute("newCategoryId", updatedId);
        } else {
            request.setAttribute("errorMessage", "Failed to update category.");
            request.setAttribute("openEditModal", true);
            request.setAttribute("editCategoryId", categoryId);
            request.setAttribute("categoryName", name);
            request.setAttribute("description", desc);
            request.setAttribute("status", statusStr);
        }

        forwardToList(request, response);
    }

    // Forward về JSP kèm danh sách category
    private void forwardToList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Category> list = categoryDAO.searchCategory(null, null, null, null);
        request.setAttribute("categoryList", list);

        request.getRequestDispatcher("/view/manager/category/view-category-list.jsp")
                .forward(request, response);
    }
}
