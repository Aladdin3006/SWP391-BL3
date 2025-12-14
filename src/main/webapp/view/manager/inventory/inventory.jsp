<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Inventory Report</title>
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
        .inventory-positive {
            color: #198754;
            font-weight: bold;
        }
        .inventory-negative {
            color: #dc3545;
            font-weight: bold;
        }
        .period-selector {
            background: white;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .summary-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
        }
        .btn-inventory {
            padding: 6px 12px;
            border-radius: 6px;
            font-weight: 500;
            margin: 2px;
        }
    </style>
</head>
<body>
<jsp:include page="/view/fragments/navbar.jsp"/>

<div class="container-fluid">
    <div class="row">
        <c:set var="activePage" value="inventory" scope="request"/>
        <jsp:include page="/view/fragments/sidebar.jsp"/>

        <main class="col-md-10 ms-sm-auto px-md-4 main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold mb-1" style="color: #2c3e50;">Inventory Report</h2>
                    <p class="text-muted">Track product inventory movements</p>
                </div>
                <div class="text-end">
                    <div class="summary-card">
                        <h6 class="mb-1">Total Products</h6>
                        <h4 class="mb-0">${totalRecords}</h4>
                    </div>
                </div>
            </div>

            <div class="period-selector">
                <form action="${pageContext.request.contextPath}/view-inventory" method="get" class="row g-3">
                    <div class="col-md-2">
                        <input type="text" name="productCode" class="form-control"
                               placeholder="Product Code" value="${productCode}">
                    </div>
                    <div class="col-md-2">
                        <input type="text" name="productName" class="form-control"
                               placeholder="Product Name" value="${productName}">
                    </div>
                    <div class="col-md-2">
                        <input type="date" name="startDate" class="form-control"
                               value="${startDate}">
                    </div>
                    <div class="col-md-2">
                        <input type="date" name="endDate" class="form-control"
                               value="${endDate}">
                    </div>
                    <div class="col-md-4 text-end">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search me-1"></i>Search
                        </button>
                        <a href="${pageContext.request.contextPath}/view-inventory" class="btn btn-secondary">
                            <i class="fas fa-redo me-1"></i>Reset
                        </a>
                    </div>
                </form>
            </div>

            <div class="card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-striped mb-0">
                            <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Code</th>
                                <th>Name</th>
                                <th>Category</th>
                                <th>Beginning</th>
                                <th>Import</th>
                                <th>Export</th>
                                <th>Ending</th>
                                <th style="width:180px;">Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${inventoryData}" var="item">
                                <tr>
                                    <td>${item.id}</td>
                                    <td>${item.productCode}</td>
                                    <td>${item.name}</td>
                                    <td>${item.categoryName}</td>
                                    <td class="inventory-positive">${item.beginning_inventory}</td>
                                    <td class="inventory-positive">+${item.import_period}</td>
                                    <td class="inventory-negative">-${item.export_period}</td>
                                    <td class="inventory-positive">
                                        <strong>${item.ending_inventory}</strong>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/view-product-detail?id=${item.id}"
                                           class="btn btn-inventory btn-info text-white btn-sm"
                                           title="View Product Detail">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/product-change-detail?id=${item.id}"
                                           class="btn btn-inventory btn-warning btn-sm"
                                           title="View Change History">
                                            <i class="fas fa-history"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty inventoryData}">
                                <tr>
                                    <td colspan="9" class="text-center p-5">
                                        <i class="fas fa-boxes fa-3x text-muted mb-3"></i>
                                        <h5 class="text-muted">No inventory data found</h5>
                                    </td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <nav class="mt-3">
                <ul class="pagination justify-content-center">
                    <li class="page-item ${pageIndex == 1 ? 'disabled' : ''}">
                        <a class="page-link"
                           href="?pageIndex=${pageIndex - 1}&productCode=${productCode}&productName=${productName}&startDate=${startDate}&endDate=${endDate}">
                            Previous
                        </a>
                    </li>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${pageIndex == i ? 'active' : ''}">
                            <a class="page-link"
                               href="?pageIndex=${i}&productCode=${productCode}&productName=${productName}&startDate=${startDate}&endDate=${endDate}">
                                    ${i}
                            </a>
                        </li>
                    </c:forEach>

                    <li class="page-item ${pageIndex == totalPages ? 'disabled' : ''}">
                        <a class="page-link"
                           href="?pageIndex=${pageIndex + 1}&productCode=${productCode}&productName=${productName}&startDate=${startDate}&endDate=${endDate}">
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