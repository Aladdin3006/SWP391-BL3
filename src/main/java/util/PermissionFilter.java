package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.PermissionChecker;
import java.io.IOException;

@WebFilter("/*")
public class PermissionFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String path = req.getServletPath();

        if (path.startsWith("/assets/") ||
                path.startsWith("/css/") ||
                path.startsWith("/js/") ||
                path.startsWith("/images/") ||
                path.equals("/unauthorized")) {
            chain.doFilter(request, response);
            return;
        }

        if (!PermissionChecker.hasPermission(req)) {
            resp.sendRedirect(req.getContextPath() + "/unauthorized");
            return;
        }

        chain.doFilter(request, response);
    }
}