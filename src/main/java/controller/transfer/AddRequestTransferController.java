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

@WebServlet(name="AddRequestTransferController", urlPatterns={"/request-transfer/add"})
public class AddRequestTransferController extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        ProductDAO productDao = new ProductDAO();
        RequestTransferDAO requestDao = new RequestTransferDAO();
        UserDAO userDao = new UserDAO();
        
        List<Product> products = productDao.getAllProducts();
        String ticketCode = requestDao.generateTicketCode();
        
        // Get storekeepers in same department
        List<User> storekeepers = new ArrayList<>();
        if (user.getDepartmentId() > 0) {
            storekeepers = requestDao.getStorekeepersByDepartment(user.getDepartmentId());
        }

        request.setAttribute("products", products);
        request.setAttribute("ticketCode", ticketCode);
        request.setAttribute("storekeepers", storekeepers);

        request.getRequestDispatcher("/view/transfer/request-add.jsp").forward(request, response);
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
            String ticketCode = request.getParameter("ticketCode");
            String type = request.getParameter("type");
            String requestDateStr = request.getParameter("requestDate");
            String note = request.getParameter("note");
            String employeeIdStr = request.getParameter("employeeId");
            
            String[] productIds = request.getParameterValues("productId");
            String[] quantities = request.getParameterValues("quantity");

            // Validate
            if (ticketCode == null || type == null || requestDateStr == null || 
                productIds == null || quantities == null || productIds.length == 0) {
                request.setAttribute("error", "Please fill all required fields");
                doGet(request, response);
                return;
            }

            RequestTransferTicket ticket = new RequestTransferTicket();
            ticket.setTicketCode(ticketCode);
            ticket.setType(type);
            ticket.setRequestDate(Date.valueOf(requestDateStr));
            ticket.setStatus("Pending");
            ticket.setCreatedBy(user.getUserId());
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
            boolean success = dao.insert(ticket);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/request-transfer?success=added");
            } else {
                request.setAttribute("error", "Failed to create request transfer ticket");
                doGet(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            doGet(request, response);
        }
    }
}

