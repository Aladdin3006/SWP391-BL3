<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Product Detail</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            font-family: "Segoe UI", sans-serif;
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
        .main-content {
            padding: 30px;
        }
        .container-box {
            background: #ffffff;
            padding: 30px;
            border-radius: 14px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        h2 {
            margin: 0 0 20px 0;
            color: #222;
            font-size: 26px;
            font-weight: 600;
            border-left: 5px solid #007bff;
            padding-left: 12px;
        }
        .product-box {
            display: flex;
            gap: 35px;
            align-items: flex-start;
        }
        .product-image img {
            width: 260px;
            height: 260px;
            border-radius: 12px;
            border: 1px solid #ddd;
            object-fit: cover;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
        .product-info {
            flex: 1;
            font-size: 16px;
            color: #444;
        }
        .info-row {
            margin-bottom: 15px;
            display: flex;
            justify-content: space-between;
            border-bottom: 1px dashed #e2e2e2;
            padding-bottom: 8px;
        }
        .info-row .label {
            font-weight: 600;
            color: #333;
        }
        .status-active, .status-inactive {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            text-transform: capitalize;
        }
        .status-active {
            background: #28a745;
            color: #fff;
        }
        .status-inactive {
            background: #dc3545;
            color: #fff;
        }
        .btn-edit {
            margin-top: 30px;
            background: #007bff;
            color: #fff;
            padding: 12px 20px;
            border-radius: 10px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            transition: 0.25s;
        }
        .btn-edit:hover {
            opacity: 0.9;
            transform: translateY(-2px);
            color: white;
            text-decoration: none;
        }
        .btn-back {
            margin-top: 30px;
            margin-right: 15px;
            background: #6c757d;
            color: #fff;
            padding: 12px 20px;
            border-radius: 10px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            transition: 0.25s;
        }
        .btn-back:hover {
            opacity: 0.9;
            transform: translateY(-2px);
            color: white;
            text-decoration: none;
        }
        .error {
            color: #d9534f;
            background: #ffecec;
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
            font-size: 16px;
            font-weight: 600;
        }
    </style>
</head>
<body>
<jsp:include page="/view/fragments/navbar.jsp"/>

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <c:set var="activePage" value="product-list" scope="request"/>
        <jsp:include page="/view/fragments/sidebar.jsp"/>

        <!-- Main Content -->
        <main class="col-md-10 ms-sm-auto main-content">
            <div class="container-box">
                <h2>Product Detail</h2>

                <c:if test="${not empty error}">
                    <div class="error">${error}</div>
                </c:if>

                <c:if test="${not empty product}">
                    <div class="product-box">
                        <div class="product-image">
                            <img src="${product.url}"
                                 alt="Product Image"
                                 onerror="this.onerror=null; this.src='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHICWZcFeQ7UuaU7N30-E4Vt1GaTYIU1DIEA&s';">
                        </div>

                        <div class="product-info">
                            <div class="info-row">
                                <span class="label">Product Code:</span> ${product.productCode}
                            </div>
                            <div class="info-row">
                                <span class="label">Name:</span> ${product.name}
                            </div>
                            <div class="info-row">
                                <span class="label">Brand:</span> ${product.brand}
                            </div>
                            <div class="info-row">
                                <span class="label">Company:</span> ${product.company}
                            </div>
                            <div class="info-row">
                                <span class="label">Category:</span> ${product.categoryName}
                            </div>
                            <div class="info-row">
                                <span class="label">Unit:</span> ${product.unit}
                            </div>
                            <div class="info-row">
                                <span class="label">Supplier:</span> ${product.supplierName}
                            </div>
                            <div class="info-row">
                                <span class="label">Status:</span>
                                <c:choose>
                                    <c:when test="${product.status == 'active'}">
                                        <span class="status-active">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-inactive">Inactive</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="mt-4">
                        <a href="${pageContext.request.contextPath}/view-product-list"
                           class="btn-back">
                            <i class="fas fa-arrow-left me-2"></i>Back to List
                        </a>
                        <a href="${pageContext.request.contextPath}/edit-product?id=${product.id}"
                           class="btn-edit">
                            <i class="fas fa-edit me-2"></i>Edit Product
                        </a>
                    </div>
                </c:if>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>