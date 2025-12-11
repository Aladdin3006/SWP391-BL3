<%-- sidebar.jsp --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<nav class="col-md-2 d-none d-md-block sidebar">
    <div class="position-sticky pt-3">
        <ul class="nav flex-column">
            <c:choose>
                <c:when test="${sessionScope.user.roleName == 'admin'}">
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'user-list' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/user-list">
                            <i class="fas fa-users me-2"></i>Manage Users
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'role' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/view-role-list">
                            <i class="fas fa-user-tag me-2"></i>Manage Roles
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'permission' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/permission">
                            <i class="fas fa-key me-2"></i>Manage Permissions
                        </a>
                    </li>
                </c:when>

                <c:when test="${sessionScope.user.roleName == 'manager'}">
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'dashboard' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/dashboard">
                            <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'inventory' ? 'active' : ''}"
                           href="#">
                            <i class="fas fa-boxes me-2"></i>Inventory
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'orders' ? 'active' : ''}"
                           href="#">
                            <i class="fas fa-shopping-cart me-2"></i>Orders
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'reports' ? 'active' : ''}"
                           href="#">
                            <i class="fas fa-chart-line me-2"></i>Reports
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'users' ? 'active' : ''}"
                           href="#">
                            <i class="fas fa-users me-2"></i>Users
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'settings' ? 'active' : ''}"
                           href="#">
                            <i class="fas fa-cog me-2"></i>Settings
                        </a>
                    </li>
                </c:when>

                <c:when test="${sessionScope.user.roleName == 'storekeeper'}">
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'dashboard' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/dashboard">
                            <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'export' ? 'active' : ''}"
                           href="#">
                            <i class="fas fa-arrow-right me-2"></i>Export Warehouse Request
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'import' ? 'active' : ''}"
                           href="#">
                            <i class="fas fa-arrow-left me-2"></i>Import Warehouse Request
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'actual-transfer' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/actual-transfer">
                            <i class="fas fa-dolly-flatbed me-2"></i>Actual Transfers
                        </a>
                    </li>
                </c:when>

                <c:when test="${sessionScope.user.roleName == 'employee'}">
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'dashboard' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/dashboard">
                            <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'items' ? 'active' : ''}"
                           href="#">
                            <i class="fas fa-box me-2"></i>Items
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'warehouse-request' ? 'active' : ''}"
                           href="#">
                            <i class="fas fa-clipboard-list me-2"></i>Your Warehouse Request
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'actual-transfer' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/actual-transfer">
                            <i class="fas fa-dolly-flatbed me-2"></i>Actual Transfers
                        </a>
                    </li>
                </c:when>

                <c:otherwise>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'dashboard' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/dashboard">
                            <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'inventory' ? 'active' : ''}"
                           href="#">
                            <i class="fas fa-boxes me-2"></i>Inventory
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'orders' ? 'active' : ''}"
                           href="#">
                            <i class="fas fa-shopping-cart me-2"></i>Orders
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'reports' ? 'active' : ''}"
                           href="#">
                            <i class="fas fa-chart-line me-2"></i>Reports
                        </a>
                    </li>
                </c:otherwise>
            </c:choose>
        </ul>
    </div>
</nav>