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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 10px 25px;
            border-radius: 10px;
            font-weight: 600;
            color: white;
            transition: transform 0.3s ease;
        }
        .btn-edit:hover {
            transform: translateY(-2px);
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
        .info-card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            border: 2px solid #f0f0f0;
            text-align: center;
            transition: all 0.3s ease;
            height: 100%;
        }
        .info-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            border-color: #667eea;
        }
        .info-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            font-size: 1.5rem;
            color: white;
        }
        .info-icon.department {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .info-icon.storekeeper {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }
        .info-icon.employees {
            background: linear-gradient(135deg, #f6d365 0%, #fda085 100%);
        }
        .info-icon.status {
            background: linear-gradient(135deg, #42e695 0%, #3bb2b8 100%);
        }
        .info-title {
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 5px;
        }
        .info-value {
            color: #2c3e50;
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 5px;
        }
        .employee-card {
            background: white;
            padding: 15px;
            border-radius: 10px;
            border: 1px solid #e9ecef;
            transition: all 0.3s ease;
        }
        .employee-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            border-color: #667eea;
        }
        .employee-avatar {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 1.2rem;
        }
        .empty-state {
            padding: 40px 20px;
            text-align: center;
            color: #6c757d;
        }
        .empty-state i {
            font-size: 3rem;
            color: #dee2e6;
            margin-bottom: 15px;
        }
        .action-buttons {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 20px;
            border-top: 2px solid #f0f0f0;
            margin-top: 20px;
        }
        .sidebar { background-color: #343a40; color: white; min-height: calc(100vh - 56px); padding-top: 20px; }
        .sidebar .nav-link { color: rgba(255, 255, 255, 0.8); padding: 10px 15px; }
        .sidebar .nav-link:hover { color: white; background-color: rgba(255, 255, 255, 0.1); }
        .sidebar .nav-link.active { color: white; background-color: #0d6efd; }
    </style>
</head>
<body>
<jsp:include page="/view/fragments/navbar.jsp"/>
<div class="container-fluid">
    <div class="row">
        <c:set var="activePage" value="department-list" scope="request"/>
        <jsp:include page="/view/fragments/sidebar.jsp"/>

        <main class="col-md-10 ms-sm-auto px-md-4 main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold mb-1" style="color: #2c3e50;">Department Details</h2>
                    <p class="text-muted">View detailed information about the department</p>
                </div>
                <a href="${pageContext.request.contextPath}/department-list" class="btn btn-back">
                    <i class="fas fa-arrow-left me-2"></i>Back to List
                </a>
            </div>

            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0 fw-bold" style="color: #2c3e50;">Department Information</h5>
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
                                <small class="text-muted">ID: ${dept.id}</small>
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
                                    <span class="badge-status ${dept.status == 'active' ? 'badge-active' : 'badge-inactive'}">
                                        <i class="fas ${dept.status == 'active' ? 'fa-check-circle' : 'fa-times-circle'} me-1"></i>
                                        ${dept.status}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row mb-5">
                        <div class="col-12">
                            <div class="card" style="border: 2px solid #e8f4ff;">
                                <div class="card-header bg-white" style="border-bottom: 2px solid #e8f4ff;">
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
                        <div>
                            <c:if test="${dept.status == 'active'}">
                                <a href="${pageContext.request.contextPath}/department-list?action=deactivate&id=${dept.id}"
                                   class="btn btn-danger me-2"
                                   onclick="return confirm('Are you sure you want to deactivate ${dept.departmentName}?')"
                                   style="border-radius: 10px; padding: 10px 20px; font-weight: 600;">
                                    <i class="fas fa-ban me-2"></i>Deactivate
                                </a>
                            </c:if>
                            <c:if test="${dept.status == 'inactive'}">
                                <a href="?action=activate&id=${dept.id}"
                                   class="btn btn-success me-2"
                                   style="border-radius: 10px; padding: 10px 20px; font-weight: 600;">
                                    <i class="fas fa-check me-2"></i>Activate
                                </a>
                            </c:if>
                        </div>
                        <div>
                            <a href="${pageContext.request.contextPath}/department-update?id=${dept.id}" class="btn btn-edit">
                                <i class="fas fa-edit me-2"></i>Edit Department
                            </a>
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