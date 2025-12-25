<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Employee Evaluation</title>
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
        .rating-stars {
            font-size: 2rem;
            color: #ddd;
            cursor: pointer;
        }
        .rating-stars .star {
            margin: 0 5px;
            transition: color 0.2s;
        }
        .rating-stars .star.active {
            color: #ffc107;
        }
        .criteria-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            border: 2px solid #f0f0f0;
            margin-bottom: 20px;
        }
        .criteria-title {
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 15px;
        }
        .date-range-container {
            background: white;
            padding: 20px;
            border-radius: 10px;
            border: 2px solid #f0f0f0;
            margin-bottom: 20px;
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
        <c:set var="activePage" value="evaluate-list" scope="request"/>
        <jsp:include page="/view/fragments/sidebar.jsp"/>

        <main class="col-md-10 ms-sm-auto px-md-4 main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold mb-1" style="color: #2c3e50;">Add Employee Evaluation</h2>
                    <p class="text-muted">Evaluate an employee's performance for a specific period</p>
                </div>
                <a href="${pageContext.request.contextPath}/evaluate-list" class="btn btn-back">
                    <i class="fas fa-arrow-left me-2"></i>Back to List
                </a>
            </div>

            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0 fw-bold" style="color: #2c3e50;">Evaluation Form</h5>
                </div>

                <div class="card-body p-4">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>
                                ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form method="post" action="evaluate-add">
                        <!-- Basic Information -->
                        <div class="row mb-4">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Employee</label>
                                <div class="icon-input">
                                    <i class="fas fa-user"></i>
                                    <select name="employeeId" class="form-select" required>
                                        <option value="">Select Employee</option>
                                        <c:forEach items="${employees}" var="emp">
                                            <option value="${emp.userId}">${emp.displayName} (ID: ${emp.userId})</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <small class="text-muted">Only employees in your department are shown</small>
                            </div>
                        </div>

                        <!-- Date Range Section -->
                        <div class="date-range-container">
                            <h5 class="criteria-title">
                                <i class="fas fa-calendar-alt me-2"></i>Evaluation Period
                            </h5>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">From Date</label>
                                    <div class="icon-input">
                                        <i class="fas fa-calendar-plus"></i>
                                        <input type="date" name="dateFrom" class="form-control"
                                               value="${dateFrom}" required>
                                    </div>
                                    <small class="text-muted">Start date of evaluation period</small>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">To Date</label>
                                    <div class="icon-input">
                                        <i class="fas fa-calendar-minus"></i>
                                        <input type="date" name="dateTo" class="form-control"
                                               value="${dateTo}" required>
                                    </div>
                                    <small class="text-muted">End date of evaluation period</small>
                                </div>
                            </div>
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle me-2"></i>
                                Period will be formatted as: <span id="periodPreview">Jan 2024</span>
                            </div>
                        </div>

                        <!-- Performance Criteria -->
                        <div class="criteria-card">
                            <h5 class="criteria-title">Performance (1-5)</h5>
                            <p class="text-muted mb-3">Overall work performance and productivity</p>
                            <div class="rating-stars" data-name="performance">
                                <i class="fas fa-star star" data-value="1"></i>
                                <i class="fas fa-star star" data-value="2"></i>
                                <i class="fas fa-star star" data-value="3"></i>
                                <i class="fas fa-star star" data-value="4"></i>
                                <i class="fas fa-star star" data-value="5"></i>
                            </div>
                            <input type="hidden" name="performance" id="performance" value="3" required>
                        </div>

                        <div class="criteria-card">
                            <h5 class="criteria-title">Accuracy (1-5)</h5>
                            <p class="text-muted mb-3">Precision in inventory counts and order processing</p>
                            <div class="rating-stars" data-name="accuracy">
                                <i class="fas fa-star star" data-value="1"></i>
                                <i class="fas fa-star star" data-value="2"></i>
                                <i class="fas fa-star star" data-value="3"></i>
                                <i class="fas fa-star star" data-value="4"></i>
                                <i class="fas fa-star star" data-value="5"></i>
                            </div>
                            <input type="hidden" name="accuracy" id="accuracy" value="3" required>
                        </div>

                        <div class="criteria-card">
                            <h5 class="criteria-title">Safety Compliance (1-5)</h5>
                            <p class="text-muted mb-3">Adherence to warehouse safety protocols</p>
                            <div class="rating-stars" data-name="safetyCompliance">
                                <i class="fas fa-star star" data-value="1"></i>
                                <i class="fas fa-star star" data-value="2"></i>
                                <i class="fas fa-star star" data-value="3"></i>
                                <i class="fas fa-star star" data-value="4"></i>
                                <i class="fas fa-star star" data-value="5"></i>
                            </div>
                            <input type="hidden" name="safetyCompliance" id="safetyCompliance" value="3" required>
                        </div>

                        <div class="criteria-card">
                            <h5 class="criteria-title">Teamwork (1-5)</h5>
                            <p class="text-muted mb-3">Collaboration with colleagues and supervisors</p>
                            <div class="rating-stars" data-name="teamwork">
                                <i class="fas fa-star star" data-value="1"></i>
                                <i class="fas fa-star star" data-value="2"></i>
                                <i class="fas fa-star star" data-value="3"></i>
                                <i class="fas fa-star star" data-value="4"></i>
                                <i class="fas fa-star star" data-value="5"></i>
                            </div>
                            <input type="hidden" name="teamwork" id="teamwork" value="3" required>
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex justify-content-between align-items-center pt-4 border-top">
                            <a href="${pageContext.request.contextPath}/evaluate-list" class="btn btn-back">
                                <i class="fas fa-times me-2"></i>Cancel
                            </a>
                            <button type="submit" class="btn btn-submit">
                                <i class="fas fa-save me-2"></i>Submit Evaluation
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.querySelectorAll('.rating-stars').forEach(starsContainer => {
        const stars = starsContainer.querySelectorAll('.star');
        const hiddenInput = document.getElementById(starsContainer.dataset.name);

        stars.forEach(star => {
            star.addEventListener('click', () => {
                const value = parseInt(star.dataset.value);
                hiddenInput.value = value;

                stars.forEach(s => {
                    const sValue = parseInt(s.dataset.value);
                    if (sValue <= value) {
                        s.classList.add('active');
                        s.classList.remove('far');
                        s.classList.add('fas');
                    } else {
                        s.classList.remove('active');
                        s.classList.remove('fas');
                        s.classList.add('far');
                    }
                });
            });
        });

        const defaultValue = parseInt(hiddenInput.value);
        stars.forEach(star => {
            const sValue = parseInt(star.dataset.value);
            if (sValue <= defaultValue) {
                star.classList.add('active');
                star.classList.remove('far');
                star.classList.add('fas');
            } else {
                star.classList.add('far');
            }
        });
    });

    function formatPeriodPreview() {
        const dateFrom = document.querySelector('input[name="dateFrom"]').value;
        const dateTo = document.querySelector('input[name="dateTo"]').value;

        if (!dateFrom || !dateTo) return;

        const fromDate = new Date(dateFrom);
        const toDate = new Date(dateTo);

        const monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

        const fromStr = monthNames[fromDate.getMonth()] + ' ' + fromDate.getFullYear();
        const toStr = monthNames[toDate.getMonth()] + ' ' + toDate.getFullYear();

        if (fromDate.getMonth() === toDate.getMonth() &&
            fromDate.getFullYear() === toDate.getFullYear()) {
            document.getElementById('periodPreview').textContent = fromStr;
        } else {
            document.getElementById('periodPreview').textContent = fromStr + ' - ' + toStr;
        }
    }

    document.querySelectorAll('input[type="date"]').forEach(input => {
        input.addEventListener('change', formatPeriodPreview);
        input.addEventListener('input', formatPeriodPreview);
    });

    document.addEventListener('DOMContentLoaded', formatPeriodPreview);
</script>
</body>
</html>