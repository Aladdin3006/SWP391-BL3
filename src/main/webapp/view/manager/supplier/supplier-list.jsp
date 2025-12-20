<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Supplier List</title>
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
        .table thead th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 15px 12px;
            font-weight: 600;
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
        <c:set var="activePage" value="supplier-list" scope="request"/>
        <jsp:include page="/view/fragments/sidebar.jsp"/>
        <main class="col-md-10 ms-sm-auto px-md-4 main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold mb-1" style="color: #2c3e50;">Supplier Management</h2>
                    <p class="text-muted">Manage your organization's suppliers</p>
                </div>
                <a href="${pageContext.request.contextPath}/supplier-add" class="btn btn-primary"
                   style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                          border: none; padding: 10px 25px; border-radius: 10px; font-weight: 600;">
                    <i class="fas fa-plus me-2"></i>Add New Supplier
                </a>
            </div>

            <div class="card">
                <div class="card-header" style="background: white; border-bottom: 2px solid #f0f0f0;">
                    <h5 class="mb-0 fw-bold" style="color: #2c3e50;">Supplier List</h5>
                </div>
                <div class="card-body p-4">
                    <form method="get" class="row g-3 mb-4 align-items-end">
                        <div class="col-md-5">
                            <div class="search-box">
                                <i class="fas fa-search"></i>
                                <input type="text" name="search" class="form-control"
                                       placeholder="Search supplier name, code or contact..." value="${search}">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-bold mb-2" style="color: #2c3e50;">Status</label>
                            <select name="status" class="form-select">
                                <option value="all" ${status == 'all' || status == null ? 'selected' : ''}>All Status</option>
                                <option value="active" ${status == 'active' ? 'selected' : ''}>Active</option>
                                <option value="inactive" ${status == 'inactive' ? 'selected' : ''}>Inactive</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="fas fa-filter me-2"></i>Filter
                            </button>
                        </div>
                        <div class="col-md-2">
                            <a href="${pageContext.request.contextPath}/supplier-list" class="btn btn-outline-secondary w-100">
                                <i class="fas fa-redo me-2"></i>Reset
                            </a>
                        </div>
                    </form>

                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>
                            Supplier ${success} successfully!
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <div class="table-responsive">
                        <c:choose>
                            <c:when test="${not empty suppliers}">
                                <table class="table table-hover align-middle">
                                    <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Code</th>
                                        <th>Supplier Name</th>
                                        <th>Contact Person</th>
                                        <th>Phone</th>
                                        <th>Email</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach items="${suppliers}" var="s" varStatus="st">
                                        <tr>
                                            <td class="fw-bold">${(currentPage-1)*10 + st.index + 1}</td>
                                            <td>
                                                <span class="badge bg-primary">${s.supplierCode}</span>
                                            </td>
                                            <td>${s.name}</td>
                                            <td>${s.contactPerson}</td>
                                            <td>${s.phone}</td>
                                            <td>${s.email}</td>
                                            <td>
                                                <span class="badge-status ${s.status == 'active' ? 'badge-active' : 'badge-inactive'}">
                                                    <i class="fas ${s.status == 'active' ? 'fa-check-circle' : 'fa-times-circle'} me-1"></i>
                                                    ${s.status}
                                                </span>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/supplier-detail?id=${s.id}"
                                                   class="btn btn-info btn-sm">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/supplier-update?id=${s.id}"
                                                   class="btn btn-warning btn-sm">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <c:if test="${s.status == 'active'}">
                                                    <a href="${pageContext.request.contextPath}/supplier-list?action=deactivate&id=${s.id}"
                                                       class="btn btn-danger btn-sm"
                                                       onclick="return confirm('Deactivate ${s.name}?')">
                                                        <i class="fas fa-ban"></i>
                                                    </a>
                                                </c:if>
                                                <c:if test="${s.status == 'inactive'}">
                                                    <a href="${pageContext.request.contextPath}/supplier-list?action=activate&id=${s.id}"
                                                       class="btn btn-success btn-sm">
                                                        <i class="fas fa-check"></i>
                                                    </a>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>

                                <c:if test="${totalPages > 0}">
                                    <nav class="mt-4">
                                        <ul class="pagination justify-content-center">
                                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                <a class="page-link" href="${pageContext.request.contextPath}/supplier-list?page=${currentPage-1}&search=${search}&status=${status}">
                                                    <i class="fas fa-chevron-left"></i>
                                                </a>
                                            </li>
                                            <c:forEach begin="1" end="${totalPages}" var="p">
                                                <li class="page-item ${p == currentPage ? 'active' : ''}">
                                                    <a class="page-link" href="${pageContext.request.contextPath}/supplier-list?page=${p}&search=${search}&status=${status}">${p}</a>
                                                </li>
                                            </c:forEach>
                                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                <a class="page-link" href="${pageContext.request.contextPath}/supplier-list?page=${currentPage+1}&search=${search}&status=${status}">
                                                    <i class="fas fa-chevron-right"></i>
                                                </a>
                                            </li>
                                        </ul>
                                    </nav>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fas fa-truck"></i>
                                    <h4 class="mt-3 mb-2">No Suppliers Found</h4>
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
</body>
</html>