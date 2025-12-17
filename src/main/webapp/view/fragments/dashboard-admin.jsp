<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - WMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .sidebar { background-color: #343a40; color: white; min-height: calc(100vh - 56px); padding-top: 20px; }
        .sidebar .nav-link { color: rgba(255, 255, 255, 0.8); padding: 10px 15px; }
        .sidebar .nav-link:hover { color: white; background-color: rgba(255, 255, 255, 0.1); }
        .sidebar .nav-link.active { color: white; background-color: #0d6efd; }

        .card {
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border: none;
            margin-bottom: 20px;
        }

        .stat-card {
            border-left: 4px solid;
            height: 100%;
        }

        .stat-card.total-users { border-color: #3498db; }
        .stat-card.active-users { border-color: #2ecc71; }
        .stat-card.inactive-users { border-color: #e74c3c; }
        .stat-card.roles { border-color: #9b59b6; }

        .welcome-card {
            background: linear-gradient(135deg, #3498db 0%, #2c3e50 100%);
            color: white;
        }

        .chart-container {
            position: relative;
            height: 300px;
            width: 100%;
        }

        .chart-container-doughnut {
            position: relative;
            height: 250px;
            width: 250px;
            margin: 0 auto;
        }

        .page-title {
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 0;
        }

        .border-bottom-custom {
            border-bottom: 1px solid #dee2e6;
            padding-bottom: 15px;
            margin-bottom: 20px;
        }

        .stat-icon {
            font-size: 2.5rem;
            opacity: 0.7;
        }

        .stat-number {
            font-size: 2.2rem;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .stat-label {
            font-size: 0.9rem;
            color: #6c757d;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 600;
        }

        .stat-subtext {
            font-size: 0.85rem;
            color: #adb5bd;
            margin-top: 5px;
        }

        .card-header {
            background-color: white;
            border-bottom: 1px solid rgba(0,0,0,.125);
            padding: 1rem 1.25rem;
            font-weight: 600;
        }

        .card-header h5 {
            margin: 0;
            color: #2c3e50;
        }
    </style>
</head>
<body>
<jsp:include page="/view/fragments/navbar.jsp"/>

<div class="container-fluid">
    <div class="row">
        <c:set var="activePage" value="dashboard-admin" scope="request"/>
        <jsp:include page="/view/fragments/sidebar.jsp"/>

        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 pt-3">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center border-bottom-custom">
                <h1 class="h2 page-title">Admin Dashboard</h1>
            </div>

            <div class="row mb-4">
                <div class="col-12">
                    <div class="card welcome-card">
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col-md-8">
                                    <h4 class="mb-2">Administrator Control Panel</h4>
                                    <p class="mb-0">Welcome back, ${sessionScope.user.displayName}! Manage users, roles, permissions, and system settings from this centralized dashboard.</p>
                                </div>
                                <div class="col-md-4 text-end">
                                    <i class="fas fa-user-shield fa-4x opacity-75"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mb-4">
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card stat-card total-users">
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col-8">
                                    <div class="stat-label">Total Users</div>
                                    <div class="stat-number">${totalUsers}</div>
                                    <div class="stat-subtext">All registered users</div>
                                </div>
                                <div class="col-4 text-end">
                                    <i class="fas fa-users stat-icon text-primary"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card stat-card active-users">
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col-8">
                                    <div class="stat-label">Active Users</div>
                                    <div class="stat-number">${activeUsers}</div>
                                    <div class="stat-subtext">Currently active</div>
                                </div>
                                <div class="col-4 text-end">
                                    <i class="fas fa-user-check stat-icon text-success"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card stat-card inactive-users">
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col-8">
                                    <div class="stat-label">Inactive Users</div>
                                    <div class="stat-number">${inactiveUsers}</div>
                                    <div class="stat-subtext">Pending activation</div>
                                </div>
                                <div class="col-4 text-end">
                                    <i class="fas fa-user-clock stat-icon text-danger"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card stat-card roles">
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col-8">
                                    <div class="stat-label">Roles</div>
                                    <div class="stat-number">${allRoles.size()}</div>
                                    <div class="stat-subtext">User roles defined</div>
                                </div>
                                <div class="col-4 text-end">
                                    <i class="fas fa-user-tag stat-icon" style="color: #9b59b6;"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mb-4">
                <div class="col-lg-8 mb-4">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">User Distribution by Role</h5>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <canvas id="roleChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4 mb-4">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">User Status</h5>
                        </div>
                        <div class="card-body">
                            <div class="chart-container-doughnut">
                                <canvas id="statusChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">Quick Actions</h5>
                        </div>
                        <div class="card-body">
                            <div class="row g-3">
                                <div class="col-md-3">
                                    <a href="${pageContext.request.contextPath}/user-list" class="btn btn-primary w-100 py-3 d-flex flex-column align-items-center justify-content-center">
                                        <i class="fas fa-users fa-2x mb-2"></i>
                                        <span>Manage Users</span>
                                    </a>
                                </div>
                                <div class="col-md-3">
                                    <a href="${pageContext.request.contextPath}/view-role-list" class="btn btn-success w-100 py-3 d-flex flex-column align-items-center justify-content-center">
                                        <i class="fas fa-user-tag fa-2x mb-2"></i>
                                        <span>Manage Roles</span>
                                    </a>
                                </div>
                                <div class="col-md-3">
                                    <a href="${pageContext.request.contextPath}/permission" class="btn btn-info w-100 py-3 d-flex flex-column align-items-center justify-content-center">
                                        <i class="fas fa-key fa-2x mb-2"></i>
                                        <span>Manage Permissions</span>
                                    </a>
                                </div>
                                <div class="col-md-3">
                                    <a href="${pageContext.request.contextPath}/user/adduser" class="btn btn-warning w-100 py-3 d-flex flex-column align-items-center justify-content-center">
                                        <i class="fas fa-user-plus fa-2x mb-2"></i>
                                        <span>Add New User</span>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script>
    const roleLabels = [];
    const roleData = [];

    <c:forEach var="entry" items="${usersByRole}">
    roleLabels.push('${entry.key}');
    roleData.push(${entry.value});
    </c:forEach>

    const roleColors = [
        '#3498db', '#2ecc71', '#e74c3c', '#f39c12',
        '#9b59b6', '#1abc9c', '#d35400', '#34495e'
    ];

    const roleChartCtx = document.getElementById('roleChart').getContext('2d');
    new Chart(roleChartCtx, {
        type: 'bar',
        data: {
            labels: roleLabels,
            datasets: [{
                label: 'Users',
                data: roleData,
                backgroundColor: roleColors.slice(0, roleLabels.length),
                borderColor: roleColors.slice(0, roleLabels.length),
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        stepSize: 1,
                        precision: 0
                    }
                }
            },
            plugins: {
                legend: {
                    display: false
                },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return `\${context.dataset.label}: \${context.parsed.y} users`;
                        }
                    }
                }
            }
        }
    });

    const statusChartCtx = document.getElementById('statusChart').getContext('2d');
    new Chart(statusChartCtx, {
        type: 'doughnut',
        data: {
            labels: ['Active', 'Inactive'],
            datasets: [{
                data: [${activeUsers}, ${inactiveUsers}],
                backgroundColor: ['#2ecc71', '#e74c3c'],
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '70%',
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        padding: 20,
                        usePointStyle: true
                    }
                },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            const total = ${activeUsers + inactiveUsers};
                            const percentage = Math.round((context.parsed / total) * 100);
                            return `\${context.label}: \${context.parsed} users (\${percentage}%)`;
                        }
                    }
                }
            }
        }
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>