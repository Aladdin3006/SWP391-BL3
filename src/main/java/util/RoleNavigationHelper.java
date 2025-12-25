package util;

public class RoleNavigationHelper {

    private RoleNavigationHelper() {
    }

    public static String getFirstPageForRole(String roleName) {
        if (roleName == null) {
            return "dashboard";
        }

        return switch (roleName.toLowerCase()) {
            case "admin" -> "/dashboard-admin";
            case "manager" -> "dashboard-manager";
            case "storekeeper" -> "actual-transfer";
            case "employee" -> "request-transfer";
            default -> "dashboard";
        };
    }

    public static String getRedirectPath(String roleName) {
        String firstPage = getFirstPageForRole(roleName);
        return firstPage;
    }
}