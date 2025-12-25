<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Department</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/css/select2.min.css" rel="stylesheet">
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
        .form-label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 8px;
        }
        .form-control, .form-select {
            border-radius: 10px;
            border: 2px solid #e0e0e0;
            padding: 10px 15px;
            transition: all 0.3s ease;
        }
        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.25rem rgba(102, 126, 234, 0.1);
        }
        .icon-input {
            position: relative;
        }
        .icon-input i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #667eea;
            z-index: 10;
        }
        .icon-input input, .icon-input select {
            padding-left: 45px;
        }
        .btn-submit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 10px 25px;
            border-radius: 10px;
            font-weight: 600;
            transition: transform 0.3s ease;
            color: white;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
        }
        .btn-back {
            padding: 10px 20px;
            border-radius: 10px;
            font-weight: 500;
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            border: none;
            color: white;
        }
        .select2-container--default .select2-selection--multiple {
            border-radius: 10px;
            border: 2px solid #e0e0e0;
            min-height: 46px;
            padding: 5px;
        }
        .select2-container--default.select2-container--focus .select2-selection--multiple {
            border-color: #667eea;
        }
        .section-title {
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f0f0f0;
        }
        .employee-list {
            max-height: 250px;
            overflow-y: auto;
            padding: 15px;
            background: white;
            border-radius: 10px;
            border: 2px solid #f0f0f0;
        }
        .employee-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 15px;
            margin-bottom: 8px;
            background: #f8f9ff;
            border-radius: 8px;
            border-left: 4px solid #667eea;
            transition: all 0.2s ease;
        }
        .employee-item:hover {
            background: #eef1ff;
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
                    <h2 class="fw-bold mb-1" style="color: #2c3e50;">Update Department</h2>
                    <p class="text-muted">Edit department information and assignments</p>
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
                    <form method="post" action="${pageContext.request.contextPath}/department-update">
                        <input type="hidden" name="id" value="${dept.id}">

                        <div class="mb-5">
                            <h4 class="section-title">
                                <i class="fas fa-info-circle me-2"></i>Basic Information
                            </h4>

                            <div class="row">
                                <div class="col-md-6 mb-4">
                                    <label class="form-label">Department ID</label>
                                    <input type="text" class="form-control bg-light" value="${dept.id}" readonly>
                                </div>
                                <div class="col-md-6 mb-4">
                                    <label class="form-label">Status</label>
                                    <div>
                                        <span class="badge-status ${dept.status == 'active' ? 'badge-active' : 'badge-inactive'}">
                                            <i class="fas ${dept.status == 'active' ? 'fa-check-circle' : 'fa-times-circle'} me-1"></i>
                                            ${dept.status}
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-4">
                                    <label class="form-label">Department Name</label>
                                    <div class="icon-input">
                                        <i class="fas fa-building"></i>
                                        <input type="text" name="departmentName" class="form-control"
                                               value="${dept.departmentName}" required>
                                    </div>
                                </div>

                                <div class="col-md-6 mb-4">
                                    <label class="form-label">Storekeeper</label>
                                    <div class="icon-input">
                                        <i class="fas fa-user-tie"></i>
                                        <select name="storekeeperId" class="form-select" required>
                                            <c:forEach items="${storekeepers}" var="sk">
                                                <option value="${sk.userId}" ${sk.userId == dept.storekeeperId ? 'selected' : ''}>
                                                        ${sk.displayName} (ID: ${sk.userId})
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-4">
                                    <label class="form-label">Update Status</label>
                                    <select name="status" class="form-select">
                                        <option value="active" ${dept.status == 'active' ? 'selected' : ''}>Active</option>
                                        <option value="inactive" ${dept.status == 'inactive' ? 'selected' : ''}>Inactive</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="mb-5">
                            <h4 class="section-title">
                                <i class="fas fa-users me-2"></i>Employee Management
                            </h4>

                            <div class="mb-4">
                                <label class="form-label">Current Employees (${currentEmployees.size()})</label>
                                <c:choose>
                                    <c:when test="${not empty currentEmployees}">
                                        <div class="employee-list">
                                            <c:forEach items="${currentEmployees}" var="emp">
                                                <c:set var="empRating" value="${currentEmployeeRatings[emp.userId]}" />
                                                <div class="employee-item">
                                                    <div>
                                                        <i class="fas fa-user me-2 text-primary"></i>
                                                        <strong>${emp.displayName}</strong>
                                                        <small class="text-muted ms-2">ID: ${emp.userId}</small>
                                                        <c:if test="${empRating > 0}">
                <span class="ms-2 text-warning">
                    <i class="fas fa-star"></i> ${String.format("%.1f", empRating)}
                </span>
                                                        </c:if>
                                                    </div>
                                                    <span class="text-success">
            <i class="fas fa-check-circle"></i>
        </span>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="alert alert-info">
                                            <i class="fas fa-info-circle me-2"></i>
                                            No employees assigned to this department
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="mb-4">
                                <label class="form-label">Add/Remove Employees</label>
                                <select name="employeeIds" class="form-control select2-multiple" multiple="multiple">
                                    <c:forEach items="${currentEmployees}" var="emp">
                                        <c:set var="empRating" value="${currentEmployeeRatings[emp.userId]}" />
                                        <option value="${emp.userId}" selected>
                                                ${emp.displayName} (ID: ${emp.userId}) -
                                            <c:choose>
                                                <c:when test="${empRating > 0}">
                                                    <i class="fas fa-star text-warning"></i> ${String.format("%.1f", empRating)} star rating
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="far fa-star text-muted"></i> No rating
                                                </c:otherwise>
                                            </c:choose>
                                        </option>
                                    </c:forEach>
                                    <c:forEach items="${availableEmployees}" var="emp">
                                        <c:set var="empRating" value="${availableEmployeeRatings[emp.userId]}" />
                                        <option value="${emp.userId}">
                                                ${emp.displayName} (ID: ${emp.userId}) -
                                            <c:choose>
                                                <c:when test="${empRating > 0}">
                                                    <i class="fas fa-star text-warning"></i> ${String.format("%.1f", empRating)} star rating
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="far fa-star text-muted"></i> No rating
                                                </c:otherwise>
                                            </c:choose>
                                        </option>
                                    </c:forEach>
                                </select>
                                <small class="text-muted">Select or deselect employees to update assignments</small>
                            </div>
                        </div>

                        <div class="d-flex justify-content-between align-items-center pt-4 border-top">
                            <a href="${pageContext.request.contextPath}/department-list" class="btn btn-back">
                                <i class="fas fa-times me-2"></i>Cancel
                            </a>
                            <button type="submit" class="btn btn-submit">
                                <i class="fas fa-save me-2"></i>Update Department
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/js/select2.min.js"></script>
<script>
    $(document).ready(function() {
        $('.select2-multiple').select2({
            placeholder: "Select employees",
            allowClear: true,
            width: '100%'
        });
    });
</script>
</body>
</html>