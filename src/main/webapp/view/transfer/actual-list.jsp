<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Actual Transfers - WMS</title>
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

                    <h2 class="mb-4 text-primary fw-bold">Actual Transfer Tickets</h2>

                    <div class="card shadow-sm border-0 mb-4">
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/actual-transfer" method="GET" class="row g-3">
                                <div class="col-md-4">
                                    <label class="form-label fw-bold small text-muted">SEARCH</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light"><i class="fas fa-search"></i></span>
                                        <input type="text" name="search" value="${search}" class="form-control" placeholder="Ticket code...">
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label fw-bold small text-muted">STATUS</label>
                                    <select name="status" class="form-select">
                                        <option value="all">All Status</option>
                                        <option value="Pending" ${status == 'Pending' ? 'selected' : ''}>Pending</option>
                                        <option value="In Progress" ${status == 'In Progress' ? 'selected' : ''}>In Progress</option>
                                        <option value="Completed" ${status == 'Completed' ? 'selected' : ''}>Completed</option>
                                        <option value="Canceled" ${status == 'Canceled' ? 'selected' : ''}>Canceled</option>
                                    </select>
                                </div>
                                <div class="col-md-2 d-flex align-items-end">
                                    <button type="submit" class="btn btn-primary w-100 fw-bold">Filter</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div class="card shadow-sm border-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th class="ps-4 py-3">Ticket Code</th>
                                        <th>Transfer Date</th>
                                        <th>Request ID</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <c:if test="${empty transfers}">
                                    <tr>
                                        <td colspan="5" class="text-center py-5 text-muted">No records found.</td>
                                    </tr>
                                </c:if>
                                <c:forEach items="${transfers}" var="t">
                                    <tr>
                                        <td class="ps-4 fw-bold text-primary">${t.ticketCode}</td>
                                        <td>${t.transferDate}</td>
                                        <td>#${t.requestTransferId}</td>
                                        <td>
                                    <c:choose>
                                        <c:when test="${t.status == 'Completed'}">
                                            <span class="badge bg-success bg-opacity-75 text-white">Completed</span>
                                        </c:when>
                                        <c:when test="${t.status == 'Pending'}">
                                            <span class="badge bg-warning text-dark">Pending</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">${t.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/actual-transfer/detail?id=${t.id}" class="btn btn-sm btn-outline-primary">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                    </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <c:if test="${totalPages > 1}">
                        <div class="mt-4 d-flex justify-content-center">
                            <ul class="pagination">
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="actual-transfer?page=${i}&search=${search}&status=${status}">${i}</a>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </c:if>

                </main>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>