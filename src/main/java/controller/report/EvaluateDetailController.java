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
import java.util.Map;

@WebServlet("/evaluate-detail")
public class EvaluateDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idRaw = request.getParameter("id");
        if (idRaw == null) {
            response.sendRedirect(request.getContextPath() + "/evaluate-list");
            return;
        }

        try {
            int id = Integer.parseInt(idRaw);
            EvaluateDAO db = new EvaluateDAO();

            Map<String, Object> result = db.getEvaluateByIdWithDetails(id);
            if (result == null) {
                response.sendRedirect(request.getContextPath() + "/evaluate-list?error=Evaluation not found");
                return;
            }

            Evaluate eval = (Evaluate) result.get("evaluate");
            String evaluatorName = (String) result.get("evaluatorName");
            String departmentName = (String) result.get("departmentName");

            request.setAttribute("eval", eval);
            request.setAttribute("evaluatorName", evaluatorName);
            request.setAttribute("departmentName", departmentName);
            request.setAttribute("activePage", "evaluate-list");
            request.getRequestDispatcher("/view/report/evaluate-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/evaluate-list?error=Invalid evaluation ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/evaluate-list?error=Server error");
        }
    }
}