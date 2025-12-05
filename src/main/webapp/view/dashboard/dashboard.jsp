<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - WMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .sidebar { background-color: #343a40; color: white; min-height: calc(100vh - 56px); padding-top: 20px; }
        .sidebar .nav-link { color: rgba(255, 255, 255, 0.8); padding: 10px 15px; }
        .sidebar .nav-link:hover { color: white; background-color: rgba(255, 255, 255, 0.1); }
        .sidebar .nav-link.active { color: white; background-color: #0d6efd; }
        .card { border-radius: 10px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); }
        .welcome-card { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .stat-card { border-left: 4px solid; }
        .stat-card.total-products { border-color: #0d6efd; }
        .stat-card.total-orders { border-color: #198754; }
        .stat-card.pending-orders { border-color: #ffc107; }
        .stat-card.low-stock { border-color: #dc3545; }
    </style>
</head>
<body>
<jsp:include page="../fragments/navbar.jsp"/>

<div class="container-fluid">
    <div class="row">
        <nav class="col-md-2 d-none d-md-block sidebar">
            <div class="position-sticky pt-3">
                <ul class="nav flex-column">
                    <c:choose>
                        <c:when test="${sessionScope.user.roleName == 'admin'}">
                            <li class="nav-item">
                                <a class="nav-link active" href="${pageContext.request.contextPath}/dashboard">
                                    <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/user-list">
                                    <i class="fas fa-users me-2"></i>Manage Users
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/role">
                                    <i class="fas fa-user-tag me-2"></i>Manage Roles
                                </a>
                            </li>
                        </c:when>

                        <c:when test="${sessionScope.user.roleName == 'manager'}">
                            <li class="nav-item">
                                <a class="nav-link active" href="${pageContext.request.contextPath}/dashboard">
                                    <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">
                                    <i class="fas fa-boxes me-2"></i>Inventory
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">
                                    <i class="fas fa-shopping-cart me-2"></i>Orders
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">
                                    <i class="fas fa-chart-line me-2"></i>Reports
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">
                                    <i class="fas fa-users me-2"></i>Users
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">
                                    <i class="fas fa-cog me-2"></i>Settings
                                </a>
                            </li>
                        </c:when>

                        <c:when test="${sessionScope.user.roleName == 'storekeeper'}">
                            <li class="nav-item">
                                <a class="nav-link active" href="${pageContext.request.contextPath}/dashboard">
                                    <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">
                                    <i class="fas fa-arrow-right me-2"></i>Export Warehouse Request
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">
                                    <i class="fas fa-arrow-left me-2"></i>Import Warehouse Request
                                </a>
                            </li>
                        </c:when>

                        <c:when test="${sessionScope.user.roleName == 'employee'}">
                            <li class="nav-item">
                                <a class="nav-link active" href="${pageContext.request.contextPath}/dashboard">
                                    <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">
                                    <i class="fas fa-box me-2"></i>Items
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">
                                    <i class="fas fa-clipboard-list me-2"></i>Your Warehouse Request
                                </a>
                            </li>
                        </c:when>

                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link active" href="${pageContext.request.contextPath}/dashboard">
                                    <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">
                                    <i class="fas fa-boxes me-2"></i>Inventory
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">
                                    <i class="fas fa-shopping-cart me-2"></i>Orders
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">
                                    <i class="fas fa-chart-line me-2"></i>Reports
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </nav>

        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Dashboard</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <div class="btn-group me-2">
                        <button type="button" class="btn btn-sm btn-outline-secondary">Today</button>
                        <button type="button" class="btn btn-sm btn-outline-secondary">Week</button>
                        <button type="button" class="btn btn-sm btn-outline-secondary">Month</button>
                    </div>
                </div>
            </div>

            <div class="row mb-4">
                <div class="col-12">
                    <div class="card welcome-card">
                        <div class="card-body">
                            <h4>Welcome back, ${sessionScope.user.displayName}!</h4>
                            <p class="mb-0">
                                <c:choose>
                                    <c:when test="${sessionScope.user.roleName == 'Admin'}">
                                        You have full access to manage users and roles in the system.
                                    </c:when>
                                    <c:when test="${sessionScope.user.roleName == 'Manager'}">
                                        Manage your team and monitor warehouse operations.
                                    </c:when>
                                    <c:when test="${sessionScope.user.roleName == 'Storekeeper'}">
                                        Handle warehouse import and export requests efficiently.
                                    </c:when>
                                    <c:when test="${sessionScope.user.roleName == 'Employee'}">
                                        Manage items and submit warehouse requests.
                                    </c:when>
                                    <c:otherwise>
                                        Browse products and manage your orders.
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-3 mb-3">
                    <div class="card stat-card total-products">
                        <div class="card-body">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <h6 class="card-subtitle mb-2 text-muted">Total Products</h6>
                                    <h3 class="card-title">152</h3>
                                </div>
                                <i class="fas fa-boxes fa-2x text-primary"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="card stat-card total-orders">
                        <div class="card-body">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <h6 class="card-subtitle mb-2 text-muted">Total Orders</h6>
                                    <h3 class="card-title">42</h3>
                                </div>
                                <i class="fas fa-shopping-cart fa-2x text-success"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="card stat-card pending-orders">
                        <div class="card-body">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <h6 class="card-subtitle mb-2 text-muted">Pending Orders</h6>
                                    <h3 class="card-title">7</h3>
                                </div>
                                <i class="fas fa-clock fa-2x text-warning"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="card stat-card low-stock">
                        <div class="card-body">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <h6 class="card-subtitle mb-2 text-muted">Low Stock</h6>
                                    <h3 class="card-title">5</h3>
                                </div>
                                <i class="fas fa-exclamation-triangle fa-2x text-danger"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mt-4">
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-header">
                            <h5>Recent Orders</h5>
                        </div>
                        <div class="card-body">
                            <table class="table table-hover">
                                <thead>
                                <tr>
                                    <th>Order ID</th>
                                    <th>Customer</th>
                                    <th>Date</th>
                                    <th>Amount</th>
                                    <th>Status</th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <td>ORD-001</td>
                                    <td>John Doe</td>
                                    <td>2024-01-15</td>
                                    <td>$1,200</td>
                                    <td><span class="badge bg-success">Completed</span></td>
                                </tr>
                                <tr>
                                    <td>ORD-002</td>
                                    <td>Jane Smith</td>
                                    <td>2024-01-14</td>
                                    <td>$850</td>
                                    <td><span class="badge bg-warning">Processing</span></td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-header">
                            <h5>Quick Actions</h5>
                        </div>
                        <div class="card-body">
                            <div class="d-grid gap-2">
                                <c:choose>
                                    <c:when test="${sessionScope.user.roleName == 'admin'}">
                                        <a href="#" class="btn btn-primary mb-2">
                                            <i class="fas fa-user-plus me-2"></i>Add New User
                                        </a>
                                        <a href="#" class="btn btn-success mb-2">
                                            <i class="fas fa-user-tag me-2"></i>Manage Roles
                                        </a>
                                    </c:when>
                                    <c:when test="${sessionScope.user.roleName == 'storekeeper'}">
                                        <a href="#" class="btn btn-primary mb-2">
                                            <i class="fas fa-arrow-right me-2"></i>New Export Request
                                        </a>
                                        <a href="#" class="btn btn-success mb-2">
                                            <i class="fas fa-arrow-left me-2"></i>New Import Request
                                        </a>
                                    </c:when>
                                    <c:when test="${sessionScope.user.roleName == 'employee'}">
                                        <a href="#" class="btn btn-primary mb-2">
                                            <i class="fas fa-box me-2"></i>View Items
                                        </a>
                                        <a href="#" class="btn btn-success mb-2">
                                            <i class="fas fa-clipboard-list me-2"></i>New Request
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="#" class="btn btn-primary mb-2">
                                            <i class="fas fa-plus me-2"></i>Add New Product
                                        </a>
                                        <a href="#" class="btn btn-success mb-2">
                                            <i class="fas fa-file-invoice me-2"></i>Create Order
                                        </a>
                                        <a href="#" class="btn btn-info mb-2">
                                            <i class="fas fa-chart-bar me-2"></i>Generate Report
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"></script>
</body>
</html>