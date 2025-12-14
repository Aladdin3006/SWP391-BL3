package controller.manager;

import dal.SupplierDBContext;
import entity.Supplier;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/supplier-add")
public class AddSupplierController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("activePage", "supplier-list");
        request.getRequestDispatcher("/view/manager/supplier/add-supplier.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String code = request.getParameter("supplierCode");
        String name = request.getParameter("name");
        String contactPerson = request.getParameter("contactPerson");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");

        Supplier supplier = new Supplier();
        supplier.setSupplierCode(code);
        supplier.setName(name);
        supplier.setContactPerson(contactPerson);
        supplier.setPhone(phone);
        supplier.setEmail(email);
        supplier.setAddress(address);
        supplier.setStatus("active");

        SupplierDBContext db = new SupplierDBContext();

        // Check if supplier code already exists
        if (db.getSupplierByCode(code) != null) {
            request.setAttribute("error", "Supplier code already exists");
            request.setAttribute("supplier", supplier);
            doGet(request, response);
            return;
        }

        try {
            db.addSupplier(supplier);
            response.sendRedirect("supplier-list?success=added");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to add supplier: " + e.getMessage());
            request.setAttribute("supplier", supplier);
            doGet(request, response);
        }
    }
}