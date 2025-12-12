package controller.transfer;

import dal.ActualTransferDAO;
import entity.ActualTransferTicket;
import entity.ProductTransferItem;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

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
        request.setAttribute("ticket", ticket);
        request.getRequestDispatcher("/view/transfer/actual-edit.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
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
            dao.update(ticket);

            response.sendRedirect(request.getContextPath() + "/actual-transfer");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/actual-transfer");
        }
    }
}
