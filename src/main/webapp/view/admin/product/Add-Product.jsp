<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

        /* Upload box */
        .upload-box {
            width: 45%;
            height: 260px;
            border: 2px dashed #bbb;
            background: #fafafa;
            border-radius: 12px;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
        }

        .upload-box img {
            width: 70px;
            opacity: 0.4;
        }

        /* Right column inputs */
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

        /* Buttons */
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

        <!-- TOP SECTION -->
        <div class="flex-box">

            <!-- UPLOAD IMAGE -->
            <div class="upload-box">
                <img src="https://cdn-icons-png.flaticon.com/512/324/324693.png">
            </div>

            <!-- REQUIRED INPUTS -->
            <div class="form-section">

                <label>Product Code *</label>
                <input type="text" name="productCode" required>

                <label>Product Name *</label>
                <input type="text" name="name" required>

                <label>Status</label>
                <select name="status">
                    <option value="Active">Active</option>
                    <option value="Inactive">Inactive</option>
                </select>

            </div>
        </div>

        <!-- ADDITIONAL FIELDS UNDERNEATH -->
        <label>Brand</label>
        <input type="text" name="brand">

        <label>Company</label>
        <input type="text" name="company">

        <label>Category</label>
        <input type="text" name="categoryName">

        <label>Unit</label>
        <input type="number" name="unit" min="0">

        <label>Supplier ID</label>
        <input type="number" name="supplierId" min="1">

        <label>Image URL</label>
        <input type="text" name="url">

        <!-- BUTTON ROW -->
        <div class="button-row">
            <button type="submit" class="btn btn-save">SAVE</button>
            <button type="submit" class="btn btn-another">SAVE & ADD ANOTHER</button>
            <a href="${pageContext.request.contextPath}/view-product-list" class="btn btn-cancel">CANCEL</a>
        </div>

    </form>

</div>

</body>
</html>
