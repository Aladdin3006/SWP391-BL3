<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Edit Request Transfer</title>
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
                <div>
                    <h2 class="text-primary fw-bold mb-0">Edit Request Transfer Ticket</h2>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/request-transfer">Request Transfers</a></li>
                            <li class="breadcrumb-item active">${ticket.ticketCode}</li>
                        </ol>
                    </nav>
                </div>
                <a href="${pageContext.request.contextPath}/request-transfer/detail?id=${ticket.id}" class="btn btn-outline-secondary">
                    <i class="fas fa-times me-1"></i> Cancel
                </a>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Status Alert (hidden by default) -->
            <div id="statusAlert" class="alert alert-warning alert-dismissible fade show <c:if test="${ticket.status != 'Completed'}">d-none</c:if>" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>
                <span id="alertMessage">Request will be sent to your Storekeeper. Are you sure you want to update this request?</span>
            </div>

            <form action="${pageContext.request.contextPath}/request-transfer/edit" method="POST" id="requestForm">
                <input type="hidden" name="id" value="${ticket.id}">

                <div class="card shadow-sm border-0 mb-4">
                    <div class="card-header bg-primary text-white py-3">
                        <h5 class="card-title mb-0 fw-bold"><i class="fas fa-info-circle me-2"></i>Request Information</h5>
                    </div>
                    <div class="card-body p-4">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Ticket Code</label>
                                <input type="text" class="form-control" value="${ticket.ticketCode}" readonly>
                                <div class="form-text">Ticket code cannot be changed</div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Transfer Type <span class="text-danger">*</span></label>
                                <select name="type" class="form-select" required>
                                    <option value="Import" ${ticket.type == 'Import' ? 'selected' : ''}>Import</option>
                                    <option value="Export" ${ticket.type == 'Export' ? 'selected' : ''}>Export</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Request Date <span class="text-danger">*</span></label>
                                <input type="date" name="requestDate" class="form-control" value="${ticket.requestDate}" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Status <span class="text-danger">*</span></label>
                                <select name="status" id="statusSelect" class="form-select" required>
                                    <option value="Pending" ${ticket.status == 'Pending' ? 'selected' : ''}>Pending</option>
                                    <option value="Completed" ${ticket.status == 'Completed' ? 'selected' : ''}>Completed</option>
                                    <option value="Rejected" ${ticket.status == 'Rejected' ? 'selected' : ''}>Rejected</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Assign Storekeeper <span class="text-danger">*</span></label>
                                <select name="storekeeperId" class="form-select" required>
                                    <option value="">-- Select Storekeeper --</option>
                                    <c:forEach items="${storekeepers}" var="sk">
                                        <option value="${sk.userId}" ${ticket.storekeeperId == sk.userId ? 'selected' : ''}>
                                                ${sk.displayName} (${sk.accountName})
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="form-text">
                                    <i class="fas fa-info-circle"></i> Select storekeeper in your department to handle this request
                                </div>
                            </div>
                            <div class="col-12">
                                <label class="form-label fw-bold">Note</label>
                                <textarea name="note" class="form-control" rows="3">${ticket.note}</textarea>
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
                            <c:if test="${not empty ticket.productTransfers}">
                                <c:forEach items="${ticket.productTransfers}" var="item" varStatus="status">
                                    <div class="row mb-3 product-row align-items-end" id="row-${status.index}">
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">Product <span class="text-danger">*</span></label>
                                            <select name="productId" class="form-select" required>
                                                <c:forEach items="${products}" var="p">
                                                    <option value="${p.id}" ${item.productId == p.id ? 'selected' : ''}>
                                                        <c:out value="${p.productCode}"/> - <c:out value="${p.name}"/>
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label fw-bold">Quantity <span class="text-danger">*</span></label>
                                            <input type="number" name="quantity" class="form-control" min="1" value="${item.quantity}" required>
                                        </div>
                                        <div class="col-md-2">
                                            <button type="button" class="btn btn-danger w-100 btn-remove-row" data-row-id="${status.index}">
                                                <i class="fas fa-trash"></i> Remove
                                            </button>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:if>
                        </div>

                        <button type="button" class="btn btn-outline-primary" onclick="addProductRow()">
                            <i class="fas fa-plus me-2"></i> Add Product
                        </button>

                        <hr class="my-4">

                        <div class="d-flex justify-content-end gap-2">
                            <a href="${pageContext.request.contextPath}/request-transfer/detail?id=${ticket.id}" class="btn btn-secondary btn-lg px-4">
                                Cancel
                            </a>
                            <button type="submit" id="submitBtn" class="btn btn-success btn-lg px-5">
                                <i class="fas fa-save me-2"></i> Update Request
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
<script id="init-data" type="application/json">
    {"rowCount": <c:choose><c:when test="${empty ticket.productTransfers}">0</c:when><c:otherwise>${ticket.productTransfers.size()}</c:otherwise></c:choose>}
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const initData = JSON.parse(document.getElementById('init-data').textContent);
    let rowCount = initData.rowCount;
    const products = JSON.parse(document.getElementById('products-data').textContent);

    function addProductRow() {
        const container = document.getElementById('productItems');
        const row = document.createElement('div');
        row.className = 'row mb-3 product-row align-items-end';
        row.id = 'row-' + rowCount;

        let productOptions = '<option value="">-- Select Product --</option>';
        products.forEach(p => {
            productOptions += '<option value="' + p.id + '">' + p.code + ' - ' + p.name + '</option>';
        });

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
        rowCount++;
    }

    function removeProductRow(id) {
        const row = document.getElementById('row-' + id);
        if (row) {
            row.remove();
        }
    }

    // Status change handler
    document.addEventListener('DOMContentLoaded', function() {
        const statusSelect = document.getElementById('statusSelect');
        const statusAlert = document.getElementById('statusAlert');
        const alertMessage = document.getElementById('alertMessage');
        const submitBtn = document.getElementById('submitBtn');
        const requestForm = document.getElementById('requestForm');

        // Initialize button based on current status
        if ('${ticket.status}' === 'Completed') {
            submitBtn.innerHTML = '<i class="fas fa-check-circle me-2"></i> Confirm & Update Request';
            submitBtn.classList.remove('btn-success');
            submitBtn.classList.add('btn-warning');
        }

        if (statusSelect) {
            statusSelect.addEventListener('change', function() {
                if (this.value === 'Completed') {
                    statusAlert.classList.remove('d-none');
                    // Change submit button text to indicate confirmation needed
                    submitBtn.innerHTML = '<i class="fas fa-check-circle me-2"></i> Confirm & Update Request';
                    submitBtn.classList.remove('btn-success');
                    submitBtn.classList.add('btn-warning');
                } else {
                    statusAlert.classList.add('d-none');
                    // Reset submit button
                    submitBtn.innerHTML = '<i class="fas fa-save me-2"></i> Update Request';
                    submitBtn.classList.remove('btn-warning');
                    submitBtn.classList.add('btn-success');
                }
            });
        }

        // Form submission handler for Completed status confirmation
        if (requestForm) {
            requestForm.addEventListener('submit', function(e) {
                const currentStatus = statusSelect.value;

                if (currentStatus === 'Completed') {
                    if (!confirm('Request will be sent to your Storekeeper. Are you sure you want to update this request?')) {
                        e.preventDefault();
                        return false;
                    }
                }
                return true;
            });
        }

        // Event delegation for remove buttons
        document.addEventListener('click', function(e) {
            if (e.target.closest('.btn-remove-row')) {
                const btn = e.target.closest('.btn-remove-row');
                const rowId = btn.getAttribute('data-row-id');
                removeProductRow(rowId);
            }
        });
    });
</script>
</body>
</html>