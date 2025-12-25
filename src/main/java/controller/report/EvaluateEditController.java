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
import java.util.Calendar;
import java.util.Date;
import java.util.List;

@WebServlet("/evaluate-update")
public class EvaluateEditController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("../login");
            return;
        }

        String idRaw = request.getParameter("id");
        if (idRaw == null) {
            response.sendRedirect("../evaluate-list");
            return;
        }

        int id = Integer.parseInt(idRaw);
        EvaluateDAO db = new EvaluateDAO();

        Evaluate eval = db.getEvaluateById(id);
        if (eval == null) {
            response.sendRedirect("evaluate-list?error=Evaluation not found");
            return;
        }

        if (eval.getCreatedBy() != user.getUserId()) {
            response.sendRedirect("evaluate-list?error=Unauthorized access");
            return;
        }

        String dateFrom = "";
        String dateTo = "";

        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat periodFormat = new SimpleDateFormat("MMM yyyy");

            String[] periodParts = eval.getPeriod().split(" - ");

            if (periodParts.length == 1) {
                Date date = periodFormat.parse(periodParts[0].trim());
                dateFrom = sdf.format(date);

                Calendar cal = Calendar.getInstance();
                cal.setTime(date);
                cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
                dateTo = sdf.format(cal.getTime());
            } else if (periodParts.length == 2) {
                Date fromDate = periodFormat.parse(periodParts[0].trim());
                dateFrom = sdf.format(fromDate);

                Date toDate = periodFormat.parse(periodParts[1].trim());

                Calendar cal = Calendar.getInstance();
                cal.setTime(toDate);
                cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
                dateTo = sdf.format(cal.getTime());
            }
        } catch (ParseException e) {
            Calendar cal = Calendar.getInstance();
            cal.set(Calendar.DAY_OF_MONTH, 1);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            dateFrom = sdf.format(cal.getTime());
            dateTo = sdf.format(new Date());
        }
        List<User> employees = db.getEmployeesInSameDepartment(user.getUserId());

        request.setAttribute("eval", eval);
        request.setAttribute("employees", employees);
        request.setAttribute("dateFrom", dateFrom);
        request.setAttribute("dateTo", dateTo);
        request.setAttribute("activePage", "evaluate-list");
        request.getRequestDispatcher("/view/report/update-evaluate.jsp").forward(request, response);
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

        String idRaw = request.getParameter("id");
        String employeeIdRaw = request.getParameter("employeeId");
        String dateFrom = request.getParameter("dateFrom");
        String dateTo = request.getParameter("dateTo");
        String performanceRaw = request.getParameter("performance");
        String accuracyRaw = request.getParameter("accuracy");
        String safetyComplianceRaw = request.getParameter("safetyCompliance");
        String teamworkRaw = request.getParameter("teamwork");

        if (idRaw == null || employeeIdRaw == null || dateFrom == null || dateFrom.trim().isEmpty() ||
                dateTo == null || dateTo.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required");
            doGet(request, response);
            return;
        }

        try {
            int id = Integer.parseInt(idRaw);
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

            Evaluate existing = db.getEvaluateById(id);
            if (existing == null || existing.getCreatedBy() != user.getUserId()) {
                response.sendRedirect("evaluate-list?error=Unauthorized");
                return;
            }

            if (!existing.getPeriod().equals(period) || existing.getEmployeeId() != employeeId) {
                if (db.hasEvaluateForPeriod(employeeId, period, user.getUserId())) {
                    request.setAttribute("error", "Evaluation already exists for this employee in selected period");
                    doGet(request, response);
                    return;
                }
            }

            Evaluate eval = new Evaluate();
            eval.setId(id);
            eval.setEmployeeId(employeeId);
            eval.setCreatedBy(user.getUserId());
            eval.setPeriod(period);
            eval.setPerformance(performance);
            eval.setAccuracy(accuracy);
            eval.setSafetyCompliance(safetyCompliance);
            eval.setTeamwork(teamwork);
            eval.setAvgStar(avgStar);
            eval.setCreatedAt(new Date());

            db.updateEvaluate(eval);
            response.sendRedirect("evaluate-list?success=updated");

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid rating values");
            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to update evaluation: " + e.getMessage());
            doGet(request, response);
        }
    }
}