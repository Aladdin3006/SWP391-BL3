<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Product Change History</title>
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
        .badge-status {
            padding: 6px 12px;
            border-radius: 20px;
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
    </style>
</head>
<body>
<jsp:include page="/view/fragments/navbar.jsp"/>

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <c:set var="activePage" value="inventory" scope="request"/>
        <jsp:include page="/view/fragments/sidebar.jsp"/>

        <!-- Main Content -->
        <main class="col-md-10 ms-sm-auto px-md-4 main-content">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <div class="d-flex justify-content-between align-items-center">
                        <h4 class="mb-0">
                            <i class="fas fa-history me-2"></i>Product Change History
                            <c:if test="${not empty productId}">
                                - Product ID: ${productId}
                            </c:if>
                        </h4>
                        <a href="${pageContext.request.contextPath}/view-inventory" class="btn btn-light">
                            <i class="fas fa-arrow-left me-1"></i>Back to Inventory
                        </a>
                    </div>
                </div>
                <div class="card-body">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>

                    <c:if test="${empty error}">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Type</th>
                                    <th>Before</th>
                                    <th>Change</th>
                                    <th>After</th>
                                    <th>Ticket</th>
                                    <th>Note</th>
                                    <th>Created</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${productChanges}" var="change">
                                    <tr>
                                        <td>${change.changeDate}</td>
                                        <td>
                                                <span class="badge ${change.changeType == 'MANUAL' ? 'bg-info' : 'bg-warning'}">
                                                        ${change.changeType}
                                                </span>
                                        </td>
                                        <td>
                                            <span class="fw-bold">${change.beforeChange}</span>
                                        </td>
                                        <td class="${change.changeAmount > 0 ? 'text-success fw-bold' : 'text-danger fw-bold'}">
                                                ${change.changeAmount > 0 ? '+' : ''}${change.changeAmount}
                                        </td>
                                        <td>
                                            <span class="fw-bold">${change.afterChange}</span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty change.ticketId}">
                                                    <span class="badge bg-secondary">${change.ticketId}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${change.note}</td>
                                        <td>
                                            <small class="text-muted">
                                                    ${change.createdAt}
                                            </small>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty productChanges}">
                                    <tr>
                                        <td colspan="8" class="text-center py-4">
                                            <i class="fas fa-info-circle fa-3x text-muted mb-3"></i>
                                            <h5 class="text-muted">No change history found for this product</h5>
                                            <p class="text-muted">This product has no inventory changes recorded.</p>
                                        </td>
                                    </tr>
                                </c:if>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>