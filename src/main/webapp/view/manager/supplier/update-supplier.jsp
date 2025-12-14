<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Supplier</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #e0f7fa 0%, #80deea 100%);
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
            box-shadow: 0 5px 20px rgba(0, 150, 136, 0.15);
            background: linear-gradient(135deg, #ffffff 0%, #e8f4f8 100%);
            border: 2px solid #80deea;
        }
        .card-header {
            background: linear-gradient(135deg, #009688 0%, #00796b 100%);
            color: white;
            border-bottom: 3px solid #004d40;
            padding: 20px 25px;
            border-radius: 15px 15px 0 0 !important;
        }
        .form-label {
            font-weight: 600;
            color: #00897b;
            margin-bottom: 8px;
        }
        .form-control, .form-select, .form-textarea {
            border-radius: 10px;
            border: 2px solid #80deea;
            padding: 10px 15px;
            transition: all 0.3s ease;
            background-color: #e0f7fa;
        }
        .form-control:focus, .form-select:focus, .form-textarea:focus {
            border-color: #009688;
            box-shadow: 0 0 0 0.25rem rgba(0, 150, 136, 0.15);
            background-color: #ffffff;
        }
        .icon-input {
            position: relative;
        }
        .icon-input i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #009688;
            z-index: 10;
        }
        .icon-input input, .icon-input select, .icon-input textarea {
            padding-left: 45px;
        }
        .btn-submit {
            background: linear-gradient(135deg, #009688 0%, #00796b 100%);
            border: none;
            padding: 12px 30px;
            border-radius: 10px;
            font-weight: 600;
            color: white;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0, 150, 136, 0.2);
        }
        .btn-submit:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0, 150, 136, 0.3);
            background: linear-gradient(135deg, #00897b 0%, #00695c 100%);
        }
        .btn-back {
            padding: 12px 25px;
            border-radius: 10px;
            font-weight: 500;
            background: linear-gradient(135deg, #607d8b 0%, #455a64 100%);
            border: none;
            color: white;
            transition: all 0.3s ease;
        }
        .btn-back:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(96, 125, 139, 0.2);
        }
        .section-title {
            color: #00796b;
            font-weight: 600;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #b2dfdb;
            display: flex;
            align-items: center;
        }
        .section-title i {
            background: linear-gradient(135deg, #009688 0%, #00796b 100%);
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 10px;
            color: white;
        }
        .badge-status {
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: 500;
            font-size: 0.85rem;
        }
        .badge-active {
            background: linear-gradient(135deg, #a7ffeb 0%, #64ffda 100%);
            color: #004d40;
            border: 1px solid #1de9b6;
        }
        .badge-inactive {
            background: linear-gradient(135deg, #ffccbc 0%, #ff8a65 100%);
            color: #bf360c;
            border: 1px solid #ff7043;
        }
        .readonly-field {
            background-color: #e8f5e9 !important;
            color: #2e7d32 !important;
            font-weight: 500;
            border-color: #81c784 !important;
        }
        .supplier-id-badge {
            background: linear-gradient(135deg, #4db6ac 0%, #26a69a 100%);
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: 600;
        }
        .info-card {
            background: linear-gradient(135deg, #e0f2f1 0%, #b2dfdb 100%);
            border: 2px solid #80cbc4;
            border-radius: 12px;
            padding: 15px;
            margin-bottom: 20px;
        }
        .sidebar { background-color: #343a40; color: white; min-height: calc(100vh - 56px); padding-top: 20px; }
        .sidebar .nav-link { color: rgba(255, 255, 255, 0.8); padding: 10px 15px; }
        .sidebar .nav-link:hover { color: white; background-color: rgba(255, 255, 255, 0.1); }
        .sidebar .nav-link.active { color: white; background-color: #0d6efd; }
        .required-star {
            color: #f44336;
        }
        .form-group {
            margin-bottom: 25px;
        }
        .status-badge {
            font-size: 0.9rem;
            padding: 6px 12px;
            border-radius: 15px;
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
                    <h2 class="fw-bold mb-1" style="color: #00796b; text-shadow: 1px 1px 3px rgba(0,0,0,0.1);">
                        <i class="fas fa-edit me-2"></i>Update Supplier
                    </h2>
                    <p class="text-muted" style="color: #26a69a !important;">Edit supplier information and status</p>
                </div>
                <a href="${pageContext.request.contextPath}/supplier-list" class="btn btn-back">
                    <i class="fas fa-arrow-left me-2"></i>Back to List
                </a>
            </div>

            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0 fw-bold">
                        <i class="fas fa-truck me-2"></i>Supplier Information
                    </h5>
                </div>

                <div class="card-body p-4">
                    <c:if test="${not empty error}">
                        <div class="alert alert-warning alert-dismissible fade show mb-4" role="alert" style="background: linear-gradient(135deg, #fff8e1 0%, #ffecb3 100%); border: 2px solid #ffb300;">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <strong>Error:</strong> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <div class="info-card mb-4">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-info-circle me-3" style="color: #009688; font-size: 1.5rem;"></i>
                            <div>
                                <h6 class="mb-1 fw-bold" style="color: #00796b;">Editing Supplier ID: <span class="supplier-id-badge">${supplier.id}</span></h6>
                                <p class="mb-0" style="color: #26a69a;">Update supplier details. Required fields marked with <span class="required-star">*</span>.</p>
                            </div>
                        </div>
                    </div>

                    <form method="post" action="${pageContext.request.contextPath}/supplier-update">
                        <input type="hidden" name="id" value="${supplier.id}">

                        <!-- Basic Information Section -->
                        <div class="mb-5">
                            <h4 class="section-title">
                                <i class="fas fa-id-card"></i>Basic Information
                            </h4>

                            <div class="row">
                                <div class="col-md-6 form-group">
                                    <label class="form-label">Supplier ID</label>
                                    <input type="text" class="form-control readonly-field" value="${supplier.id}" readonly>
                                </div>
                                <div class="col-md-6 form-group">
                                    <label class="form-label">Current Status</label>
                                    <div>
                                        <span class="badge-status ${supplier.status == 'active' ? 'badge-active' : 'badge-inactive'}">
                                            <i class="fas ${supplier.status == 'active' ? 'fa-check-circle' : 'fa-times-circle'} me-1"></i>
                                            ${supplier.status}
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 form-group">
                                    <label class="form-label">Supplier Code <span class="required-star">*</span></label>
                                    <div class="icon-input">
                                        <i class="fas fa-barcode"></i>
                                        <input type="text" name="supplierCode" class="form-control"
                                               value="${supplier.supplierCode}" required
                                               pattern="[A-Za-z0-9\-]+" title="Alphanumeric characters and hyphens only">
                                    </div>
                                    <small class="text-muted" style="color: #26a69a !important;">Unique identifier</small>
                                </div>

                                <div class="col-md-6 form-group">
                                    <label class="form-label">Supplier Name <span class="required-star">*</span></label>
                                    <div class="icon-input">
                                        <i class="fas fa-building"></i>
                                        <input type="text" name="name" class="form-control"
                                               value="${supplier.name}" required>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 form-group">
                                    <label class="form-label">Contact Person</label>
                                    <div class="icon-input">
                                        <i class="fas fa-user-tie"></i>
                                        <input type="text" name="contactPerson" class="form-control"
                                               value="${supplier.contactPerson}">
                                    </div>
                                </div>

                                <div class="col-md-6 form-group">
                                    <label class="form-label">Phone Number</label>
                                    <div class="icon-input">
                                        <i class="fas fa-phone"></i>
                                        <input type="tel" name="phone" class="form-control"
                                               value="${supplier.phone}">
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 form-group">
                                    <label class="form-label">Email Address</label>
                                    <div class="icon-input">
                                        <i class="fas fa-envelope"></i>
                                        <input type="email" name="email" class="form-control"
                                               value="${supplier.email}">
                                    </div>
                                </div>

                                <div class="col-md-6 form-group">
                                    <label class="form-label">Update Status</label>
                                    <div class="icon-input">
                                        <i class="fas fa-toggle-on"></i>
                                        <select name="status" class="form-select">
                                            <option value="active" ${supplier.status == 'active' ? 'selected' : ''}>Active</option>
                                            <option value="inactive" ${supplier.status == 'inactive' ? 'selected' : ''}>Inactive</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-12 form-group">
                                    <label class="form-label">Address</label>
                                    <div class="icon-input">
                                        <i class="fas fa-map-marker-alt"></i>
                                        <textarea name="address" class="form-control form-textarea" rows="3">${supplier.address}</textarea>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex justify-content-between align-items-center pt-4 border-top" style="border-top: 2px solid #b2dfdb !important;">
                            <div>
                                <a href="${pageContext.request.contextPath}/supplier-detail?id=${supplier.id}" class="btn btn-info me-2"
                                   style="background: linear-gradient(135deg, #4db6ac 0%, #26a69a 100%); border: none; color: white;">
                                    <i class="fas fa-eye me-2"></i>View Details
                                </a>
                                <a href="${pageContext.request.contextPath}/supplier-list" class="btn btn-back">
                                    <i class="fas fa-times me-2"></i>Cancel
                                </a>
                            </div>
                            <button type="submit" class="btn btn-submit">
                                <i class="fas fa-save me-2"></i>Update Supplier
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {
        // Status badge animation
        $('.badge-status').hover(function() {
            $(this).css('transform', 'scale(1.05)');
        }, function() {
            $(this).css('transform', 'scale(1)');
        });

        // Form validation
        $('form').on('submit', function(e) {
            let isValid = true;
            $('input[required]').each(function() {
                if ($(this).val().trim() === '') {
                    $(this).addClass('is-invalid');
                    isValid = false;
                } else {
                    $(this).removeClass('is-invalid');
                }
            });

            if (!isValid) {
                e.preventDefault();
                alert('Please fill in all required fields marked with *.');
            }
        });

        // Real-time validation for supplier code
        $('input[name="supplierCode"]').on('input', function() {
            const value = $(this).val();
            const regex = /^[A-Za-z0-9\-]+$/;
            if (!regex.test(value) && value !== '') {
                $(this).addClass('is-invalid');
            } else {
                $(this).removeClass('is-invalid');
            }
        });
    });
</script>
</body>
</html>