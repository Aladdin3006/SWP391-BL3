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
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

@WebServlet("/evaluate-add")
public class EvaluateAddController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("../login");
            return;
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.DAY_OF_MONTH, 1);
        String dateFrom = sdf.format(cal.getTime());

        String dateTo = sdf.format(new Date());

        EvaluateDAO db = new EvaluateDAO();
        List<User> employees = db.getEmployeesInSameDepartment(user.getUserId());

        request.setAttribute("employees", employees);
        request.setAttribute("dateFrom", dateFrom);
        request.setAttribute("dateTo", dateTo);
        request.setAttribute("activePage", "evaluate-list");
        request.getRequestDispatcher("/view/report/add-evaluate.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("../login");
            return;
        }

        String employeeIdRaw = request.getParameter("employeeId");
        String dateFrom = request.getParameter("dateFrom");
        String dateTo = request.getParameter("dateTo");
        String performanceRaw = request.getParameter("performance");
        String accuracyRaw = request.getParameter("accuracy");
        String safetyComplianceRaw = request.getParameter("safetyCompliance");
        String teamworkRaw = request.getParameter("teamwork");

        if (employeeIdRaw == null || dateFrom == null || dateFrom.trim().isEmpty() ||
                dateTo == null || dateTo.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required");
            doGet(request, response);
            return;
        }

        try {
            int employeeId = Integer.parseInt(employeeIdRaw);
            int performance = Integer.parseInt(performanceRaw);
            int accuracy = Integer.parseInt(accuracyRaw);
            int safetyCompliance = Integer.parseInt(safetyComplianceRaw);
            int teamwork = Integer.parseInt(teamworkRaw);

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat periodFormat = new SimpleDateFormat("MMM yyyy");
            Date fromDate = sdf.parse(dateFrom);
            Date toDate = sdf.parse(dateTo);

            String period;
            Calendar calFrom = Calendar.getInstance();
            Calendar calTo = Calendar.getInstance();
            calFrom.setTime(fromDate);
            calTo.setTime(toDate);

            if (calFrom.get(Calendar.MONTH) == calTo.get(Calendar.MONTH) &&
                    calFrom.get(Calendar.YEAR) == calTo.get(Calendar.YEAR)) {
                period = periodFormat.format(fromDate);
            } else {
                period = periodFormat.format(fromDate) + " - " + periodFormat.format(toDate);
            }

            double avgStar = (performance + accuracy + safetyCompliance + teamwork) / 4.0;

            EvaluateDAO db = new EvaluateDAO();

            if (db.hasEvaluateForPeriod(employeeId, period, user.getUserId())) {
                request.setAttribute("error", "Evaluation already exists for this employee in selected period");
                doGet(request, response);
                return;
            }

            Evaluate eval = new Evaluate();
            eval.setEmployeeId(employeeId);
            eval.setCreatedBy(user.getUserId());
            eval.setPeriod(period);
            eval.setPerformance(performance);
            eval.setAccuracy(accuracy);
            eval.setSafetyCompliance(safetyCompliance);
            eval.setTeamwork(teamwork);
            eval.setAvgStar(avgStar);
            eval.setCreatedAt(new Date());

            db.addEvaluate(eval);
            response.sendRedirect("evaluate-list?success=added");

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid rating values");
            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to add evaluation: " + e.getMessage());
            doGet(request, response);
        }
    }
}