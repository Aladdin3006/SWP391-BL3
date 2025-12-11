<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Actual Transfer</title>
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
                        <h2 class="text-primary fw-bold mb-0">Create Transfer Ticket</h2>
                        <a href="${pageContext.request.contextPath}/actual-transfer" class="btn btn-outline-secondary">
                            Cancel
                        </a>
                    </div>

                    <div class="card shadow-sm border-0 mb-4">
                        <div class="card-header bg-white py-3">
                            <h5 class="card-title mb-0 fw-bold text-secondary">Step 1: Select Pending Request</h5>
                        </div>
                        <div class="card-body">
                            <form method="GET">
                                <label class="form-label text-muted small fw-bold">REQUEST REFERENCE</label>
                                <select name="reqId" class="form-select form-select-lg" onchange="this.form.submit()">
                                    <option value="">-- Click to choose Request --</option>
                                    <c:forEach items="${requests}" var="r">
                                        <option value="${r.id}" ${param.reqId == r.id ? 'selected' : ''}>
                                            Ticket #${r.ticketCode} (Requested: ${r.requestDate})
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="form-text">Selecting a request will verify items from the warehouse inventory plan.</div>
                            </form>
                        </div>
                    </div>

                    <c:if test="${not empty selectedTicket}">
                        <div class="card shadow-sm border-0">
                            <div class="card-header bg-white py-3">
                                <h5 class="card-title mb-0 fw-bold text-secondary">Step 2: Confirm Actual Details</h5>
                            </div>
                            <div class="card-body p-4">
                                <form action="add" method="POST">
                                    <input type="hidden" name="requestTransferId" value="${selectedTicket.id}">

                                    <div class="row g-3 mb-4">
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">Ticket Code</label>
                                            <input type="text" name="ticketCode" class="form-control" required placeholder="Ex: ACT-2023-001">
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">Actual Transfer Date</label>
                                            <input type="date" name="transferDate" class="form-control" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">Status</label>
                                            <select name="status" class="form-select">
                                                <option value="In Progress">In Progress</option>
                                                <option value="Completed">Completed</option>
                                                <option value="Pending">Pending</option>
                                            </select>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">Note</label>
                                            <textarea name="note" class="form-control" rows="1"></textarea>
                                        </div>
                                    </div>

                                    <hr class="text-muted">

                                    <h5 class="fw-bold text-primary mb-3">Inventory Items</h5>
                                    <div class="table-responsive">
                                        <table class="table table-bordered table-striped align-middle">
                                            <thead class="table-dark">
                                                <tr>
                                                    <th>Product Code</th>
                                                    <th>Product Name</th>
                                                    <th style="width: 200px;" class="text-center">Actual Quantity</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${selectedTicket.productTransfers}" var="item">
                                                    <tr>
                                                        <td class="fw-bold text-secondary">${item.productCode}</td>
                                                        <td>${item.productName}</td>
                                                        <td>
                                                            <input type="hidden" name="productId" value="${item.productId}">
                                                            <div class="input-group">
                                                                <input type="number" name="quantity" class="form-control text-center fw-bold" 
                                                                       value="${item.quantity}" min="0">
                                                                <span class="input-group-text">Units</span>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>

                                    <div class="d-flex justify-content-end mt-3">
                                        <button type="submit" class="btn btn-success btn-lg px-5">
                                            <i class="fas fa-save me-2"></i> Save Ticket
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </c:if>
                </main>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>