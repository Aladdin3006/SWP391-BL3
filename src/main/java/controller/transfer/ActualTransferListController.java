package controller.transfer;

import dal.ActualTransferDAO;
import entity.ActualTransferTicket;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name="ActualTransferListController", urlPatterns={"/actual-transfer"})
public class ActualTransferListController extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        ActualTransferDAO dao = new ActualTransferDAO();

        String search = request.getParameter("search");
        String status = request.getParameter("status");
        String pageStr = request.getParameter("page");

        int page = (pageStr == null || pageStr.isEmpty()) ? 1 : Integer.parseInt(pageStr);
        int pageSize = 10;

        List<ActualTransferTicket> list = dao.getAll(search, status, page, pageSize);
        int totalRecords = dao.count(search, status);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        request.setAttribute("transfers", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", search);
        request.setAttribute("status", status);

        request.getRequestDispatcher("/view/transfer/actual-list.jsp").forward(request, response);
    }
}
