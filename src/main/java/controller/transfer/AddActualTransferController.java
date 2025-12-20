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
import entity.User;
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

@WebServlet(name = "AddActualTransferController", urlPatterns = {"/actual-transfer/add"})
public class AddActualTransferController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        RequestTransferDAO reqDao = new RequestTransferDAO();
        request.setAttribute("requests", reqDao.getAvailableForActual());

        String selectedReqId = request.getParameter("reqId");
        if (selectedReqId != null && !selectedReqId.isEmpty()) {
            RequestTransferTicket reqTicket = reqDao.getById(Integer.parseInt(selectedReqId));
            request.setAttribute("selectedTicket", reqTicket);
        }

        request.getRequestDispatcher("/view/transfer/actual-add.jsp").forward(request, response);
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
            int requestTransferId = Integer.parseInt(request.getParameter("requestTransferId"));
            Date transferDate = Date.valueOf(request.getParameter("transferDate"));
            String status = request.getParameter("status");
            String note = request.getParameter("note");

            int confirmedBy = user.getUserId();

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
            ticket.setTicketCode(ticketCode);
            ticket.setRequestTransferId(requestTransferId);
            ticket.setTransferDate(transferDate);
            ticket.setStatus(status);
            ticket.setConfirmedBy(confirmedBy);
            ticket.setNote(note);
            ticket.setProductTransfers(items);

            ActualTransferDAO dao = new ActualTransferDAO();
            dao.insert(ticket);

            if ("Completed".equals(status)) {
                RequestTransferDAO requestDAO = new RequestTransferDAO();
                RequestTransferTicket requestTicket = requestDAO.getById(requestTransferId);
                String requestType = requestTicket != null ? requestTicket.getType() : "Unknown";
                createProductChangeRecords(ticket, requestType, confirmedBy);
            }

            response.sendRedirect(request.getContextPath() + "/actual-transfer");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/actual-transfer/add?error=1");
        }
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