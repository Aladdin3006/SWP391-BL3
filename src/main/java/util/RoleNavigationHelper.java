package util;

public class RoleNavigationHelper {

    private RoleNavigationHelper() {
    }

    public static String getFirstPageForRole(String roleName) {
        if (roleName == null) {
            return "dashboard";
        }

        return switch (roleName.toLowerCase()) {
            case "admin" -> "user-list";
            case "manager" -> "view-product-list";
            case "storekeeper" -> "request-transfer";
            case "employee" -> "actual-transfer";
            default -> "dashboard";
        };
    }

    public static String getRedirectPath(String roleName) {
        String firstPage = getFirstPageForRole(roleName);
        return firstPage;
    }
}