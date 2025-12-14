package controller.manager;

import dal.ProductChangeDAO;
import entity.ProductChange;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductChangeDetailController", urlPatterns = {"/product-change-detail"})
public class ProductChangeDetailController extends HttpServlet {

    private final ProductChangeDAO productChangeDAO = new ProductChangeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int productId = Integer.parseInt(idParam);
                List<ProductChange> changes = productChangeDAO.getProductChangesByProductId(productId);

                request.setAttribute("productChanges", changes);
                request.setAttribute("productId", productId);

            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid product ID");
            }
        } else {
            request.setAttribute("error", "Product ID is required");
        }

        request.getRequestDispatcher("/view/manager/inventory/product-change-detail.jsp")
                .forward(request, response);
    }
}