<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Edit Actual Transfer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .sidebar {
            background-color: #343a40;
            color: white;
            min-height: calc(100vh - 56px);
            padding-top: 20px;
        }
        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.8);
        }
        .sidebar .nav-link.active {
            color: white;
            background-color: #0d6efd;
        }
        .btn-success {
            background-color: #28a745;
            border-color: #28a745;
        }
        .btn-success:hover {
            background-color: #218838;
            border-color: #1e7e34;
        }
        .status-update-warning {
            background-color: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
            display: none;
        }
        .type-badge {
            font-size: 0.8rem;
            padding: 4px 10px;
        }
        .type-import {
            background-color: #d1e7dd;
            color: #0f5132;
        }
        .type-export {
            background-color: #f8d7da;
            color: #842029;
        }
    </style>
</head>
<body>
<jsp:include page="/view/fragments/navbar.jsp"/>
<div class="container-fluid">
    <div class="row">
        <c:set var="activePage" value="actual-transfer" scope="request"/>
        <jsp:include page="/view/fragments/sidebar.jsp"/>

        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">

            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="fw-bold text-primary mb-0">Edit Ticket: <span class="text-dark">${ticket.ticketCode}</span></h3>
                <a href="../actual-transfer" class="btn btn-outline-secondary">
                    Cancel
                </a>
            </div>

            <div class="status-update-warning" id="statusWarning">
                <div class="d-flex align-items-center">
                    <i class="fas fa-exclamation-circle text-warning me-3 fs-4"></i>
                    <div>
                        <h5 class="mb-1">Status Change Detected</h5>
                        <p class="mb-0">You are changing the status to <strong>Completed</strong>. This will update the warehouse inventory.</p>
                    </div>
                </div>
            </div>

            <div class="card shadow-sm border-0">
                <div class="card-body p-4">
                    <form action="edit" method="POST" id="editForm">
                        <input type="hidden" name="id" value="${ticket.id}">
                        <input type="hidden" id="originalStatus" value="${ticket.status}">

                        <div class="row g-3 mb-4">
                            <div class="col-md-4">
                                <label class="form-label fw-bold small text-muted">TRANSFER DATE</label>
                                <input type="date" name="transferDate" value="${ticket.transferDate}" class="form-control" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-bold small text-muted">STATUS</label>
                                <select name="status" id="statusSelect" class="form-select" onchange="checkStatusChange()">
                                    <option value="Pending" ${ticket.status == 'Pending' ? 'selected' : ''}>Pending</option>
                                    <option value="In Progress" ${ticket.status == 'In Progress' ? 'selected' : ''}>In Progress</option>
                                    <option value="Completed" ${ticket.status == 'Completed' ? 'selected' : ''}>Completed</option>
                                    <option value="Canceled" ${ticket.status == 'Canceled' ? 'selected' : ''}>Canceled</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-bold small text-muted">TRANSFER TYPE</label>
                                <div class="form-control bg-light">
                                    <c:choose>
                                        <c:when test="${requestType == 'Import'}">
                                                    <span class="badge type-badge type-import">
                                                        <i class="fas fa-arrow-down me-1"></i> IMPORT
                                                    </span>
                                            <span class="ms-2">Stock will INCREASE</span>
                                        </c:when>
                                        <c:when test="${requestType == 'Export'}">
                                                    <span class="badge type-badge type-export">
                                                        <i class="fas fa-arrow-up me-1"></i> EXPORT
                                                    </span>
                                            <span class="ms-2">Stock will DECREASE</span>
                                        </c:when>
                                        <c:otherwise>
                                                    <span class="badge type-badge bg-secondary">
                                                        <i class="fas fa-question me-1"></i> UNKNOWN
                                                    </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <input type="hidden" id="transferType" value="${requestType}">
                            </div>
                            <div class="col-md-12">
                                <label class="form-label fw-bold small text-muted">NOTE</label>
                                <textarea name="note" class="form-control" rows="2">${ticket.note}</textarea>
                            </div>
                        </div>

                        <hr class="text-muted">

                        <h5 class="fw-bold text-secondary mb-3">Item Details</h5>
                        <div class="table-responsive">
                            <table class="table table-bordered align-middle">
                                <thead class="table-light">
                                <tr>
                                    <th>Product Information</th>
                                    <th style="width: 200px;">Confirmed Quantity</th>
                                    <th style="width: 150px;">Current Stock</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${ticket.productTransfers}" var="item">
                                    <tr>
                                        <td>
                                            <span class="d-block fw-bold text-dark">${item.productCode}</span>
                                            <span class="text-muted small">${item.productName}</span>
                                        </td>
                                        <td>
                                            <input type="hidden" name="productId" value="${item.productId}">
                                            <div class="input-group input-group-sm">
                                                <input type="number" name="quantity" class="form-control text-center fw-bold"
                                                       value="${item.quantity}" min="0">
                                            </div>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge bg-info">${item.quantity}</span>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <div class="d-flex justify-content-end gap-2 mt-4">
                            <a href="../actual-transfer" class="btn btn-light border">Cancel</a>
                            <button type="button" id="submitBtn" onclick="submitForm()" class="btn btn-primary px-4 fw-bold">Update Ticket</button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function checkStatusChange() {
        const originalStatus = document.getElementById('originalStatus').value;
        const newStatus = document.getElementById('statusSelect').value;
        const warningDiv = document.getElementById('statusWarning');
        const submitBtn = document.getElementById('submitBtn');

        if (originalStatus !== 'Completed' && newStatus === 'Completed') {
            warningDiv.style.display = 'block';
            submitBtn.textContent = 'Update Ticket & Warehouse';
            submitBtn.className = 'btn btn-success px-4 fw-bold';
        } else {
            warningDiv.style.display = 'none';
            submitBtn.textContent = 'Update Ticket';
            submitBtn.className = 'btn btn-primary px-4 fw-bold';
        }
    }

    function submitForm() {
        const originalStatus = document.getElementById('originalStatus').value;
        const newStatus = document.getElementById('statusSelect').value;
        const transferType = document.getElementById('transferType').value;

        if (originalStatus !== 'Completed' && newStatus === 'Completed') {
            let message = 'Are you sure you want to mark this transfer as COMPLETED? This will update warehouse inventory and create product change records.';

            if (transferType === 'Import') {
                message += '\n\nType: IMPORT - Product stock will INCREASE.';
            } else if (transferType === 'Export') {
                message += '\n\nType: EXPORT - Product stock will DECREASE.';
            }

            if (confirm(message)) {
                document.getElementById('editForm').submit();
            }
        } else {
            document.getElementById('editForm').submit();
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        checkStatusChange();
    });
</script>
</body>
</html>