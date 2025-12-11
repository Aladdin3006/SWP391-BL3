package controller.transfer;

import dal.ActualTransferDAO;
import dal.RequestTransferDAO;
import entity.ActualTransferTicket;
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

@WebServlet(name = "AddActualTransferController", urlPatterns = {"/actual-transfer/add"})
public class AddActualTransferController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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

        try {
            String ticketCode = request.getParameter("ticketCode");
            int requestTransferId = Integer.parseInt(request.getParameter("requestTransferId"));
            Date transferDate = Date.valueOf(request.getParameter("transferDate"));
            String status = request.getParameter("status");
            String note = request.getParameter("note");

            User user = (User) request.getSession().getAttribute("user");
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

            response.sendRedirect(request.getContextPath() + "/actual-transfer");

        } catch (IOException | NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/actual-transfer/add?error=1");
        }
    }
}
