<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Multiple Products</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }

        .container-box {
            background: white;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }

        .product-row {
            border: 1px solid #ddd;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            position: relative;
        }

        .remove-btn {
            position: absolute;
            top: 10px;
            right: 10px;
        }

        .error-text {
            color: red;
            font-size: 0.85rem;
        }
    </style>
</head>

<body>
<jsp:include page="/view/fragments/navbar.jsp"/>

<div class="container-fluid mt-4">
    <div class="row">
        <jsp:include page="/view/fragments/sidebar.jsp"/>

        <main class="col-md-10 px-4">
            <div class="container-box">

                <h2 class="text-center mb-4">Add Multiple Products</h2>

                <c:if test="${success == true}">
                    <script>
                        alert("Added ${insertedCount} products successfully!");
                        window.location.href = "${pageContext.request.contextPath}/view-product-list";
                    </script>
                </c:if>
                <form id="multiProductForm"
                      method="post"
                      enctype="multipart/form-data"
                      novalidate>

                    <div id="productContainer">

                        <!-- ================= PRODUCT ROW ================= -->
                        <div class="product-row">

                            <button type="button" class="btn btn-danger btn-sm remove-btn"
                                    onclick="removeRow(this)">
                                <i class="fa fa-trash"></i>
                            </button>

                            <div class="row">
                                <div class="col-md-3">
                                    <label>Product Code</label>
                                    <input type="text" name="productCode"
                                           class="form-control product-code">
                                    <div class="error-text"></div>
                                </div>

                                <div class="col-md-3">
                                    <label>Name</label>
                                    <input type="text" name="name"
                                           class="form-control name">
                                    <div class="error-text"></div>
                                </div>

                                <div class="col-md-3">
                                    <label>Brand</label>
                                    <input type="text" name="brand"
                                           class="form-control brand">
                                    <div class="error-text"></div>
                                </div>

                                <div class="col-md-3">
                                    <label>Company</label>
                                    <input type="text" name="company"
                                           class="form-control company">
                                    <div class="error-text"></div>
                                </div>
                            </div>

                            <div class="row mt-2">
                                <div class="col-md-3">
                                    <label>Category</label>
                                    <select name="categoryId"
                                            class="form-select category">
                                        <option value="0">--- Select Category ---</option>
                                        <c:forEach items="${categories}" var="c">
                                            <option value="${c.categoryId}">
                                                    ${c.categoryName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <div class="error-text"></div>
                                </div>

                                <div class="col-md-3">
                                    <label>Supplier</label>
                                    <select name="supplierId"
                                            class="form-select supplier">
                                        <option value="0">--- Select Supplier ---</option>
                                        <c:forEach items="${suppliers}" var="s">
                                            <option value="${s.id}">
                                                    ${s.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <div class="error-text"></div>
                                </div>

                                <div class="col-md-2">
                                    <label>Unit</label>
                                    <input type="number" name="unit"
                                           class="form-control unit">
                                    <div class="error-text"></div>
                                </div>

                                <div class="col-md-4">
                                    <label>Image</label>
                                    <input type="file" name="imageFile"
                                           class="form-control image">
                                    <div class="error-text"></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- ================= BUTTONS ================= -->
                    <div class="d-flex justify-content-between mt-4">
                        <button type="button" class="btn btn-secondary" onclick="addRow()">
                            <i class="fa fa-plus"></i> Add Row
                        </button>

                        <button type="submit" class="btn btn-warning">
                            <i class="fa fa-save"></i> SAVE ALL
                        </button>
                    </div>

                </form>
            </div>
        </main>
    </div>
</div>

<script>
    function isEmpty(val) {
        return !val || val.trim() === "";
    }

    function clearErrors() {
        document.querySelectorAll(".error-text").forEach(e => e.textContent = "");
        document.querySelectorAll(".product-row").forEach(r => {
            r.style.border = "1px solid #ddd";
        });
    }

    function showError(input, message) {
        input.nextElementSibling.textContent = message;
        input.closest(".product-row").style.border = "2px solid red";
    }
    function addRow() {
        const container = document.getElementById("productContainer");
        const clone = container.children[0].cloneNode(true);

        clone.querySelectorAll("input").forEach(i => i.value = "");
        clone.querySelectorAll("select").forEach(s => s.value = "0");
        clone.querySelectorAll(".error-text").forEach(e => e.textContent = "");

        container.appendChild(clone);
    }

    function removeRow(btn) {
        const rows = document.querySelectorAll(".product-row");
        if (rows.length > 1) {
            btn.closest(".product-row").remove();
        } else {
            alert("At least one product is required.");
        }
    }

    function validateForm() {
        clearErrors();

        let hasError = false;
        let alerts = [];

        const rows = document.querySelectorAll(".product-row");

        rows.forEach((row, index) => {
            let rowHasError = false;

            const code = row.querySelector('input[name="productCode"]');
            const name = row.querySelector('input[name="name"]');
            const brand = row.querySelector('input[name="brand"]');
            const company = row.querySelector('input[name="company"]');
            const category = row.querySelector('select[name="categoryId"]');
            const supplier = row.querySelector('select[name="supplierId"]');
            const unit = row.querySelector('input[name="unit"]');
            const image = row.querySelector('input[type="file"]');

            // ---------- productCode ----------
            if (isEmpty(code.value)) {
                showError(code, "Product Code is required");
                rowHasError = true;
            }

            // ---------- name ----------
            if (isEmpty(name.value)) {
                showError(name, "Name is required");
                rowHasError = true;
            }

            // ---------- brand ----------
            if (isEmpty(brand.value)) {
                showError(brand, "Brand is required");
                rowHasError = true;
            }

            // ---------- company ----------
            if (isEmpty(company.value)) {
                showError(company, "Company is required");
                rowHasError = true;
            }

            // ---------- category ----------
            if (category.value === "0") {
                showError(category, "Please select category");
                rowHasError = true;
            }

            // ---------- supplier ----------
            if (supplier.value === "0") {
                showError(supplier, "Please select supplier");
                rowHasError = true;
            }

            // ---------- unit ----------
            if (isEmpty(unit.value) || parseInt(unit.value) <= 0) {
                showError(unit, "Unit must be greater than 0");
                rowHasError = true;
            }

            // ---------- image ----------
            if (!image.files || image.files.length === 0) {
                showError(image, "Image is required");
                rowHasError = true;
            }

            if (rowHasError) {
                hasError = true;
            }
        });

        // ================= DUPLICATE PRODUCT CODE =================
        const codeMap = new Map();
        document.querySelectorAll('input[name="productCode"]').forEach((input, i) => {
            const value = input.value.trim().toUpperCase();
            if (!value) return;

            if (codeMap.has(value)) {
                showError(input, "Duplicate product code");
                hasError = true;
            } else {
                codeMap.set(value, input);
            }
        });

        return !hasError;
    }

    document.querySelector("form").addEventListener("submit", function (e) {
        if (!validateForm()) {
            e.preventDefault();
        }
    });
</script>

</body>
</html>
