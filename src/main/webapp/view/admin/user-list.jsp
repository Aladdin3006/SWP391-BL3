<%--
  Created by IntelliJ IDEA.
  User: truyd
  Date: 04/12/2025
  Time: 6:46 CH
  To change this template use File | Settings | File Templates.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Danh sách người dùng</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; padding: 20px; background-color: #f4f6f9; }

        .filter-box {
            background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            display: flex; gap: 15px; flex-wrap: wrap; align-items: flex-end; margin-bottom: 20px;
        }
        .form-group { display: flex; flex-direction: column; }
        .form-group label { font-size: 14px; font-weight: 600; margin-bottom: 5px; color: #333; }
        .form-group input, .form-group select {
            padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; min-width: 200px; font-size: 14px;
        }
        .btn-filter {
            padding: 9px 20px; background-color: #007bff; color: white; border: none; border-radius: 4px;
            cursor: pointer; font-weight: bold; margin-bottom: 1px;
        }
        .btn-filter:hover { background-color: #0056b3; }

        table { width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #eee; }
        th { background-color: #343a40; color: white; font-weight: 600; text-transform: uppercase; font-size: 13px; }
        tr:hover { background-color: #f1f1f1; }

        .badge { padding: 5px 10px; border-radius: 12px; font-size: 12px; font-weight: bold; text-align: center; display: inline-block; min-width: 80px;}

        .role-admin { background-color: #ffd700; color: #856404; }
        .role-manager { background-color: #ff8c00; color: white; }
        .role-employee { background-color: #28a745; color: white; }
        .role-other { background-color: #6c757d; color: white; }

        .status-active { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .status-inactive { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

        .btn-action { padding: 6px 12px; font-size: 12px; border-radius: 4px; text-decoration: none; color: white; display: inline-block; }
        .btn-lock { background-color: #dc3545; }
        .btn-lock:hover { background-color: #c82333; }
        .btn-unlock { background-color: #28a745; }
        .btn-unlock:hover { background-color: #218838; }
    </style>
</head>
<body>

<h2 style="color: #333;">Quản Lý Người Dùng</h2>

<form action="users" method="GET" class="filter-box">
    <div class="form-group">
        <label>Tên người dùng</label>
        <input type="text" name="searchName" value="${searchName}" placeholder="Nhập tên...">
    </div>

    <div class="form-group">
        <label>Email</label>
        <input type="text" name="searchEmail" value="${searchEmail}" placeholder="Nhập email...">
    </div>

    <div class="form-group">
        <label>Vai trò</label>
        <select name="roleId">
            <option value="0">-- Tất cả --</option>
            <c:forEach items="${roles}" var="r">
                <option value="${r.roleId}" ${selectedRoleId == r.roleId ? 'selected' : ''}>${r.roleName}</option>
            </c:forEach>
        </select>
    </div>

    <div class="form-group">
        <label>Trạng thái</label>
        <select name="status">
            <option value="all" ${selectedStatus == 'all' ? 'selected' : ''}>-- Tất cả --</option>
            <option value="active" ${selectedStatus == 'active' ? 'selected' : ''}>Hoạt động</option>
            <option value="inactive" ${selectedStatus == 'inactive' ? 'selected' : ''}>Vô hiệu hóa</option>
        </select>
    </div>

    <button type="submit" class="btn-filter">Tìm kiếm</button>
</form>

<table>
    <thead>
    <tr>
        <th style="width: 50px; text-align: center;">STT</th>
        <th>Họ và tên</th>
        <th>Email</th>
        <th>Số điện thoại</th>
        <th style="text-align: center;">Vai trò</th>
        <th style="text-align: center;">Trạng thái</th>
        <th style="text-align: center;">Hành động</th>
    </tr>
    </thead>
    <tbody>
    <c:if test="${empty users}">
        <tr>
            <td colspan="7" style="text-align: center; padding: 20px;">Không tìm thấy người dùng nào.</td>
        </tr>
    </c:if>
    <c:forEach items="${users}" var="u" varStatus="loop">
        <tr>
            <td style="text-align: center;">${loop.index + 1}</td>
            <td>
                <strong>${u.displayName}</strong><br>
                <span style="font-size: 12px; color: #888;">@${u.accountName}</span>
            </td>
            <td>${u.email}</td>
            <td>${u.phone}</td>

            <td style="text-align: center;">
                <c:choose>
                    <c:when test="${u.roleName == 'admin'}"><span class="badge role-admin">${u.roleName}</span></c:when>
                    <c:when test="${u.roleName == 'manager'}"><span class="badge role-manager">${u.roleName}</span></c:when>
                    <c:when test="${u.roleName == 'employee'}"><span class="badge role-employee">${u.roleName}</span></c:when>
                    <c:otherwise><span class="badge role-other">${u.roleName}</span></c:otherwise>
                </c:choose>
            </td>

            <td style="text-align: center;">
                        <span class="badge ${u.status == 'active' ? 'status-active' : 'status-inactive'}">
                                ${u.status == 'active' ? 'Hoạt động' : 'Vô hiệu hóa'}
                        </span>
            </td>

            <td style="text-align: center;">
                <c:if test="${u.status == 'active'}">
                    <a href="users?action=deactivate&userId=${u.userId}" class="btn-action btn-lock"
                       onclick="return confirm('Bạn chắc chắn muốn VÔ HIỆU HÓA người dùng này?')">Khóa</a>
                </c:if>
                <c:if test="${u.status == 'inactive'}">
                    <a href="users?action=activate&userId=${u.userId}" class="btn-action btn-unlock">Mở khóa</a>
                </c:if>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>

</body>
</html>
