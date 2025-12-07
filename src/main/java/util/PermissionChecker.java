package util;

import dal.PermissionDAO;
import dal.RolePermissionDAO;
import entity.User;
import jakarta.servlet.http.HttpServletRequest;
import java.util.List;

public class PermissionChecker {

    private static final PermissionDAO permissionDAO = new PermissionDAO();
    private static final RolePermissionDAO rolePermissionDAO = new RolePermissionDAO();

    public static boolean hasPermission(HttpServletRequest request) {
        User user = (User) request.getSession().getAttribute("user");

        String currentUrl = getCleanUrl(request.getRequestURI(), request.getContextPath());

        if (isPublicUrl(currentUrl)) {
            return true;
        }

        if (user == null) {
            return false;
        }

        if ("/dashboard".equals(currentUrl)) {
            return true;
        }

        List<String> userPermissions = rolePermissionDAO.getPermissionUrlsByRoleId(user.getRoleId());

        for (String permissionUrl : userPermissions) {
            if (permissionUrl != null && currentUrl.startsWith(permissionUrl)) {
                return true;
            }
        }

        return false;
    }

    private static String getCleanUrl(String requestUri, String contextPath) {
        String url = requestUri.substring(contextPath.length());
        if (url.isEmpty()) {
            url = "/";
        }
        return url;
    }

    private static boolean isPublicUrl(String url) {
        return "/".equals(url) ||
                "/home".equals(url) ||
                "/login".equals(url) ||
                "/register".equals(url) ||
                "/forgot-password".equals(url) ||
                "/reset-password".equals(url) ||
                "/verify".equals(url) ||
                "/verify-email-change".equals(url) ||
                "/unauthorized".equals(url);
    }

    public static boolean checkUrl(HttpServletRequest request, String urlToCheck) {
        User user = (User) request.getSession().getAttribute("user");

        if (user == null) {
            return isPublicUrl(urlToCheck);
        }

        if ("/dashboard".equals(urlToCheck) || "/logout".equals(urlToCheck)) {
            return true;
        }

        List<String> userPermissions = rolePermissionDAO.getPermissionUrlsByRoleId(user.getRoleId());

        for (String permissionUrl : userPermissions) {
            if (permissionUrl != null && urlToCheck.startsWith(permissionUrl)) {
                return true;
            }
        }

        return false;
    }
}