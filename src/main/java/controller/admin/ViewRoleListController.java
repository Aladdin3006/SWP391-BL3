package controller.admin;

import dal.RoleDAO;
import entity.Role;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewRoleListController", urlPatterns = {"/view-role-list"})
public class ViewRoleListController extends HttpServlet {

    // số bản ghi trên 1 trang
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // lấy param từ URL
        String pageParam = request.getParameter("page");
        String keyword = request.getParameter("keyword");   // search theo roleName
        String status = request.getParameter("status");     // filter theo status

        int pageIndex = 1;          // trang mặc định
        int pageSize = PAGE_SIZE;   // có thể cho chọn pageSize sau

        // parse pageIndex an toàn
        if (pageParam != null) {
            try {
                pageIndex = Integer.parseInt(pageParam);
                if (pageIndex < 1) {
                    pageIndex = 1;
                }
            } catch (NumberFormatException e) {
                pageIndex = 1;
            }
        }

        RoleDAO dao = new RoleDAO();

        // lấy danh sách role theo điều kiện
        List<Role> roles = dao.getAllRoles(keyword, status, pageIndex, pageSize);
        // đếm tổng record để tính totalPages (nhớ tự thêm hàm này vào DAO)
        int totalRecords = dao.countRoles(keyword, status);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        // đẩy dữ liệu xuống JSP
        request.setAttribute("roles", roles);
        request.setAttribute("pageIndex", pageIndex);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);

        // giữ lại giá trị filter/search để hiển thị lại trên form
        request.setAttribute("keyword", keyword == null ? "" : keyword);
        request.setAttribute("status", status == null ? "all" : status);

        // forward tới JSP (sửa lại path nếu bạn dùng cấu trúc khác)
        request.getRequestDispatcher("/view/admin/role/view-role-list.jsp")
                .forward(request, response);
    }
}
