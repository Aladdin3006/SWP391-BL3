<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - WMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }

        .profile-container {
            max-width: 800px;
            margin: 0 auto;
        }

        .profile-card {
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .profile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 30px;
            text-align: center;
        }

        .profile-avatar {
            width: 120px;
            height: 120px;
            background-color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            border: 4px solid white;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }

        .profile-avatar i {
            font-size: 60px;
            color: #667eea;
        }

        .profile-body {
            padding: 30px;
            background-color: white;
        }

        .info-item {
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }

        .info-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 5px;
        }

        .info-value {
            color: #212529;
        }

        .edit-form {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-top: 20px;
        }

        .email-warning {
            background-color: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 5px;
            padding: 10px;
            margin-bottom: 15px;
            color: #856404;
        }
    </style>
</head>
<body>
<jsp:include page="navbar.jsp"/>

<div class="container mt-4 mb-5">
    <div class="profile-container">
        <div class="profile-card">
            <div class="profile-header">
                <div class="profile-avatar">
                    <i class="fas fa-user"></i>
                </div>
                <h2>${profileUser.displayName}</h2>
                <p class="mb-0">${profileUser.role.roleName}</p>
            </div>

            <div class="profile-body">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <c:if test="${not empty message}">
                    <div class="alert alert-success">${message}</div>
                </c:if>

                <c:if test="${not empty emailChangeMessage}">
                    <div class="email-warning">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                            ${emailChangeMessage}
                    </div>
                </c:if>

                <div class="row">
                    <div class="col-md-6">
                        <div class="info-item">
                            <div class="info-label">Account Name</div>
                            <div class="info-value">${profileUser.accountName}</div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="info-item">
                            <div class="info-label">User ID</div>
                            <div class="info-value">${profileUser.userId}</div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="info-item">
                            <div class="info-label">Display Name</div>
                            <div class="info-value">${profileUser.displayName}</div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="info-item">
                            <div class="info-label">Email</div>
                            <div class="info-value">${profileUser.email}</div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="info-item">
                            <div class="info-label">Phone</div>
                            <div class="info-value">${profileUser.phone}</div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="info-item">
                            <div class="info-label">Status</div>
                            <div class="info-value">
                                <span class="badge ${profileUser.status == 'active' ? 'bg-success' : 'bg-warning'}">
                                    ${profileUser.status}
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="info-item">
                            <div class="info-label">Role</div>
                            <div class="info-value">${profileUser.role.roleName}</div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="info-item">
                            <div class="info-label">Department ID</div>
                            <div class="info-value">${profileUser.departmentId}</div>
                        </div>
                    </div>
                </div>

                <hr class="my-4">

                <div class="d-flex justify-content-between">
                    <button class="btn btn-primary" type="button" data-bs-toggle="collapse" data-bs-target="#editForm">
                        <i class="fas fa-edit me-2"></i>Edit Profile
                    </button>

                    <a href="home" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left me-2"></i>Back to Home
                    </a>
                </div>

                <div class="collapse mt-4" id="editForm">
                    <div class="edit-form">
                        <h4>Edit Profile Information</h4>
                        <form method="post" action="profile">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="currentEmail" value="${profileUser.email}">

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Display Name</label>
                                    <input type="text" class="form-control" name="displayName" value="${profileUser.displayName}" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Email</label>
                                    <input type="email" class="form-control" name="email" value="${profileUser.email}" required>
                                    <div class="form-text">Changing email requires verification</div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Phone</label>
                                    <input type="tel" class="form-control" name="phone" value="${profileUser.phone}">
                                </div>
                            </div>

                            <div class="mt-3">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-2"></i>Save Changes
                                </button>
                                <button type="button" class="btn btn-outline-secondary" data-bs-toggle="collapse" data-bs-target="#editForm">
                                    Cancel
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"></script>
</body>
</html>