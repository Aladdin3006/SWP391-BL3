package controller.transfer;

import dal.ActualTransferDAO;
import dal.ProductChangeDAO;
import dal.ProductDAO;
import dal.RequestTransferDAO;
import entity.ActualTransferTicket;
import entity.ProductTransferItem;
import entity.ProductChange;
import entity.Product;
import entity.RequestTransferTicket;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "EditActualTransferController", urlPatterns = {"/actual-transfer/edit"})
public class EditActualTransferController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect("../actual-transfer");
            return;
        }

        ActualTransferDAO dao = new ActualTransferDAO();
        ActualTransferTicket ticket = dao.getById(Integer.parseInt(idStr));
        RequestTransferDAO requestDAO = new RequestTransferDAO();
        RequestTransferTicket requestTicket = requestDAO.getById(ticket.getRequestTransferId());

        if (requestTicket != null) {
            request.setAttribute("requestType", requestTicket.getType());
        }

        request.setAttribute("ticket", ticket);
        request.getRequestDispatcher("/view/transfer/actual-edit.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();

            int id = Integer.parseInt(request.getParameter("id"));
            Date transferDate = Date.valueOf(request.getParameter("transferDate"));
            String status = request.getParameter("status");
            String note = request.getParameter("note");

            String[] productIds = request.getParameterValues("productId");
            String[] quantities = request.getParameterValues("quantity");

            List<ProductTransferItem> items = new ArrayList<>();
            if (productIds != null) {
                for (int i = 0; i < productIds.length; i++) {
                    ProductTransferItem item = new ProductTransferItem();
                    item.setProductId(Integer.parseInt(productIds[i]));
                    item.setQuantity(Integer.parseInt(quantities[i]));
                    items.add(item);
                }
            }

            ActualTransferTicket ticket = new ActualTransferTicket();
            ticket.setId(id);
            ticket.setTransferDate(transferDate);
            ticket.setStatus(status);
            ticket.setNote(note);
            ticket.setProductTransfers(items);

            ActualTransferDAO dao = new ActualTransferDAO();
            ActualTransferTicket originalTicket = dao.getById(id);
            String originalStatus = originalTicket.getStatus();
            RequestTransferDAO requestDAO = new RequestTransferDAO();
            RequestTransferTicket requestTicket = requestDAO.getById(originalTicket.getRequestTransferId());
            String requestType = requestTicket != null ? requestTicket.getType() : "Unknown";
            dao.update(ticket);
            if (!"Completed".equals(originalStatus) && "Completed".equals(status)) {
                int createdBy = getCreatedBy(session, originalTicket);
                createProductChangeRecords(ticket, requestType, createdBy);
            }

            response.sendRedirect(request.getContextPath() + "/actual-transfer");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/actual-transfer");
        }
    }

    private int getCreatedBy(HttpSession session, ActualTransferTicket ticket) {
        int createdBy = getUserIdFromSession(session);
        if (createdBy == 0 && ticket.getConfirmedBy() > 0) {
            createdBy = ticket.getConfirmedBy();
        }

        return createdBy;
    }

    private int getUserIdFromSession(HttpSession session) {
        Object userObj = session.getAttribute("user");
        int userId = 0;

        if (userObj != null) {
            try {
                java.lang.reflect.Method getUserIdMethod = userObj.getClass().getMethod("getUserId");
                Object result = getUserIdMethod.invoke(userObj);
                if (result instanceof Integer) {
                    userId = (Integer) result;
                }
            } catch (Exception e) {
                try {
                    java.lang.reflect.Method getIdMethod = userObj.getClass().getMethod("getId");
                    Object result = getIdMethod.invoke(userObj);
                    if (result instanceof Integer) {
                        userId = (Integer) result;
                    }
                } catch (Exception ex) {
                    Integer sessionUserId = (Integer) session.getAttribute("userId");
                    if (sessionUserId != null) {
                        userId = sessionUserId;
                    }
                }
            }
        }
        return userId;
    }

    private void createProductChangeRecords(ActualTransferTicket ticket, String requestType, int createdBy) {
        ProductDAO productDAO = new ProductDAO();
        ProductChangeDAO productChangeDAO = new ProductChangeDAO();

        for (ProductTransferItem item : ticket.getProductTransfers()) {
            Product product = productDAO.getProductById(item.getProductId());
            if (product != null) {
                int beforeChange = product.getUnit();
                int changeAmount = item.getQuantity();
                int afterChange;
                if ("Import".equalsIgnoreCase(requestType)) {
                    afterChange = beforeChange + changeAmount;
                } else if ("Export".equalsIgnoreCase(requestType)) {
                    afterChange = Math.max(0, beforeChange - changeAmount);
                    changeAmount = beforeChange - afterChange;
                } else {
                    continue;
                }
                ProductChange productChange = new ProductChange();
                productChange.setProductId(item.getProductId());
                productChange.setChangeType("TRANSFER_TICKET");
                productChange.setChangeDate(Date.valueOf(LocalDate.now()));
                productChange.setBeforeChange(beforeChange);
                productChange.setAfterChange(afterChange);
                productChange.setChangeAmount(changeAmount);
                productChange.setTicketId(String.valueOf(ticket.getId()));

                String noteText = "Transfer completed ";
                if ("Import".equalsIgnoreCase(requestType)) {
                    noteText += " (Import - Stock Increased)";
                } else if ("Export".equalsIgnoreCase(requestType)) {
                    noteText += " (Export - Stock Decreased)";
                }
                productChange.setNote(noteText);
                productChange.setCreatedBy(createdBy);
                productChangeDAO.insert(productChange);
                product.setUnit(afterChange);
                productDAO.updateProduct(product);
            }
        }
    }
}