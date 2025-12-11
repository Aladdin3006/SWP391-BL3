<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ticket Detail - ${ticket.ticketCode}</title>
    <!-- Bootstrap for navbar + layout -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/layout.css">
    <style>
        .detail-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .detail-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .detail-header h1 {
            color: #2c3e50;
            font-size: 28px;
            margin: 0;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            transition: all 0.3s;
            display: inline-block;
        }

        .btn-secondary {
            background: #95a5a6;
            color: white;
        }

        .btn-secondary:hover {
            background: #7f8c8d;
        }

        .btn-warning {
            background: #f39c12;
            color: white;
        }

        .btn-warning:hover {
            background: #e67e22;
        }

        .info-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 25px;
            margin-bottom: 25px;
        }

        .info-card h2 {
            color: #34495e;
            font-size: 20px;
            margin-bottom: 20px;
            border-bottom: 2px solid #3498db;
            padding-bottom: 10px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        .info-item {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .info-label {
            font-weight: 600;
            color: #555;
            font-size: 14px;
        }

        .info-value {
            color: #2c3e50;
            font-size: 16px;
        }

        .badge {
            padding: 5px 12px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 600;
            display: inline-block;
        }

        .badge-import {
            background: #d1ecf1;
            color: #0c5460;
        }

        .badge-export {
            background: #fff3cd;
            color: #856404;
        }

        .badge-pending {
            background: #ffeaa7;
            color: #6c5ce7;
        }

        .badge-approved {
            background: #55efc4;
            color: #00b894;
        }

        .badge-completed {
            background: #a29bfe;
            color: #6c5ce7;
        }

        .badge-rejected {
            background: #fab1a0;
            color: #d63031;
        }

        .products-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        .products-table thead {
            background: #34495e;
            color: white;
        }

        .products-table th,
        .products-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .products-table tbody tr:hover {
            background: #f8f9fa;
        }

        .note-section {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            border-left: 4px solid #3498db;
        }

        .note-label {
            font-weight: 600;
            color: #555;
            margin-bottom: 8px;
        }

        .note-content {
            color: #2c3e50;
            line-height: 1.6;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
        }

        .total-row {
            font-weight: bold;
            background: #ecf0f1;
        }
    </style>
</head>
<body>
    <jsp:include page="../fragments/navbar.jsp"/>

    <div class="detail-container">
        <div class="detail-header">
            <h1>Transfer Ticket Detail</h1>
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/transfer-tickets" class="btn btn-secondary">
                    ← Back to List
                </a>
                <c:if test="${ticket.status == 'Pending'}">
                    <a href="${pageContext.request.contextPath}/transfer-tickets?action=edit&id=${ticket.id}" 
                       class="btn btn-warning">
                        Edit Ticket
                    </a>
                </c:if>
            </div>
        </div>

        <!-- Ticket Information -->
        <div class="info-card">
            <h2>Ticket Information</h2>
            <div class="info-grid">
                <div class="info-item">
                    <span class="info-label">Ticket Code</span>
                    <span class="info-value"><strong>${ticket.ticketCode}</strong></span>
                </div>

                <div class="info-item">
                    <span class="info-label">Type</span>
                    <span class="info-value">
                        <span class="badge ${ticket.type == 'Import' ? 'badge-import' : 'badge-export'}">
                            ${ticket.type}
                        </span>
                    </span>
                </div>

                <div class="info-item">
                    <span class="info-label">Request Date</span>
                    <span class="info-value">${ticket.requestDate}</span>
                </div>

                <div class="info-item">
                    <span class="info-label">Status</span>
                    <span class="info-value">
                        <span class="badge badge-${ticket.status.toLowerCase()}">
                            ${ticket.status}
                        </span>
                    </span>
                </div>

                <div class="info-item">
                    <span class="info-label">Created By</span>
                    <span class="info-value">${ticket.createdByName}</span>
                </div>

                <div class="info-item">
                    <span class="info-label">Assigned Employee</span>
                    <span class="info-value">${ticket.employeeName}</span>
                </div>

                <div class="info-item">
                    <span class="info-label">Created At</span>
                    <span class="info-value">${ticket.createdAt}</span>
                </div>
            </div>

            <c:if test="${not empty ticket.note}">
                <div class="note-section" style="margin-top: 20px;">
                    <div class="note-label">Note:</div>
                    <div class="note-content">${ticket.note}</div>
                </div>
            </c:if>
        </div>

        <!-- Product Items -->
        <div class="info-card">
            <h2>Product Items</h2>
            <c:choose>
                <c:when test="${empty ticket.items}">
                    <p style="color: #95a5a6; text-align: center; padding: 20px;">
                        No products in this ticket.
                    </p>
                </c:when>
                <c:otherwise>
                    <table class="products-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Product Code</th>
                                <th>Product Name</th>
                                <th>Brand</th>
                                <th>Company</th>
                                <th>Category</th>
                                <th>Quantity</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="totalQty" value="0"/>
                            <c:forEach items="${ticket.items}" var="item" varStatus="status">
                                <tr>
                                    <td>${status.index + 1}</td>
                                    <td><strong>${item.product.productCode}</strong></td>
                                    <td>${item.product.name}</td>
                                    <td>${item.product.brand}</td>
                                    <td>${item.product.company}</td>
                                    <td>${item.product.categoryName}</td>
                                    <td><strong>${item.quantity}</strong></td>
                                </tr>
                                <c:set var="totalQty" value="${totalQty + item.quantity}"/>
                            </c:forEach>
                            <tr class="total-row">
                                <td colspan="6" style="text-align: right;">Total Items:</td>
                                <td><strong>${totalQty}</strong></td>
                            </tr>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
<!-- Bootstrap JS (dropdown, responsive navbar) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</html>

