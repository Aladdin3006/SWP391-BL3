<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login - WMS</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-4">
                    <div class="card shadow">
                        <div class="card-header bg-primary text-white text-center">
                            <h3>Login</h3>
                        </div>
                        <div class="card-body">
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger">${error}</div>
                            </c:if>

                            <c:if test="${not empty message}">
                                <div class="alert alert-success">${message}</div>
                            </c:if>

                            <form action="login" method="post">
                                <div class="mb-3">
                                    <label class="form-label fw-bold">Username</label>
                                    <input type="text" name="username" class="form-control" placeholder="Enter username" required>
                                </div>
                                <div class="mb-3">
                                    <div class="d-flex justify-content-between">
                                        <label class="form-label fw-bold">Password</label>
                                        <a href="forgot-password" class="text-decoration-none small">Forgot Password?</a>
                                    </div>
                                    <input type="password" name="password" class="form-control" placeholder="Enter password" required>
                                </div>
                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn btn-primary btn-lg">Login</button>
                                </div>
                            </form>
                        </div>
                        <div class="card-footer text-center">
                            Don't have an account? <a href="register">Register here</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
