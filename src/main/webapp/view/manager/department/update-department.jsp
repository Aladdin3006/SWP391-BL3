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
        .form-container {
            max-width: 800px;
            margin: 40px auto;
        }
        .card {
            border-radius: 20px;
            border: none;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }
        .card-header {
            background: linear-gradient(135deg, #f6d365 0%, #fda085 100%);
            color: white;
            border-radius: 20px 20px 0 0 !important;
            padding: 25px 30px;
        }
        .form-section {
            background: #fff9f7;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 25px;
            border: 2px solid #ffe8e0;
        }
        .form-label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 10px;
        }
        .form-control, .form-select {
            border-radius: 12px;
            border: 2px solid #e0e0e0;
            padding: 12px 15px;
            transition: all 0.3s ease;
        }
        .form-control:focus, .form-select:focus {
            border-color: #fda085;
            box-shadow: 0 0 0 0.25rem rgba(253, 160, 133, 0.25);
        }
        .btn-update {
            background: linear-gradient(135deg, #f6d365 0%, #fda085 100%);
            border: none;
            padding: 14px 30px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .btn-update:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(253, 160, 133, 0.3);
        }
        .btn-back {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            border: none;
            padding: 12px 25px;
            border-radius: 12px;
            font-weight: 500;
        }
        .employee-list {
            max-height: 200px;
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
            padding: 10px 15px;
            margin-bottom: 8px;
            background: #f8f9ff;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }
        .icon-input {
            position: relative;
        }
        .icon-input i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #fda085;
        }
        .icon-input input, .icon-input select {
            padding-left: 45px;
        }
        .select2-container--default .select2-selection--multiple {
            border-radius: 12px;
            border: 2px solid #e0e0e0;
            min-height: 46px;
            padding: 5px;
        }
        .select2-container--default.select2-container--focus .select2-selection--multiple {
            border-color: #fda085;
        }
        .status-badge {
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: 500;
            display: inline-block;
        }
        .status-active {
            background: linear-gradient(135deg, #d1ffd1 0%, #a8ff78 100%);
            color: #0a5c0a;
        }
        .status-inactive {
            background: linear-gradient(135deg, #ffd1d1 0%, #ff7878 100%);
            color: #8b0000;
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
            <div class="form-container">
                <div class="card">
                    <div class="card-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h2 class="mb-1"><i class="fas fa-edit me-2"></i>Update Department</h2>
                                <p class="mb-0 opacity-75">Edit department information and assignments</p>
                            </div>
                            <a href="${pageContext.request.contextPath}/department-list" class="btn btn-light btn-sm">
                                <i class="fas fa-arrow-left me-1"></i>Back to List
                            </a>
                        </div>
                    </div>

                    <div class="card-body p-4">
                        <form method="post" action="${pageContext.request.contextPath}/department-update">
                            <input type="hidden" name="id" value="${dept.id}">

                            <div class="form-section">
                                <h4 class="mb-4" style="color: #2c3e50;">
                                    <i class="fas fa-info-circle me-2"></i>Department Details
                                </h4>

                                <div class="row mb-4">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Department ID</label>
                                            <input type="text" class="form-control bg-light" value="${dept.id}" readonly>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Current Status</label>
                                            <br>
                                            <span class="status-badge ${dept.status == 'active' ? 'status-active' : 'status-inactive'}">
                                                <i class="fas ${dept.status == 'active' ? 'fa-check-circle' : 'fa-times-circle'} me-1"></i>
                                                ${dept.status}
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label">Department Name</label>
                                    <div class="icon-input">
                                        <i class="fas fa-building"></i>
                                        <input type="text" name="departmentName" class="form-control"
                                               value="${dept.departmentName}" required>
                                    </div>
                                </div>

                                <div class="mb-4">
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

                                <div class="mb-4">
                                    <label class="form-label">Status</label>
                                    <select name="status" class="form-select">
                                        <option value="active" ${dept.status == 'active' ? 'selected' : ''}>Active</option>
                                        <option value="inactive" ${dept.status == 'inactive' ? 'selected' : ''}>Inactive</option>
                                    </select>
                                </div>
                            </div>

                            <div class="form-section">
                                <h4 class="mb-4" style="color: #2c3e50;">
                                    <i class="fas fa-users me-2"></i>Employee Management
                                </h4>

                                <div class="mb-4">
                                    <h6 class="fw-bold mb-3">Current Employees (${currentEmployees.size()})</h6>
                                    <c:choose>
                                        <c:when test="${not empty currentEmployees}">
                                            <div class="employee-list">
                                                <c:forEach items="${currentEmployees}" var="emp">
                                                    <div class="employee-item">
                                                        <div>
                                                            <i class="fas fa-user me-2 text-primary"></i>
                                                            <strong>${emp.displayName}</strong>
                                                            <small class="text-muted ms-2">ID: ${emp.userId}</small>
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
                                            <option value="${emp.userId}" selected>${emp.displayName} (ID: ${emp.userId})</option>
                                        </c:forEach>
                                        <c:forEach items="${availableEmployees}" var="emp">
                                            <option value="${emp.userId}">${emp.displayName} (ID: ${emp.userId})</option>
                                        </c:forEach>
                                    </select>
                                    <small class="text-muted">Select or deselect employees to update assignments</small>
                                </div>
                            </div>

                            <div class="d-flex justify-content-between align-items-center mt-5">
                                <a href="${pageContext.request.contextPath}/department-list" class="btn btn-back">
                                    <i class="fas fa-times me-2"></i>Cancel
                                </a>
                                <div>
                                    <button type="submit" class="btn btn-update">
                                        <i class="fas fa-save me-2"></i>Update Department
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
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

        $('.select2-multiple').on('change', function() {
            const selectedCount = $(this).val() ? $(this).val().length : 0;
            $('.employee-count').text(selectedCount);
        });
    });
</script>
</body>
</html>