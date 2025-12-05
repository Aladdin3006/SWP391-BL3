<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Forgot Password - WMS</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-4">
                    <div class="card shadow">
                        <div class="card-header bg-warning text-dark text-center">
                            <h3>Forgot Password</h3>
                        </div>
                        <div class="card-body">
                            <c:if test="${not empty message}">
                                <div class="alert alert-info">${message}</div>
                            </c:if>

                            <p>Enter your email address and we'll send you a link to reset your password.</p>

                            <form action="forgot-password" method="post">
                                <div class="mb-3">
                                    <label class="form-label">Email Address</label>
                                    <input type="email" name="email" class="form-control" required>
                                </div>
                                <div class="d-grid">
                                    <button type="submit" class="btn btn-warning">Send Reset Link</button>
                                </div>
                            </form>
                        </div>
                        <div class="card-footer text-center">
                            <a href="login">Back to Login</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>