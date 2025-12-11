<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Department Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
        .main-content {
            padding-top: 20px;
            padding-bottom: 40px;
            margin-left: 0;
        }
        .card {
            border-radius: 15px;
            border: none;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            transition: transform 0.3s ease;
        }
        .card-header {
            background: white;
            border-bottom: 2px solid #f0f0f0;
            padding: 20px 25px;
            border-radius: 15px 15px 0 0 !important;
        }
        .btn-back {
            padding: 10px 20px;
            border-radius: 10px;
            font-weight: 500;
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            border: none;
            color: white;
        }
        .btn-edit {
            background: linear-gradient(135deg, #f6d365 0%, #fda085 100%);
            border: none;
            padding: 10px 25px;
            border-radius: 10px;
            font-weight: 600;
            color: white;
        }
        .badge-status {
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: 500;
            font-size: 0.85rem;
        }
        .badge-active {
            background: linear-gradient(135deg, #d1ffd1 0%, #a8ff78 100%);
            color: #0a5c0a;
        }
        .badge-inactive {
            background: linear-gradient(135deg, #ffd1d1 0%, #ff7878 100%);
            color: #8b0000;
        }
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
    </style>
</head>
<body>
<jsp:include page="/view/fragments/navbar.jsp"/>
<div class="container-fluid">
    <div class="row">
        <c:set var="activePage" value="department-list" scope="request"/>
        <jsp:include page="/view/fragments/sidebar.jsp"/>

        <main class="col-md-10 ms-sm-auto px-md-4">
            <div class="detail-container">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0 fw-bold" style="color: #2c3e50;">Department Details</h5>
                    </div>

                    <div class="card-body p-4">
                        <div class="row mb-4">
                            <div class="col-md-3 mb-4">
                                <div class="info-card">
                                    <div class="info-icon department">
                                        <i class="fas fa-building"></i>
                                    </div>
                                    <div class="info-title">Department Name</div>
                                    <div class="info-value">${dept.departmentName}</div>
                                </div>
                            </div>

                            <div class="col-md-3 mb-4">
                                <div class="info-card">
                                    <div class="info-icon storekeeper">
                                        <i class="fas fa-user-tie"></i>
                                    </div>
                                    <div class="info-title">Storekeeper</div>
                                    <div class="info-value">${storekeeperName}</div>
                                    <small class="text-muted">ID: ${dept.storekeeperId}</small>
                                </div>
                            </div>

                            <div class="col-md-3 mb-4">
                                <div class="info-card">
                                    <div class="info-icon employees">
                                        <i class="fas fa-users"></i>
                                    </div>
                                    <div class="info-title">Total Employees</div>
                                    <div class="info-value">${employeeCount}</div>
                                    <small class="text-muted">Assigned to department</small>
                                </div>
                            </div>

                            <div class="col-md-3 mb-4">
                                <div class="info-card">
                                    <div class="info-icon status">
                                        <i class="fas fa-chart-line"></i>
                                    </div>
                                    <div class="info-title">Status</div>
                                    <div>
                                        <span class="status-badge ${dept.status == 'active' ? 'status-active' : 'status-inactive'}">
                                            <i class="fas ${dept.status == 'active' ? 'fa-check-circle' : 'fa-times-circle'} me-1"></i>
                                            ${dept.status}
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-12">
                                <div class="card mb-4" style="border-radius: 15px; border: 2px solid #e8f4ff;">
                                    <div class="card-header bg-white" style="border-radius: 15px 15px 0 0; border-bottom: 2px solid #e8f4ff;">
                                        <h5 class="mb-0 fw-bold" style="color: #2c3e50;">
                                            <i class="fas fa-users me-2"></i>Department Employees
                                            <span class="badge bg-primary ms-2">${employeeCount}</span>
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <c:choose>
                                            <c:when test="${not empty employees}">
                                                <div class="row">
                                                    <c:forEach items="${employees}" var="emp">
                                                        <div class="col-md-6 col-lg-4 mb-3">
                                                            <div class="employee-card">
                                                                <div class="d-flex align-items-center">
                                                                    <div class="employee-avatar me-3">
                                                                            ${emp.displayName.charAt(0)}
                                                                    </div>
                                                                    <div>
                                                                        <h6 class="mb-1 fw-bold" style="color: #2c3e50;">${emp.displayName}</h6>
                                                                        <div class="text-muted">
                                                                            <small>
                                                                                <i class="fas fa-id-card me-1"></i>ID: ${emp.userId}
                                                                            </small>
                                                                        </div>
                                                                        <div class="text-muted">
                                                                            <small>
                                                                                <i class="fas fa-user-tag me-1"></i>Employee
                                                                            </small>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="empty-state">
                                                    <i class="fas fa-user-friends"></i>
                                                    <h5 class="mt-3 mb-2">No Employees Assigned</h5>
                                                    <p class="text-muted mb-0">This department currently has no assigned employees</p>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/department-list" class="btn btn-back">
                                <i class="fas fa-arrow-left me-2"></i>Back to List
                            </a>
                            <div class="ms-auto">
                                <c:if test="${dept.status == 'active'}">
                                    <a href="${pageContext.request.contextPath}/department-list?action=deactivate&id=${dept.id}"
                                       class="btn btn-danger me-2"
                                       onclick="return confirm('Are you sure you want to deactivate ${dept.departmentName}?')"
                                       style="border-radius: 12px; padding: 12px 25px; font-weight: 600;">
                                        <i class="fas fa-ban me-2"></i>Deactivate
                                    </a>
                                </c:if>
                                <c:if test="${dept.status == 'inactive'}">
                                    <a href="?action=activate&id=${dept.id}"
                                       class="btn btn-success me-2"
                                       style="border-radius: 12px; padding: 12px 25px; font-weight: 600;">
                                        <i class="fas fa-check me-2"></i>Activate
                                    </a>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/department-update?id=${dept.id}" class="btn btn-edit">
                                    <i class="fas fa-edit me-2"></i>Edit Department
                                </a>
                            </div>
                        </div>

                        <div class="mt-4 pt-4 border-top">
                            <h6 class="fw-bold mb-3" style="color: #2c3e50;">
                                <i class="fas fa-history me-2"></i>Department Information
                            </h6>
                            <div class="row">
                                <div class="col-md-6">
                                    <table class="table table-borderless">
                                        <tr>
                                            <td class="text-muted" width="40%">Department ID:</td>
                                            <td class="fw-bold">${dept.id}</td>
                                        </tr>
                                        <tr>
                                            <td class="text-muted">Department Name:</td>
                                            <td class="fw-bold">${dept.departmentName}</td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="col-md-6">
                                    <table class="table table-borderless">
                                        <tr>
                                            <td class="text-muted" width="40%">Storekeeper ID:</td>
                                            <td class="fw-bold">${dept.storekeeperId}</td>
                                        </tr>
                                        <tr>
                                            <td class="text-muted">Current Status:</td>
                                            <td>
                                                <span class="badge ${dept.status == 'active' ? 'bg-success' : 'bg-danger'}">
                                                    ${dept.status}
                                                </span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
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