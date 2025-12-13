<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Product</title>
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
            flex-direction: column; /* xếp dọc ảnh + input */
            gap: 8px; /* khoảng cách giữa ảnh và input */
        }

        .upload-box {
            width: 100%;
            height: 260px; /* giữ khung như trước */
            border: 2px dashed #bbb;
            background: #fafafa;
            border-radius: 12px;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden; /* ngăn ảnh tràn */
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
        }
        .btn {
            padding: 12px 24px;
            border-radius: 10px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            font-size: 15px;
        }
        .button-row {
            display: flex;
            gap: 15px;
            margin-top: 20px;
            justify-content: flex-end; /* đẩy các nút sang phải */
        }
        .btn-save {
            background: #ff8b22;
            color: white;
        }
        .btn-save:hover {
            background: #e57a14;
        }
        .btn-another {
            background: #4b6ef5;
            color: white;
        }
        .btn-another:hover {
            background: #3a58d5;
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

    <h2>Add Product</h2>

    <form action="${pageContext.request.contextPath}/add-product" method="post">

        <div class="flex-box">
            <div class="upload-container">
                <div class="upload-box">
                    <img id="previewImg" src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHICWZcFeQ7UuaU7N30-E4Vt1GaTYIU1DIEA&s" alt="Preview">
                </div>
                <label>Enter Image Url...</label>
                <input type="text" name="url" id="imageUrl" placeholder="Enter image URL..." value="${url}">
                <div class="error-text" id="err-url"></div>
            </div>

            <div class="form-section">
                <label>Product Code</label>
                <input type="text" name="productCode" value="${productCode}">
                <div class="error-text" id="err-productCode">
                    <c:if test="${not empty errProductCode}">
                        ${errProductCode}
                    </c:if>
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
                    <option value="0">--- Select Category --</option>
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
                        <option value="${s.id}"
                            ${s.id == supplierId ? "selected" : ""}>
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
<script>
    const previewImg = document.getElementById('previewImg');
    const imageUrlInput = document.getElementById('imageUrl');
    const defaultImg = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHICWZcFeQ7UuaU7N30-E4Vt1GaTYIU1DIEA&s";

    imageUrlInput.addEventListener('input', () => {
        const url = imageUrlInput.value.trim();
        if (!url) {
            previewImg.src = defaultImg; // nếu rỗng thì về default
            return;
        }

        // Tạo ảnh tạm để kiểm tra URL có hợp lệ không
        const tempImg = new Image();
        tempImg.onload = () => previewImg.src = url; // load thành công thì hiển thị
        tempImg.onerror = () => previewImg.src = defaultImg; // lỗi thì về default
        tempImg.src = url;
    });

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
        const url = document.querySelector("input[name='url']");
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

        if (isEmpty(url.value)) {
            showError("err-url", "Image URL is required.");
            hasError = true;
        }

        if (isEmpty(url.value)) {
            showError("err-url", "Image URL is required.");
            hasError = true;
        } else if (url.value.length > 255) {
            showError("err-url", "Image URL too long.");
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
            e.preventDefault(); // chặn submit
        }
    });
</script>
</body>
</html>
