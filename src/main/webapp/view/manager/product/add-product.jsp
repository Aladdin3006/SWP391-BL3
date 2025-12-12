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
            object-fit: contain;
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
            justify-content: flex-end;
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
            </div>

            <div class="form-section">
                <label>Product Code *</label>
                <input type="text" name="productCode" value="${productCode}" required>

                <label>Product Name *</label>
                <input type="text" name="name" value="${name}" required>

                <label>Brand</label>
                <input type="text" name="brand" value="${brand}">

                <label>Company</label>
                <input type="text" name="company" value="${company}">

                <label>Category</label>
                <select name="categoryId">
                    <option value="0">--- Select Category --</option>
                    <c:forEach items="${categories}" var="c">
                        <option value="${c.categoryId}" ${c.categoryId == categoryId ? "selected" : ""}>
                                ${c.categoryName}
                        </option>
                    </c:forEach>
                </select>



                <label>Supplier</label>
                <select name="supplierId" required>
                    <option value="">--- Select Supplier ---</option>
                    <c:forEach items="${suppliers}" var="s">
                        <option value="${s.id}"
                            ${s.id == supplierId ? "selected" : ""}>
                                ${s.name}
                        </option>
                    </c:forEach>
                </select>
                <label>Unit</label>
                <input type="number" name="unit" min="0" value="${unit}">



            </div>
        </div>

        <div class="button-row">
            <button type="submit" class="btn btn-save">SAVE</button>
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

</script>
</body>
</html>
