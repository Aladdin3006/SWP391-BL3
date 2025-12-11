<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add New Department</title>
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
            transition: transform 0.3s ease;
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
        }
        .btn-submit:hover {
            transform: translateY(-2px);
        }
        .btn-back {
            padding: 10px 20px;
            border-radius: 10px;
            font-weight: 500;
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

        <main class="col-md-10 ms-sm-auto px-md-4 main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold mb-1" style="color: #2c3e50;">Add New Department</h2>
                    <p class="text-muted">Create a new department for your organization</p>
                </div>
                <a href="../department-list" class="btn btn-outline-secondary"
                   style="padding: 10px 20px; border-radius: 10px; font-weight: 500;">
                    <i class="fas fa-arrow-left me-2"></i>Back to List
                </a>
            </div>

            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0 fw-bold" style="color: #2c3e50;">Department Information</h5>
                </div>

                <div class="card-body p-4">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>
                                ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form method="post" action="department-add">
                        <!-- Basic Information Section -->
                        <div class="mb-5">
                            <h4 class="section-title">
                                <i class="fas fa-info-circle me-2"></i>Basic Information
                            </h4>

                            <div class="row">
                                <div class="col-md-6 mb-4">
                                    <label class="form-label">Department Name</label>
                                    <div class="icon-input">
                                        <i class="fas fa-building"></i>
                                        <input type="text" name="departmentName" class="form-control"
                                               placeholder="Enter department name" required>
                                    </div>
                                </div>

                                <div class="col-md-6 mb-4">
                                    <label class="form-label">Storekeeper</label>
                                    <div class="icon-input">
                                        <i class="fas fa-user-tie"></i>
                                        <select name="storekeeperId" class="form-select" required>
                                            <option value="">Select a storekeeper</option>
                                            <c:forEach items="${storekeepers}" var="sk">
                                                <option value="${sk.userId}">
                                                        ${sk.displayName} (ID: ${sk.userId})
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <small class="text-muted">Only available storekeepers are shown</small>
                                </div>
                            </div>
                        </div>

                        <!-- Assign Employees Section -->
                        <div class="mb-5">
                            <h4 class="section-title">
                                <i class="fas fa-users me-2"></i>Assign Employees
                            </h4>

                            <div class="mb-4">
                                <label class="form-label">Select Employees</label>
                                <select name="employeeIds" class="form-control select2-multiple" multiple="multiple">
                                    <c:forEach items="${employees}" var="emp">
                                        <option value="${emp.userId}">
                                                ${emp.displayName} (ID: ${emp.userId})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex justify-content-between align-items-center pt-4 border-top">
                            <a href="../department-list" class="btn btn-back btn-outline-secondary">
                                <i class="fas fa-times me-2"></i>Cancel
                            </a>
                            <button type="submit" class="btn btn-submit">
                                <i class="fas fa-save me-2"></i>Create Department
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