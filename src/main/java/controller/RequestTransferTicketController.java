package controller;

import dal.RequestTransferTicketDAO;
import dal.UserDBContext;
import entity.ProductTransferItem;
import entity.RequestTransferTicket;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "RequestTransferTicketController", urlPatterns = {"/transfer-tickets"})
public class RequestTransferTicketController extends HttpServlet {

    private RequestTransferTicketDAO ticketDAO = new RequestTransferTicketDAO();
    private UserDBContext userDAO = new UserDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":
                showList(request, response);
                break;
            case "detail":
                showDetail(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            default:
                showList(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("create".equals(action)) {
            createTicket(request, response, currentUser);
        } else if ("update".equals(action)) {
            updateTicket(request, response);
        }
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String search = request.getParameter("search");
        String type = request.getParameter("type");
        String status = request.getParameter("status");
        String pageStr = request.getParameter("page");
        
        if (type == null) type = "all";
        if (status == null) status = "all";
        
        int page = 1;
        int pageSize = 10;
        
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        List<RequestTransferTicket> tickets = ticketDAO.getAllTickets(search, type, status, page, pageSize);
        int totalTickets = ticketDAO.countTickets(search, type, status);
        int totalPages = (int) Math.ceil((double) totalTickets / pageSize);
        
        request.setAttribute("tickets", tickets);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", search);
        request.setAttribute("type", type);
        request.setAttribute("status", status);
        
        request.getRequestDispatcher("/view/transfer/ticket-list.jsp").forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/transfer-tickets");
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            RequestTransferTicket ticket = ticketDAO.getTicketById(id);
            
            if (ticket == null) {
                response.sendRedirect(request.getContextPath() + "/transfer-tickets");
                return;
            }
            
            request.setAttribute("ticket", ticket);
            request.getRequestDispatcher("/view/transfer/ticket-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/transfer-tickets");
        }
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Load products for dropdown
        request.setAttribute("products", ticketDAO.getAllProducts());
        
        // Load employees for dropdown
        request.setAttribute("employees", userDAO.getAllUsers());
        
        // Generate ticket code
        request.setAttribute("ticketCode", ticketDAO.generateTicketCode());
        
        request.getRequestDispatcher("/view/transfer/ticket-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/transfer-tickets");
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            RequestTransferTicket ticket = ticketDAO.getTicketById(id);
            
            if (ticket == null || !"Pending".equals(ticket.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/transfer-tickets");
                return;
            }
            
            request.setAttribute("ticket", ticket);
            request.setAttribute("products", ticketDAO.getAllProducts());
            request.setAttribute("employees", userDAO.getAllUsers());
            
            request.getRequestDispatcher("/view/transfer/ticket-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/transfer-tickets");
        }
    }

    private void createTicket(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        try {
            RequestTransferTicket ticket = new RequestTransferTicket();
            ticket.setTicketCode(request.getParameter("ticketCode"));
            ticket.setType(request.getParameter("type"));
            ticket.setRequestDate(Date.valueOf(request.getParameter("requestDate")));
            ticket.setStatus("Pending");
            ticket.setCreatedBy(currentUser.getUserId());
            ticket.setNote(request.getParameter("note"));
            ticket.setEmployeeId(Integer.parseInt(request.getParameter("employeeId")));
            
            // Parse items
            List<ProductTransferItem> items = new ArrayList<>();
            String[] productIds = request.getParameterValues("productId");
            String[] quantities = request.getParameterValues("quantity");
            
            if (productIds != null && quantities != null) {
                for (int i = 0; i < productIds.length; i++) {
                    if (productIds[i] != null && !productIds[i].isEmpty() 
                        && quantities[i] != null && !quantities[i].isEmpty()) {
                        
                        int qty = Integer.parseInt(quantities[i]);
                        if (qty > 0) {
                            ProductTransferItem item = new ProductTransferItem();
                            item.setProductId(Integer.parseInt(productIds[i]));
                            item.setQuantity(qty);
                            items.add(item);
                        }
                    }
                }
            }
            
            if (items.isEmpty()) {
                request.setAttribute("error", "Please add at least one product");
                showAddForm(request, response);
                return;
            }
            
            boolean success = ticketDAO.insertTicket(ticket, items);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/transfer-tickets?success=created");
            } else {
                request.setAttribute("error", "Failed to create ticket");
                showAddForm(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            showAddForm(request, response);
        }
    }

    private void updateTicket(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            RequestTransferTicket ticket = new RequestTransferTicket();
            ticket.setId(id);
            ticket.setType(request.getParameter("type"));
            ticket.setRequestDate(Date.valueOf(request.getParameter("requestDate")));
            ticket.setNote(request.getParameter("note"));
            ticket.setEmployeeId(Integer.parseInt(request.getParameter("employeeId")));
            
            // Parse items
            List<ProductTransferItem> items = new ArrayList<>();
            String[] productIds = request.getParameterValues("productId");
            String[] quantities = request.getParameterValues("quantity");
            
            if (productIds != null && quantities != null) {
                for (int i = 0; i < productIds.length; i++) {
                    if (productIds[i] != null && !productIds[i].isEmpty() 
                        && quantities[i] != null && !quantities[i].isEmpty()) {
                        
                        int qty = Integer.parseInt(quantities[i]);
                        if (qty > 0) {
                            ProductTransferItem item = new ProductTransferItem();
                            item.setProductId(Integer.parseInt(productIds[i]));
                            item.setQuantity(qty);
                            items.add(item);
                        }
                    }
                }
            }
            
            if (items.isEmpty()) {
                request.setAttribute("error", "Please add at least one product");
                request.setAttribute("id", id);
                showEditForm(request, response);
                return;
            }
            
            boolean success = ticketDAO.updateTicket(ticket, items);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/transfer-tickets?success=updated");
            } else {
                request.setAttribute("error", "Failed to update ticket. Only pending tickets can be edited.");
                request.setAttribute("id", id);
                showEditForm(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/transfer-tickets");
        }
    }
}

