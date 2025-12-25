<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Product List</title>
    <!-- Bootstrap -->
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
        .sidebar {
            background-color: #343a40;
            color: white;
            min-height: calc(100vh - 56px);
            padding-top: 20px;
        }
        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.8);
            padding: 10px 15px;
        }
        .sidebar .nav-link:hover {
            color: white;
            background-color: rgba(255, 255, 255, 0.1);
        }
        .sidebar .nav-link.active {
            color: white;
            background-color: #0d6efd;
        }
        .table thead th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
        }
        .badge {
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
    </style>
</head>
<body>
<jsp:include page="/view/fragments/navbar.jsp"/>

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <c:set var="activePage" value="product-list" scope="request"/>
        <jsp:include page="/view/fragments/sidebar.jsp"/>

        <!-- Main Content -->
        <main class="col-md-10 ms-sm-auto px-md-4 main-content">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div>
                    <h2 class="fw-bold mb-1" style="color: #2c3e50;">Product Management</h2>
                    <p class="text-muted">Manage your products efficiently</p>
                </div>
                <div class="dropdown">
                    <button class="btn btn-success dropdown-toggle"
                            type="button"
                            data-bs-toggle="dropdown"
                            aria-expanded="false"
                            style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border: none;">
                        <i class="fas fa-plus me-2"></i>Add Product
                    </button>

                    <ul class="dropdown-menu">
                        <li>
                            <a class="dropdown-item"
                               href="${pageContext.request.contextPath}/add-product">
                                Add Single Product
                            </a>
                        </li>
                        <li>
                            <a class="dropdown-item"
                               href="${pageContext.request.contextPath}/add-multi-product">
                                Add Multiple Products
                            </a>
                        </li>
                    </ul>
                </div>

            </div>

            <!-- Filter Form -->
            <form action="${pageContext.request.contextPath}/view-product-list" method="get" class="card p-3 mb-3">
                <div class="row g-2">
                    <div class="col-md-2">
                        <input type="text" name="productCode" class="form-control"
                               placeholder="Product Code" value="${productCode}">
                    </div>
                    <div class="col-md-2">
                        <input type="text" name="productName" class="form-control"
                               placeholder="Product Name" value="${productName}">
                    </div>
                    <div class="col-md-2">
                        <input type="text" name="brand" class="form-control"
                               placeholder="Brand" value="${brand}">
                    </div>
                    <div class="col-md-2">
                        <input type="text" name="company" class="form-control"
                               placeholder="Company" value="${company}">
                    </div>
                    <div class="col-md-2">
                        <select name="categoryId" class="form-select">
                            <option value="0" ${categoryId == null || categoryId == 0 ? "selected" : ""}>--- All Categories ---</option>
                            <c:forEach items="${categories}" var="c">
                                <option value="${c.categoryId}"
                                    ${c.categoryId == categoryId ? "selected" : ""}>
                                        ${c.categoryName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <select name="status" class="form-control">
                            <option value="all" ${status == null || status eq 'all' ? 'selected' : ''}>
                                --- All Status ---
                            </option>
                            <option value="active" ${status eq 'active' ? 'selected' : ''}>
                                Active
                            </option>
                            <option value="inactive" ${status eq 'inactive' ? 'selected' : ''}>
                                Inactive
                            </option>
                        </select>
                    </div>
                </div>

                <div class="row g-2 mt-3">
                    <div class="col-md-2">
                        <select name="sortField" class="form-select">
                            <option value="id" ${sortField == 'id' ? 'selected' : ''}>ID</option>
                            <option value="name" ${sortField == 'name' ? 'selected' : ''}>Name</option>
                            <option value="brand" ${sortField == 'brand' ? 'selected' : ''}>Brand</option>
                            <option value="company" ${sortField == 'company' ? 'selected' : ''}>Company</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <select name="sortOrder" class="form-select">
                            <option value="asc" ${sortOrder == 'asc' ? 'selected' : ''}>Ascending</option>
                            <option value="desc" ${sortOrder == 'desc' ? 'selected' : ''}>Descending</option>
                        </select>
                    </div>
                    <div class="col-md-8 text-end">
                        <button type="submit" class="btn btn-primary">Search</button>
                        <a href="${pageContext.request.contextPath}/view-product-list" class="btn btn-secondary">Reset</a>
                    </div>
                </div>
            </form>

            <!-- Product Table -->
            <div class="card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-striped mb-0">
                            <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Code</th>
                                <th>Name</th>
                                <th>Brand</th>
                                <th>Company</th>
                                <th>Category</th>
                                <th>Unit</th>
                                <th>Status</th>
                                <th style="width:120px;">Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${products}" var="p">
                                <tr>
                                    <td>${p.id}</td>
                                    <td>${p.productCode}</td>
                                    <td>${p.name}</td>
                                    <td>${p.brand}</td>
                                    <td>${p.company}</td>
                                    <td>${p.categoryName}</td>
                                    <td>${p.unit}</td>
                                    <td>
                                        <span class="badge ${p.status == 'active' ? 'badge-active' : 'badge-inactive'}">
                                                ${p.status}
                                        </span>
                                    </td>
                                    <td class="action-buttons">
                                        <a href="${pageContext.request.contextPath}/view-product-detail?id=${p.id}"
                                           class="btn btn-action btn-info text-white">
                                            <i class="fas fa-eye me-1"></i>View
                                        </a>
                                        <a href="${pageContext.request.contextPath}/edit-product?id=${p.id}"
                                           class="btn btn-action btn-warning">
                                            <i class="fas fa-edit me-1"></i>Edit
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty products}">
                                <tr>
                                    <td colspan="9" class="text-center p-5">
                                        <i class="fas fa-box-open fa-3x text-muted mb-3"></i>
                                        <h5 class="text-muted">No products found</h5>
                                    </td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Pagination -->
            <nav class="mt-3">
                <ul class="pagination justify-content-center">
                    <li class="page-item ${pageIndex == 1 ? 'disabled' : ''}">
                        <a class="page-link"
                           href="?pageIndex=${pageIndex - 1}&productCode=${productCode}&productName=${productName}&brand=${brand}&company=${company}&categoryId=${categoryId}&status=${status}&sortField=${sortField}&sortOrder=${sortOrder}">
                            Previous
                        </a>
                    </li>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${pageIndex == i ? 'active' : ''}">
                            <a class="page-link"
                               href="?pageIndex=${i}&productCode=${productCode}&productName=${productName}&brand=${brand}&company=${company}&categoryId=${categoryId}&status=${status}&sortField=${sortField}&sortOrder=${sortOrder}">
                                    ${i}
                            </a>
                        </li>
                    </c:forEach>

                    <li class="page-item ${pageIndex == totalPages ? 'disabled' : ''}">
                        <a class="page-link"
                           href="?pageIndex=${pageIndex + 1}&productCode=${productCode}&productName=${productName}&brand=${brand}&company=${company}&categoryId=${categoryId}&status=${status}&sortField=${sortField}&sortOrder=${sortOrder}">
                            Next
                        </a>
                    </li>
                </ul>
            </nav>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>