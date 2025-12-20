package controller.manager;

import dal.SupplierDBContext;
import entity.Supplier;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/supplier-update")
public class UpdateSupplierController extends HttpServlet {

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
        request.getRequestDispatcher("/view/manager/supplier/update-supplier.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String idRaw = request.getParameter("id");
        String code = request.getParameter("supplierCode");
        String name = request.getParameter("name");
        String contactPerson = request.getParameter("contactPerson");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String status = request.getParameter("status");

        Supplier supplier = new Supplier();
        supplier.setId(Integer.parseInt(idRaw));
        supplier.setSupplierCode(code);
        supplier.setName(name);
        supplier.setContactPerson(contactPerson);
        supplier.setPhone(phone);
        supplier.setEmail(email);
        supplier.setAddress(address);
        supplier.setStatus(status);

        SupplierDBContext db = new SupplierDBContext();

        if (db.isSupplierCodeExists(code, supplier.getId())) {
            request.setAttribute("error", "Supplier code already exists");
            request.setAttribute("supplier", supplier);
            doGet(request, response);
            return;
        }

        try {
            db.updateSupplier(supplier);
            response.sendRedirect("supplier-list?success=Supplier updated successfully");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to update supplier: " + e.getMessage());
            request.setAttribute("supplier", supplier);
            doGet(request, response);
        }
    }
}