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

        // Validate required fields
        if (code == null || code.trim().isEmpty() || name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Supplier code and name are required");
            request.setAttribute("supplierCode", code);
            request.setAttribute("name", name);
            request.setAttribute("contactPerson", contactPerson);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.setAttribute("address", address);
            doGet(request, response);
            return;
        }

        Supplier supplier = new Supplier();
        supplier.setSupplierCode(code.trim());
        supplier.setName(name.trim());
        supplier.setContactPerson(contactPerson != null ? contactPerson.trim() : null);
        supplier.setPhone(phone != null ? phone.trim() : null);
        supplier.setEmail(email != null ? email.trim() : null);
        supplier.setAddress(address != null ? address.trim() : null);
        supplier.setStatus("active");

        SupplierDBContext db = new SupplierDBContext();

        // Check if supplier code already exists
        if (db.getSupplierByCode(code.trim()) != null) {
            request.setAttribute("error", "Supplier code '" + code + "' already exists");
            request.setAttribute("supplierCode", code);
            request.setAttribute("name", name);
            request.setAttribute("contactPerson", contactPerson);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.setAttribute("address", address);
            doGet(request, response);
            return;
        }

        try {
            db.addSupplier(supplier);
            response.sendRedirect("supplier-list?success=Supplier added successfully");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to add supplier: " + e.getMessage());
            request.setAttribute("supplierCode", code);
            request.setAttribute("name", name);
            request.setAttribute("contactPerson", contactPerson);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.setAttribute("address", address);
            doGet(request, response);
        }
    }
}