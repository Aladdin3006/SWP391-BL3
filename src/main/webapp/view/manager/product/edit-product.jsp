<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Product</title>
    <style>
        body {
            background: linear-gradient(135deg, #6a11cb, #2575fc);
            font-family: "Segoe UI", sans-serif;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 850px;
            margin: 40px auto;
            background: white;
            padding: 30px 40px;
            border-radius: 16px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }
        h2 {
            font-size: 26px;
            font-weight: 700;
            color: #444;
            margin-bottom: 25px;
            text-align: center;
        }
        .flex-box {
            display: flex;
            gap: 30px;
        }
        .upload-container {
            width: 45%;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        .upload-box {
            width: 100%;
            height: 260px;
            border: 2px dashed #bbb;
            background: #fafafa;
            border-radius: 12px;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden;
        }
        .upload-box img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 12px;
        }
        .upload-container input[type="text"] {
            width: 100%;
            padding: 8px;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 14px;
        }
        .form-section {
            width: 55%;
        }
        label {
            font-weight: 600;
            margin-bottom: 6px;
            display: block;
            color: #444;
        }
        input, select {
            width: 100%;
            padding: 12px;
            border-radius: 10px;
            border: 1px solid #ccc;
            margin-bottom: 18px;
            font-size: 15px;
            transition: 0.2s;
            box-sizing: border-box;
        }
        input:focus, select:focus {
            border-color: #2575fc;
            box-shadow: 0 0 5px rgba(37,117,252,0.4);
            outline: none;
        }
        .button-row {
            display: flex;
            gap: 15px;
            margin-top: 20px;
            justify-content: flex-end;
        }
        .btn {
            padding: 12px 24px;
            border-radius: 10px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            font-size: 15px;
        }
        .btn-save {
            background: #ff8b22;
            color: white;
        }
        .btn-save:hover {
            background: #e57a14;
        }
        .btn-cancel {
            background: #ddd;
            color: #333;
        }
        .btn-cancel:hover {
            background: #ccc;
        }
        .error-text {
            color: red;
            font-size: 13px;
            margin-top: -12px;
            margin-bottom: 12px;
        }
    </style>
</head>
<body>

<div class="container">

    <h2>Edit Product</h2>

    <form action="${pageContext.request.contextPath}/edit-product" method="post">
        <!-- Hidden field để giữ ID -->
        <input type="hidden" name="id" value="${product.id}">

        <div class="flex-box">
            <div class="upload-container">
                <div class="upload-box">
                    <img id="previewImg" src="${product.url != null ? product.url : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHICWZcFeQ7UuaU7N30-E4Vt1GaTYIU1DIEA&s'}" alt="Preview">
                </div>
                <label>Enter Image Url...</label>
                <input type="text" name="url" id="imageUrl" placeholder="Enter image URL..." value="${product.url}">
                <div class="error-text" id="err-url"></div>
            </div>

            <div class="form-section">
                <label>Product Code</label>
                <input type="text" value="${product.productCode}" disabled>
                <input type="hidden" name="productCode" value="${product.productCode}">
                <div class="error-text" id="err-productCode"></div>

                <label>Product Name</label>
                <input type="text" name="name" value="${product.name}">
                <div class="error-text" id="err-name"></div>

                <label>Brand</label>
                <input type="text" name="brand" value="${product.brand}">
                <div class="error-text" id="err-brand"></div>

                <label>Company</label>
                <input type="text" name="company" value="${product.company}">
                <div class="error-text" id="err-company"></div>

                <label>Category</label>
                <select name="categoryId">
                    <option value="0">--- Select Category ---</option>
                    <c:forEach items="${categories}" var="c">
                        <option value="${c.categoryId}" ${c.categoryId == product.categoryId ? "selected" : ""}>
                                ${c.categoryName}
                        </option>
                    </c:forEach>
                </select>
                <div class="error-text" id="err-categoryId"></div>

                <label>Supplier</label>
                <select name="supplierId">
                    <option value="">--- Select Supplier ---</option>
                    <c:forEach items="${suppliers}" var="s">
                        <option value="${s.id}" ${s.id == product.supplierId ? "selected" : ""}>
                                ${s.name}
                        </option>
                    </c:forEach>
                </select>
                <div class="error-text" id="err-supplierId"></div>

                <label>Unit</label>
                <input type="number" name="unit" min="0" value="${product.unit}">
                <div class="error-text" id="err-unit"></div>

                <label>Status</label>
                <select name="status">
                    <option value="active" ${product.status == 'active' ? 'selected' : ''}>Active</option>
                    <option value="inactive" ${product.status == 'inactive' ? 'selected' : ''}>Inactive</option>
                </select>
                <div class="error-text" id="err-status"></div>

            </div>
        </div>

        <div class="button-row">
            <button type="submit" class="btn btn-save">SAVE</button>
            <a href="${pageContext.request.contextPath}/view-product-detail?id=${product.id}" class="btn btn-cancel">CANCEL</a>
        </div>

    </form>

</div>

<script>
    const previewImg = document.getElementById('previewImg');
    const imageUrlInput = document.getElementById('imageUrl');
    const defaultImg = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHICWZcFeQ7UuaU7N30-E4Vt1GaTYIU1DIEA&s";

    imageUrlInput.addEventListener('input', () => {
        const url = imageUrlInput.value.trim();
        if (!url) {
            previewImg.src = defaultImg;
            return;
        }
        const tempImg = new Image();
        tempImg.onload = () => previewImg.src = url;
        tempImg.onerror = () => previewImg.src = defaultImg;
        tempImg.src = url;
    });

    function showError(id, message) {
        document.getElementById(id).textContent = message;
    }

    function isEmpty(v) {
        return !v || v.trim().length === 0;
    }

    document.querySelector("form").addEventListener("submit", function (e) {
        document.querySelectorAll(".error-text").forEach(el => el.textContent = "");
        let hasError = false;

        const productCode = document.querySelector("input[name='productCode']");
        const name = document.querySelector("input[name='name']");
        const brand = document.querySelector("input[name='brand']");
        const company = document.querySelector("input[name='company']");
        const url = document.querySelector("input[name='url']");
        const categoryId = document.querySelector("select[name='categoryId']");
        const supplierId = document.querySelector("select[name='supplierId']");
        const unit = document.querySelector("input[name='unit']");
        const status = document.querySelector("select[name='status']");

        if (isEmpty(productCode.value)) { showError("err-productCode", "Product code is required."); hasError = true; }
        if (isEmpty(name.value)) { showError("err-name", "Product name is required."); hasError = true; }
        if (isEmpty(brand.value)) { showError("err-brand", "Brand is required."); hasError = true; }
        if (isEmpty(company.value)) { showError("err-company", "Company is required."); hasError = true; }
        if (isEmpty(url.value)) { showError("err-url", "Image URL is required."); hasError = true; }
        else if (url.value.length > 255) { showError("err-url", "Image URL too long."); hasError = true; }
        if (supplierId.value === "") { showError("err-supplierId", "Please select a supplier."); hasError = true; }
        if (isEmpty(unit.value) || Number(unit.value) < 0) { showError("err-unit", "Unit must be a number ≥ 0."); hasError = true; }

        if (hasError) e.preventDefault();
    });
</script>

</body>
</html>
