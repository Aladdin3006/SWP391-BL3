<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Department List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
        .main-content {
            padding-top: 20px;
            padding-bottom: 40px;
            margin-left: 0;
        }
        .card {
            border-radius: 15px;
            border: none;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            transition: transform 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .table {
            border-collapse: separate;
            border-spacing: 0;
        }
        .table thead th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 15px 12px;
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        .table tbody tr {
            transition: all 0.2s ease;
        }
        .table tbody tr:hover {
            background-color: rgba(102, 126, 234, 0.08);
            transform: scale(1.002);
        }
        .badge-status {
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: 500;
            font-size: 0.85rem;
        }
        .badge-active {
            background: linear-gradient(135deg, #d1ffd1 0%, #a8ff78 100%);
            color: #0a5c0a;
        }
        .badge-inactive {
            background: linear-gradient(135deg, #ffd1d1 0%, #ff7878 100%);
            color: #8b0000;
        }
        .btn-action {
            padding: 6px 15px;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
            margin: 2px;
        }
        .pagination .page-item.active .page-link {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-color: #667eea;
        }
        .pagination .page-link {
            color: #667eea;
            border-radius: 8px;
            margin: 0 3px;
            border: 1px solid #dee2e6;
        }
        .search-box {
            position: relative;
        }
        .search-box i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
        }
        .search-box input {
            padding-left: 45px;
            border-radius: 10px;
            border: 2px solid #e0e0e0;
        }
        .action-buttons {
            white-space: nowrap;
        }
        .empty-state {
            padding: 60px 20px;
            text-align: center;
            color: #6c757d;
        }
        .empty-state i {
            font-size: 4rem;
            color: #dee2e6;
            margin-bottom: 20px;
        }
        .sidebar { background-color: #343a40; color: white; min-height: calc(100vh - 56px); padding-top: 20px; }
        .sidebar .nav-link { color: rgba(255, 255, 255, 0.8); padding: 10px 15px; }
        .sidebar .nav-link:hover { color: white; background-color: rgba(255, 255, 255, 0.1); }
        .sidebar .nav-link.active { color: white; background-color: #0d6efd; }
    </style>
</head>
<body>
<jsp:include page="/view/fragments/navbar.jsp"/>

<div class="container-fluid">
    <div class="row">
        <c:set var="activePage" value="department-list" scope="request"/>
        <jsp:include page="/view/fragments/sidebar.jsp"/>
        <main class="col-md-10 ms-sm-auto px-md-4 main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold mb-1" style="color: #2c3e50;">Department Management</h2>
                    <p class="text-muted">Manage your organization's department efficiently</p>
                </div>
                <a href="${pageContext.request.contextPath}/department-add" class="btn btn-primary"
                   style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                          border: none; padding: 10px 25px; border-radius: 10px; font-weight: 600;">
                    <i class="fas fa-plus me-2"></i>Add New Department
                </a>
            </div>

            <div class="card">
                <div class="card-header" style="background: white; border-bottom: 2px solid #f0f0f0;">
                    <h5 class="mb-0 fw-bold" style="color: #2c3e50;">Department List</h5>
                </div>
                <div class="card-body p-4">
                    <form method="get" class="row g-3 mb-4 align-items-end">
                        <div class="col-md-5">
                            <div class="search-box">
                                <i class="fas fa-search"></i>
                                <input type="text" name="search" class="form-control"
                                       placeholder="Search department name..." value="${search}">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-bold mb-2" style="color: #2c3e50;">Status</label>
                            <select name="status" class="form-select" style="border-radius: 10px; border: 2px solid #e0e0e0;">
                                <option value="all" ${status == 'all' || status == null ? 'selected' : ''}>All Status</option>
                                <option value="active" ${status == 'active' ? 'selected' : ''}>Active</option>
                                <option value="inactive" ${status == 'inactive' ? 'selected' : ''}>Inactive</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-primary w-100"
                                    style="border: none; padding: 10px; border-radius: 10px; font-weight: 600;">
                                <i class="fas fa-filter me-2"></i>Filter
                            </button>
                        </div>
                        <div class="col-md-2">
                            <a href="${pageContext.request.contextPath}/department-list" class="btn btn-outline-secondary w-100"
                               style="padding: 10px; border-radius: 10px; font-weight: 500;">
                                <i class="fas fa-redo me-2"></i>Reset
                            </a>
                        </div>
                    </form>

                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>
                            Department ${success} successfully!
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <div class="table-responsive">
                        <c:choose>
                            <c:when test="${not empty department}">
                                <table class="table table-hover align-middle">
                                    <thead>
                                    <tr>
                                        <th style="border-top-left-radius: 10px;">#</th>
                                        <th>Department Name</th>
                                        <th>Storekeeper</th>
                                        <th>Employees</th>
                                        <th>Status</th>
                                        <th style="border-top-right-radius: 10px;">Actions</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach items="${department}" var="d" varStatus="st">
                                        <tr>
                                            <td class="fw-bold" style="color: #6c757d;">
                                                    ${(currentPage-1)*10 + st.index + 1}
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <div class="bg-primary rounded-circle d-flex align-items-center justify-content-center me-3"
                                                         style="width: 40px; height: 40px; color: white;">
                                                        <i class="fas fa-building"></i>
                                                    </div>
                                                    <div>
                                                        <h6 class="mb-0 fw-bold" style="color: #2c3e50;">${d.departmentName}</h6>
                                                        <small class="text-muted">ID: ${d.id}</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <div class="bg-success rounded-circle d-flex align-items-center justify-content-center me-2"
                                                         style="width: 32px; height: 32px; color: white; font-size: 0.8rem;">
                                                        <i class="fas fa-user-tie"></i>
                                                    </div>
                                                    <span class="fw-medium">${d.storekeeperName}</span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <div class="bg-info rounded-circle d-flex align-items-center justify-content-center me-2"
                                                         style="width: 32px; height: 32px; color: white; font-size: 0.8rem;">
                                                        <i class="fas fa-users"></i>
                                                    </div>
                                                    <span class="fw-bold fs-5">${d.employeeCount}</span>
                                                    <small class="text-muted ms-1">employees</small>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="badge badge-status ${d.status == 'active' ? 'badge-active' : 'badge-inactive'}">
                                                    <i class="fas ${d.status == 'active' ? 'fa-check-circle' : 'fa-times-circle'} me-1"></i>
                                                    ${d.status == 'active' ? 'Active' : 'Inactive'}
                                                </span>
                                            </td>
                                            <td class="action-buttons">
                                                <a href="${pageContext.request.contextPath}/department-detail?id=${d.id}"
                                                   class="btn btn-action btn-info"
                                                   style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); color: white;">
                                                    <i class="fas fa-eye me-1"></i>View
                                                </a>
                                                <a href="${pageContext.request.contextPath}/department-update?id=${d.id}"
                                                   class="btn btn-action btn-warning"
                                                   style="background: linear-gradient(135deg, #f6d365 0%, #fda085 100%); color: white;">
                                                    <i class="fas fa-edit me-1"></i>Edit
                                                </a>
                                                <c:if test="${d.status == 'active'}">
                                                    <a href="${pageContext.request.contextPath}/department-list?action=deactivate&id=${d.id}&search=${search}&status=${status}&page=${currentPage}"
                                                       class="btn btn-action btn-danger"
                                                       style="background: linear-gradient(135deg, #ff6b6b 0%, #ff8e8e 100%); color: white;"
                                                       onclick="return confirm('Are you sure you want to deactivate ${d.departmentName}?')">
                                                        <i class="fas fa-ban me-1"></i>Deactivate
                                                    </a>
                                                </c:if>
                                                <c:if test="${d.status == 'inactive'}">
                                                    <a href="${pageContext.request.contextPath}/department-list?action=activate&id=${d.id}&search=${search}&status=${status}&page=${currentPage}"
                                                       class="btn btn-action btn-success"
                                                       style="background: linear-gradient(135deg, #4cd964 0%, #5ac8fa 100%); color: white;">
                                                        <i class="fas fa-check me-1"></i>Activate
                                                    </a>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>

                                <c:if test="${totalPages > 1}">
                                    <nav class="mt-4">
                                        <ul class="pagination justify-content-center">
                                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                <a class="page-link" href="${pageContext.request.contextPath}/department-list?page=${currentPage-1}&search=${search}&status=${status}">
                                                    <i class="fas fa-chevron-left"></i>
                                                </a>
                                            </li>
                                            <c:forEach begin="1" end="${totalPages}" var="p">
                                                <li class="page-item ${p == currentPage ? 'active' : ''}">
                                                    <a class="page-link" href="${pageContext.request.contextPath}/department-list?page=${p}&search=${search}&status=${status}">${p}</a>
                                                </li>
                                            </c:forEach>
                                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                <a class="page-link" href="${pageContext.request.contextPath}/department-list?page=${currentPage+1}&search=${search}&status=${status}">
                                                    <i class="fas fa-chevron-right"></i>
                                                </a>
                                            </li>
                                        </ul>
                                    </nav>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fas fa-building"></i>
                                    <h4 class="mt-3 mb-2">No Departments Found</h4>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    setTimeout(() => {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(alert => {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        });
    }, 5000);
</script>
</body>
</html>