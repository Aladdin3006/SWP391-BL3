package controller.manager;

import dal.ProductDAO;
import entity.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ViewProductDetailController", urlPatterns = {"/view-product-detail"})
public class ViewProductDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idRaw = request.getParameter("id");

        // Không có id → quay về danh sách
        if (idRaw == null || idRaw.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "view-product-list");
            return;
        }

        try {
            int id = Integer.parseInt(idRaw);

            ProductDAO dao = new ProductDAO();
            Product product = dao.getProductByPId(id);

            if (product == null) {
                request.setAttribute("error", "Product not found.");
                request.getRequestDispatcher("/view/manager/product/view-product-detail.jsp")
                        .forward(request, response);
                return;
            }

            request.setAttribute("product", product);
            request.getRequestDispatcher("/view/manager/product/view-product-detail.jsp")
                    .forward(request, response);

        } catch (NumberFormatException ex) {
            ex.printStackTrace();
            response.sendRedirect(request.getContextPath() + "view-product-list");
        }
    }
}
