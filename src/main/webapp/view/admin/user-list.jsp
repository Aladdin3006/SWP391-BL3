<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>User Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .sidebar { background-color: #343a40; color: white; min-height: calc(100vh - 56px); padding-top: 20px; }
        .sidebar .nav-link { color: rgba(255, 255, 255, 0.8); padding: 10px 15px; }
        .sidebar .nav-link:hover { color: white; background-color: rgba(255, 255, 255, 0.1); }
        .sidebar .nav-link.active { color: white; background-color: #0d6efd; }

        .filter-box {
            background: white; padding: 25px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 25px;
        }
        .form-group label { font-size: 14px; font-weight: 600; margin-bottom: 5px; color: #495057; }
        .form-group input, .form-group select {
            padding: 10px 12px; border: 1px solid #ced4da; border-radius: 6px; font-size: 14px;
        }
        .btn-filter {
            padding: 10px 25px; background-color: #0d6efd; color: white; border: none; border-radius: 6px;
            cursor: pointer; font-weight: bold; transition: background-color 0.3s;
            height: 42px;
        }
        .btn-filter:hover { background-color: #0b5ed7; }

        .table-container {
            background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 15px; text-align: left; border-bottom: 1px solid #dee2e6; }
        th { background-color: #2c3e50; color: white; font-weight: 600; text-transform: uppercase; font-size: 13px; }
        tr:hover { background-color: #f8f9fa; }

        .badge { padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: bold; text-align: center; display: inline-block; min-width: 90px;}

        .role-admin { background-color: #ffd700; color: #856404; }
        .role-manager { background-color: #ff8c00; color: white; }
        .role-employee { background-color: #28a745; color: white; }
        .role-other { background-color: #6c757d; color: white; }

        .status-active { background-color: #d1e7dd; color: #0f5132; border: 1px solid #badbcc; }
        .status-inactive { background-color: #f8d7da; color: #842029; border: 1px solid #f5c2c7; }

        .btn-action { padding: 6px 12px; font-size: 12px; border-radius: 4px; text-decoration: none; color: white; display: inline-block; }
        .btn-lock { background-color: #dc3545; }
        .btn-lock:hover { background-color: #c82333; }
        .btn-unlock { background-color: #28a745; }
        .btn-unlock:hover { background-color: #218838; }

        .page-title { color: #2c3e50; font-weight: 600; margin-bottom: 20px; }

        .empty-state {
            text-align: center; padding: 40px; color: #6c757d;
        }
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
                                <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                                    <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link active" href="${pageContext.request.contextPath}/users">
                                    <i class="fas fa-users me-2"></i>Manage Users
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">
                                    <i class="fas fa-user-tag me-2"></i>Manage Roles
                                </a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                                    <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </nav>

        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2 page-title">User Management</h1>
            </div>

            <form action="${pageContext.request.contextPath}/users" method="GET" class="filter-box">
                <div class="row g-3">
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="form-label">Display Name</label>
                            <input type="text" name="searchName" value="${searchName}" class="form-control" placeholder="Enter name...">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="form-label">Email</label>
                            <input type="text" name="searchEmail" value="${searchEmail}" class="form-control" placeholder="Enter email...">
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="form-group">
                            <label class="form-label">Role</label>
                            <select name="roleId" class="form-select">
                                <option value="0">All Roles</option>
                                <c:forEach items="${roles}" var="r">
                                    <option value="${r.roleId}" ${selectedRoleId == r.roleId ? 'selected' : ''}>${r.roleName}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="form-group">
                            <label class="form-label">Status</label>
                            <select name="status" class="form-select">
                                <option value="all" ${selectedStatus == 'all' ? 'selected' : ''}>All Status</option>
                                <option value="active" ${selectedStatus == 'active' ? 'selected' : ''}>Active</option>
                                <option value="inactive" ${selectedStatus == 'inactive' ? 'selected' : ''}>Inactive</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary btn-filter w-100">
                            <i class="fas fa-search me-1"></i> Search
                        </button>
                    </div>
                </div>
            </form>

            <div class="table-container">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th style="width: 50px; text-align: center;">#</th>
                        <th>User Information</th>
                        <th>Contact</th>
                        <th style="text-align: center;">Role</th>
                        <th style="text-align: center;">Status</th>
                        <th style="text-align: center;">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:if test="${empty users}">
                        <tr>
                            <td colspan="6" class="empty-state">
                                <i class="fas fa-users fa-2x mb-3" style="color: #dee2e6;"></i>
                                <p class="mb-0">No users found.</p>
                            </td>
                        </tr>
                    </c:if>
                    <c:forEach items="${users}" var="u" varStatus="loop">
                        <tr>
                            <td style="text-align: center; vertical-align: middle;">${loop.index + 1}</td>
                            <td style="vertical-align: middle;">
                                <strong>${u.displayName}</strong><br>
                                <span style="font-size: 13px; color: #6c757d;">@${u.accountName}</span>
                            </td>
                            <td style="vertical-align: middle;">
                                <div>${u.email}</div>
                                <div style="font-size: 13px; color: #6c757d;">${u.phone}</div>
                            </td>
                            <td style="text-align: center; vertical-align: middle;">
                                <c:choose>
                                    <c:when test="${u.roleName == 'admin'}"><span class="badge role-admin">${u.roleName}</span></c:when>
                                    <c:when test="${u.roleName == 'manager'}"><span class="badge role-manager">${u.roleName}</span></c:when>
                                    <c:when test="${u.roleName == 'employee'}"><span class="badge role-employee">${u.roleName}</span></c:when>
                                    <c:otherwise><span class="badge role-other">${u.roleName}</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td style="text-align: center; vertical-align: middle;">
                                <span class="badge ${u.status == 'active' ? 'status-active' : 'status-inactive'}">
                                        ${u.status == 'active' ? 'Active' : 'Inactive'}
                                </span>
                            </td>
                            <td style="text-align: center; vertical-align: middle;">
                                <c:if test="${u.status == 'active'}">
                                    <a href="${pageContext.request.contextPath}/users?action=deactivate&userId=${u.userId}"
                                       class="btn btn-sm btn-danger btn-action"
                                       onclick="return confirm('Are you sure you want to deactivate this user?')">
                                        <i class="fas fa-lock me-1"></i> Deactivate
                                    </a>
                                </c:if>
                                <c:if test="${u.status == 'inactive'}">
                                    <a href="${pageContext.request.contextPath}/users?action=activate&userId=${u.userId}"
                                       class="btn btn-sm btn-success btn-action">
                                        <i class="fas fa-unlock me-1"></i> Activate
                                    </a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"></script>
</body>
</html>