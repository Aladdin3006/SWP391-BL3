package controller.report;

import dal.EvaluateDAO;
import entity.Evaluate;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet(name = "EvaluateListController", urlPatterns = {"/evaluate-list"})
public class EvaluateListController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("../login");
            return;
        }

        EvaluateDAO db = new EvaluateDAO();

        String action = request.getParameter("action");
        String idRaw = request.getParameter("id");

        if ("delete".equals(action) && idRaw != null) {
            int id = Integer.parseInt(idRaw);
            db.deleteEvaluate(id);
            response.sendRedirect("evaluate-list?success=deleted");
            return;
        }

        String pageRaw = request.getParameter("page");
        int page = pageRaw == null ? 1 : Integer.parseInt(pageRaw);

        String search = request.getParameter("search");
        String sort = request.getParameter("sort");
        String dateFilter = request.getParameter("dateFilter");

        if (sort == null || sort.isEmpty()) {
            sort = "newest";
        }

        List<Evaluate> evaluates = db.getEvaluateListWithPaging(user.getUserId(), search, sort, dateFilter, page, PAGE_SIZE);
        int total = db.countEvaluates(user.getUserId(), search, dateFilter);
        int totalPages = (int) Math.ceil(total * 1.0 / PAGE_SIZE);

        request.setAttribute("evaluates", evaluates);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", search);
        request.setAttribute("sort", sort);
        request.setAttribute("dateFilter", dateFilter);

        request.setAttribute("activePage", "evaluate-list");
        request.getRequestDispatcher("/view/report/evaluate-list.jsp").forward(request, response);
    }
}