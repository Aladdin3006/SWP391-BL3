package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import dal.ProductDBContext;
import java.util.List;

public class HomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ProductDBContext productDB = new ProductDBContext();

        String search = request.getParameter("search");
        String category = request.getParameter("category");
        String company = request.getParameter("company");
        String brand = request.getParameter("brand");

        List<entity.Product> products;

        if (search != null || category != null || company != null || brand != null) {
            products = productDB.searchProducts(search, category, company, brand);
        } else {
            products = productDB.getAllProducts();
        }

        List<String> categories = productDB.getAllCategories();
        List<String> companies = productDB.getAllCompanies();
        List<String> brands = productDB.getAllBrands();

        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("companies", companies);
        request.setAttribute("brands", brands);

        request.getRequestDispatcher("/view/home/home.jsp").forward(request, response);
    }
}