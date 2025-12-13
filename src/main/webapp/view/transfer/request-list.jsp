<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Request Transfer Tickets - WMS</title>
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
            .pagination {
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            .pagination .page-link {
                color: #0d6efd;
                border: 1px solid #dee2e6;
                padding: 0.5rem 0.75rem;
                margin: 0 2px;
                border-radius: 0.25rem;
                transition: all 0.3s;
            }
            .pagination .page-link:hover {
                background-color: #0d6efd;
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(13, 110, 253, 0.3);
            }
            .pagination .page-item.active .page-link {
                background-color: #0d6efd;
                border-color: #0d6efd;
                color: white;
                font-weight: bold;
            }
            .pagination .page-item.disabled .page-link {
                color: #6c757d;
                pointer-events: none;
                background-color: #fff;
                border-color: #dee2e6;
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
                        <h2 class="text-primary fw-bold mb-0">Request Transfer Tickets</h2>
                        <a href="${pageContext.request.contextPath}/request-transfer/add" class="btn btn-success fw-bold">
                            <i class="fas fa-plus me-1"></i> Create Request
                        </a>
                    </div>

                    <c:if test="${param.success == 'added'}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>Request transfer ticket created successfully!
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <div class="card shadow-sm border-0 mb-4">
                        <div class="card-body p-4">
                            <form action="${pageContext.request.contextPath}/request-transfer" method="GET">
                                <div class="row g-3">
                                    <div class="col-md-5">
                                        <label class="form-label fw-bold text-secondary small text-uppercase">SEARCH</label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-white border-end-0"><i class="fas fa-search text-muted"></i></span>
                                            <input type="text" name="search" value="${search}" class="form-control border-start-0" placeholder="Search by Ticket Code or Note...">
                                        </div>
                                    </div>
                                    <div class="col-md-5">
                                        <label class="form-label fw-bold text-secondary small text-uppercase">STATUS</label>
                                        <select name="status" class="form-select">
                                            <option value="">All Status</option>
                                            <option value="Pending" ${status == 'Pending' ? 'selected' : ''}>Pending</option>
                                            <option value="Approved" ${status == 'Approved' ? 'selected' : ''}>Approved</option>
                                            <option value="Completed" ${status == 'Completed' ? 'selected' : ''}>Completed</option>
                                            <option value="Rejected" ${status == 'Rejected' ? 'selected' : ''}>Rejected</option>
                                        </select>
                                    </div>
                                    <div class="col-md-2 d-flex align-items-end gap-2">
                                        <button type="submit" class="btn btn-primary fw-bold flex-fill" style="height: 38px;">
                                            <i class="fas fa-filter me-1"></i> Filter
                                        </button>
                                        <a href="${pageContext.request.contextPath}/request-transfer" class="btn btn-outline-secondary fw-bold flex-fill" style="height: 38px;" title="Reset filters">
                                            <i class="fas fa-redo"></i>
                                        </a>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div class="card shadow-sm border-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light text-uppercase small">
                                    <tr>
                                        <th class="ps-4 py-3 text-secondary">Ticket Code</th>
                                        <th class="py-3 text-secondary">Type</th>
                                        <th class="py-3 text-secondary">Request Date</th>
                                        <th class="py-3 text-secondary">Status</th>
                                        <th class="py-3 text-secondary">Assigned To</th>
                                        <th class="py-3 text-center text-secondary">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:if test="${empty transfers}">
                                        <tr>
                                            <td colspan="6" class="text-center py-5 text-muted">
                                                <i class="fas fa-folder-open fa-2x mb-3 text-secondary"></i><br>No records found.
                                            </td>
                                        </tr>
                                    </c:if>
                                    <c:forEach items="${transfers}" var="t">
                                        <tr>
                                            <td class="ps-4 fw-bold text-primary">${t.ticketCode}</td>
                                            <td>${t.type}</td>
                                            <td>${t.requestDate}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${t.status == 'Completed'}">
                                                        <span class="badge bg-success bg-opacity-75 text-white">Completed</span>
                                                    </c:when>
                                                    <c:when test="${t.status == 'Pending'}">
                                                        <span class="badge bg-warning text-dark">Pending</span>
                                                    </c:when>
                                                    <c:when test="${t.status == 'Approved'}">
                                                        <span class="badge bg-info text-dark">Approved</span>
                                                    </c:when>
                                                    <c:when test="${t.status == 'Rejected'}">
                                                        <span class="badge bg-danger">Rejected</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">${t.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${t.employeeId > 0}">
                                                        <i class="fas fa-user text-muted me-1"></i> Employee #${t.employeeId}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Not Assigned</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <div class="btn-group">
                                                    <a href="${pageContext.request.contextPath}/request-transfer/detail?id=${t.id}" 
                                                       class="btn btn-sm btn-outline-secondary" title="View Detail">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <c:if test="${t.status == 'Pending'}">
                                                        <a href="${pageContext.request.contextPath}/request-transfer/edit?id=${t.id}" 
                                                           class="btn btn-sm btn-outline-primary" title="Edit Request">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Pagination Section -->
                    <c:if test="${totalPages > 0}">
                        <div class="mt-4">
                            <div class="d-flex justify-content-between align-items-center flex-wrap">
                                <!-- Page Info -->
                                <div class="text-muted mb-2 mb-md-0">
                                    <i class="fas fa-info-circle me-1"></i>
                                    Showing <strong>${fromRecord}</strong> to <strong>${toRecord}</strong> of <strong>${totalRecords}</strong> records
                                    <span class="text-secondary">| Page ${currentPage} of ${totalPages}</span>
                                </div>

                                <!-- Pagination Controls -->
                                <c:if test="${totalPages > 1}">
                                    <nav aria-label="Page navigation">
                                        <ul class="pagination mb-0">
                                            <!-- First Page -->
                                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                <a class="page-link" href="request-transfer?page=1&search=${search}&status=${status}" aria-label="First">
                                                    <i class="fas fa-angle-double-left"></i>
                                                </a>
                                            </li>

                                            <!-- Previous Page -->
                                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                <a class="page-link" href="request-transfer?page=${currentPage - 1}&search=${search}&status=${status}" aria-label="Previous">
                                                    <i class="fas fa-angle-left"></i>
                                                </a>
                                            </li>

                                            <!-- Page Numbers -->
                                            <c:choose>
                                                <c:when test="${totalPages <= 7}">
                                                    <!-- Show all pages if 7 or less -->
                                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                            <a class="page-link" href="request-transfer?page=${i}&search=${search}&status=${status}">${i}</a>
                                                        </li>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <!-- Smart pagination for many pages -->
                                                    <c:choose>
                                                        <c:when test="${currentPage <= 4}">
                                                            <!-- Near start -->
                                                            <c:forEach begin="1" end="5" var="i">
                                                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                                    <a class="page-link" href="request-transfer?page=${i}&search=${search}&status=${status}">${i}</a>
                                                                </li>
                                                            </c:forEach>
                                                            <li class="page-item disabled"><span class="page-link">...</span></li>
                                                            <li class="page-item">
                                                                <a class="page-link" href="request-transfer?page=${totalPages}&search=${search}&status=${status}">${totalPages}</a>
                                                            </li>
                                                        </c:when>
                                                        <c:when test="${currentPage >= totalPages - 3}">
                                                            <!-- Near end -->
                                                            <li class="page-item">
                                                                <a class="page-link" href="request-transfer?page=1&search=${search}&status=${status}">1</a>
                                                            </li>
                                                            <li class="page-item disabled"><span class="page-link">...</span></li>
                                                            <c:forEach begin="${totalPages - 4}" end="${totalPages}" var="i">
                                                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                                    <a class="page-link" href="request-transfer?page=${i}&search=${search}&status=${status}">${i}</a>
                                                                </li>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <!-- In middle -->
                                                            <li class="page-item">
                                                                <a class="page-link" href="request-transfer?page=1&search=${search}&status=${status}">1</a>
                                                            </li>
                                                            <li class="page-item disabled"><span class="page-link">...</span></li>
                                                            <c:forEach begin="${currentPage - 1}" end="${currentPage + 1}" var="i">
                                                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                                    <a class="page-link" href="request-transfer?page=${i}&search=${search}&status=${status}">${i}</a>
                                                                </li>
                                                            </c:forEach>
                                                            <li class="page-item disabled"><span class="page-link">...</span></li>
                                                            <li class="page-item">
                                                                <a class="page-link" href="request-transfer?page=${totalPages}&search=${search}&status=${status}">${totalPages}</a>
                                                            </li>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:otherwise>
                                            </c:choose>

                                            <!-- Next Page -->
                                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                <a class="page-link" href="request-transfer?page=${currentPage + 1}&search=${search}&status=${status}" aria-label="Next">
                                                    <i class="fas fa-angle-right"></i>
                                                </a>
                                            </li>

                                            <!-- Last Page -->
                                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                <a class="page-link" href="request-transfer?page=${totalPages}&search=${search}&status=${status}" aria-label="Last">
                                                    <i class="fas fa-angle-double-right"></i>
                                                </a>
                                            </li>
                                        </ul>
                                    </nav>
                                </c:if>
                            </div>
                        </div>
                    </c:if>

                </main>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>

