<%-- /view/auth/unauthorized.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Access Denied - WMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .error-container {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            max-width: 500px;
            width: 100%;
            text-align: center;
        }
        .error-icon {
            font-size: 5rem;
            color: #dc3545;
            margin-bottom: 20px;
        }
        .btn-back {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
            padding: 12px 30px;
            border-radius: 50px;
            font-weight: 600;
            transition: transform 0.3s;
        }
        .btn-back:hover {
            transform: translateY(-3px);
            color: white;
        }
    </style>
</head>
<body>
<div class="error-container">
    <div class="error-icon">
        <i class="fas fa-ban"></i>
    </div>
    <h1 class="text-danger mb-3">Access Denied</h1>
    <p class="lead mb-4">
        You don't have permission to access this page.
    </p>
    <p class="text-muted mb-4">
        If you believe this is an error, please contact your system administrator.
    </p>
    <div class="d-flex justify-content-center gap-3">
        <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">
            <i class="fas fa-home me-2"></i>Go to Home
        </a>
    </div>
</div>
</body>
</html>