<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="util.PermissionChecker" %>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <a class="navbar-brand" href="#"
                   onclick="navigateToDashboard(event); return false;">
                    <i class="fas fa-warehouse"></i> WMS PC Accessories
                </a>
            </c:when>
            <c:otherwise>
                <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
                    <i class="fas fa-warehouse"></i> WMS PC Accessories
                </a>
            </c:otherwise>
        </c:choose>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <c:if test="${empty sessionScope.user}">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/home">Home</a>
                    </li>
                </c:if>

                <c:if test="${not empty sessionScope.user}">
                    <c:if test="<%= PermissionChecker.hasPermission(request) &&
                    PermissionChecker.checkUrl(request, \"/users\") %>">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/users">Users</a>
                        </li>
                    </c:if>

                    <c:if test="<%= PermissionChecker.hasPermission(request) &&
                    PermissionChecker.checkUrl(request, \"/roles\") %>">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/roles">Roles</a>
                        </li>
                    </c:if>

                    <c:if test="<%= PermissionChecker.hasPermission(request) &&
                    PermissionChecker.checkUrl(request, \"/permission\") %>">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/permission">Permissions</a>
                        </li>
                    </c:if>
                </c:if>
            </ul>

            <div class="navbar-nav">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                                <i class="fas fa-user me-1"></i>
                                    ${sessionScope.user.displayName}
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><span class="dropdown-item-text">
                                <small>Role: ${sessionScope.user.roleName}</small>
                            </span></li>
                                <li><hr class="dropdown-divider"></li>
                                <c:if test="<%= PermissionChecker.checkUrl(request, \"/profile\") %>">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                        <i class="fas fa-user-circle me-2"></i>Profile
                                    </a></li>
                                </c:if>
                                <c:if test="<%= PermissionChecker.checkUrl(request, \"/change-password\") %>">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/change-password">
                                        <i class="fas fa-key me-2"></i>Change Password
                                    </a></li>
                                </c:if>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                    <i class="fas fa-sign-out-alt me-2"></i>Logout
                                </a></li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/login">Login</a>
                        </li>
                        <c:if test="<%= PermissionChecker.checkUrl(request, \"/register\") %>">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/register">Register</a>
                            </li>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>

<script>
    function navigateToDashboard(event) {
        const userRole = '${sessionScope.user.roleName}';
        const basePath = '${pageContext.request.contextPath}';
        let dashboardUrl = basePath + '/dashboard';

        switch(userRole.toLowerCase()) {
            case 'admin':
                dashboardUrl = basePath + '/dashboard-admin';
                break;
            case 'manager':
                dashboardUrl = basePath + '/dashboard-manager';
                break;
            case 'storekeeper':
                dashboardUrl = basePath + '/actual-transfer';
                break;
            case 'employee':
                dashboardUrl = basePath + '/request-transfer';
                break;
            default:
                dashboardUrl = basePath + '/dashboard';
        }

        window.location.href = dashboardUrl;
    }
</script>

<c:if test="${sessionScope.user.roleName == 'employee' or sessionScope.user.roleName == 'storekeeper'}">
    <jsp:include page="/view/fragments/chat-widget.jsp"/>
</c:if>