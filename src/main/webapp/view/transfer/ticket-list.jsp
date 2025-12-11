<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Request Transfer Ticket List</title>
    <!-- Bootstrap for navbar + layout -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/layout.css">
    <style>
        .ticket-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }

        .ticket-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .ticket-header h1 {
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
        }

        .btn-primary {
            background: #3498db;
            color: white;
        }

        .btn-primary:hover {
            background: #2980b9;
        }

        .btn-info {
            background: #17a2b8;
            color: white;
        }

        .btn-warning {
            background: #f39c12;
            color: white;
        }

        .btn-sm {
            padding: 5px 10px;
            font-size: 12px;
        }

        .filter-section {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .filter-form {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            align-items: flex-end;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .form-group label {
            font-size: 14px;
            color: #555;
            font-weight: 500;
        }

        .form-group input,
        .form-group select {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }

        .alert {
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .table-container {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background: #34495e;
            color: white;
        }

        thead th {
            padding: 15px;
            text-align: left;
            font-weight: 600;
        }

        tbody td {
            padding: 12px 15px;
            border-bottom: 1px solid #eee;
        }

        tbody tr:hover {
            background: #f8f9fa;
        }

        .badge {
            padding: 5px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
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

        .pagination {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 20px;
            padding: 20px;
        }

        .pagination a {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            text-decoration: none;
            color: #3498db;
        }

        .pagination a.active {
            background: #3498db;
            color: white;
        }

        .pagination a:hover:not(.active) {
            background: #ecf0f1;
        }

        .no-data {
            text-align: center;
            padding: 40px;
            color: #95a5a6;
        }

        .action-buttons {
            display: flex;
            gap: 5px;
        }
    </style>
</head>
<body>
    <jsp:include page="../fragments/navbar.jsp"/>

    <div class="ticket-container">
        <div class="ticket-header">
            <h1>Request Transfer Warehouse Tickets</h1>
            <a href="${pageContext.request.contextPath}/transfer-tickets?action=add" class="btn btn-primary">
                + Add New Ticket
            </a>
        </div>

        <c:if test="${param.success == 'created'}">
            <div class="alert alert-success">
                Ticket created successfully!
            </div>
        </c:if>

        <c:if test="${param.success == 'updated'}">
            <div class="alert alert-success">
                Ticket updated successfully!
            </div>
        </c:if>

        <div class="filter-section">
            <form action="${pageContext.request.contextPath}/transfer-tickets" method="get" class="filter-form">
                <div class="form-group">
                    <label>Search</label>
                    <input type="text" name="search" placeholder="Ticket code or note..." 
                           value="${search}" style="width: 250px;">
                </div>

                <div class="form-group">
                    <label>Type</label>
                    <select name="type">
                        <option value="all" ${type == 'all' ? 'selected' : ''}>All Types</option>
                        <option value="Import" ${type == 'Import' ? 'selected' : ''}>Import</option>
                        <option value="Export" ${type == 'Export' ? 'selected' : ''}>Export</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Status</label>
                    <select name="status">
                        <option value="all" ${status == 'all' ? 'selected' : ''}>All Status</option>
                        <option value="Pending" ${status == 'Pending' ? 'selected' : ''}>Pending</option>
                        <option value="Approved" ${status == 'Approved' ? 'selected' : ''}>Approved</option>
                        <option value="Completed" ${status == 'Completed' ? 'selected' : ''}>Completed</option>
                        <option value="Rejected" ${status == 'Rejected' ? 'selected' : ''}>Rejected</option>
                    </select>
                </div>

                <div class="form-group">
                    <button type="submit" class="btn btn-primary">Filter</button>
                </div>

                <div class="form-group">
                    <a href="${pageContext.request.contextPath}/transfer-tickets" class="btn btn-warning">Reset</a>
                </div>
            </form>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Ticket Code</th>
                        <th>Type</th>
                        <th>Request Date</th>
                        <th>Status</th>
                        <th>Created By</th>
                        <th>Employee</th>
                        <th>Note</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty tickets}">
                            <tr>
                                <td colspan="8" class="no-data">
                                    No tickets found. Click "Add New Ticket" to create one.
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${tickets}" var="ticket">
                                <tr>
                                    <td><strong>${ticket.ticketCode}</strong></td>
                                    <td>
                                        <span class="badge ${ticket.type == 'Import' ? 'badge-import' : 'badge-export'}">
                                            ${ticket.type}
                                        </span>
                                    </td>
                                    <td>${ticket.requestDate}</td>
                                    <td>
                                        <span class="badge badge-${ticket.status.toLowerCase()}">
                                            ${ticket.status}
                                        </span>
                                    </td>
                                    <td>${ticket.createdByName}</td>
                                    <td>${ticket.employeeName}</td>
                                    <td>${ticket.note}</td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="${pageContext.request.contextPath}/transfer-tickets?action=detail&id=${ticket.id}" 
                                               class="btn btn-info btn-sm">
                                                View
                                            </a>
                                            <c:if test="${ticket.status == 'Pending'}">
                                                <a href="${pageContext.request.contextPath}/transfer-tickets?action=edit&id=${ticket.id}" 
                                                   class="btn btn-warning btn-sm">
                                                    Edit
                                                </a>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <c:if test="${totalPages > 1}">
            <div class="pagination">
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <a href="${pageContext.request.contextPath}/transfer-tickets?page=${i}&search=${search}&type=${type}&status=${status}" 
                       class="${i == currentPage ? 'active' : ''}">
                        ${i}
                    </a>
                </c:forEach>
            </div>
        </c:if>
    </div>
</body>
<!-- Bootstrap JS (dropdown, responsive navbar) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</html>

