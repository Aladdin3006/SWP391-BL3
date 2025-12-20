<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manager Dashboard - WMS</title>
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
            transition: transform 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-card.products { border-color: #3498db; }
        .stat-card.suppliers { border-color: #2ecc71; }
        .stat-card.departments { border-color: #9b59b6; }
        .stat-card.inventory { border-color: #e74c3c; }
        .stat-card.staff { border-color: #f39c12; }
        .stat-card.low-stock { border-color: #e74c3c; }

        .welcome-card {
            background: linear-gradient(135deg, #2ecc71 0%, #27ae60 100%);
            color: white;
        }

        .chart-container {
            position: relative;
            height: 300px;
            width: 100%;
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

        .alert-low-stock {
            background-color: #fff3cd;
            border-color: #ffeaa7;
            color: #856404;
            padding: 10px 15px;
            border-radius: 6px;
            margin-bottom: 15px;
        }

        .quick-action-btn {
            padding: 15px;
            text-align: center;
            border-radius: 8px;
            background: white;
            color: #2c3e50;
            text-decoration: none;
            display: block;
            transition: all 0.3s ease;
            border: 1px solid #e9ecef;
        }

        .quick-action-btn:hover {
            background-color: #f8f9fa;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            text-decoration: none;
            color: #2c3e50;
        }

        .quick-action-icon {
            font-size: 2rem;
            margin-bottom: 10px;
            display: block;
        }

        .product-status-badge {
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .status-active { background-color: #d4edda; color: #155724; }
        .status-inactive { background-color: #f8d7da; color: #721c24; }
        .status-low { background-color: #fff3cd; color: #856404; }

        .month-indicator {
            background: linear-gradient(135deg, #3498db 0%, #2c3e50 100%);
            color: white;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .metric-change {
            font-size: 0.85rem;
            padding: 2px 8px;
            border-radius: 10px;
            display: inline-block;
            margin-left: 5px;
        }

        .metric-change.positive {
            background-color: #d4edda;
            color: #155724;
        }

        .metric-change.negative {
            background-color: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>
<jsp:include page="/view/fragments/navbar.jsp"/>

<div class="container-fluid">
    <div class="row">
        <c:set var="activePage" value="dashboard-manager" scope="request"/>
        <jsp:include page="/view/fragments/sidebar.jsp"/>

        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 pt-3">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center border-bottom-custom">
                <h1 class="h2 page-title">Manager Dashboard</h1>
                <div class="month-indicator">
                    <i class="fas fa-calendar-alt me-2"></i>
                    ${currentMonth} ${currentYear} Report
                </div>
            </div>

            <div class="row mb-4">
                <div class="col-12">
                    <div class="card welcome-card">
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col-md-8">
                                    <h4 class="mb-2">Warehouse Management Overview</h4>
                                    <p class="mb-0">Welcome back, ${sessionScope.user.displayName}! Monitor and manage warehouse operations, inventory, and team performance.</p>
                                </div>
                                <div class="col-md-4 text-end">
                                    <i class="fas fa-chart-line fa-4x opacity-75"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mb-4">
                <div class="col-xl-2 col-md-4 mb-4">
                    <div class="card stat-card products">
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col-8">
                                    <div class="stat-label">Total Products</div>
                                    <div class="stat-number">${totalProducts}</div>
                                    <div class="stat-subtext">
                                        <span class="metric-change positive">${activeProducts} active</span>
                                    </div>
                                </div>
                                <div class="col-4 text-end">
                                    <i class="fas fa-boxes stat-icon text-primary"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-2 col-md-4 mb-4">
                    <div class="card stat-card suppliers">
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col-8">
                                    <div class="stat-label">Suppliers</div>
                                    <div class="stat-number">${totalSuppliers}</div>
                                    <div class="stat-subtext">
                                        <span class="metric-change positive">${activeSuppliers} active</span>
                                    </div>
                                </div>
                                <div class="col-4 text-end">
                                    <i class="fas fa-truck stat-icon text-success"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-2 col-md-4 mb-4">
                    <div class="card stat-card departments">
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col-8">
                                    <div class="stat-label">Departments</div>
                                    <div class="stat-number">${totalDepartments}</div>
                                    <div class="stat-subtext">
                                        <span class="metric-change positive">${activeDepartments} active</span>
                                    </div>
                                </div>
                                <div class="col-4 text-end">
                                    <i class="fas fa-building stat-icon" style="color: #9b59b6;"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-2 col-md-4 mb-4">
                    <div class="card stat-card inventory">
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col-8">
                                    <div class="stat-label">Monthly Imports</div>
                                    <div class="stat-number">${monthlyImports}</div>
                                    <div class="stat-subtext">Units this month</div>
                                </div>
                                <div class="col-4 text-end">
                                    <i class="fas fa-download stat-icon text-danger"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-2 col-md-4 mb-4">
                    <div class="card stat-card inventory">
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col-8">
                                    <div class="stat-label">Monthly Exports</div>
                                    <div class="stat-number">${monthlyExports}</div>
                                    <div class="stat-subtext">Units this month</div>
                                </div>
                                <div class="col-4 text-end">
                                    <i class="fas fa-upload stat-icon text-warning"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mb-4">
                <div class="col-lg-8 mb-4">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">Inventory Movement - ${currentMonth} ${currentYear}</h5>
                            <div>
                                <span class="badge bg-primary me-2">Imports: ${monthlyImports}</span>
                                <span class="badge bg-success">Exports: ${monthlyExports}</span>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <canvas id="inventoryChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4 mb-4">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">Staff Overview</h5>
                        </div>
                        <div class="card-body">
                            <div class="mb-4">
                                <h6 class="text-muted mb-3">Department Staff</h6>
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Total Employees in Departments:</span>
                                    <strong>${totalEmployeesInDepartments}</strong>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Storekeepers:</span>
                                    <strong>${totalStorekeepers}</strong>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <span>All Employees:</span>
                                    <strong>${totalEmployeesAll}</strong>
                                </div>
                            </div>

                            <div class="mt-4 pt-3 border-top">
                                <h6 class="text-muted mb-3">Product Status</h6>
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Active Products:</span>
                                    <span class="badge bg-success">${activeProducts}</span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Inactive Products:</span>
                                    <span class="badge bg-secondary">${inactiveProducts}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">Quick Actions</h5>
                        </div>
                        <div class="card-body">
                            <div class="row g-3">
                                <div class="col-md-2">
                                    <a href="${pageContext.request.contextPath}/view-inventory" class="quick-action-btn">
                                        <i class="fas fa-chart-bar quick-action-icon text-primary"></i>
                                        <span>Inventory Report</span>
                                    </a>
                                </div>
                                <div class="col-md-2">
                                    <a href="${pageContext.request.contextPath}/view-product-list" class="quick-action-btn">
                                        <i class="fas fa-boxes quick-action-icon text-success"></i>
                                        <span>Manage Products</span>
                                    </a>
                                </div>
                                <div class="col-md-2">
                                    <a href="${pageContext.request.contextPath}/supplier-list" class="quick-action-btn">
                                        <i class="fas fa-truck quick-action-icon text-info"></i>
                                        <span>Manage Suppliers</span>
                                    </a>
                                </div>
                                <div class="col-md-2">
                                    <a href="${pageContext.request.contextPath}/department-list" class="quick-action-btn">
                                        <i class="fas fa-building quick-action-icon" style="color: #9b59b6;"></i>
                                        <span>Manage Departments</span>
                                    </a>
                                </div>
                                <div class="col-md-2">
                                    <a href="${pageContext.request.contextPath}/import-warehouse-report" class="quick-action-btn">
                                        <i class="fas fa-download quick-action-icon text-danger"></i>
                                        <span>Import Reports</span>
                                    </a>
                                </div>
                                <div class="col-md-2">
                                    <a href="${pageContext.request.contextPath}/export-warehouse-report" class="quick-action-btn">
                                        <i class="fas fa-upload quick-action-icon text-warning"></i>
                                        <span>Export Reports</span>
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
    document.addEventListener('DOMContentLoaded', function() {
        const inventoryChartCtx = document.getElementById('inventoryChart').getContext('2d');
        const monthlyImports = ${monthlyImports};
        const monthlyExports = ${monthlyExports};
        const currentMonth = '${currentMonth}';
        const currentYear = ${currentYear};

        if(monthlyImports === 0 && monthlyExports === 0) {
            document.getElementById('inventoryChart').style.display = 'none';
            document.querySelector('#inventoryChart').parentElement.innerHTML = `
                <div class="text-center py-5">
                    <i class="fas fa-chart-bar fa-3x text-muted mb-3"></i>
                    <p class="text-muted mb-0">No inventory movement data available for ${currentMonth} ${currentYear}.</p>
                    <small class="text-muted">Data will appear once imports or exports are recorded.</small>
                </div>
            `;
        } else {
            new Chart(inventoryChartCtx, {
                type: 'bar',
                data: {
                    labels: ['Imports', 'Exports'],
                    datasets: [{
                        label: 'Units',
                        data: [monthlyImports, monthlyExports],
                        backgroundColor: [
                            'rgba(52, 152, 219, 0.7)',
                            'rgba(46, 204, 113, 0.7)'
                        ],
                        borderColor: [
                            'rgb(52, 152, 219)',
                            'rgb(46, 204, 113)'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Units'
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
                                    return `${context.label}: ${context.parsed.y} units`;
                                }
                            }
                        }
                    }
                }
            });
        }
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>