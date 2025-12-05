<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Role Management - WMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .sidebar { background-color: #343a40; color: white; min-height: calc(100vh - 56px); padding-top: 20px; }
        .sidebar .nav-link { color: rgba(255, 255, 255, 0.8); padding: 10px 15px; }
        .sidebar .nav-link:hover { color: white; background-color: rgba(255, 255, 255, 0.1); }
        .sidebar .nav-link.active { color: white; background-color: #0d6efd; }
        .card { border-radius: 10px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); }
    </style>
</head>
<body>
<jsp:include page="../fragments/navbar.jsp"/>

<div class="container-fluid">
    <div class="row">
        <nav class="col-md-2 d-none d-md-block sidebar">
            <div class="position-sticky pt-3">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/user-list">
                            <i class="fas fa-users me-2"></i>Manage Users
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/role-list">
                            <i class="fas fa-user-tag me-2"></i>Manage Roles
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Role Management</h1>
            </div>

            <form class="row mb-3">
                <div class="col-md-4">
                    <input name="search" value="${param.search}" class="form-control" placeholder="Search role name...">
                </div>
                <div class="col-md-3">
                    <select name="status" class="form-select">
                        <option value="all" ${param.status=="all"?"selected":""}>All</option>
                        <option value="active" ${param.status=="active"?"selected":""}>Active</option>
                        <option value="inactive" ${param.status=="inactive"?"selected":""}>Inactive</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <button class="btn btn-primary w-100">Search</button>
                </div>
                <div class="col-md-3 text-end">
                    <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addModal">
                        <i class="fas fa-plus me-1"></i>Add Role
                    </button>
                </div>
            </form>

            <div class="card">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-striped table-bordered">
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Description</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="r" items="${roles}" varStatus="i">
                                <tr>
                                    <td>${r.roleId}</td>
                                    <td>${r.roleName}</td>
                                    <td>${r.roleDescription}</td>
                                    <td>
                                        <span class="badge ${r.status=='active'?'bg-success':'bg-danger'}">${r.status}</span>
                                    </td>
                                    <td>
                                        <button class="btn btn-info btn-sm" onclick="openDetail(${r.roleId}, '${r.roleName}', '${r.roleDescription}', '${r.status}')">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <button class="btn btn-warning btn-sm" onclick="openEdit(${r.roleId}, '${r.roleName}', '${r.roleDescription}', '${r.status}')">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <form method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="toggle">
                                            <input type="hidden" name="id" value="${r.roleId}">
                                            <button class="btn ${r.status=='active'?'btn-danger':'btn-success'} btn-sm">
                                                <c:choose>
                                                    <c:when test="${r.status=='active'}"><i class="fas fa-times"></i></c:when>
                                                    <c:otherwise><i class="fas fa-check"></i></c:otherwise>
                                                </c:choose>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <c:if test="${not empty totalPage and totalPage > 1}">
                        <nav>
                            <ul class="pagination justify-content-center">
                                <c:forEach begin="1" end="${totalPage}" var="p">
                                    <li class="page-item ${p==page?'active':''}">
                                        <a class="page-link" href="?page=${p}&search=${param.search}&status=${param.status}">${p}</a>
                                    </li>
                                </c:forEach>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>
        </main>
    </div>
</div>

<div class="modal fade" id="addModal">
    <div class="modal-dialog">
        <form method="post" class="modal-content">
            <input type="hidden" name="action" value="add">
            <div class="modal-header">
                <h5 class="modal-title">Add Role</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label">Role Name</label>
                    <input name="roleName" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Description</label>
                    <textarea name="roleDescription" class="form-control" rows="3"></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary">Save</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>
        </form>
    </div>
</div>

<div class="modal fade" id="editModal">
    <div class="modal-dialog">
        <form method="post" class="modal-content">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="roleId" id="editId">
            <div class="modal-header">
                <h5 class="modal-title">Edit Role</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label">Role Name</label>
                    <input name="roleName" id="editName" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Description</label>
                    <textarea name="roleDescription" id="editDesc" class="form-control" rows="3"></textarea>
                </div>
                <div class="mb-3">
                    <label class="form-label">Status</label>
                    <select name="status" id="editStatus" class="form-select">
                        <option value="active">Active</option>
                        <option value="inactive">Inactive</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary">Update</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>
        </form>
    </div>
</div>

<div class="modal fade" id="detailModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Role Detail</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p><strong>ID:</strong> <span id="dId"></span></p>
                <p><strong>Name:</strong> <span id="dName"></span></p>
                <p><strong>Description:</strong> <span id="dDesc"></span></p>
                <p><strong>Status:</strong> <span id="dStatus"></span></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function openEdit(id, name, desc, status) {
        document.getElementById("editId").value = id;
        document.getElementById("editName").value = name;
        document.getElementById("editDesc").value = desc;
        document.getElementById("editStatus").value = status;
        new bootstrap.Modal(document.getElementById("editModal")).show();
    }

    function openDetail(id, name, desc, status) {
        document.getElementById("dId").innerHTML = id;
        document.getElementById("dName").innerHTML = name;
        document.getElementById("dDesc").innerHTML = desc;
        document.getElementById("dStatus").innerHTML = status;
        new bootstrap.Modal(document.getElementById("detailModal")).show();
    }
</script>
</body>
</html>