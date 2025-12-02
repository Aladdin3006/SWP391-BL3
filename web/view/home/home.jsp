<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Warehouse Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
        }

        .navbar {
            background-color: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .navbar-brand {
            font-weight: bold;
            color: #0d6efd;
        }

        .main-section {
            padding-top: 80px;
            padding-bottom: 40px;
            background-color: #e9ecef;
        }

        .card {
            border: 1px solid #ddd;
            border-radius: 8px;
            transition: box-shadow 0.3s;
            height: 100%;
        }

        .card:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        .feature-icon {
            width: 60px;
            height: 60px;
            background-color: #0d6efd;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
        }

        .feature-icon i {
            color: white;
            font-size: 24px;
        }

        .stats-box {
            background-color: #0d6efd;
            color: white;
            padding: 40px 0;
            margin: 40px 0;
        }

        .stat-number {
            font-size: 36px;
            font-weight: bold;
        }

        .footer {
            background-color: #343a40;
            color: white;
            padding: 40px 0 20px;
        }

        .footer a {
            color: #adb5bd;
            text-decoration: none;
        }

        .footer a:hover {
            color: white;
        }

        .filter-section {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .product-table {
            background-color: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .table thead th {
            background-color: #0d6efd;
            color: white;
            border: none;
        }

        .table tbody tr:hover {
            background-color: #f8f9fa;
        }

        .btn-filter {
            min-width: 120px;
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg fixed-top">
    <div class="container">
        <a class="navbar-brand" href="#">
            <i class="fas fa-warehouse"></i> WMS
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMenu">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarMenu">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="#home">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#products">Products</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#features">Features</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#about">About</a>
                </li>
                <li class="nav-item">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">
                                Dashboard
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">
                                Login
                            </a>
                        </c:otherwise>
                    </c:choose>
                </li>
            </ul>
        </div>
    </div>
</nav>

<section id="home" class="main-section">
    <div class="container">
        <div class="row">
            <div class="col-md-8 mx-auto text-center">
                <h1>Warehouse Management System</h1>
                <p class="lead">
                    Manage generator inventory and orders efficiently with our system.
                </p>

                <div class="mt-4">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary btn-lg">
                                Go to Dashboard
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-lg">
                                Get Started
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</section>

<section id="products" class="py-5">
    <div class="container">
        <h2 class="text-center mb-4">Generator Products</h2>
        <p class="text-center text-muted mb-5">Browse our collection of generator products with search and filter options</p>

        <div class="filter-section">
            <form method="get" action="${pageContext.request.contextPath}/home">
                <div class="row g-3">
                    <div class="col-md-3">
                        <input type="text" class="form-control" name="search" placeholder="Search product or code..." value="${param.search}">
                    </div>
                    <div class="col-md-2">
                        <select class="form-select" name="category">
                            <option value="">All Categories</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat}" ${param.category == cat ? 'selected' : ''}>${cat}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <select class="form-select" name="company">
                            <option value="">All Companies</option>
                            <c:forEach var="comp" items="${companies}">
                                <option value="${comp}" ${param.company == comp ? 'selected' : ''}>${comp}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <select class="form-select" name="brand">
                            <option value="">All Brands</option>
                            <c:forEach var="br" items="${brands}">
                                <option value="${br}" ${param.brand == br ? 'selected' : ''}>${br}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <button type="submit" class="btn btn-primary btn-filter">Filter</button>
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary">Clear</a>
                    </div>
                </div>
            </form>
        </div>

        <div class="product-table">
            <table class="table table-hover">
                <thead>
                <tr>
                    <th>Product Code</th>
                    <th>Name</th>
                    <th>Brand</th>
                    <th>Company</th>
                    <th>Category</th>
                    <th>Unit</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="product" items="${products}">
                    <tr>
                        <td>${product.productCode}</td>
                        <td>${product.name}</td>
                        <td>${product.brand}</td>
                        <td>${product.company}</td>
                        <td>${product.categoryName}</td>
                        <td>${product.unit}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty products}">
                    <tr>
                        <td colspan="6" class="text-center py-4">No products found</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>

        <div class="text-center mt-4">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary btn-lg">
                        Go to Dashboard for More Features
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-lg">
                        Login to Manage Products
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</section>

<section id="features" class="py-5">
    <div class="container">
        <h2 class="text-center mb-5">Features</h2>

        <div class="row g-4">
            <div class="col-md-4">
                <div class="card p-4">
                    <div class="feature-icon">
                        <i class="fas fa-boxes"></i>
                    </div>
                    <h4 class="text-center">Inventory</h4>
                    <p class="text-center">
                        Track generator stock levels in real-time.
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card p-4">
                    <div class="feature-icon">
                        <i class="fas fa-clipboard-check"></i>
                    </div>
                    <h4 class="text-center">Orders</h4>
                    <p class="text-center">
                        Process generator orders efficiently.
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card p-4">
                    <div class="feature-icon">
                        <i class="fas fa-chart-line"></i>
                    </div>
                    <h4 class="text-center">Reports</h4>
                    <p class="text-center">
                        View detailed generator reports.
                    </p>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="stats-box">
    <div class="container">
        <div class="row text-center">
            <div class="col-md-3 col-6 mb-3">
                <div class="stat-number">${empty products ? '0' : products.size()}</div>
                <div>Products</div>
            </div>
            <div class="col-md-3 col-6 mb-3">
                <div class="stat-number">10K+</div>
                <div>Transactions</div>
            </div>
            <div class="col-md-3 col-6 mb-3">
                <div class="stat-number">99%</div>
                <div>Accuracy</div>
            </div>
            <div class="col-md-3 col-6 mb-3">
                <div class="stat-number">24/7</div>
                <div>Support</div>
            </div>
        </div>
    </div>
</section>

<section id="about" class="py-5">
    <div class="container">
        <div class="row">
            <div class="col-md-6">
                <h2>About WMS</h2>
                <p>
                    Our system helps businesses manage warehouse operations for generator products.
                </p>
                <p>
                    Track generator inventory, process orders, and view reports.
                </p>

                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">
                    Start Free Trial
                </a>
            </div>

            <div class="col-md-6 mt-4 mt-md-0">
                <div class="card p-4">
                    <h4>Benefits</h4>
                    <ul class="list-unstyled">
                        <li class="mb-2">
                            <i class="fas fa-check text-success me-2"></i>
                            Reduce Generator Costs
                        </li>
                        <li class="mb-2">
                            <i class="fas fa-check text-success me-2"></i>
                            Improve Inventory Accuracy
                        </li>
                        <li class="mb-2">
                            <i class="fas fa-check text-success me-2"></i>
                            Save Time on Orders
                        </li>
                        <li class="mb-2">
                            <i class="fas fa-check text-success me-2"></i>
                            Better Business Decisions
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</section>

<footer class="footer">
    <div class="container">
        <div class="row">
            <div class="col-md-4 mb-4">
                <h5>WMS</h5>
                <p>
                    Warehouse Management System for generator businesses.
                </p>
            </div>

            <div class="col-md-2 mb-4">
                <h6>Links</h6>
                <ul class="list-unstyled">
                    <li><a href="#home">Home</a></li>
                    <li><a href="#products">Products</a></li>
                    <li><a href="#features">Features</a></li>
                    <li><a href="#about">About</a></li>
                </ul>
            </div>

            <div class="col-md-3 mb-4">
                <h6>Contact</h6>
                <ul class="list-unstyled">
                    <li>SWP391 University</li>
                    <li>HCMC, Vietnam</li>
                    <li>support@wms.com</li>
                </ul>
            </div>

            <div class="col-md-3 mb-4">
                <h6>Services</h6>
                <ul class="list-unstyled">
                    <li><a href="#">Generator Inventory</a></li>
                    <li><a href="#">Orders Management</a></li>
                    <li><a href="#">Product Reports</a></li>
                </ul>
            </div>
        </div>

        <div class="text-center pt-3 border-top">
            <p>&copy; 2024 WMS. All rights reserved.</p>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"></script>

<script>
    document.querySelectorAll('a[href^="#"]').forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if(target) {
                window.scrollTo({
                    top: target.offsetTop - 70,
                    behavior: 'smooth'
                });
            }
        });
    });
</script>
</body>
</html>