<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Product</title>
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
        input, select, textarea {
            width: 100%;
            padding: 12px;
            border-radius: 10px;
            border: 1px solid #ccc;
            margin-bottom: 18px;
            font-size: 15px;
            transition: 0.2s;
            box-sizing: border-box;
        }
        textarea {
            resize: vertical;
            min-height: 80px;
        }
        input:focus, select:focus, textarea:focus {
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
        .unit-note-container {
            display: none;
            margin-top: 5px;
            margin-bottom: 18px;
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            border-left: 4px solid #ff8b22;
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
                <h2>Edit Product</h2>

                <form action="${pageContext.request.contextPath}/edit-product" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="id" value="${product.id}">
                    <input type="hidden" id="originalUnit" value="${product.unit}">

                    <div class="flex-box">
                        <div class="upload-container">
                            <div class="upload-box">
                                <img id="previewImg" src="${product.url != null ? product.url : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHICWZcFeQ7UuaU7N30-E4Vt1GaTYIU1DIEA&s'}" alt="Preview">
                            </div>
                            <label>Upload Image File</label>
                            <input type="file" name="imageFile" id="imageFile" accept="image/*" onchange="previewFile()">
                            <div class="error-text" id="err-url">
                                <c:if test="${not empty errImage}">${errImage}</c:if>
                            </div>
                        </div>

                        <div class="form-section">
                            <label>Product Code</label>
                            <input type="text" value="${product.productCode}" disabled>
                            <input type="hidden" name="productCode" value="${product.productCode}">

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
                                    <option value="${c.categoryId}"
                                        ${c.categoryId == product.categoryId ? "selected" : ""}
                                        ${c.status == 0 ? "disabled" : ""}>
                                            ${c.categoryName}
                                        <c:if test="${c.status == 0}">(Inactive)</c:if>
                                    </option>

                                </c:forEach>
                            </select>
                            <div class="error-text" id="err-categoryId"></div>

                            <label>Supplier</label>
                            <select name="supplierId">
                                <option value="">--- Select Supplier ---</option>

                                <c:forEach items="${suppliers}" var="s">
                                    <option value="${s.id}"
                                            <c:if test="${s.id eq product.supplierId}">selected</c:if>
                                            <c:if test="${s.status eq 'inactive'}">disabled</c:if>>
                                            ${s.name}
                                        <c:if test="${s.status eq 'inactive'}">(Inactive)</c:if>
                                    </option>
                                </c:forEach>
                            </select>

                            <div class="error-text" id="err-supplierId"></div>

                            <label>Unit</label>
                            <input type="number" name="unit" id="unitInput" min="0" value="${product.unit}" oninput="checkUnitChange()">
                            <div class="error-text" id="err-unit"></div>

                            <div class="unit-note-container" id="unitNoteContainer">
                                <label>Note for Unit Change</label>
                                <textarea name="note" id="noteTextarea" placeholder="Enter note for unit change (optional)"></textarea>
                            </div>

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

    function checkUnitChange() {
        const originalUnit = parseInt(document.getElementById('originalUnit').value);
        const currentUnit = parseInt(document.getElementById('unitInput').value) || 0;
        const noteContainer = document.getElementById('unitNoteContainer');
        const noteTextarea = document.getElementById('noteTextarea');

        if (originalUnit !== currentUnit) {
            noteContainer.style.display = 'block';
            noteTextarea.required = false;
        } else {
            noteContainer.style.display = 'none';
            noteTextarea.value = '';
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        checkUnitChange();
    });

    document.querySelector("form").addEventListener("submit", function (e) {
        document.querySelectorAll(".error-text").forEach(el => el.textContent = "");
        let hasError = false;

        const productCode = document.querySelector("input[name='productCode']");
        const name = document.querySelector("input[name='name']");
        const brand = document.querySelector("input[name='brand']");
        const company = document.querySelector("input[name='company']");
        const categoryId = document.querySelector("select[name='categoryId']");
        const supplierId = document.querySelector("select[name='supplierId']");
        const unit = document.querySelector("input[name='unit']");
        const status = document.querySelector("select[name='status']");

        if (isEmpty(productCode.value)) { showError("err-productCode", "Product code is required."); hasError = true; }
        if (isEmpty(name.value)) { showError("err-name", "Product name is required."); hasError = true; }
        if (isEmpty(brand.value)) { showError("err-brand", "Brand is required."); hasError = true; }
        if (isEmpty(company.value)) { showError("err-company", "Company is required."); hasError = true; }
        if (supplierId.value === "") { showError("err-supplierId", "Please select a supplier."); hasError = true; }
        if (isEmpty(unit.value) || Number(unit.value) < 0) { showError("err-unit", "Unit must be a number ≥ 0."); hasError = true; }

        if (hasError) e.preventDefault();
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>