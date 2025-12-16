package controller.report;

import dal.ActualTransferDAO;
import entity.ActualTransferTicket;
import entity.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name="ExportWarehouseReportController", urlPatterns={"/export-warehouse-report"})
public class ExportWarehouseReportController extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        ActualTransferDAO dao = new ActualTransferDAO();

        String search = request.getParameter("search");
        String dateFrom = request.getParameter("dateFrom");
        String dateTo = request.getParameter("dateTo");
        String pageStr = request.getParameter("page");

        int page = (pageStr == null || pageStr.isEmpty()) ? 1 : Integer.parseInt(pageStr);
        int pageSize = 10;
        
        // Filter by Export type, date range and assigned storekeeper
        Integer storekeeperId = user.getUserId(); // Only show actual transfers assigned to this storekeeper
        List<ActualTransferTicket> list = dao.getAllByTypeAndDateAndStorekeeper("Export", dateFrom, dateTo, search, storekeeperId, page, pageSize);
        int totalRecords = dao.countByTypeAndDateAndStorekeeper("Export", dateFrom, dateTo, search, storekeeperId);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        // Calculate display range
        int fromRecord = totalRecords > 0 ? ((page - 1) * pageSize + 1) : 0;
        int toRecord = Math.min(page * pageSize, totalRecords);

        request.setAttribute("transfers", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("fromRecord", fromRecord);
        request.setAttribute("toRecord", toRecord);
        request.setAttribute("search", search);
        request.setAttribute("dateFrom", dateFrom);
        request.setAttribute("dateTo", dateTo);
        request.setAttribute("reportType", "Export");

        request.getRequestDispatcher("/view/report/warehouse-report.jsp").forward(request, response);
    }
}
