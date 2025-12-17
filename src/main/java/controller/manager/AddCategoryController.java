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

@WebServlet(name = "AddCategoryController", urlPatterns = {"/add-category"})

public class AddCategoryController extends HttpServlet {
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("categoryName");
        String desc = request.getParameter("description");

        boolean hasError = false;

        if (categoryDAO.isCategoryNameExist(name.trim(), 0)) {

            request.setAttribute("nameError", "Category name already exists.");
            hasError = true;
        }
        if(hasError) {
            request.setAttribute("openAddModal", true);
            request.setAttribute("categoryName", name);
            request.setAttribute("description", desc);

            List<Category> list = categoryDAO.searchCategory(null, null, null, null);
            request.setAttribute("categoryList", list);

            request.getRequestDispatcher("/view/manager/category/view-category-list.jsp")
                    .forward(request, response);
            return;
        }

        // insert
        Category c = new Category();
        c.setCategoryName(name.trim());
        c.setDescription(desc.trim());
        c.setStatus(1);

        int newId = categoryDAO.insertCategory(c);

        if (newId > 0) {
            // Forward về view-category-list.jsp để hiện alert
            request.setAttribute("success", true);
            request.setAttribute("newCategoryId", newId);

            List<Category> list = categoryDAO.searchCategory(null, null, null, null);
            request.setAttribute("categoryList", list);

            request.getRequestDispatcher("/view/manager/category/view-category-list.jsp")
                    .forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Failed to create new category.");

            List<Category> list = categoryDAO.searchCategory(null, null, null, null);
            request.setAttribute("categoryList", list);

            request.setAttribute("openAddModal", true);
            request.getRequestDispatcher("/view/manager/category/view-category-list.jsp")
                    .forward(request, response);
        }

    }
}
