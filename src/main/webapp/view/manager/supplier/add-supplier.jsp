<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add New Supplier</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #e6f7ff 0%, #b3e0ff 100%);
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
            box-shadow: 0 5px 20px rgba(0, 102, 204, 0.1);
            transition: transform 0.3s ease;
            background: linear-gradient(135deg, #ffffff 0%, #f8fdff 100%);
        }
        .card:hover {
            transform: translateY(-2px);
        }
        .card-header {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            color: white;
            border-bottom: 3px solid #004085;
            padding: 20px 25px;
            border-radius: 15px 15px 0 0 !important;
        }
        .form-label {
            font-weight: 600;
            color: #0066cc;
            margin-bottom: 8px;
        }
        .form-control, .form-select {
            border-radius: 10px;
            border: 2px solid #b3d9ff;
            padding: 10px 15px;
            transition: all 0.3s ease;
            background-color: #f0f8ff;
        }
        .form-control:focus, .form-select:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.25rem rgba(0, 123, 255, 0.15);
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
            color: #007bff;
            z-index: 10;
        }
        .icon-input input, .icon-input select, .icon-input textarea {
            padding-left: 45px;
        }
        .btn-submit {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            border: none;
            padding: 12px 30px;
            border-radius: 10px;
            font-weight: 600;
            color: white;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0, 123, 255, 0.2);
        }
        .btn-submit:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0, 123, 255, 0.3);
            background: linear-gradient(135deg, #0069d9 0%, #004a9e 100%);
        }
        .btn-back {
            padding: 12px 25px;
            border-radius: 10px;
            font-weight: 500;
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            border: none;
            color: white;
            transition: all 0.3s ease;
        }
        .btn-back:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(108, 117, 125, 0.2);
        }
        .section-title {
            color: #007bff;
            font-weight: 600;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e6f2ff;
            display: flex;
            align-items: center;
        }
        .section-title i {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 10px;
            color: white;
        }
        .alert-custom {
            background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
            border: 2px solid #ffc107;
            border-radius: 10px;
            color: #856404;
        }
        .info-box {
            background: linear-gradient(135deg, #e6f7ff 0%, #cce7ff 100%);
            border: 2px solid #b3d9ff;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
        }
        .sidebar { background-color: #343a40; color: white; min-height: calc(100vh - 56px); padding-top: 20px; }
        .sidebar .nav-link { color: rgba(255, 255, 255, 0.8); padding: 10px 15px; }
        .sidebar .nav-link:hover { color: white; background-color: rgba(255, 255, 255, 0.1); }
        .sidebar .nav-link.active { color: white; background-color: #0d6efd; }
        .required-star {
            color: #ff4757;
        }
        .form-group {
            margin-bottom: 25px;
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
                    <h2 class="fw-bold mb-1" style="color: #0066cc; text-shadow: 1px 1px 3px rgba(0,0,0,0.1);">
                        <i class="fas fa-truck-loading me-2"></i>Add New Supplier
                    </h2>
                    <p class="text-muted" style="color: #4d94ff !important;">Register a new supplier for your inventory management</p>
                </div>
                <a href="../supplier-list" class="btn btn-back">
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
                        <div class="alert alert-custom alert-dismissible fade show mb-4" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <strong>Error:</strong> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <div class="info-box mb-4">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-info-circle me-3" style="color: #007bff; font-size: 1.5rem;"></i>
                            <div>
                                <h6 class="mb-1 fw-bold" style="color: #0066cc;">Important Information</h6>
                                <p class="mb-0" style="color: #4d94ff;">Fill in all required fields marked with <span class="required-star">*</span>. Supplier Code must be unique.</p>
                            </div>
                        </div>
                    </div>

                    <form method="post" action="supplier-add">
                        <!-- Basic Information Section -->
                        <div class="mb-5">
                            <h4 class="section-title">
                                <i class="fas fa-id-card"></i>Basic Information
                            </h4>

                            <div class="row">
                                <div class="col-md-6 form-group">
                                    <label class="form-label">Supplier Code <span class="required-star">*</span></label>
                                    <div class="icon-input">
                                        <i class="fas fa-barcode"></i>
                                        <input type="text" name="supplierCode" class="form-control"
                                               placeholder="Enter unique supplier code" required
                                               pattern="[A-Za-z0-9\-]+" title="Alphanumeric characters and hyphens only">
                                    </div>
                                    <small class="text-muted" style="color: #4d94ff !important;">Unique identifier for the supplier</small>
                                </div>

                                <div class="col-md-6 form-group">
                                    <label class="form-label">Supplier Name <span class="required-star">*</span></label>
                                    <div class="icon-input">
                                        <i class="fas fa-building"></i>
                                        <input type="text" name="name" class="form-control"
                                               placeholder="Enter supplier company name" required>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 form-group">
                                    <label class="form-label">Contact Person</label>
                                    <div class="icon-input">
                                        <i class="fas fa-user-tie"></i>
                                        <input type="text" name="contactPerson" class="form-control"
                                               placeholder="Enter contact person name">
                                    </div>
                                </div>

                                <div class="col-md-6 form-group">
                                    <label class="form-label">Phone Number</label>
                                    <div class="icon-input">
                                        <i class="fas fa-phone"></i>
                                        <input type="tel" name="phone" class="form-control"
                                               placeholder="Enter phone number">
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 form-group">
                                    <label class="form-label">Email Address</label>
                                    <div class="icon-input">
                                        <i class="fas fa-envelope"></i>
                                        <input type="email" name="email" class="form-control"
                                               placeholder="Enter email address">
                                    </div>
                                </div>

                                <div class="col-md-6 form-group">
                                    <label class="form-label">Status</label>
                                    <div class="icon-input">
                                        <i class="fas fa-toggle-on"></i>
                                        <select name="status" class="form-select" disabled>
                                            <option value="active" selected>Active</option>
                                            <option value="inactive">Inactive</option>
                                        </select>
                                    </div>
                                    <small class="text-muted" style="color: #4d94ff !important;">New suppliers are automatically set to active</small>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-12 form-group">
                                    <label class="form-label">Address</label>
                                    <div class="icon-input">
                                        <i class="fas fa-map-marker-alt"></i>
                                        <textarea name="address" class="form-control" rows="3"
                                                  placeholder="Enter full address"></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex justify-content-between align-items-center pt-4 border-top" style="border-top: 2px solid #e6f2ff !important;">
                            <a href="../supplier-list" class="btn btn-back">
                                <i class="fas fa-times me-2"></i>Cancel
                            </a>
                            <button type="submit" class="btn btn-submit">
                                <i class="fas fa-save me-2"></i>Create Supplier
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
        // Add animation to form elements
        $('.form-control, .form-select').on('focus', function() {
            $(this).parent().find('i').css('color', '#0056b3');
        }).on('blur', function() {
            $(this).parent().find('i').css('color', '#007bff');
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
    });
</script>
</body>
</html>