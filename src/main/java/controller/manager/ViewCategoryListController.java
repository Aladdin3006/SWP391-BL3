package controller.manager;

import dal.CategoryDAO;
import entity.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewCategoryListController", urlPatterns = {"/view-category-list"})
public class ViewCategoryListController extends HttpServlet {

    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ===== 1. Lấy parameter từ request =====
        String categoryName = request.getParameter("categoryName");
        String status = request.getParameter("status");
        String sortField = request.getParameter("sortField");
        String sortOrder = request.getParameter("sortOrder");

        // ===== 2. Gọi DAO =====
        List<Category> categoryList =
                categoryDAO.searchCategory(categoryName, status, sortField, sortOrder);

        // ===== 3. Gửi dữ liệu sang JSP =====
        request.setAttribute("categoryList", categoryList);
        request.setAttribute("categoryName", categoryName);
        request.setAttribute("status", status);
        request.setAttribute("sortField", sortField);
        request.setAttribute("sortOrder", sortOrder);

        // ===== 4. Forward sang view =====
        request.getRequestDispatcher("/view/manager/category/view-category-list.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiện tại không dùng POST
        doGet(request, response);
    }
}
