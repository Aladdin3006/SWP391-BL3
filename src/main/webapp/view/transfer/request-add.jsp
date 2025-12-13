<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Request Transfer</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                background-color: #f8f9fa;
            }
            .sidebar {
                background-color: #343a40;
                color: white;
                min-height: calc(100vh - 56px);
                padding-top: 20px;
            }
            .sidebar .nav-link {
                color: rgba(255, 255, 255, 0.8);
            }
            .sidebar .nav-link.active {
                color: white;
                background-color: #0d6efd;
            }
        </style>
    </head>
    <body>
        <jsp:include page="/view/fragments/navbar.jsp"/>
        <div class="container-fluid">
            <div class="row">
                <c:set var="activePage" value="request-transfer" scope="request"/>
                <jsp:include page="/view/fragments/sidebar.jsp"/>

                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="text-primary fw-bold mb-0">Create Request Transfer Ticket</h2>
                        <a href="${pageContext.request.contextPath}/request-transfer" class="btn btn-outline-secondary">
                            <i class="fas fa-times me-1"></i> Cancel
                        </a>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/request-transfer/add" method="POST">
                        <div class="card shadow-sm border-0 mb-4">
                            <div class="card-header bg-primary text-white py-3">
                                <h5 class="card-title mb-0 fw-bold"><i class="fas fa-info-circle me-2"></i>Request Information</h5>
                            </div>
                            <div class="card-body p-4">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">Ticket Code <span class="text-danger">*</span></label>
                                        <input type="text" name="ticketCode" class="form-control" value="${ticketCode}" readonly required>
                                        <div class="form-text">Auto-generated ticket code</div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">Transfer Type <span class="text-danger">*</span></label>
                                        <select name="type" class="form-select" required>
                                            <option value="">-- Select Type --</option>
                                            <option value="Internal Transfer">Internal Transfer</option>
                                            <option value="Supplier Return">Supplier Return</option>
                                            <option value="Store Transfer">Store Transfer</option>
                                            <option value="Inventory Adjustment">Inventory Adjustment</option>
                                            <option value="Emergency Transfer">Emergency Transfer</option>
                                            <option value="Seasonal Stock">Seasonal Stock</option>
                                            <option value="Clearance Sale">Clearance Sale</option>
                                            <option value="New Store Opening">New Store Opening</option>
                                            <option value="Warehouse Relocation">Warehouse Relocation</option>
                                            <option value="Supplier Exchange">Supplier Exchange</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">Request Date <span class="text-danger">*</span></label>
                                        <input type="date" name="requestDate" class="form-control" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">Assign Employee</label>
                                        <select name="employeeId" class="form-select">
                                            <option value="">-- Not Assigned --</option>
                                            <c:forEach items="${employees}" var="emp">
                                                <option value="${emp.userId}">${emp.displayName} (${emp.accountName})</option>
                                            </c:forEach>
                                        </select>
                                        <div class="form-text">Select employee responsible for this transfer</div>
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label fw-bold">Note</label>
                                        <textarea name="note" class="form-control" rows="3" placeholder="Enter any additional notes..."></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="card shadow-sm border-0">
                            <div class="card-header bg-success text-white py-3">
                                <h5 class="card-title mb-0 fw-bold"><i class="fas fa-boxes me-2"></i>Product Items</h5>
                            </div>
                            <div class="card-body p-4">
                                <div id="productItems">
                                    <!-- Dynamic product rows will be added here -->
                                </div>
                                
                                <button type="button" class="btn btn-outline-primary" onclick="addProductRow()">
                                    <i class="fas fa-plus me-2"></i> Add Product
                                </button>

                                <hr class="my-4">

                                <div class="d-flex justify-content-end gap-2">
                                    <a href="${pageContext.request.contextPath}/request-transfer" class="btn btn-secondary btn-lg px-4">
                                        Cancel
                                    </a>
                                    <button type="submit" class="btn btn-success btn-lg px-5">
                                        <i class="fas fa-save me-2"></i> Create Request
                                    </button>
                                </div>
                            </div>
                        </div>
                    </form>

                </main>
            </div>
        </div>

        <!-- Product Data -->
        <script id="products-data" type="application/json">
        [
        <c:forEach items="${products}" var="p" varStatus="status">
        {
            "id": ${p.id},
            "code": "${fn:escapeXml(p.productCode)}",
            "name": "${fn:escapeXml(p.name)}"
        }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
        ]
        </script>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            let rowCount = 0;
            let products = [];
            
            try {
                const productsData = document.getElementById('products-data');
                if (productsData && productsData.textContent) {
                    products = JSON.parse(productsData.textContent);
                    console.log('Products loaded:', products.length);
                } else {
                    console.error('Products data not found');
                }
            } catch(e) {
                console.error('Error parsing products data:', e);
            }

            function addProductRow() {
                rowCount++;
                const container = document.getElementById('productItems');
                
                if (!container) {
                    console.error('Container not found');
                    return;
                }
                
                const row = document.createElement('div');
                row.className = 'row mb-3 product-row align-items-end';
                row.id = 'row-' + rowCount;
                
                let productOptions = '<option value="">-- Select Product --</option>';
                
                if (products && products.length > 0) {
                    products.forEach(p => {
                        productOptions += '<option value="' + p.id + '">' + p.code + ' - ' + p.name + '</option>';
                    });
                } else {
                    productOptions += '<option value="" disabled>No products available</option>';
                }
                
                row.innerHTML = 
                    '<div class="col-md-6">' +
                        '<label class="form-label fw-bold">Product <span class="text-danger">*</span></label>' +
                        '<select name="productId" class="form-select" required>' + productOptions + '</select>' +
                    '</div>' +
                    '<div class="col-md-4">' +
                        '<label class="form-label fw-bold">Quantity <span class="text-danger">*</span></label>' +
                        '<input type="number" name="quantity" class="form-control" min="1" required placeholder="0">' +
                    '</div>' +
                    '<div class="col-md-2">' +
                        '<button type="button" class="btn btn-danger w-100" onclick="removeProductRow(' + rowCount + ')">' +
                            '<i class="fas fa-trash"></i> Remove' +
                        '</button>' +
                    '</div>';
                
                container.appendChild(row);
                console.log('Row added:', rowCount);
            }

            function removeProductRow(id) {
                const row = document.getElementById('row-' + id);
                if (row) {
                    row.remove();
                    console.log('Row removed:', id);
                }
            }

            // Add one row by default when page loads
            document.addEventListener('DOMContentLoaded', function() {
                console.log('Page loaded, adding first row');
                addProductRow();
            });
        </script>
    </body>
</html>

