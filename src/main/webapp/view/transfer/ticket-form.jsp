<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${ticket != null ? 'Edit' : 'Add'} Transfer Ticket</title>
    <!-- Bootstrap for navbar + layout -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/layout.css">
    <style>
        .form-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .form-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .form-header h1 {
            color: #2c3e50;
            font-size: 28px;
            margin: 0;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            transition: all 0.3s;
            display: inline-block;
        }

        .btn-secondary {
            background: #95a5a6;
            color: white;
        }

        .btn-secondary:hover {
            background: #7f8c8d;
        }

        .btn-primary {
            background: #3498db;
            color: white;
        }

        .btn-primary:hover {
            background: #2980b9;
        }

        .btn-success {
            background: #27ae60;
            color: white;
        }

        .btn-success:hover {
            background: #229954;
        }

        .btn-danger {
            background: #e74c3c;
            color: white;
        }

        .btn-danger:hover {
            background: #c0392b;
        }

        .form-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 25px;
            margin-bottom: 25px;
        }

        .form-card h2 {
            color: #34495e;
            font-size: 20px;
            margin-bottom: 20px;
            border-bottom: 2px solid #3498db;
            padding-bottom: 10px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-label {
            font-weight: 600;
            color: #555;
            font-size: 14px;
        }

        .form-label.required::after {
            content: " *";
            color: #e74c3c;
        }

        .form-control {
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        .form-control:focus {
            outline: none;
            border-color: #3498db;
        }

        .form-control:disabled {
            background: #ecf0f1;
            cursor: not-allowed;
        }

        .alert {
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .alert-danger {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .products-section {
            margin-top: 20px;
        }

        .products-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        .products-table thead {
            background: #34495e;
            color: white;
        }

        .products-table th,
        .products-table td {
            padding: 12px 10px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .products-table select,
        .products-table input {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        .btn-remove {
            padding: 5px 10px;
            font-size: 12px;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 30px;
        }

        .add-product-btn {
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <jsp:include page="../fragments/navbar.jsp"/>

    <div class="form-container">
        <div class="form-header">
            <h1>${ticket != null ? 'Edit' : 'Add New'} Transfer Ticket</h1>
            <a href="${pageContext.request.contextPath}/transfer-tickets" class="btn btn-secondary">
                ← Back to List
            </a>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/transfer-tickets" method="post" id="ticketForm">
            <input type="hidden" name="action" value="${ticket != null ? 'update' : 'create'}">
            <c:if test="${ticket != null}">
                <input type="hidden" name="id" value="${ticket.id}">
            </c:if>

            <!-- Basic Information -->
            <div class="form-card">
                <h2>Basic Information</h2>
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label required">Ticket Code</label>
                        <input type="text" name="ticketCode" class="form-control" 
                               value="${ticket != null ? ticket.ticketCode : ticketCode}" 
                               ${ticket != null ? 'readonly' : 'readonly'} required>
                    </div>

                    <div class="form-group">
                        <label class="form-label required">Type</label>
                        <select name="type" class="form-control" required>
                            <option value="">-- Select Type --</option>
                            <option value="Import" ${ticket != null && ticket.type == 'Import' ? 'selected' : ''}>Import</option>
                            <option value="Export" ${ticket != null && ticket.type == 'Export' ? 'selected' : ''}>Export</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label required">Request Date</label>
                        <input type="date" name="requestDate" class="form-control" 
                               value="${ticket != null ? ticket.requestDate : ''}" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label required">Assigned Employee</label>
                        <select name="employeeId" class="form-control" required>
                            <option value="">-- Select Employee --</option>
                            <c:forEach items="${employees}" var="emp">
                                <option value="${emp.userId}" 
                                        ${ticket != null && ticket.employeeId == emp.userId ? 'selected' : ''}>
                                    ${emp.displayName} (${emp.accountName})
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group full-width">
                        <label class="form-label">Note</label>
                        <textarea name="note" class="form-control" rows="3">${ticket != null ? ticket.note : ''}</textarea>
                    </div>
                </div>
            </div>

            <!-- Products Section -->
            <div class="form-card">
                <h2>Products</h2>
                <div class="products-section">
                    <table class="products-table" id="productsTable">
                        <thead>
                            <tr>
                                <th style="width: 50%;">Product</th>
                                <th style="width: 30%;">Quantity</th>
                                <th style="width: 20%;">Action</th>
                            </tr>
                        </thead>
                        <tbody id="productRows">
                            <c:choose>
                                <c:when test="${ticket != null && not empty ticket.items}">
                                    <c:forEach items="${ticket.items}" var="item" varStatus="status">
                                        <tr class="product-row">
                                            <td>
                                                <select name="productId" class="form-control" required>
                                                    <option value="">-- Select Product --</option>
                                                    <c:forEach items="${products}" var="prod">
                                                        <option value="${prod.id}" 
                                                                ${item.productId == prod.id ? 'selected' : ''}>
                                                            ${prod.productCode} - ${prod.name}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <td>
                                                <input type="number" name="quantity" class="form-control" 
                                                       min="1" value="${item.quantity}" required>
                                            </td>
                                            <td>
                                                <button type="button" class="btn btn-danger btn-remove" 
                                                        onclick="removeProductRow(this)">Remove</button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr class="product-row">
                                        <td>
                                            <select name="productId" class="form-control" required>
                                                <option value="">-- Select Product --</option>
                                                <c:forEach items="${products}" var="prod">
                                                    <option value="${prod.id}">
                                                        ${prod.productCode} - ${prod.name}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td>
                                            <input type="number" name="quantity" class="form-control" 
                                                   min="1" value="1" required>
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-danger btn-remove" 
                                                    onclick="removeProductRow(this)">Remove</button>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                    <button type="button" class="btn btn-success add-product-btn" onclick="addProductRow()">
                        + Add Product
                    </button>
                </div>
            </div>

            <!-- Form Actions -->
            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/transfer-tickets" class="btn btn-secondary">Cancel</a>
                <button type="submit" class="btn btn-primary">
                    ${ticket != null ? 'Update' : 'Create'} Ticket
                </button>
            </div>
        </form>
    </div>

    <script>
        // Product options template
        const productOptions = `
            <option value="">-- Select Product --</option>
            <c:forEach items="${products}" var="prod">
                <option value="${prod.id}">${prod.productCode} - ${prod.name}</option>
            </c:forEach>
        `;

        function addProductRow() {
            const tbody = document.getElementById('productRows');
            const newRow = document.createElement('tr');
            newRow.className = 'product-row';
            newRow.innerHTML = `
                <td>
                    <select name="productId" class="form-control" required>
                        ${productOptions}
                    </select>
                </td>
                <td>
                    <input type="number" name="quantity" class="form-control" 
                           min="1" value="1" required>
                </td>
                <td>
                    <button type="button" class="btn btn-danger btn-remove" 
                            onclick="removeProductRow(this)">Remove</button>
                </td>
            `;
            tbody.appendChild(newRow);
        }

        function removeProductRow(button) {
            const tbody = document.getElementById('productRows');
            const rows = tbody.getElementsByClassName('product-row');
            
            if (rows.length > 1) {
                button.closest('tr').remove();
            } else {
                alert('At least one product is required.');
            }
        }

        // Form validation
        document.getElementById('ticketForm').addEventListener('submit', function(e) {
            const productRows = document.querySelectorAll('.product-row');
            let hasValidProduct = false;

            productRows.forEach(row => {
                const productSelect = row.querySelector('select[name="productId"]');
                const quantityInput = row.querySelector('input[name="quantity"]');
                
                if (productSelect.value && quantityInput.value > 0) {
                    hasValidProduct = true;
                }
            });

            if (!hasValidProduct) {
                e.preventDefault();
                alert('Please add at least one product with valid quantity.');
            }
        });

        // Set today as default date if adding new ticket
        <c:if test="${ticket == null}">
            const today = new Date().toISOString().split('T')[0];
            document.querySelector('input[name="requestDate"]').value = today;
        </c:if>
    </script>
</body>
<!-- Bootstrap JS (dropdown, responsive navbar) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</html>

