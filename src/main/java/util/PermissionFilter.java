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
                path.equals("/") ||
                path.equals("/home") ||
                path.equals("/login") ||
                path.equals("/register") ||
                path.equals("/forgot-password") ||
                path.equals("/reset-password") ||
                path.equals("/verify") ||
                path.equals("/verify-email-change") ||
                path.equals("/unauthorized") ||
                path.equals("/logout")) {
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