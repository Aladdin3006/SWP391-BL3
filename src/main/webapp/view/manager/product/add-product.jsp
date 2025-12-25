<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Product</title>
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
<jsp:include page="/view/fragments/navbar.jsp"/>

<div class="container-fluid">
    <div class="row">
        <c:set var="activePage" value="product-list" scope="request"/>
        <jsp:include page="/view/fragments/sidebar.jsp"/>

        <main class="col-md-10 ms-sm-auto main-content">
            <div class="container-box">
                <h2>Add Product</h2>

                <form action="${pageContext.request.contextPath}/add-product" method="post" enctype="multipart/form-data">
                    <div class="flex-box">
                        <div class="upload-container">
                            <div class="upload-box">
                                <img id="previewImg" src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHICWZcFeQ7UuaU7N30-E4Vt1GaTYIU1DIEA&s" alt="Preview">
                            </div>
                            <label>Upload Image File</label>
                            <input type="file" name="imageFile" id="imageFile" accept="image/*" onchange="previewFile()">
                            <div class="error-text" id="err-url">
                                <c:if test="${not empty errImage}">${errImage}</c:if>
                            </div>
                        </div>

                        <div class="form-section">
                            <label>Product Code</label>
                            <input type="text" name="productCode" value="${productCode}">
                            <div class="error-text" id="err-productCode">
                                <c:if test="${not empty errProductCode}">${errProductCode}</c:if>
                            </div>

                            <label>Product Name</label>
                            <input type="text" name="name" value="${name}">
                            <div class="error-text" id="err-name"></div>

                            <label>Brand</label>
                            <input type="text" name="brand" value="${brand}">
                            <div class="error-text" id="err-brand"></div>

                            <label>Company</label>
                            <input type="text" name="company" value="${company}">
                            <div class="error-text" id="err-company"></div>

                            <label>Category</label>
                            <select name="categoryId">
                                <option value="0">--- Select Category ---</option>
                                <c:forEach items="${categories}" var="c">
                                    <option value="${c.categoryId}" ${c.categoryId == categoryId ? "selected" : ""}>
                                            ${c.categoryName}
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="error-text" id="err-categoryId"></div>

                            <label>Supplier</label>
                            <select name="supplierId">
                                <option value="">--- Select Supplier ---</option>
                                <c:forEach items="${suppliers}" var="s">
                                    <option value="${s.id}" ${s.id == supplierId ? "selected" : ""}>
                                            ${s.name}
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="error-text" id="err-supplierId"></div>

                            <label>Unit</label>
                            <input type="number" name="unit" min="0" value="${unit}">
                            <div class="error-text" id="err-unit"></div>
                        </div>
                    </div>

                    <div class="button-row">
                        <button type="submit" class="btn btn-save">SAVE</button>
                        <a href="${pageContext.request.contextPath}/view-product-list" class="btn btn-cancel">CANCEL</a>
                    </div>
                </form>

                <c:if test="${success != null && success == true}">
                    <script>
                        const newId = ${newProductId};
                        alert("Add product successful!");
                        window.location.href = "${pageContext.request.contextPath}/view-product-detail?id=" + newId;
                    </script>
                </c:if>
            </div>
        </main>
    </div>
</div>

<script>
    function previewFile() {
        const fileInput = document.getElementById('imageFile');
        const preview = document.getElementById('previewImg');

        if (fileInput.files && fileInput.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.src = e.target.result;
            }
            reader.readAsDataURL(fileInput.files[0]);
        }
    }

    function showError(id, message) {
        document.getElementById(id).textContent = message;
    }

    function isEmpty(v) {
        return !v || v.trim().length === 0;
    }

    document.querySelector("form").addEventListener("submit", function (e) {
        document.querySelectorAll(".error-text").forEach(e => e.textContent = "");
        let hasError = false;

        const productCode = document.querySelector("input[name='productCode']");
        const name = document.querySelector("input[name='name']");
        const brand = document.querySelector("input[name='brand']");
        const company = document.querySelector("input[name='company']");
        const imageFile = document.querySelector("input[name='imageFile']");
        const categoryId = document.querySelector("select[name='categoryId']");
        const supplierId = document.querySelector("select[name='supplierId']");
        const unit = document.querySelector("input[name='unit']");

        if (isEmpty(productCode.value)) {
            showError("err-productCode", "Product code is required.");
            hasError = true;
        }
        if (isEmpty(name.value)) {
            showError("err-name", "Product name is required.");
            hasError = true;
        }
        if (isEmpty(brand.value)) {
            showError("err-brand", "Brand is required.");
            hasError = true;
        }
        if (isEmpty(company.value)) {
            showError("err-company", "Company is required.");
            hasError = true;
        }
        if (imageFile.files.length === 0) {
            showError("err-url", "Please upload an image file.");
            hasError = true;
        }
        if (categoryId.value === "0") {
            showError("err-categoryId", "Please select a category.");
            hasError = true;
        }
        if (supplierId.value === "") {
            showError("err-supplierId", "Please select a supplier.");
            hasError = true;
        }
        if (isEmpty(unit.value) || Number(unit.value) < 0) {
            showError("err-unit", "Unit must be a number ≥ 0.");
            hasError = true;
        }

        if (hasError) {
            e.preventDefault();
        }
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>