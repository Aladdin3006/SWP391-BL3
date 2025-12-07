<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Role List</title>
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
<jsp:include page="/view/fragments/navbar.jsp" />

<div class="container-fluid mt-0">
    <div class="row">
        <c:set var="activePage" value="role" scope="request"/>
        <jsp:include page="/view/fragments/sidebar.jsp"/>

        <main class="col-md-10 ms-sm-auto px-4">
            <h1 class="h2">Role Management</h1>

            <div class="card p-3 mb-4">
                <form action="view-role-list" method="get" class="row g-3 align-items-center">
                    <div class="col-md-4">
                        <input type="text" name="keyword" value="${keyword}" class="form-control" placeholder="Search by name...">
                    </div>
                    <div class="col-md-3">
                        <select name="status" class="form-select">
                            <option value="all" ${status == 'all' ? 'selected' : ''}>--- All Status ---</option>
                            <option value="active" ${status == 'active' ? 'selected' : ''}>✅ Active</option>
                            <option value="inactive" ${status == 'inactive' ? 'selected' : ''}>❌ Inactive</option>
                        </select>
                    </div>
                    <div class="col-md-5 d-flex align-items-center">
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary" title="Search">
                                <i class="fas fa-search"></i>
                            </button>
                            <a href="view-role-list" class="btn btn-secondary" title="Reset">
                                <i class="fas fa-rotate-right"></i>
                            </a>
                        </div>
                        <button type="button" class="btn btn-success ms-auto" title="Add Role"
                                data-bs-toggle="modal" data-bs-target="#addModal">
                            <i class="fas fa-plus"></i> Add Role
                        </button>
                    </div>
                </form>
            </div>

            <div class="table-responsive card p-3">
                <table class="table table-bordered table-hover align-middle mb-0">
                    <thead class="table-primary text-center">
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Status</th>
                        <th>Permission</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty roles}">
                            <c:forEach var="r" items="${roles}" varStatus="st">
                                <tr>
                                    <td>${r.roleId}</td>
                                    <td>${r.roleName}</td>
                                    <td>${r.roleDescription}</td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${r.status == 'active'}">
                                                <i class="fas fa-check-circle text-success" title="Active"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fas fa-times-circle text-danger" title="Inactive"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <a href="${pageContext.request.contextPath}/role-permission?roleId=${r.roleId}"
                                           class="btn btn-sm btn-warning text-white" title="Edit Permissions">
                                            <i class="fas fa-key"></i>
                                        </a>
                                    </td>
                                    <td class="text-center">
                                        <button type="button" class="btn btn-sm btn-info text-white" title="Edit"
                                                onclick="openEdit(${r.roleId}, '${r.roleName}', '${r.roleDescription}', '${r.status}')">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6" class="text-center text-muted">
                                    No roles found for your search.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>

            <nav aria-label="Role pagination" class="mt-4">
                <ul class="pagination justify-content-end">
                    <li class="page-item ${pageIndex == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="view-role-list?page=${pageIndex - 1}&keyword=${keyword}&status=${status}"><</a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="p">
                        <li class="page-item ${p == pageIndex ? 'active' : ''}">
                            <a class="page-link" href="view-role-list?page=${p}&keyword=${keyword}&status=${status}">${p}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${pageIndex == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="view-role-list?page=${pageIndex + 1}&keyword=${keyword}&status=${status}">></a>
                    </li>
                </ul>
            </nav>
        </main>
    </div>
</div>

<div class="modal fade" id="addModal">
    <div class="modal-dialog">
        <form method="post" class="modal-content">
            <input type="hidden" name="action" value="add">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fa fa-plus"></i> Add Role</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label fw-bold">Role Name</label>
                    <input type="text" name="roleName" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold">Description</label>
                    <textarea name="roleDescription" class="form-control" rows="3"></textarea>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold">Status</label>
                    <select name="status" class="form-select">
                        <option value="active" selected>✅ Active</option>
                        <option value="inactive">❌ Inactive</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> Save
                </button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>
        </form>
    </div>
</div>

<div class="modal fade" id="editModal">
    <div class="modal-dialog">
        <form method="post" class="modal-content">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="roleId" id="editRoleId">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fa fa-edit"></i> Edit Role</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label fw-bold">Role Name</label>
                    <input type="text" name="roleName" id="editRoleName" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold">Description</label>
                    <textarea name="roleDescription" id="editRoleDescription" class="form-control" rows="3"></textarea>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold">Status</label>
                    <select name="status" id="editRoleStatus" class="form-select">
                        <option value="active">✅ Active</option>
                        <option value="inactive">❌ Inactive</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> Update
                </button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>
        </form>
    </div>
</div>

<div class="modal fade" id="deleteModal">
    <div class="modal-dialog">
        <form method="post" class="modal-content">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="roleId" id="deleteRoleId">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title"><i class="fa fa-trash"></i> Confirm Delete</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete role:
                    <b id="deleteRoleName" class="text-danger"></b>?
                </p>
                <p class="text-muted">This will toggle the role status.</p>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-danger">
                    <i class="fas fa-trash"></i> Delete
                </button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function openEdit(id, name, description, status) {
        document.getElementById('editRoleId').value = id;
        document.getElementById('editRoleName').value = name;
        document.getElementById('editRoleDescription').value = description;
        document.getElementById('editRoleStatus').value = status;

        var editModal = new bootstrap.Modal(document.getElementById('editModal'));
        editModal.show();
    }

    function openDelete(id, name) {
        document.getElementById('deleteRoleId').value = id;
        document.getElementById('deleteRoleName').textContent = name;

        var deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
        deleteModal.show();
    }
</script>
</body>
</html>