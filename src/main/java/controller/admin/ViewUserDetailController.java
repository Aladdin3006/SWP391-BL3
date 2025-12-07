package controller.admin;

import dal.UserDBContext;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/user/detail")
public class ViewUserDetailController extends HttpServlet {

    private UserDBContext userDB = new UserDBContext();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Lấy id từ URL
        String idParam = req.getParameter("id");
        if (idParam == null) {
            resp.sendRedirect(req.getContextPath() + "/user-list");
            return;
        }

        int userId;
        try {
            userId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/user-list");
            return;
        }

        // Gọi DBContext
        User user = userDB.getUserById(userId);

        // Không tìm thấy user → quay lại list
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/user-list");
            return;
        }

        // Đẩy dữ liệu sang JSP
        req.setAttribute("user", user);

        // Forward sang đúng file JSP bạn muốn
        req.getRequestDispatcher("/view/admin/user/userdetail.jsp")
                .forward(req, resp);
    }
}
