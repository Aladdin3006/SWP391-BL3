package controller.transfer;

import dal.RequestTransferDAO;
import dal.UserDAO;
import entity.RequestTransferTicket;
import entity.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name="RequestTransferDetailController", urlPatterns={"/request-transfer/detail"})
public class RequestTransferDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/request-transfer");
            return;
        }

        int id = Integer.parseInt(idStr);
        RequestTransferDAO dao = new RequestTransferDAO();
        UserDAO userDao = new UserDAO();

        RequestTransferTicket ticket = dao.getById(id);
        if (ticket == null) {
            response.sendRedirect(request.getContextPath() + "/request-transfer");
            return;
        }

        User creator = userDao.getUserById(ticket.getCreatedBy());
        User storekeeper = null;
        if (ticket.getStorekeeperId() > 0) {
            storekeeper = userDao.getUserById(ticket.getStorekeeperId());
        }

        request.setAttribute("ticket", ticket);
        request.setAttribute("creator", creator);
        request.setAttribute("storekeeper", storekeeper);

        request.getRequestDispatcher("/view/transfer/request-detail.jsp").forward(request, response);
    }
}