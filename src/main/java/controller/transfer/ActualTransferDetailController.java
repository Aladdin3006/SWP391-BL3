package controller.transfer;

import dal.ActualTransferDAO;
import entity.ActualTransferTicket;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ActualTransferDetailController", urlPatterns = {"/actual-transfer/detail"})
public class ActualTransferDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");

        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/actual-transfer");
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            ActualTransferDAO dao = new ActualTransferDAO();
            ActualTransferTicket ticket = dao.getById(id);

            if (ticket == null) {
                response.sendRedirect(request.getContextPath() + "/actual-transfer");
                return;
            }
            
            request.setAttribute("ticket", ticket);
            request.getRequestDispatcher("/view/transfer/actual-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/actual-transfer");
        }
    }
}
