<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add New User - Admin</title>

    <!-- Bootstrap -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">

    <style>
        body {
            background: #f5f7fa;
            font-family: Arial, sans-serif;
        }

        .sidebar {
            height: 100vh;
            background: #ffffff;
            border-right: 1px solid #e0e6ed;
            padding-top: 20px;
        }

        .card-custom {
            border-radius: 12px;
            border: 1px solid #e0e6ed;
            background: #ffffff;
            padding: 20px;
        }

        h2 {
            font-weight: 650;
            color: #333;
        }

        .form-label {
            font-weight: 600;
        }

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

        .error-message {
            color: #d93025;
            font-size: 14px;
            margin-top: 4px;
            font-weight: 500;
        }

        button.btn-primary {
            padding: 10px 20px;
            font-weight: 600;
            border-radius: 8px;
            box-shadow: 0 3px 6px rgba(0, 123, 255, 0.3);
            transition: transform 0.15s ease-in-out;
        }

        button.btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 10px rgba(0,123,255,0.4);
        }

        .btn-cancel {
            padding: 10px 20px;
            font-weight: 600;
            border-radius: 8px;
        }
        .sidebar { background-color: #343a40; color: white; min-height: calc(100vh - 56px); padding-top: 20px; }
        .sidebar .nav-link { color: rgba(255, 255, 255, 0.8); padding: 10px 15px; }
        .sidebar .nav-link:hover { color: white; background-color: rgba(255, 255, 255, 0.1); }
        .sidebar .nav-link.active { color: white; background-color: #0d6efd; }
        .card { border-radius: 10px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); }
    </style>

</head>
<body>

<jsp:include page="/view/fragments/navbar.jsp" />

<div class="container-fluid">
    <div class="row">

        <c:set var="activePage" value="user-list" scope="request"/>
        <jsp:include page="/view/fragments/sidebar.jsp"/>

        <main class="col-md-10 ms-sm-auto px-md-4 mt-4">

            <h2 class="mb-4">Add New User</h2>

            <form method="post"
                  action="${pageContext.request.contextPath}/user/adduser"
                  class="card-custom shadow-sm">

                <div class="row mb-3">
                    <div class="col">
                        <label class="form-label">Account Name</label>
                        <input type="text" id="accountName" name="accountName" class="form-control"
                               value="${accountName}" required>
                        <p class="error-message" id="errAccountName">${errAccountName}</p>
                    </div>

                    <div class="col">
                        <label class="form-label">Display Name</label>
                        <input type="text" id="displayName" name="displayName" class="form-control"
                               value="${displayName}" required>
                        <p class="error-message" id="errDisplayName">${errDisplayName}</p>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col">
                        <label class="form-label">Email</label>
                        <input type="email" id="email" name="email" class="form-control"
                               value="${email}" required>
                        <p class="error-message" id="errEmail">${errEmail}</p>
                    </div>

                    <div class="col">
                        <label class="form-label">Phone</label>
                        <input type="text" id="phone" name="phone" class="form-control"
                               value="${phone}">
                        <p class="error-message" id="errPhone">${errPhone}</p>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Role</label>
                    <select id="roleId" name="roleId" class="form-select" required>
                        <option value="">--- Select Role ---</option>

                        <c:forEach var="r" items="${roles}">
                            <c:if test="${r.roleId != 1}">
                                <option value="${r.roleId}"
                                        <c:if test="${roleId == r.roleId}">selected</c:if>>
                                        ${r.roleName}
                                </option>
                            </c:if>
                        </c:forEach>

                    </select>
                    <p class="error-message" id="errRole">${errRole}</p>
                </div>

                <div class="row mb-3">
                    <div class="col">
                        <label class="form-label">Password</label>
                        <input type="password" id="password" name="password" class="form-control"
                               value="${password}" required>
                        <p class="error-message" id="errPassword">${errPassword}</p>
                    </div>

                    <div class="col">
                        <label class="form-label">Confirm Password</label>
                        <input type="password" id="cfpassword" name="cfpassword" class="form-control"
                               value="${cfpassword}" required>
                        <p class="error-message" id="errCfPassword">${errCfPassword}</p>
                    </div>
                </div>

                <div class="d-flex justify-content-between mt-4 mb-2">
                    <a href="" class="btn btn-secondary btn-cancel" onclick="location.reload(); return false;">
                        Cancel
                    </a>

                    <button type="submit" class="btn btn-primary">Create</button>
                </div>

            </form>

        </main>

    </div>
</div>

<!-- SUCCESS ALERT + REDIRECT -->
<c:if test="${not empty successMessage}">
    <script>
        alert("${successMessage}");
        const userId = "${newUserId}";
        if (userId) {
            window.location.href =
                "${pageContext.request.contextPath}/user/detail?id=" + userId;
        }
    </script>
</c:if>

<!-- ERROR ALERT -->
<c:if test="${not empty errorMessage}">
    <script>alert("${errorMessage}");</script>
</c:if>

<!-- OLD VALIDATION SCRIPT (giữ nguyên) -->
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

        if (accountName.value.trim() === "") {
            document.getElementById("errAccountName").innerText = "Account Name cannot be empty";
            isValid = false;
        } else document.getElementById("errAccountName").innerText = "";

        if (displayName.value.trim() === "") {
            document.getElementById("errDisplayName").innerText = "Display Name cannot be empty";
            isValid = false;
        } else document.getElementById("errDisplayName").innerText = "";

        if (password.value.length < 6 || password.value.length > 20) {
            document.getElementById("errPassword").innerText = "Password must be 6–20 characters";
            isValid = false;
        } else document.getElementById("errPassword").innerText = "";

        if (cfpassword.value !== password.value) {
            document.getElementById("errCfPassword").innerText = "Passwords do not match";
            isValid = false;
        } else document.getElementById("errCfPassword").innerText = "";

        if (email.value.trim() === "") {
            document.getElementById("errEmail").innerText = "Email cannot be empty";
            isValid = false;
        } else document.getElementById("errEmail").innerText = "";

        if (roleId.value === "") {
            document.getElementById("errRole").innerText = "Role is required";
            isValid = false;
        } else document.getElementById("errRole").innerText = "";

        if (!isValid) e.preventDefault();
    });
</script>

</body>
</html>

