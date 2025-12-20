<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>Role Permission Matrix</title>

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <style>
        body { background-color: #f8f9fa; }
        .sidebar { background-color: #343a40; color: white; min-height: calc(100vh - 56px); padding-top: 20px; }
        .sidebar .nav-link { color: rgba(255, 255, 255, 0.8); padding: 10px 15px; }
        .sidebar .nav-link:hover { color: white; background-color: rgba(255, 255, 255, 0.1); }
        .sidebar .nav-link.active { color: white; background-color: #0d6efd; }

        .permission-matrix {
            width: 100%;
            overflow-x: auto;
            max-height: 600px;
            overflow-y: auto;
        }
        .matrix-table {
            min-width: 800px;
            border-collapse: separate;
            border-spacing: 0;
        }
        .permission-name-col {
            position: sticky;
            left: 0;
            background: white;
            z-index: 3;
            min-width: 200px;
            border-right: 2px solid #dee2e6;
        }
        .permission-url-col {
            position: sticky;
            left: 200px;
            background: white;
            z-index: 3;
            min-width: 200px;
            border-right: 2px solid #dee2e6;
        }
        .role-header {
            background-color: #f8f9fa;
            min-width: 120px;
            text-align: center;
            position: sticky;
            top: 0;
            z-index: 2;
        }
        .permission-cell {
            text-align: center;
            vertical-align: middle;
            cursor: pointer;
            min-width: 120px;
            height: 70px;
        }
        .assigned-true {
            background-color: #d4edda !important;
        }
        .assigned-false {
            background-color: #f8d7da !important;
        }
        .permission-url {
            font-size: 0.8rem;
            color: #6c757d;
        }
        .table-header {
            position: sticky;
            top: 0;
            background: white;
            z-index: 4;
        }
        .table-header th {
            position: sticky;
            top: 0;
            background: white;
            z-index: 4;
        }
        .permission-row:hover {
            background-color: #f5f5f5;
        }
        .toggle-btn {
            width: 100%;
            height: 100%;
            border: none;
            background: none;
            cursor: pointer;
            padding: 10px;
        }
    </style>
</head>

<body>
<jsp:include page="/view/fragments/navbar.jsp"/>

<div class="container-fluid">
    <div class="row">
        <c:set var="activePage" value="role" scope="request"/>
        <jsp:include page="/view/fragments/sidebar.jsp"/>

        <main class="col-md-10 ms-sm-auto px-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Role Permission Matrix</h1>
                <a href="${pageContext.request.contextPath}/view-role-list" class="btn btn-secondary">
                    <i class="fa fa-arrow-left"></i> Back to Roles
                </a>
            </div>

            <div class="card p-3 mb-4">
                <div class="permission-matrix">
                    <table class="table table-bordered matrix-table">
                        <thead class="table-header">
                        <tr>
                            <th class="permission-name-col">Permission</th>
                            <th class="permission-url-col">URL</th>
                            <c:forEach var="role" items="${allRoles}">
                                <th class="role-header">
                                    <div class="fw-bold">${role.roleName}</div>
                                    <div class="permission-url">
                                        <c:choose>
                                            <c:when test="${role.status == 'active'}">
                                                <span class="badge bg-success">Active</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger">Inactive</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </th>
                            </c:forEach>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="permission" items="${allPermissions}">
                            <tr class="permission-row">
                                <td class="permission-name-col fw-bold">${permission.permissionName}</td>
                                <td class="permission-url-col permission-url">${permission.url}</td>

                                <c:forEach var="role" items="${allRoles}">
                                    <c:set var="isAssigned"
                                           value="${rolePermissionsMap[role.roleId].contains(permission.permissionId)}"/>
                                    <td class="permission-cell ${isAssigned ? 'assigned-true' : 'assigned-false'}">
                                        <form method="post" action="role-permission" class="toggle-form"
                                              id="form-${role.roleId}-${permission.permissionId}">
                                            <input type="hidden" name="roleId" value="${role.roleId}"/>
                                            <input type="hidden" name="permissionId" value="${permission.permissionId}"/>
                                            <input type="hidden" name="action" value="${isAssigned ? 'remove' : 'assign'}"/>

                                            <button type="submit" class="toggle-btn">
                                                <c:choose>
                                                    <c:when test="${isAssigned}">
                                                        <i class="fas fa-check-circle text-success fa-lg"></i>
                                                        <div class="text-muted small">Assigned</div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fas fa-times-circle text-danger fa-lg"></i>
                                                        <div class="text-muted small">Not Assigned</div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </button>
                                        </form>
                                    </td>
                                </c:forEach>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="card p-3">
                <h5 class="card-title">Legend:</h5>
                <div class="row">
                    <div class="col-md-3">
                        <div class="d-flex align-items-center mb-2">
                            <div class="assigned-true p-2 me-2" style="width: 30px; height: 30px; text-align: center;">
                                <i class="fas fa-check-circle text-success"></i>
                            </div>
                            <span>Permission Assigned</span>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="d-flex align-items-center mb-2">
                            <div class="assigned-false p-2 me-2" style="width: 30px; height: 30px; text-align: center;">
                                <i class="fas fa-times-circle text-danger"></i>
                            </div>
                            <span>Permission Not Assigned</span>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <p class="text-muted mb-0">
                            <i class="fas fa-info-circle"></i>
                            Click on any cell to toggle permission assignment. Green = Assigned, Red = Not Assigned.
                        </p>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const toggleForms = document.querySelectorAll('.toggle-form');

        toggleForms.forEach(form => {
            form.addEventListener('submit', function(e) {
                const action = this.querySelector('input[name="action"]').value;
                const roleId = this.querySelector('input[name="roleId"]').value;
                const permissionId = this.querySelector('input[name="permissionId"]').value;

                if (action === 'remove') {
                    if (!confirm('Are you sure you want to remove this permission?')) {
                        e.preventDefault();
                    }
                }
            });
        });
    });
</script>
</body>
</html>