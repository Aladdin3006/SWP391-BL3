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
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
        }

        .main-section {
            padding-top: 60px;
            padding-bottom: 80px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .hero-content {
            max-width: 600px;
        }

        .hero-image {
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            max-width: 100%;
            height: auto;
        }

        .card {
            border: 1px solid #ddd;
            border-radius: 10px;
            transition: all 0.3s ease;
            height: 100%;
            border: none;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }

        .feature-icon {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
        }

        .feature-icon i {
            color: white;
            font-size: 30px;
        }

        .stats-box {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            color: white;
            padding: 60px 0;
            margin: 60px 0;
        }

        .stat-number {
            font-size: 48px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .stat-label {
            font-size: 16px;
            opacity: 0.9;
        }

        .footer {
            background-color: #2c3e50;
            color: white;
            padding: 60px 0 30px;
        }

        .footer a {
            color: #bdc3c7;
            text-decoration: none;
            transition: color 0.3s;
        }

        .footer a:hover {
            color: white;
        }

        .product-showcase {
            background-color: white;
            border-radius: 15px;
            padding: 30px;
            margin: 40px 0;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        .product-category {
            margin-bottom: 30px;
        }

        .category-title {
            font-size: 24px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 3px solid #667eea;
        }

        .btn-custom {
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s;
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(102, 126, 234, 0.4);
        }

        .highlight-box {
            background: linear-gradient(135deg, #3498db 0%, #2ecc71 100%);
            color: white;
            padding: 40px;
            border-radius: 15px;
            margin: 40px 0;
        }
    </style>
</head>
<body>
<jsp:include page="../fragments/navbar.jsp"/>

<section id="home" class="main-section">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-6">
                <div class="hero-content">
                    <h1 class="display-4 fw-bold mb-4">PC Accessories Warehouse Management System</h1>
                    <p class="lead mb-4">Streamline your PC components and accessories inventory with our powerful warehouse management solution.</p>
                    <div class="mt-4">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-custom btn-primary-custom btn-lg me-3">
                                    Get Started
                                </a>
                                <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-light btn-custom btn-lg">
                                    Register
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="text-center">
                    <img src="${pageContext.request.contextPath}/images/banner-home.png" alt="Warehouse Management System" class="hero-image">
                </div>
            </div>
        </div>
    </div>
</section>

<section id="products" class="py-5">
    <div class="container">
        <h2 class="text-center mb-5 display-5 fw-bold">PC Accessories We Manage</h2>

        <div class="product-showcase">
            <div class="row">
                <div class="col-md-4 product-category">
                    <h3 class="category-title">Computer Components</h3>
                    <ul class="list-unstyled">
                        <li class="mb-2"><i class="fas fa-microchip text-primary me-2"></i>Processors (CPU)</li>
                        <li class="mb-2"><i class="fas fa-memory text-primary me-2"></i>Memory (RAM)</li>
                        <li class="mb-2"><i class="fas fa-hdd text-primary me-2"></i>Storage Drives</li>
                        <li class="mb-2"><i class="fas fa-desktop text-primary me-2"></i>Graphics Cards (GPU)</li>
                        <li class="mb-2"><i class="fas fa-server text-primary me-2"></i>Motherboards</li>
                    </ul>
                </div>
                <div class="col-md-4 product-category">
                    <h3 class="category-title">Peripherals</h3>
                    <ul class="list-unstyled">
                        <li class="mb-2"><i class="fas fa-keyboard text-primary me-2"></i>Keyboards</li>
                        <li class="mb-2"><i class="fas fa-mouse text-primary me-2"></i>Mice & Pointing Devices</li>
                        <li class="mb-2"><i class="fas fa-headphones text-primary me-2"></i>Headsets & Speakers</li>
                        <li class="mb-2"><i class="fas fa-tv text-primary me-2"></i>Monitors & Displays</li>
                        <li class="mb-2"><i class="fas fa-print text-primary me-2"></i>Printers & Scanners</li>
                    </ul>
                </div>
                <div class="col-md-4 product-category">
                    <h3 class="category-title">Networking & Accessories</h3>
                    <ul class="list-unstyled">
                        <li class="mb-2"><i class="fas fa-wifi text-primary me-2"></i>Networking Equipment</li>
                        <li class="mb-2"><i class="fas fa-bolt text-primary me-2"></i>Power Supplies & UPS</li>
                        <li class="mb-2"><i class="fas fa-usb text-primary me-2"></i>Cables & Adapters</li>
                        <li class="mb-2"><i class="fas fa-fan text-primary me-2"></i>Cooling Systems</li>
                        <li class="mb-2"><i class="fas fa-tools text-primary me-2"></i>PC Tools & Maintenance</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</section>

<section id="features" class="py-5">
    <div class="container">
        <h2 class="text-center mb-5 display-5 fw-bold">System Features</h2>

        <div class="row g-4">
            <div class="col-md-4">
                <div class="card p-4">
                    <div class="feature-icon">
                        <i class="fas fa-boxes"></i>
                    </div>
                    <h4 class="text-center mb-3">Smart Inventory</h4>
                    <p class="text-center">
                        Real-time tracking of PC components with automated stock alerts and barcode scanning.
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card p-4">
                    <div class="feature-icon">
                        <i class="fas fa-clipboard-check"></i>
                    </div>
                    <h4 class="text-center mb-3">Order Management</h4>
                    <p class="text-center">
                        Efficient order processing for PC accessories with automated fulfillment workflows.
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card p-4">
                    <div class="feature-icon">
                        <i class="fas fa-chart-line"></i>
                    </div>
                    <h4 class="text-center mb-3">Analytics Dashboard</h4>
                    <p class="text-center">
                        Detailed reports on PC component sales, inventory turnover, and profit margins.
                    </p>
                </div>
            </div>
        </div>
    </div>
</section>

<div class="highlight-box">
    <div class="container text-center">
        <h3 class="mb-3">Optimized for PC Accessories Business</h3>
        <p class="mb-4">Specialized features for managing computer components, peripherals, and networking equipment with precision and efficiency.</p>
        <a href="${pageContext.request.contextPath}/login" class="btn btn-light btn-custom">Start Managing Your PC Inventory</a>
    </div>
</div>

<section class="stats-box">
    <div class="container">
        <div class="row text-center">
            <div class="col-md-3 col-6 mb-4">
                <div class="stat-number">50K+</div>
                <div class="stat-label">PC Components Managed</div>
            </div>
            <div class="col-md-3 col-6 mb-4">
                <div class="stat-number">99.8%</div>
                <div class="stat-label">Inventory Accuracy</div>
            </div>
            <div class="col-md-3 col-6 mb-4">
                <div class="stat-number">24/7</div>
                <div class="stat-label">System Availability</div>
            </div>
            <div class="col-md-3 col-6 mb-4">
                <div class="stat-number">500+</div>
                <div class="stat-label">Business Partners</div>
            </div>
        </div>
    </div>
</section>

<section id="about" class="py-5">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-6">
                <h2 class="display-6 fw-bold mb-4">About Our PC Accessories WMS</h2>
                <p class="mb-3">
                    Our Warehouse Management System is specifically designed for businesses dealing with PC components and accessories. From processors and graphics cards to keyboards and networking equipment, we provide specialized tools to manage your entire inventory lifecycle.
                </p>
                <p class="mb-4">
                    With features tailored for the computer hardware industry, including SKU management for different component models, compatibility tracking, and supplier management for tech manufacturers.
                </p>

                <div class="mt-4">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary-custom btn-custom">
                                Get Free Demo
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="col-md-6 mt-4 mt-md-0">
                <div class="card p-4">
                    <h4 class="mb-3">Business Benefits</h4>
                    <ul class="list-unstyled">
                        <li class="mb-3">
                            <i class="fas fa-check-circle text-success me-2 fs-5"></i>
                            <span class="fw-medium">Reduce PC Component Stockouts</span>
                            <p class="mt-1 mb-0 small">Automated reordering for popular PC parts</p>
                        </li>
                        <li class="mb-3">
                            <i class="fas fa-check-circle text-success me-2 fs-5"></i>
                            <span class="fw-medium">Optimize Warehouse Space</span>
                            <p class="mt-1 mb-0 small">Smart storage for different component sizes</p>
                        </li>
                        <li class="mb-3">
                            <i class="fas fa-check-circle text-success me-2 fs-5"></i>
                            <span class="fw-medium">Streamline Order Fulfillment</span>
                            <p class="mt-1 mb-0 small">Fast picking and packing for PC accessories</p>
                        </li>
                        <li class="mb-3">
                            <i class="fas fa-check-circle text-success me-2 fs-5"></i>
                            <span class="fw-medium">Real-time Component Tracking</span>
                            <p class="mt-1 mb-0 small">Monitor inventory levels for every PC part</p>
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
            <div class="col-lg-4 mb-4">
                <h5 class="mb-3"><i class="fas fa-warehouse me-2"></i>PC Accessories WMS</h5>
                <p>
                    Specialized Warehouse Management System for computer components, peripherals, and networking equipment businesses.
                </p>
                <div class="mt-3">
                    <a href="#" class="me-3"><i class="fab fa-facebook fa-lg"></i></a>
                    <a href="#" class="me-3"><i class="fab fa-twitter fa-lg"></i></a>
                    <a href="#" class="me-3"><i class="fab fa-linkedin fa-lg"></i></a>
                    <a href="#"><i class="fab fa-instagram fa-lg"></i></a>
                </div>
            </div>

            <div class="col-lg-2 col-md-4 mb-4">
                <h6 class="mb-3">Quick Links</h6>
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="#home">Home</a></li>
                    <li class="mb-2"><a href="#products">Products</a></li>
                    <li class="mb-2"><a href="#features">Features</a></li>
                    <li class="mb-2"><a href="#about">About</a></li>
                </ul>
            </div>

            <div class="col-lg-3 col-md-4 mb-4">
                <h6 class="mb-3">Contact Us</h6>
                <ul class="list-unstyled">
                    <li class="mb-2"><i class="fas fa-university me-2"></i>SWP391 FPT University</li>
                    <li class="mb-2"><i class="fas fa-map-marker-alt me-2"></i>Hoa Lac, Vietnam</li>
                    <li class="mb-2"><i class="fas fa-envelope me-2"></i>support@pcwms.com</li>
                    <li class="mb-2"><i class="fas fa-phone me-2"></i>+84 28 1234 5678</li>
                </ul>
            </div>

            <div class="col-lg-3 col-md-4 mb-4">
                <h6 class="mb-3">Our Services</h6>
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="#">PC Inventory Management</a></li>
                    <li class="mb-2"><a href="#">Component Order Processing</a></li>
                    <li class="mb-2"><a href="#">Supplier Management</a></li>
                    <li class="mb-2"><a href="#">Analytics & Reporting</a></li>
                </ul>
            </div>
        </div>

        <div class="text-center pt-4 border-top border-secondary">
            <p class="mb-0">&copy; 2024 PC Accessories Warehouse Management System. All rights reserved.</p>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"></script>

<script>
    document.querySelectorAll('a[href^="#"]').forEach(link => {
        link.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
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