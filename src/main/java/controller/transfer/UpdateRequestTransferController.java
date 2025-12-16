package controller.transfer;

import dal.ProductDAO;
import dal.RequestTransferDAO;
import dal.UserDAO;
import entity.Product;
import entity.ProductTransferItem;
import entity.RequestTransferTicket;
import entity.User;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name="UpdateRequestTransferController", urlPatterns={"/request-transfer/edit"})
public class UpdateRequestTransferController extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/request-transfer");
            return;
        }

        int id = Integer.parseInt(idStr);
        RequestTransferDAO requestDao = new RequestTransferDAO();
        ProductDAO productDao = new ProductDAO();
        
        RequestTransferTicket ticket = requestDao.getById(id);
        if (ticket == null) {
            response.sendRedirect(request.getContextPath() + "/request-transfer");
            return;
        }

        // Only allow editing if status is Pending
        if (!"Pending".equals(ticket.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/request-transfer/detail?id=" + id);
            return;
        }

        List<Product> products = productDao.getAllProducts();
        
        // Get storekeepers in same department
        List<User> storekeepers = new ArrayList<>();
        if (user.getDepartmentId() > 0) {
            storekeepers = requestDao.getStorekeepersByDepartment(user.getDepartmentId());
        }

        request.setAttribute("ticket", ticket);
        request.setAttribute("products", products);
        request.setAttribute("storekeepers", storekeepers);

        request.getRequestDispatcher("/view/transfer/request-edit.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String idStr = request.getParameter("id");
            String type = request.getParameter("type");
            String requestDateStr = request.getParameter("requestDate");
            String status = request.getParameter("status");
            String note = request.getParameter("note");
            String employeeIdStr = request.getParameter("employeeId");
            
            String[] productIds = request.getParameterValues("productId");
            String[] quantities = request.getParameterValues("quantity");

            if (idStr == null || type == null || requestDateStr == null || 
                productIds == null || quantities == null || productIds.length == 0) {
                request.setAttribute("error", "Please fill all required fields");
                doGet(request, response);
                return;
            }

            int id = Integer.parseInt(idStr);

            RequestTransferTicket ticket = new RequestTransferTicket();
            ticket.setId(id);
            ticket.setType(type);
            ticket.setRequestDate(Date.valueOf(requestDateStr));
            ticket.setStatus(status != null ? status : "Pending");
            ticket.setNote(note);
            
            if (employeeIdStr != null && !employeeIdStr.isEmpty()) {
                ticket.setEmployeeId(Integer.parseInt(employeeIdStr));
            }

            // Add product items
            List<ProductTransferItem> items = new ArrayList<>();
            for (int i = 0; i < productIds.length; i++) {
                if (productIds[i] != null && !productIds[i].isEmpty() && 
                    quantities[i] != null && !quantities[i].isEmpty()) {
                    ProductTransferItem item = new ProductTransferItem();
                    item.setProductId(Integer.parseInt(productIds[i]));
                    item.setQuantity(Integer.parseInt(quantities[i]));
                    items.add(item);
                }
            }
            
            if (items.isEmpty()) {
                request.setAttribute("error", "Please add at least one product");
                doGet(request, response);
                return;
            }

            ticket.setProductTransfers(items);

            RequestTransferDAO dao = new RequestTransferDAO();
            boolean success = dao.update(ticket);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/request-transfer/detail?id=" + id + "&success=updated");
            } else {
                request.setAttribute("error", "Failed to update request transfer ticket");
                doGet(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            doGet(request, response);
        }
    }
}

