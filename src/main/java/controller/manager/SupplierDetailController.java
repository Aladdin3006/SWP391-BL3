package controller.manager;

import dal.SupplierDBContext;
import entity.Supplier;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/supplier-detail")
public class SupplierDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idRaw = request.getParameter("id");
        if (idRaw == null) {
            response.sendRedirect("supplier-list");
            return;
        }

        int id = Integer.parseInt(idRaw);
        SupplierDBContext db = new SupplierDBContext();
        Supplier supplier = db.getSupplierById(id);

        if (supplier == null) {
            response.sendRedirect("supplier-list?error=Supplier not found");
            return;
        }

        request.setAttribute("supplier", supplier);
        request.setAttribute("activePage", "supplier-list");
        request.getRequestDispatcher("/view/manager/supplier/supplier-detail.jsp").forward(request, response);
    }
}