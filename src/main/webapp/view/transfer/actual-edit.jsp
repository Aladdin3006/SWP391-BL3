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

                    <div class="card shadow-sm border-0">
                        <div class="card-body p-4">
                            <form action="edit" method="POST">
                                <input type="hidden" name="id" value="${ticket.id}">

                                <div class="row g-3 mb-4">
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold small text-muted">TRANSFER DATE</label>
                                        <input type="date" name="transferDate" value="${ticket.transferDate}" class="form-control" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold small text-muted">STATUS</label>
                                        <select name="status" class="form-select">
                                            <option value="Pending" ${ticket.status == 'Pending' ? 'selected' : ''}>Pending</option>
                                            <option value="In Progress" ${ticket.status == 'In Progress' ? 'selected' : ''}>In Progress</option>
                                            <option value="Completed" ${ticket.status == 'Completed' ? 'selected' : ''}>Completed</option>
                                            <option value="Canceled" ${ticket.status == 'Canceled' ? 'selected' : ''}>Canceled</option>
                                        </select>
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
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <div class="d-flex justify-content-end gap-2 mt-4">
                                    <a href="../actual-transfer" class="btn btn-light border">Cancel</a>
                                    <button type="submit" class="btn btn-primary px-4 fw-bold">Update Ticket</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </main>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>