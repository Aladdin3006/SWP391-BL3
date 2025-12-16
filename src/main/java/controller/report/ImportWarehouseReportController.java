package controller.report;

import dal.ActualTransferDAO;
import entity.ActualTransferTicket;
import entity.User;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Map;

@WebServlet(name="ImportWarehouseReportController", urlPatterns={"/import-warehouse-report"})
public class ImportWarehouseReportController extends HttpServlet {
   
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

        if (dateFrom == null || dateFrom.isEmpty()) {
            Calendar cal = Calendar.getInstance();
            cal.set(Calendar.DAY_OF_MONTH, 1);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            dateFrom = sdf.format(cal.getTime());
        }

        if (dateTo == null || dateTo.isEmpty()) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            dateTo = sdf.format(new Date());
        }
        List<Map<String, Object>> list = dao.getAllByTypeAndDate("Import", dateFrom, dateTo, search, page, pageSize); list = dao.getAllByTypeAndDate("Import", dateFrom, dateTo, search, page, pageSize);
        int totalRecords = dao.countByTypeAndDate("Import", dateFrom, dateTo, search);
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
        request.setAttribute("dateFrom", dateFrom);
        request.setAttribute("dateTo", dateTo);
        request.setAttribute("reportType", "Import");

        request.getRequestDispatcher("/view/manager/report/warehouse-report.jsp").forward(request, response);
    }
}
