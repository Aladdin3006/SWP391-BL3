package controller.transfer;

import dal.RequestTransferDAO;
import entity.RequestTransferTicket;
import entity.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name="RequestTransferListController", urlPatterns={"/request-transfer"})
public class RequestTransferListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        RequestTransferDAO dao = new RequestTransferDAO();

        String search = request.getParameter("search");
        String status = request.getParameter("status");
        String pageStr = request.getParameter("page");

        int page = (pageStr == null || pageStr.isEmpty()) ? 1 : Integer.parseInt(pageStr);
        int pageSize = 10;

        int userId = user.getUserId();
        String roleName = user.getRole() != null ? user.getRole().getRoleName() : "";

        List<RequestTransferTicket> list;
        int totalRecords;

        if ("admin".equals(roleName) || "manager".equals(roleName)) {
            list = dao.getAll(search, status, page, pageSize);
            totalRecords = dao.count(search, status);
        } else if ("storekeeper".equals(roleName)) {
            list = dao.getAll(search, status, page, pageSize, userId, null);
            totalRecords = dao.count(search, status, userId, null);
        } else {
            list = dao.getAllByCreatedBy(userId, search, status, page, pageSize);
            totalRecords = dao.countByCreatedBy(userId, search, status);
        }

        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        int fromRecord = totalRecords > 0 ? ((page - 1) * pageSize + 1) : 0;
        int toRecord = Math.min(page * pageSize, totalRecords);

        request.setAttribute("transfers", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("fromRecord", fromRecord);
        request.setAttribute("toRecord", toRecord);
        request.setAttribute("search", search);
        request.setAttribute("status", status);

        request.getRequestDispatcher("/view/transfer/request-list.jsp").forward(request, response);
    }
}