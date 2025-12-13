<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Request Transfer Detail - WMS</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                background-color: #f8f9fa;
                font-family: 'Segoe UI', sans-serif;
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
                <c:set var="activePage" value="request-transfer" scope="request"/>
                <jsp:include page="/view/fragments/sidebar.jsp"/>

                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h2 class="text-primary fw-bold mb-0">Request Transfer Detail</h2>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb mb-0">
                                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/request-transfer">Request Transfers</a></li>
                                    <li class="breadcrumb-item active">${ticket.ticketCode}</li>
                                </ol>
                            </nav>
                        </div>
                        <c:if test="${ticket.status == 'Pending'}">
                            <a href="${pageContext.request.contextPath}/request-transfer/edit?id=${ticket.id}" class="btn btn-primary">
                                <i class="fas fa-edit me-1"></i> Edit Request
                            </a>
                        </c:if>
                    </div>

                    <c:if test="${param.success == 'updated'}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>Request transfer ticket updated successfully!
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <div class="row">
                        <div class="col-lg-8">
                            <div class="card shadow-sm border-0 mb-4">
                                <div class="card-header bg-primary text-white">
                                    <h5 class="mb-0"><i class="fas fa-info-circle me-2"></i>Request Information</h5>
                                </div>
                                <div class="card-body p-4">
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label class="text-muted small">Ticket Code</label>
                                            <div class="fw-bold fs-5 text-primary">${ticket.ticketCode}</div>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="text-muted small">Status</label>
                                            <div>
                                                <c:choose>
                                                    <c:when test="${ticket.status == 'Completed'}">
                                                        <span class="badge bg-success fs-6">Completed</span>
                                                    </c:when>
                                                    <c:when test="${ticket.status == 'Pending'}">
                                                        <span class="badge bg-warning text-dark fs-6">Pending</span>
                                                    </c:when>
                                                    <c:when test="${ticket.status == 'Approved'}">
                                                        <span class="badge bg-info text-dark fs-6">Approved</span>
                                                    </c:when>
                                                    <c:when test="${ticket.status == 'Rejected'}">
                                                        <span class="badge bg-danger fs-6">Rejected</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary fs-6">${ticket.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                    <hr>
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label class="text-muted small">Type</label>
                                            <div class="fw-bold">${ticket.type}</div>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="text-muted small">Request Date</label>
                                            <div class="fw-bold">${ticket.requestDate}</div>
                                        </div>
                                    </div>
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label class="text-muted small">Created By</label>
                                            <div class="fw-bold">
                                                <c:choose>
                                                    <c:when test="${creator != null}">
                                                        <i class="fas fa-user text-primary me-1"></i> ${creator.displayName}
                                                    </c:when>
                                                    <c:otherwise>
                                                        User #${ticket.createdBy}
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="text-muted small">Assigned Employee</label>
                                            <div class="fw-bold">
                                                <c:choose>
                                                    <c:when test="${employee != null}">
                                                        <i class="fas fa-user-check text-success me-1"></i> ${employee.displayName}
                                                    </c:when>
                                                    <c:when test="${ticket.employeeId > 0}">
                                                        Employee #${ticket.employeeId}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Not Assigned</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                    <c:if test="${ticket.note != null && !ticket.note.isEmpty()}">
                                        <hr>
                                        <div>
                                            <label class="text-muted small">Note</label>
                                            <div class="border rounded p-3 bg-light">${ticket.note}</div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>

                            <div class="card shadow-sm border-0">
                                <div class="card-header bg-success text-white">
                                    <h5 class="mb-0"><i class="fas fa-boxes me-2"></i>Product Items</h5>
                                </div>
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0">
                                            <thead class="table-light">
                                                <tr>
                                                    <th class="ps-4">#</th>
                                                    <th>Product Code</th>
                                                    <th>Product Name</th>
                                                    <th class="text-end pe-4">Quantity</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${empty ticket.productTransfers}">
                                                        <tr>
                                                            <td colspan="4" class="text-center py-4 text-muted">
                                                                No product items
                                                            </td>
                                                        </tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach items="${ticket.productTransfers}" var="item" varStatus="status">
                                                            <tr>
                                                                <td class="ps-4">${status.index + 1}</td>
                                                                <td><span class="badge bg-secondary"><c:out value="${item.productCode}"/></span></td>
                                                                <td><c:out value="${item.productName}"/></td>
                                                                <td class="text-end pe-4 fw-bold">${item.quantity}</td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:otherwise>
                                                </c:choose>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-4">
                            <div class="card shadow-sm border-0">
                                <div class="card-header bg-info text-white">
                                    <h6 class="mb-0"><i class="fas fa-clock me-2"></i>Quick Actions</h6>
                                </div>
                                <div class="card-body">
                                    <div class="d-grid gap-2">
                                        <a href="${pageContext.request.contextPath}/request-transfer" class="btn btn-outline-secondary">
                                            <i class="fas fa-arrow-left me-2"></i> Back to List
                                        </a>
                                        <c:if test="${ticket.status == 'Pending'}">
                                            <a href="${pageContext.request.contextPath}/request-transfer/edit?id=${ticket.id}" class="btn btn-outline-primary">
                                                <i class="fas fa-edit me-2"></i> Edit Request
                                            </a>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </main>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>

