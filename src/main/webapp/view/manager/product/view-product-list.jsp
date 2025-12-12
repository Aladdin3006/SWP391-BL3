<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Product List</title>
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Product List</h2>
        <!-- Nút Add Product -->
        <a href="${pageContext.request.contextPath}/add-product" class="btn btn-success">+ Add Product</a>
    </div>

    <!-- ===================== FILTER FORM ===================== -->
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
                    <option value="0" ${categoryId == null ? "selected" : ""}>--- Category ---</option>

                    <c:forEach items="${categories}" var="c">
                        <option value="${c.categoryId}"
                            ${c.categoryId == (categoryId != null ? categoryId : 0) ? "selected" : ""}>
                                ${c.categoryName}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-2">
                <select name="status" class="form-control">
                    <option value="all" ${status == null || status eq 'all' ? 'selected' : ''}>
                        --- Status ---
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

    <!-- ===================== PRODUCT TABLE ===================== -->
    <div class="card">
        <div class="card-body p-0">
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
                            <span class="badge ${p.status == 'active' ? 'bg-success' : 'bg-danger'}">
                                    ${p.status}
                            </span>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/view-product-detail?id=${p.id}" class="btn btn-sm btn-info text-white">View</a>
                            <a href="${pageContext.request.contextPath}/edit-product?id=${p.id}" class="btn btn-sm btn-warning">Edit</a>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty products}">
                    <tr><td colspan="9" class="text-center p-3">No products found</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <!-- ===================== PAGINATION ===================== -->
    <nav class="mt-3">
        <ul class="pagination justify-content-center">
            <li class="page-item ${pageIndex == 1 ? 'disabled' : ''}">
                <a class="page-link"
                   href="?pageIndex=${pageIndex - 1}&productCode=${productCode}&productName=${productName}&brand=${brand}&company=${company}&categoryId=${categoryId}&status=${status}">
                    Previous
                </a>
            </li>

            <c:forEach begin="1" end="${totalPages}" var="i">
                <li class="page-item ${pageIndex == i ? 'active' : ''}">
                    <a class="page-link"
                       href="?pageIndex=${i}&productCode=${productCode}&productName=${productName}&brand=${brand}&company=${company}&categoryId=${categoryId}&status=${status}">
                            ${i}
                    </a>
                </li>
            </c:forEach>

            <li class="page-item ${pageIndex == totalPages ? 'disabled' : ''}">
                <a class="page-link"
                   href="?pageIndex=${pageIndex + 1}&productCode=${productCode}&productName=${productName}&brand=${brand}&company=${company}&categoryId=${categoryId}&status=${status}">
                    Next
                </a>
            </li>
        </ul>
    </nav>

</div>

</body>
</html>
