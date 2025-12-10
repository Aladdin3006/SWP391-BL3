<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Detail</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />

    <style>
        body { background-color: #f8f9fa; }

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

        .value-box {
            padding: .55rem .75rem;
            background: #e9ecef;
            border-radius: 6px;
            border: 1px solid #ced4da;
        }

        .card {
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.08);
        }
        .sidebar { background-color: #343a40; color: white; min-height: calc(100vh - 56px); padding-top: 20px; }
        .sidebar .nav-link { color: rgba(255, 255, 255, 0.8); padding: 10px 15px; }
        .sidebar .nav-link:hover { color: white; background-color: rgba(255, 255, 255, 0.1); }
        .sidebar .nav-link.active { color: white; background-color: #0d6efd; }
        .card { border-radius: 10px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); }
    </style>
</head>

<body>

<jsp:include page="/view/fragments/navbar.jsp" />

<div class="container-fluid mt-0">
    <div class="row">

        <c:set var="activePage" value="user-list" scope="request"/>
        <jsp:include page="/view/fragments/sidebar.jsp"/>

        <main class="col-md-10 ms-sm-auto px-4 py-4">

            <div class="mb-4">
                <a href="${pageContext.request.contextPath}/user-list" class="btn btn-secondary">
                    ← Back to List
                </a>
            </div>

            <div class="card p-4">

                <h3 class="mb-3">User Detail</h3>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">User ID</label>
                        <div class="value-box">${user.userId}</div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold">Account Name</label>
                        <div class="value-box">${user.accountName}</div>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">Display Name</label>
                        <div class="value-box">${user.displayName}</div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold">Email</label>
                        <div class="value-box">${user.email}</div>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">Phone</label>
                        <div class="value-box">${user.phone}</div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold">Status</label>
                        <div class="value-box">
                            <c:choose>
                                <c:when test="${user.status == 'active'}">
                                    Active
                                </c:when>
                                <c:otherwise>
                                    Inactive
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">Workspace ID</label>
                        <div class="value-box">${user.workspaceId}</div>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">Role</label>
                        <div class="value-box">
                            <c:choose>
                                <c:when test="${user.role != null}">
                                    ${user.role.roleName}
                                </c:when>
                                <c:otherwise>N/A</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>



            </div>

        </main>

    </div>
</div>

</body>
</html>
