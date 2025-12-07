<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Role List</title>
    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>

        body { background-color: #f8f9fa; }

        .sidebar { background-color: #343a40; color: white; min-height: calc(100vh - 56px); padding-top: 20px; }
        .sidebar .nav-link { color: rgba(255, 255, 255, 0.8); padding: 10px 15px; }
        .sidebar .nav-link:hover { color: white; background-color: rgba(255, 255, 255, 0.1); }
        .sidebar .nav-link.active { color: white; background-color: #0d6efd; }
        .card { border-radius: 10px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); }

    </style>
</head>
<body>
<jsp:include page="/view/fragments/navbar.jsp" />

<div class="container-fluid mt-0">
    <div class="row">
        <!-- Sidebar -->
        <nav class="col-md-2 d-none d-md-block sidebar">
            <div class="position-sticky pt-3">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/user-list">
                            <i class="fas fa-users me-2"></i>Manage Users
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/view-role-list">
                            <i class="fas fa-user-tag me-2"></i>Manage Roles
                        </a>
                    </li>
                </ul>
            </div>
        </nav>


        <!-- Main content -->
        <main class="col-md-10 ms-sm-auto px-4">
            <h1 class="h2">Role Management</h1>

            <!-- SEARCH + FILTER FORM -->
            <div class="card p-3 mb-4">
                <form action="view-role-list" method="get" class="row g-3 align-items-center">
                    <!-- Keyword input -->
                    <div class="col-md-4">
                        <input type="text" name="keyword" value="${keyword}" class="form-control" placeholder="Search by name...">
                    </div>

                    <!-- Status select -->
                    <div class="col-md-3">
                        <select name="status" class="form-select">
                            <option value="all" ${status == 'all' ? 'selected' : ''}>--- All Status ---</option>
                            <option value="active" ${status == 'active' ? 'selected' : ''}>✅ Active</option>
                            <option value="inactive" ${status == 'inactive' ? 'selected' : ''}>❌ Inactive</option>
                        </select>
                    </div>

                    <!-- Buttons -->
                    <div class="col-md-5 d-flex align-items-center">
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary" title="Search">
                                <i class="fas fa-search"></i>
                            </button>
                            <a href="view-role-list" class="btn btn-secondary" title="Reset">
                                <i class="fas fa-rotate-right"></i>
                            </a>
                        </div>
                        <a href="#" class="btn btn-success ms-auto" title="Add Role">
                            <i class="fas fa-plus"></i>
                        </a>
                    </div>
                </form>
            </div>

            <!-- ROLE TABLE -->
            <div class="table-responsive card p-3">
                <table class="table table-bordered table-hover align-middle mb-0">
                    <thead class="table-primary text-center">
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty roles}">
                            <c:forEach var="r" items="${roles}" varStatus="st">
                                <tr>
                                    <td>${r.roleId}</td>
                                    <td>${r.roleName}</td>
                                    <td>${r.roleDescription}</td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${r.status == 'active'}">
                                                <i class="fas fa-check-circle text-success" title="Active"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fas fa-times-circle text-danger" title="Inactive"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <a href="#" class="btn btn-sm btn-info text-white" title="View">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="#" class="btn btn-sm btn-warning text-white" title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="#" class="btn btn-sm btn-danger text-white" title="Delete" onclick="return confirm('Are you sure?');">
                                            <i class="fas fa-trash-alt"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="5" class="text-center text-muted">
                                    No roles found for your search.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>

                </table>
            </div>

            <!-- PAGINATION -->
            <nav aria-label="Role pagination" class="mt-4">
                <ul class="pagination justify-content-end">
                    <li class="page-item ${pageIndex == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="view-role-list?page=${pageIndex - 1}&keyword=${keyword}&status=${status}"><</a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="p">
                        <li class="page-item ${p == pageIndex ? 'active' : ''}">
                            <a class="page-link" href="view-role-list?page=${p}&keyword=${keyword}&status=${status}">${p}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${pageIndex == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="view-role-list?page=${pageIndex + 1}&keyword=${keyword}&status=${status}">></a>
                    </li>
                </ul>
            </nav>
        </main>
    </div>
</div>

<!-- Bootstrap JS CDN -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
