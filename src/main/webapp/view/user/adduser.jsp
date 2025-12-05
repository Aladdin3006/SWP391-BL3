<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add New User - Admin</title>
    <style>
        body {
            background: #f5f7fa;
            font-family: Arial, sans-serif;
        }

        .card {
            border-radius: 12px;
            border: 1px solid #e0e6ed;
            background: #ffffff;
        }

        h2 {
            font-weight: 600;
            color: #333;
        }

        .form-label {
            font-weight: 600;
            color: #444;
        }

        /* Input style */
        input.form-control,
        select.form-select {
            border-radius: 8px;
            padding: 10px 12px;
            border: 1px solid #cdd4da;
            transition: all 0.2s ease-in-out;
        }

        input.form-control:focus,
        select.form-select:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 4px rgba(13, 110, 253, 0.4);
        }

        /* Error message highlight */
        .error-message {
            color: #d93025;
            font-size: 14px;
            margin-top: 4px;
            font-weight: 500;
        }

        /* Button style */
        button.btn-primary {
            padding: 10px 20px;
            font-weight: 600;
            border-radius: 8px;
            box-shadow: 0 3px 6px rgba(0, 123, 255, 0.3);
            transition: transform 0.15s ease-in-out;
        }

        button.btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 10px rgba(0, 123, 255, 0.4);
        }

        button.btn-primary:active {
            transform: scale(0.98);
        }
    </style>
    <!-- (Optional) Bootstrap cho dễ nhìn, có thể bỏ nếu project bạn không dùng -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">

</head>
<body class="bg-light">

<div class="container mt-5">
    <h2 class="mb-4">Add New User</h2>


    <form method="post" action="${pageContext.request.contextPath}/user/adduser" class="card p-4 shadow-sm">

        <div class="mb-3">
            <label class="form-label">Account Name</label>
            <input type="text" id="accountName" name="accountName" class="form-control" value="${accountName}" required>
            <p class="error-message" id ="errAccountName">${errAccountName}</p>
        </div>

        <div class="mb-3">
            <label class="form-label">Display Name</label>
            <input type="text" id="displayName" name="displayName" class="form-control" value="${displayName}" required>
            <p class="error-message" id ="errDisplayName">${errDisplayName}</p>

        </div>

        <div class="mb-3">
            <label class="form-label">Password</label>
            <input type="password" id="password" name="password" class="form-control" value="${password}" required>
            <p class="error-message" id ="errPassword">${errPassword}</p>

        </div>
        <div class="mb-3">
            <label class="form-label">Confirm Password</label>
            <input type="password" id="cfpassword" name="cfpassword" class="form-control" value="${cfpassword}" required>
            <p class="error-message" id ="errCfPassword">${errCfPassword}</p>
        </div>
        <div class="mb-3">
            <label class="form-label">Email</label>
            <input type="email" id="email" name="email" class="form-control" value="${email}" required>
                <p class="error-message" id ="errEmail">${errEmail}</p>
        </div>

        <div class="mb-3">
            <label class="form-label">Phone</label>
            <input type="text" id="phone" name="phone" class="form-control" value="${phone}">
            <p class="error-message" id ="errPhone">${errPhone}</p>

        </div>

        <div class="mb-3">
            <label class="form-label">Role ID</label>
            <select id="roleId" name="roleId" class="form-select">
                <option value="">Select Role</option>
                <option value="2" ${roleId == 2 ? "selected" : ""}>Manager</option>
                <option value="3" ${roleId == 3 ? "selected" : ""}>Employee</option>
                <option value="4" ${roleId == 4 ? "selected" : ""}>Storekeeper</option>
            </select>
            <p class="error-message" id ="errRole">${errRole}</p>

        </div>

        <div class="d-flex justify-content-between">
            <button type="submit" class="btn btn-primary">
                Create
            </button>
        </div>
    </form>
</div>
<script>
    const form = document.querySelector("form");

    const accountName = document.getElementById("accountName");
    const displayName = document.getElementById("displayName");
    const password = document.getElementById("password");
    const cfpassword = document.getElementById("cfpassword");
    const email = document.getElementById("email");
    const phone = document.getElementById("phone");
    const roleId = document.getElementById("roleId");

    form.addEventListener("submit", function (e) {
        let isValid = true;

        // Account Name
        if (accountName.value.trim() === "") {
            document.getElementById("errAccountName").innerText = "Account Name cannot be empty";
            isValid = false;
        } else {
            document.getElementById("errAccountName").innerText = "";
        }

        // Display Name
        if (displayName.value.trim() === "") {
            document.getElementById("errDisplayName").innerText = "Display Name cannot be empty";
            isValid = false;
        } else {
            document.getElementById("errDisplayName").innerText = "";
        }

        // Password length
        if (password.value.length < 6 || password.value.length > 20) {
            document.getElementById("errPassword").innerText = "Password must be 6–20 characters";
            isValid = false;
        } else {
            document.getElementById("errPassword").innerText = "";
        }

        // Confirm Password
        if (cfpassword.value !== password.value) {
            document.getElementById("errCfPassword").innerText = "Passwords do not match";
            isValid = false;
        } else {
            document.getElementById("errCfPassword").innerText = "";
        }

        // Email empty
        if (email.value.trim() === "") {
            document.getElementById("errEmail").innerText = "Email cannot be empty";
            isValid = false;
        } else {
            document.getElementById("errEmail").innerText = "";
        }

        // Role required
        if (roleId.value === "") {
            document.getElementById("errRole").innerText = "Role is required";
            isValid = false;
        } else {
            document.getElementById("errRole").innerText = "";
        }

        // Stop submit nếu có lỗi
        if (!isValid) {
            e.preventDefault();
        }
    });
</script>

</body>
</html>

