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
        .product-form {
            border: 2px solid #eee;
            padding: 20px;
            margin-bottom: 25px;
            border-radius: 12px;
            background: #f9f9f9;
            position: relative;
        }
        .product-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #ddd;
        }
        .product-number {
            font-size: 18px;
            font-weight: bold;
            color: #ff8b22;
        }
        .remove-btn {
            background: #dc3545;
            color: white;
            border: none;
            border-radius: 6px;
            padding: 6px 12px;
            cursor: pointer;
            font-size: 14px;
        }
        .remove-btn:hover {
            background: #c82333;
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
        .buttons-container {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 2px solid #eee;
        }
        .btn {
            padding: 12px 24px;
            border-radius: 10px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            font-size: 15px;
        }
        .btn-add {
            background: #28a745;
            color: white;
        }
        .btn-add:hover {
            background: #218838;
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
        .global-error {
            color: red;
            margin-bottom: 15px;
            font-weight: bold;
        }
        .global-success {
            color: green;
            margin-bottom: 15px;
            font-weight: bold;
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
                <h2>Add Products</h2>

                <c:if test="${not empty errorMessage}">
                    <div class="global-error">${errorMessage}</div>
                </c:if>

                <c:if test="${not empty errorMessages}">
                    <div class="global-error">
                        <c:forEach items="${errorMessages}" var="err">
                            <div>${err}</div>
                        </c:forEach>
                    </div>
                </c:if>

                <c:if test="${success != null && success == true}">
                    <div class="global-success">
                        Successfully added ${savedCount} product(s)!
                    </div>
                </c:if>

                <form id="addProductsForm" action="${pageContext.request.contextPath}/add-product" method="post" enctype="multipart/form-data">
                    <div id="productsContainer">
                        <div class="product-form" data-index="0">
                            <div class="product-header">
                                <span class="product-number">Product #1</span>
                                <button type="button" class="remove-btn" onclick="removeProduct(this)" disabled>
                                    <i class="fas fa-times"></i> Remove
                                </button>
                            </div>

                            <div class="flex-box">
                                <div class="upload-container">
                                    <div class="upload-box">
                                        <img class="previewImg" data-index="0" src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHICWZcFeQ7UuaU7N30-E4Vt1GaTYIU1DIEA&s" alt="Preview">
                                    </div>
                                    <label>Upload Image File</label>
                                    <input type="file" name="imageFile" class="imageFile" data-index="0" accept="image/*" onchange="previewFile(this)">
                                    <div class="error-text error-url" data-index="0"></div>
                                </div>

                                <div class="form-section">
                                    <label>Product Code</label>
                                    <input type="text" name="productCode" value="${productCode}">
                                    <div class="error-text error-productCode" data-index="0"></div>

                                    <label>Product Name</label>
                                    <input type="text" name="name" value="${name}">
                                    <div class="error-text error-name" data-index="0"></div>

                                    <label>Brand</label>
                                    <input type="text" name="brand" value="${brand}">
                                    <div class="error-text error-brand" data-index="0"></div>

                                    <label>Company</label>
                                    <input type="text" name="company" value="${company}">
                                    <div class="error-text error-company" data-index="0"></div>

                                    <label>Category</label>
                                    <select name="categoryId">
                                        <option value="0">--- Select Category ---</option>
                                        <c:forEach items="${categories}" var="c">
                                            <option value="${c.categoryId}">
                                                    ${c.categoryName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <div class="error-text error-categoryId" data-index="0"></div>

                                    <label>Supplier</label>
                                    <select name="supplierId">
                                        <option value="">--- Select Supplier ---</option>
                                        <c:forEach items="${suppliers}" var="s">
                                            <option value="${s.id}">
                                                    ${s.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <div class="error-text error-supplierId" data-index="0"></div>

                                    <label>Unit</label>
                                    <input type="number" name="unit" min="0" value="0">
                                    <div class="error-text error-unit" data-index="0"></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="buttons-container">
                        <button type="button" class="btn btn-add" onclick="addProduct()">
                            <i class="fas fa-plus"></i> ADD MORE PRODUCT
                        </button>
                        <div>
                            <button type="submit" class="btn btn-save">SAVE ALL</button>
                            <a href="${pageContext.request.contextPath}/view-product-list" class="btn btn-cancel">CANCEL</a>
                        </div>
                    </div>
                </form>
            </div>
        </main>
    </div>
</div>

<script>
    let productCount = 1;

    function previewFile(input) {
        const index = input.getAttribute('data-index');
        const preview = document.querySelector(`.previewImg[data-index="${index}"]`);

        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.src = e.target.result;
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    function addProduct() {
        productCount++;
        const container = document.getElementById('productsContainer');
        const firstForm = container.querySelector('.product-form');
        const newForm = firstForm.cloneNode(true);

        newForm.setAttribute('data-index', productCount - 1);
        newForm.querySelector('.product-number').textContent = `Product #${productCount}`;

        const index = productCount - 1;
        const inputs = newForm.querySelectorAll('input, select');
        inputs.forEach(input => {
            input.value = '';
            if (input.name === 'unit') input.value = '0';
            if (input.tagName === 'SELECT') input.selectedIndex = 0;

            const originalName = input.getAttribute('data-original-name') || input.name;
            input.setAttribute('data-original-name', originalName);

            if (index > 0) {
                input.name = originalName + '_' + index;
            } else {
                input.name = originalName;
            }

            if (input.classList.contains('imageFile')) {
                input.setAttribute('name', 'imageFile' + (index > 0 ? '_' + index : ''));
                input.setAttribute('data-index', index);
                input.onchange = function() { previewFile(this); };
            }
        });

        newForm.querySelector('.previewImg').setAttribute('data-index', index);
        newForm.querySelector('.previewImg').src = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHICWZcFeQ7UuaU7N30-E4Vt1GaTYIU1DIEA&s';

        const errorDivs = newForm.querySelectorAll('.error-text');
        errorDivs.forEach(div => {
            div.setAttribute('data-index', index);
            div.textContent = '';
        });

        newForm.querySelector('.remove-btn').disabled = false;
        newForm.querySelector('.remove-btn').onclick = function() { removeProduct(this); };

        container.appendChild(newForm);

        if (productCount > 1) {
            container.querySelector('.product-form:first-child .remove-btn').disabled = false;
        }
    }

    function removeProduct(button) {
        const form = button.closest('.product-form');
        if (productCount > 1) {
            form.remove();
            productCount--;

            const forms = document.querySelectorAll('.product-form');
            forms.forEach((form, index) => {
                form.setAttribute('data-index', index);
                form.querySelector('.product-number').textContent = `Product #${index + 1}`;

                const inputs = form.querySelectorAll('input, select');
                inputs.forEach(input => {
                    const originalName = input.getAttribute('data-original-name') || input.name.split('_')[0];
                    input.setAttribute('data-original-name', originalName);

                    if (index > 0) {
                        input.name = originalName + '_' + index;
                    } else {
                        input.name = originalName;
                    }

                    if (input.classList.contains('imageFile')) {
                        input.setAttribute('name', 'imageFile' + (index > 0 ? '_' + index : ''));
                        input.setAttribute('data-index', index);
                    }
                });

                form.querySelector('.previewImg').setAttribute('data-index', index);

                const errorDivs = form.querySelectorAll('.error-text');
                errorDivs.forEach(div => {
                    div.setAttribute('data-index', index);
                });
            });

            if (productCount === 1) {
                document.querySelector('.product-form .remove-btn').disabled = true;
            }
        }
    }

    function showError(index, field, message) {
        const errorDiv = document.querySelector(`.error-${field}[data-index="${index}"]`);
        if (errorDiv) {
            errorDiv.textContent = message;
        }
    }

    function clearErrors() {
        document.querySelectorAll('.error-text').forEach(e => e.textContent = '');
    }

    function isEmpty(v) {
        return !v || v.trim().length === 0;
    }

    document.getElementById("addProductsForm").addEventListener("submit", function (e) {
        clearErrors();

        const forms = document.querySelectorAll('.product-form');
        let hasError = false;
        const productCodes = new Set();

        forms.forEach((form, index) => {
            const productCodeInput = form.querySelector('input[name^="productCode"]');
            const nameInput = form.querySelector('input[name^="name"]');
            const brandInput = form.querySelector('input[name^="brand"]');
            const companyInput = form.querySelector('input[name^="company"]');
            const imageFile = form.querySelector('.imageFile');
            const categorySelect = form.querySelector('select[name^="categoryId"]');
            const supplierSelect = form.querySelector('select[name^="supplierId"]');
            const unitInput = form.querySelector('input[name^="unit"]');

            const productCode = productCodeInput ? productCodeInput.value.trim() : '';
            const name = nameInput ? nameInput.value.trim() : '';
            const brand = brandInput ? brandInput.value.trim() : '';
            const company = companyInput ? companyInput.value.trim() : '';
            const categoryId = categorySelect ? categorySelect.value : '';
            const supplierId = supplierSelect ? supplierSelect.value : '';
            const unit = unitInput ? unitInput.value : '';

            if (productCodes.has(productCode.toLowerCase())) {
                showError(index, 'productCode', 'Duplicate product code in this batch.');
                hasError = true;
            } else if (!isEmpty(productCode)) {
                productCodes.add(productCode.toLowerCase());
            }

            if (isEmpty(productCode)) {
                showError(index, 'productCode', 'Product code is required.');
                hasError = true;
            }

            if (isEmpty(name)) {
                showError(index, 'name', 'Product name is required.');
                hasError = true;
            }

            if (isEmpty(brand)) {
                showError(index, 'brand', 'Brand is required.');
                hasError = true;
            }

            if (isEmpty(company)) {
                showError(index, 'company', 'Company is required.');
                hasError = true;
            }

            if (!imageFile.files || imageFile.files.length === 0) {
                showError(index, 'url', 'Please upload an image file.');
                hasError = true;
            }

            if (supplierId === "" || supplierId === "0") {
                showError(index, 'supplierId', 'Please select a supplier.');
                hasError = true;
            }

            if (categoryId === "0") {
                showError(index, 'categoryId', 'Please select a category.');
                hasError = true;
            }

            if (isEmpty(unit) || Number(unit) < 0) {
                showError(index, 'unit', 'Unit must be a number ≥ 0.');
                hasError = true;
            }
        });

        if (hasError) {
            e.preventDefault();
        }
    });

    document.addEventListener('DOMContentLoaded', function() {
        const successElement = document.querySelector('.global-success');
        if (successElement && successElement.textContent.trim() !== '') {
            alert(successElement.textContent);
        }

        const errorElement = document.querySelector('.global-error');
        if (errorElement && errorElement.textContent.trim() !== '') {
            alert('Error: ' + errorElement.textContent);
        }
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>