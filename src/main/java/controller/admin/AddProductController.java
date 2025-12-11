package controller.admin;

import dal.ProductDAO;
import entity.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "AddProductController", urlPatterns = {"/add-product"})
public class AddProductController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Chuyển đến trang Add Product
        request.getRequestDispatcher("/view/admin/product/Add-Product.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Product p = new Product();
        p.setProductCode(request.getParameter("productCode"));
        p.setName(request.getParameter("name"));
        p.setBrand(request.getParameter("brand"));
        p.setCompany(request.getParameter("company"));
        p.setCategoryName(request.getParameter("categoryName"));
        p.setUnit(Integer.parseInt(request.getParameter("unit")));
        p.setSupplierId(Integer.parseInt(request.getParameter("supplierId")));
        p.setStatus(request.getParameter("status"));
        p.setUrl(request.getParameter("url"));

        ProductDAO productDAO = new ProductDAO();
        productDAO.insertProduct(p);

        response.sendRedirect("view-product-list");
    }
}
