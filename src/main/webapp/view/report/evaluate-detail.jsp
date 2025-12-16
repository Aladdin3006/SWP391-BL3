<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Evaluation Details</title>
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
        .info-card {
            background: white;
            padding: 25px;
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
            width: 70px;
            height: 70px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 1.8rem;
            color: white;
        }
        .info-icon.employee {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .info-icon.evaluator {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }
        .info-icon.period {
            background: linear-gradient(135deg, #f6d365 0%, #fda085 100%);
        }
        .info-icon.rating {
            background: linear-gradient(135deg, #42e695 0%, #3bb2b8 100%);
        }
        .info-title {
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 5px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .info-value {
            color: #2c3e50;
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 5px;
        }
        .criteria-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            border: 1px solid #e9ecef;
            margin-bottom: 15px;
            transition: all 0.3s ease;
        }
        .criteria-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
        }
        .criteria-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        .criteria-name {
            font-weight: 600;
            color: #2c3e50;
            font-size: 1.1rem;
        }
        .criteria-rating {
            font-size: 1.2rem;
            font-weight: 700;
        }
        .rating-5 { color: #28a745; }
        .rating-4 { color: #20c997; }
        .rating-3 { color: #ffc107; }
        .rating-2 { color: #fd7e14; }
        .rating-1 { color: #dc3545; }
        .progress-bar-custom {
            border-radius: 10px;
            height: 10px;
            overflow: hidden;
        }
        .star-rating-large {
            font-size: 2rem;
            color: #ffc107;
            text-align: center;
            margin: 10px 0;
        }
        .sidebar { background-color: #343a40; color: white; min-height: calc(100vh - 56px); padding-top: 20px; }
        .sidebar .nav-link { color: rgba(255, 255, 255, 0.8); padding: 10px 15px; }
        .sidebar .nav-link:hover { color: white; background-color: rgba(255, 255, 255, 0.1); }
        .sidebar .nav-link.active { color: white; background-color: #0d6efd; }
        .action-buttons {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 20px;
            border-top: 2px solid #f0f0f0;
            margin-top: 20px;
        }
        .evaluation-date {
            color: #6c757d;
            font-size: 0.9rem;
        }
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
                    <h2 class="fw-bold mb-1" style="color: #2c3e50;">Evaluation Details</h2>
                    <p class="text-muted">Complete evaluation information</p>
                </div>
                <a href="${pageContext.request.contextPath}/evaluate-list" class="btn btn-back">
                    <i class="fas fa-arrow-left me-2"></i>Back to List
                </a>
            </div>

            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0 fw-bold" style="color: #2c3e50;">Evaluation #${eval.id}</h5>
                </div>

                <div class="card-body p-4">
                    <div class="row mb-5">
                        <div class="col-md-3 mb-4">
                            <div class="info-card">
                                <div class="info-icon employee">
                                    <i class="fas fa-user"></i>
                                </div>
                                <div class="info-title">Employee</div>
                                <div class="info-value">${eval.employee.displayName}</div>
                                <small class="text-muted">ID: ${eval.employeeId}</small>
                            </div>
                        </div>

                        <div class="col-md-3 mb-4">
                            <div class="info-card">
                                <div class="info-icon evaluator">
                                    <i class="fas fa-user-tie"></i>
                                </div>
                                <div class="info-title">Evaluator</div>
                                <div class="info-value">${evaluatorName}</div>
                            </div>
                        </div>

                        <div class="col-md-3 mb-4">
                            <div class="info-card">
                                <div class="info-icon period">
                                    <i class="fas fa-calendar"></i>
                                </div>
                                <div class="info-title">Period</div>
                                <div class="info-value">${eval.period}</div>
                                <div class="evaluation-date">
                                    <i class="fas fa-clock me-1"></i>
                                    <fmt:formatDate value="${eval.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                </div>
                            </div>
                        </div>

                        <div class="col-md-3 mb-4">
                            <div class="info-card">
                                <div class="info-icon rating">
                                    <i class="fas fa-star"></i>
                                </div>
                                <div class="info-title">Average Rating</div>
                                <div class="info-value">
                                    ${String.format("%.1f", eval.avgStar)}
                                </div>
                                <div class="star-rating-large">
                                    <c:forEach begin="1" end="5" var="i">
                                        <c:choose>
                                            <c:when test="${i <= eval.avgStar}">
                                                <i class="fas fa-star"></i>
                                            </c:when>
                                            <c:when test="${i - 0.5 <= eval.avgStar}">
                                                <i class="fas fa-star-half-alt"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="far fa-star"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row mb-5">
                        <div class="col-12">
                            <div class="card" style="border: 2px solid #e8f4ff;">
                                <div class="card-header bg-white" style="border-bottom: 2px solid #e8f4ff;">
                                    <h5 class="mb-0 fw-bold" style="color: #2c3e50;">
                                        <i class="fas fa-chart-bar me-2"></i>Evaluation Criteria
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="criteria-card">
                                        <div class="criteria-header">
                                            <div>
                                                <div class="criteria-name">Performance</div>
                                                <small class="text-muted">Overall work performance and productivity</small>
                                            </div>
                                            <div class="criteria-rating rating-${eval.performance}">
                                                ${eval.performance}/5
                                            </div>
                                        </div>
                                        <div class="progress-bar-custom bg-light">
                                            <div class="progress-bar bg-success" style="width: ${eval.performance * 20}%; height: 10px;"></div>
                                        </div>
                                    </div>

                                    <div class="criteria-card">
                                        <div class="criteria-header">
                                            <div>
                                                <div class="criteria-name">Accuracy</div>
                                                <small class="text-muted">Precision in inventory counts and order processing</small>
                                            </div>
                                            <div class="criteria-rating rating-${eval.accuracy}">
                                                ${eval.accuracy}/5
                                            </div>
                                        </div>
                                        <div class="progress-bar-custom bg-light">
                                            <div class="progress-bar bg-info" style="width: ${eval.accuracy * 20}%; height: 10px;"></div>
                                        </div>
                                    </div>

                                    <div class="criteria-card">
                                        <div class="criteria-header">
                                            <div>
                                                <div class="criteria-name">Safety Compliance</div>
                                                <small class="text-muted">Adherence to warehouse safety protocols</small>
                                            </div>
                                            <div class="criteria-rating rating-${eval.safetyCompliance}">
                                                ${eval.safetyCompliance}/5
                                            </div>
                                        </div>
                                        <div class="progress-bar-custom bg-light">
                                            <div class="progress-bar bg-warning" style="width: ${eval.safetyCompliance * 20}%; height: 10px;"></div>
                                        </div>
                                    </div>

                                    <div class="criteria-card">
                                        <div class="criteria-header">
                                            <div>
                                                <div class="criteria-name">Teamwork</div>
                                                <small class="text-muted">Collaboration with colleagues and supervisors</small>
                                            </div>
                                            <div class="criteria-rating rating-${eval.teamwork}">
                                                ${eval.teamwork}/5
                                            </div>
                                        </div>
                                        <div class="progress-bar-custom bg-light">
                                            <div class="progress-bar bg-primary" style="width: ${eval.teamwork * 20}%; height: 10px;"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row mb-5">
                        <div class="col-12">
                            <div class="card" style="border: 2px solid #e8f4ff;">
                                <div class="card-header bg-white" style="border-bottom: 2px solid #e8f4ff;">
                                    <h5 class="mb-0 fw-bold" style="color: #2c3e50;">
                                        <i class="fas fa-building me-2"></i>Department Information
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="d-flex align-items-center mb-3">
                                                <div class="bg-primary rounded-circle d-flex align-items-center justify-content-center me-3"
                                                     style="width: 50px; height: 50px; color: white;">
                                                    <i class="fas fa-building"></i>
                                                </div>
                                                <div>
                                                    <h6 class="mb-0 fw-bold" style="color: #2c3e50;">Department</h6>
                                                    <p class="mb-0 text-muted">${departmentName}</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="d-flex align-items-center mb-3">
                                                <div class="bg-info rounded-circle d-flex align-items-center justify-content-center me-3"
                                                     style="width: 50px; height: 50px; color: white;">
                                                    <i class="fas fa-user-tie"></i>
                                                </div>
                                                <div>
                                                    <h6 class="mb-0 fw-bold" style="color: #2c3e50;">Evaluator Role</h6>
                                                    <p class="mb-0 text-muted">Storekeeper</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="action-buttons">
                        <div>
                            <a href="${pageContext.request.contextPath}/evaluate-update?id=${eval.id}" class="btn btn-edit">
                                <i class="fas fa-edit me-2"></i>Edit Evaluation
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