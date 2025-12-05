<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add New User - Admin</title>

    <!-- (Optional) Bootstrap cho dễ nhìn, có thể bỏ nếu project bạn không dùng -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">

<div class="container mt-5">
    <h2 class="mb-4">Add New User</h2>

    <!-- Hiển thị lỗi nếu có -->
    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
    <div class="alert alert-danger">
        <%= error %>
    </div>
    <%
        }
    %>

    <form method="post" action="${pageContext.request.contextPath}/user/adduser" class="card p-4 shadow-sm">

        <div class="mb-3">
            <label class="form-label">Account Name</label>
            <input type="text" name="accountName" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Display Name</label>
            <input type="text" name="displayName" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Password</label>
            <input type="password" name="password" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Email</label>
            <input type="email" name="email" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Phone</label>
            <input type="text" name="phone" class="form-control">
        </div>

        <div class="mb-3">
            <label class="form-label">Role ID</label>
            <input type="number" name="roleId" class="form-control" required>
            <!-- Ví dụ: 1 = Admin, 2 = Staff, ... -->
        </div>

        <div class="mb-3">
            <label class="form-label">Workspace ID</label>
            <input type="number" name="workspaceId" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Status</label>
            <select name="status" class="form-select">
                <option value="active" selected>active</option>
                <option value="inactive">inactive</option>
            </select>
        </div>
        <div class="d-flex justify-content-between">
            <a href="${pageContext.request.contextPath}" class="btn btn-secondary">
                Back to User List
            </a>
            <button type="submit" class="btn btn-primary">
                Create User
            </button>
        </div>
    </form>
</div>

</body>
</html>

