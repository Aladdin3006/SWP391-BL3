<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Supplier Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            min-height: 100vh;
        }
        .main-content {
            padding-top: 20px;
            padding-bottom: 40px;
            margin-left: 0;
        }
        .card {
            border-radius: 15px;
            border: none;
            box-shadow: 0 5px 25px rgba(33, 150, 243, 0.15);
            background: linear-gradient(135deg, #ffffff 0%, #f5fbff 100%);
            border: 2px solid #90caf9;
        }
        .card-header {
            background: linear-gradient(135deg, #2196f3 0%, #0d47a1 100%);
            color: white;
            border-bottom: 3px solid #1565c0;
            padding: 20px 25px;
            border-radius: 15px 15px 0 0 !important;
        }
        .btn-back {
            padding: 12px 25px;
            border-radius: 10px;
            font-weight: 500;
            background: linear-gradient(135deg, #546e7a 0%, #37474f 100%);
            border: none;
            color: white;
            transition: all 0.3s ease;
        }
        .btn-back:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(84, 110, 122, 0.2);
        }
        .btn-edit {
            background: linear-gradient(135deg, #2196f3 0%, #0d47a1 100%);
            border: none;
            padding: 12px 30px;
            border-radius: 10px;
            font-weight: 600;
            color: white;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(33, 150, 243, 0.2);
        }
        .btn-edit:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(33, 150, 243, 0.3);
        }
        .badge-status {
            padding: 10px 20px;
            border-radius: 25px;
            font-weight: 600;
            font-size: 0.9rem;
            border: 2px solid transparent;
        }
        .badge-active {
            background: linear-gradient(135deg, #c8e6c9 0%, #a5d6a7 100%);
            color: #1b5e20;
            border-color: #4caf50;
            box-shadow: 0 2px 10px rgba(76, 175, 80, 0.2);
        }
        .badge-inactive {
            background: linear-gradient(135deg, #ffcdd2 0%, #ef9a9a 100%);
            color: #b71c1c;
            border-color: #f44336;
            box-shadow: 0 2px 10px rgba(244, 67, 54, 0.2);
        }
        .info-card {
            background: linear-gradient(135deg, #ffffff 0%, #e3f2fd 100%);
            padding: 25px;
            border-radius: 12px;
            border: 2px solid #bbdefb;
            text-align: center;
            transition: all 0.3s ease;
            height: 100%;
            box-shadow: 0 4px 15px rgba(187, 222, 251, 0.3);
        }
        .info-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 8px 25px rgba(33, 150, 243, 0.2);
            border-color: #2196f3;
        }
        .info-icon {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 1.8rem;
            color: white;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .info-icon.code {
            background: linear-gradient(135deg, #2196f3 0%, #0d47a1 100%);
        }
        .info-icon.name {
            background: linear-gradient(135deg, #42a5f5 0%, #1976d2 100%);
        }
        .info-icon.contact {
            background: linear-gradient(135deg, #64b5f6 0%, #1565c0 100%);
        }
        .info-icon.status {
            background: linear-gradient(135deg, #90caf9 0%, #0d47a1 100%);
        }
        .info-title {
            color: #546e7a;
            font-size: 0.95rem;
            margin-bottom: 8px;
            font-weight: 500;
        }
        .info-value {
            color: #1565c0;
            font-size: 1.6rem;
            font-weight: 700;
            margin-bottom: 5px;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
        }
        .detail-section {
            background: linear-gradient(135deg, #f5fbff 0%, #e3f2fd 100%);
            padding: 25px;
            border-radius: 12px;
            border: 2px solid #bbdefb;
            margin-bottom: 25px;
        }
        .detail-label {
            color: #0d47a1;
            font-weight: 600;
            font-size: 0.9rem;
            margin-bottom: 5px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .detail-value {
            color: #1565c0;
            font-size: 1.1rem;
            font-weight: 500;
            padding: 10px 15px;
            background: white;
            border-radius: 8px;
            border: 1px solid #e3f2fd;
            min-height: 45px;
            display: flex;
            align-items: center;
        }
        .contact-info {
            background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
            border: 2px solid #81c784;
            border-radius: 12px;
            padding: 20px;
            margin-top: 20px;
        }
        .empty-value {
            color: #90a4ae;
            font-style: italic;
        }
        .action-buttons {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 25px;
            border-top: 3px solid #e3f2fd;
            margin-top: 25px;
        }
        .sidebar { background-color: #343a40; color: white; min-height: calc(100vh - 56px); padding-top: 20px; }
        .sidebar .nav-link { color: rgba(255, 255, 255, 0.8); padding: 10px 15px; }
        .sidebar .nav-link:hover { color: white; background-color: rgba(255, 255, 255, 0.1); }
        .sidebar .nav-link.active { color: white; background-color: #0d6efd; }
        .supplier-code-badge {
            background: linear-gradient(135deg, #2196f3 0%, #0d47a1 100%);
            color: white;
            padding: 8px 20px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 1.1rem;
            display: inline-block;
            box-shadow: 0 2px 10px rgba(33, 150, 243, 0.3);
        }
    </style>
</head>
<body>
<jsp:include page="/view/fragments/navbar.jsp"/>
<div class="container-fluid">
    <div class="row">
        <c:set var="activePage" value="supplier-list" scope="request"/>
        <jsp:include page="/view/fragments/sidebar.jsp"/>

        <main class="col-md-10 ms-sm-auto px-md-4 main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold mb-1" style="color: #0d47a1; text-shadow: 1px 1px 3px rgba(0,0,0,0.1);">
                        <i class="fas fa-truck me-2"></i>Supplier Details
                    </h2>
                    <p class="text-muted" style="color: #2196f3 !important;">View complete information about the supplier</p>
                </div>
                <a href="${pageContext.request.contextPath}/supplier-list" class="btn btn-back">
                    <i class="fas fa-arrow-left me-2"></i>Back to List
                </a>
            </div>

            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0 fw-bold">
                        <i class="fas fa-info-circle me-2"></i>Supplier Information
                    </h5>
                </div>

                <div class="card-body p-4">
                    <!-- Summary Cards -->
                    <div class="row mb-5">
                        <div class="col-lg-3 col-md-6 mb-4">
                            <div class="info-card">
                                <div class="info-icon code">
                                    <i class="fas fa-barcode"></i>
                                </div>
                                <div class="info-title">Supplier Code</div>
                                <div class="info-value">${supplier.supplierCode}</div>
                                <small class="text-muted">Unique Identifier</small>
                            </div>
                        </div>

                        <div class="col-lg-3 col-md-6 mb-4">
                            <div class="info-card">
                                <div class="info-icon name">
                                    <i class="fas fa-building"></i>
                                </div>
                                <div class="info-title">Supplier Name</div>
                                <div class="info-value">${supplier.name}</div>
                                <small class="text-muted">Company/Organization</small>
                            </div>
                        </div>

                        <div class="col-lg-3 col-md-6 mb-4">
                            <div class="info-card">
                                <div class="info-icon contact">
                                    <i class="fas fa-user-tie"></i>
                                </div>
                                <div class="info-title">Contact Person</div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty supplier.contactPerson}">${supplier.contactPerson}</c:when>
                                        <c:otherwise><span class="empty-value">Not specified</span></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-3 col-md-6 mb-4">
                            <div class="info-card">
                                <div class="info-icon status">
                                    <i class="fas fa-chart-line"></i>
                                </div>
                                <div class="info-title">Status</div>
                                <div>
                                    <span class="badge-status ${supplier.status == 'active' ? 'badge-active' : 'badge-inactive'}">
                                        <i class="fas ${supplier.status == 'active' ? 'fa-check-circle' : 'fa-times-circle'} me-1"></i>
                                        ${supplier.status}
                                    </span>
                                </div>
                                <small class="text-muted">Supplier ID: ${supplier.id}</small>
                            </div>
                        </div>
                    </div>

                    <!-- Detailed Information -->
                    <div class="row">
                        <div class="col-md-6 mb-4">
                            <div class="detail-section">
                                <h5 class="fw-bold mb-4" style="color: #0d47a1; border-bottom: 2px solid #bbdefb; padding-bottom: 10px;">
                                    <i class="fas fa-info-circle me-2"></i>Basic Details
                                </h5>

                                <div class="row mb-3">
                                    <div class="col-12">
                                        <div class="detail-label">Supplier ID</div>
                                        <div class="detail-value">${supplier.id}</div>
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-12">
                                        <div class="detail-label">Supplier Code</div>
                                        <div class="detail-value">
                                            <span class="supplier-code-badge">${supplier.supplierCode}</span>
                                        </div>
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-12">
                                        <div class="detail-label">Supplier Name</div>
                                        <div class="detail-value">${supplier.name}</div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-12">
                                        <div class="detail-label">Address</div>
                                        <div class="detail-value">
                                            <c:choose>
                                                <c:when test="${not empty supplier.address}">
                                                    <i class="fas fa-map-marker-alt me-2 text-primary"></i>${supplier.address}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="empty-value">No address provided</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6 mb-4">
                            <div class="detail-section">
                                <h5 class="fw-bold mb-4" style="color: #0d47a1; border-bottom: 2px solid #bbdefb; padding-bottom: 10px;">
                                    <i class="fas fa-address-book me-2"></i>Contact Information
                                </h5>

                                <div class="row mb-3">
                                    <div class="col-12">
                                        <div class="detail-label">Contact Person</div>
                                        <div class="detail-value">
                                            <c:choose>
                                                <c:when test="${not empty supplier.contactPerson}">
                                                    <i class="fas fa-user-tie me-2 text-primary"></i>${supplier.contactPerson}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="empty-value">Not specified</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-12">
                                        <div class="detail-label">Phone Number</div>
                                        <div class="detail-value">
                                            <c:choose>
                                                <c:when test="${not empty supplier.phone}">
                                                    <i class="fas fa-phone me-2 text-success"></i>${supplier.phone}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="empty-value">No phone number</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-12">
                                        <div class="detail-label">Email Address</div>
                                        <div class="detail-value">
                                            <c:choose>
                                                <c:when test="${not empty supplier.email}">
                                                    <i class="fas fa-envelope me-2 text-danger"></i>${supplier.email}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="empty-value">No email address</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-12">
                                        <div class="detail-label">Status</div>
                                        <div class="detail-value">
                                            <span class="badge-status ${supplier.status == 'active' ? 'badge-active' : 'badge-inactive'}">
                                                <i class="fas ${supplier.status == 'active' ? 'fa-check-circle' : 'fa-times-circle'} me-1"></i>
                                                ${supplier.status == 'active' ? 'Active Supplier' : 'Inactive Supplier'}
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="action-buttons">
                        <div>
                            <c:if test="${supplier.status == 'active'}">
                                <a href="${pageContext.request.contextPath}/supplier-list?action=deactivate&id=${supplier.id}"
                                   class="btn btn-danger me-2"
                                   onclick="return confirm('Are you sure you want to deactivate ${supplier.name}? This may affect inventory operations.')"
                                   style="border-radius: 10px; padding: 12px 25px; font-weight: 600; background: linear-gradient(135deg, #f44336 0%, #c62828 100%); border: none;">
                                    <i class="fas fa-ban me-2"></i>Deactivate Supplier
                                </a>
                            </c:if>
                            <c:if test="${supplier.status == 'inactive'}">
                                <a href="${pageContext.request.contextPath}/supplier-list?action=activate&id=${supplier.id}"
                                   class="btn btn-success me-2"
                                   onclick="return confirm('Activate ${supplier.name}?')"
                                   style="border-radius: 10px; padding: 12px 25px; font-weight: 600; background: linear-gradient(135deg, #4caf50 0%, #2e7d32 100%); border: none;">
                                    <i class="fas fa-check me-2"></i>Activate Supplier
                                </a>
                            </c:if>
                        </div>
                        <div>
                            <a href="${pageContext.request.contextPath}/supplier-update?id=${supplier.id}" class="btn btn-edit">
                                <i class="fas fa-edit me-2"></i>Edit Supplier
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {
        // Animate info cards on load
        $('.info-card').each(function(index) {
            $(this).css('opacity', '0').css('transform', 'translateY(20px)');
            setTimeout(() => {
                $(this).animate({
                    opacity: 1,
                    marginTop: '0px'
                }, 500 + (index * 100));
            }, 100);
        });

        // Hover effects for buttons
        $('.btn').hover(function() {
            $(this).css('transform', 'translateY(-3px)');
        }, function() {
            $(this).css('transform', 'translateY(0)');
        });

        // Confirmation for deactivation/activation
        $('a[href*="action=deactivate"], a[href*="action=activate"]').click(function(e) {
            if (!confirm($(this).attr('onclick') ? '' : $(this).attr('data-confirm'))) {
                e.preventDefault();
            }
        });
    });
</script>
</body>
</html>