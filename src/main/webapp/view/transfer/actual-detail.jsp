<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Detail ${ticket.ticketCode}</title>
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
            .detail-label {
                font-size: 0.85rem;
                font-weight: bold;
                color: #6c757d;
                text-transform: uppercase;
                margin-bottom: 0.2rem;
            }
            .detail-value {
                font-size: 1.1rem;
                font-weight: 500;
                color: #212529;
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
                        <button type="button" onclick="window.history.back()" class="btn btn-outline-secondary btn-sm">
                            <i class="fas fa-arrow-left me-1"></i> Back
                        </button>
                        <span class="badge bg-secondary fs-6">Actual Transfer Ticket</span>
                    </div>

                    <div class="card shadow-sm border-0 mb-4">
                        <div class="card-body">
                            <div class="row g-4">
                                <div class="col-md-3">
                                    <div class="detail-label">Ticket Code</div>
                                    <div class="detail-value text-primary">${ticket.ticketCode}</div>
                                </div>
                                <div class="col-md-3">
                                    <div class="detail-label">Request Ref</div>
                                    <div class="detail-value">#${ticket.requestTransferId}</div>
                                </div>
                                <div class="col-md-3">
                                    <div class="detail-label">Transfer Date</div>
                                    <div class="detail-value">${ticket.transferDate}</div>
                                </div>
                                <div class="col-md-3">
                                    <div class="detail-label">Status</div>
                                    <div>
                                        <span class="badge bg-warning text-dark px-3 py-2 fs-6">${ticket.status}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="row g-4 mt-1">
                                <div class="col-md-12">
                                    <div class="detail-label">Note</div>
                                    <div class="bg-light p-3 rounded border">
                                        ${not empty ticket.note ? ticket.note : 'No additional notes.'}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <h5 class="mb-3 fw-bold text-secondary">Items List</h5>
                    <div class="card shadow-sm border-0">
                        <div class="table-responsive">
                            <table class="table table-bordered table-striped mb-0">
                                <thead class="table-dark">
                                    <tr>
                                        <th class="text-center" style="width: 50px;">#</th>
                                        <th>Product Code</th>
                                        <th>Product Name</th>
                                        <th class="text-center" style="width: 150px;">Quantity</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${ticket.productTransfers}" var="item" varStatus="status">
                                    <tr>
                                        <td class="text-center">${status.index + 1}</td>
                                        <td class="fw-bold text-primary">${item.productCode}</td>
                                        <td>${item.productName}</td>
                                        <td class="text-center fw-bold fs-5">${item.quantity}</td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                </main>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>