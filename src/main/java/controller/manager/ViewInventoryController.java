package controller.manager;

import dal.InventoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ViewInventoryController", urlPatterns = {"/view-inventory"})
public class ViewInventoryController extends HttpServlet {

    private final InventoryDAO inventoryDAO = new InventoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String productCode = request.getParameter("productCode");
        String productName = request.getParameter("productName");

        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        LocalDate today = LocalDate.now();
        LocalDate firstDayOfMonth = today.withDayOfMonth(1);

        Date startDate;
        Date endDate;

        if (startDateStr != null && !startDateStr.isEmpty()) {
            startDate = Date.valueOf(startDateStr);
        } else {
            startDate = Date.valueOf(firstDayOfMonth);
        }

        if (endDateStr != null && !endDateStr.isEmpty()) {
            endDate = Date.valueOf(endDateStr);
        } else {
            endDate = Date.valueOf(today);
        }

        int pageIndex = 1;
        int pageSize = 10;

        try {
            pageIndex = Integer.parseInt(request.getParameter("pageIndex"));
        } catch (Exception ignored) {}

        List<Map<String, Object>> inventoryData = inventoryDAO.getInventoryReport(
                productCode,
                productName,
                startDate,
                endDate,
                pageIndex,
                pageSize
        );

        int totalRecords = inventoryDAO.countInventoryReport(
                productCode,
                productName,
                startDate,
                endDate
        );

        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        request.setAttribute("inventoryData", inventoryData);
        request.setAttribute("productCode", productCode);
        request.setAttribute("productName", productName);
        request.setAttribute("startDate", startDateStr != null ? startDateStr : firstDayOfMonth.toString());
        request.setAttribute("endDate", endDateStr != null ? endDateStr : today.toString());
        request.setAttribute("pageIndex", pageIndex);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);

        request.getRequestDispatcher("/view/manager/inventory/inventory.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}