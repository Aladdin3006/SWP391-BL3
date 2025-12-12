<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Product Detail</title>
    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background: #eef1f6;
            margin: 0;
            padding: 30px;
        }

        .container {
            width: 900px;
            margin: auto;
            background: #ffffff;
            padding: 30px;
            border-radius: 14px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            transition: 0.3s;
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

        /* Ảnh sản phẩm */
        .product-image img {
            width: 260px;
            height: 260px; /* cố định chiều cao */
            border-radius: 12px;
            border: 1px solid #ddd;
            object-fit: cover; /* hình không méo, crop vừa khung */
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            transition: 0.2s;
        }

        .product-image img:hover {
            transform: none;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1); /* không đổi khi hover */
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

        /* Status badge */
        .status-active, .status-inactive {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            text-transform: capitalize;
        }
        .status-active { background: #28a745; color: #fff; }
        .status-inactive { background: #dc3545; color: #fff; }

        .btn-group {
            margin-top: 30px;
        }

        .btn {
            padding: 11px 18px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            display: inline-block;
            transition: 0.25s;
        }



        .btn-edit {
            position: fixed;
            bottom: 35px;
            right: 35px;
            background: #007bff;
            color: #fff;
            padding: 12px 20px;
            border-radius: 10px;
            font-weight: 600;
            text-decoration: none;
            box-shadow: 0 4px 12px rgba(0,0,0,0.25);
            transition: 0.25s;
        }

        .btn-edit:hover {
            opacity: 0.9;
            transform: translateY(-2px);
        }


        .btn:hover {
            opacity: 0.9;
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.15);
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
<div class="container">

    <h2>Product Detail</h2>

    <!-- Nếu product không tồn tại -->
    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>

    <!-- Nếu có product -->
    <c:if test="${not empty product}">

        <div class="product-box">

            <!-- Ảnh sản phẩm -->
            <div class="product-image">
                <img src="${product.url}"
                     alt="Product Image"
                     onerror="this.onerror=null; this.src='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHICWZcFeQ7UuaU7N30-E4Vt1GaTYIU1DIEA&s';">

            </div>

            <!-- Thông tin sản phẩm -->
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

        <!-- Nút điều hướng -->
        <a href="${pageContext.request.contextPath}/edit-product?id=${product.id}"
           class="btn-edit">✎ Edit Product</a>


    </c:if>

</div>

</body>
</html>
