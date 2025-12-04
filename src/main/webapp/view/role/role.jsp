<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"/>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
<link rel="stylesheet" href="assets/css/role.css">
<div class="container mt-4">

    <h2 class="mb-3">Role Management</h2>

    <!-- Search + Filter Row -->
    <form class="row mb-3">
        <div class="col-md-4">
            <input name="search" value="${search}" class="form-control" placeholder="Search role name...">
        </div>

        <div class="col-md-3">
            <select name="status" class="form-select">
                <option value="all" ${status=="all"?"selected":""}>All</option>
                <option value="active" ${status=="active"?"selected":""}>Active</option>
                <option value="inactive" ${status=="inactive"?"selected":""}>Inactive</option>
            </select>
        </div>

        <div class="col-md-2">
            <button class="btn btn-primary w-100">Search</button>
        </div>
    </form>

    <!-- New row for Add Role button -->
    <div class="mb-3">
        <button type="button" class="btn btn-success"
                data-bs-toggle="modal" data-bs-target="#addModal">
            Add Role
        </button>
    </div>

    <!-- Table -->
    <table class="table table-striped table-bordered">
        <thead>
            <tr>
                <th>Index</th>
                <th>Name</th>
                <th>Description</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>

        <tbody>
            <c:forEach var="r" items="${roles}" varStatus="i">
                <tr>
                    <td>${i.index + 1}</td>  <!-- Index -->
                    <td>${r.roleName}</td>
                    <td class="description">${r.roleDescription}</td>
                    <td>
                        <span class="badge ${r.status=='active'?'bg-success':'bg-danger'}">${r.status}</span>
                    </td>
                    <td>
                        <button class="btn btn-info btn-sm"
                                onclick="openDetail(${r.roleId}, '${r.roleName}', '${r.roleDescription}', '${r.status}')">
                            <i class="bi bi-eye-fill"></i> Detail
                        </button>

                        <button class="btn btn-warning btn-sm"
                                onclick="openEdit(${r.roleId}, '${r.roleName}', '${r.roleDescription}', '${r.status}')">
                            <i class="bi bi-pencil-square"></i> Edit
                        </button>

                        <form method="post" style="display:inline;">
                            <input type="hidden" name="action" value="toggle">
                            <input type="hidden" name="id" value="${r.roleId}">

                            <button class="btn ${r.status=='active'?'btn-danger':'btn-success'} btn-sm">
                                <i class="bi ${r.status=='active'?'bi-x-circle-fill':'bi-check-circle-fill'}"></i>
                                ${r.status=='active'?'Deactivate':'Activate'}
                            </button>
                        </form>
                    </td>

                </tr>
            </c:forEach>
        </tbody>
    </table>

    <!-- Pagination -->
    <nav>
        <ul class="pagination">
            <c:forEach begin="1" end="${totalPage}" var="p">
                <li class="page-item ${p==page?'active':''}">
                    <a class="page-link" href="?page=${p}&search=${search}&status=${status}">
                        ${p}
                    </a>
                </li>
            </c:forEach>
        </ul>
    </nav>

</div>

<!-- MODAL ADD -->
<div class="modal fade" id="addModal">
    <div class="modal-dialog">
        <form method="post" class="modal-content" onsubmit="return validateAdd()">
            <input type="hidden" name="action" value="add">

            <div class="modal-header">
                <h5>Add Role</h5>
                <button class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">

                <label>Role Name</label>
                <input name="roleName" id="addName" class="form-control">

                <label>Description</label>
                <textarea name="roleDescription" id="addDesc" class="form-control"></textarea>

            </div>

            <div class="modal-footer">
                <button class="btn btn-primary">Save</button>
                <button class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>
        </form>
    </div>
</div>

<!-- MODAL EDIT -->
<div class="modal fade" id="editModal">
    <div class="modal-dialog">
        <form method="post" class="modal-content" onsubmit="return validateEdit()">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="roleId" id="editId">

            <div class="modal-header">
                <h5>Edit Role</h5>
                <button class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">

                <label>Role Name</label>
                <input name="roleName" id="editName" class="form-control">

                <label>Description</label>
                <textarea name="roleDescription" id="editDesc" class="form-control"></textarea>

                <label>Status</label>
                <select name="status" id="editStatus" class="form-select">
                    <option value="active">Active</option>
                    <option value="inactive">Inactive</option>
                </select>

            </div>

            <div class="modal-footer">
                <button class="btn btn-primary">Update</button>
                <button class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>
        </form>
    </div>
</div>

<!-- MODAL DETAIL -->
<div class="modal fade" id="detailModal">
    <div class="modal-dialog">
        <div class="modal-content">

            <div class="modal-header">
                <h5>Role Detail</h5>
                <button class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <p><b>ID:</b> <span id="dId"></span></p>
                <p><b>Name:</b> <span id="dName"></span></p>
                <p><b>Description:</b> <span id="dDesc"></span></p>
                <p><b>Status:</b> <span id="dStatus"></span></p>
            </div>

        </div>
    </div>
</div>

<script>
    function openEdit(id, name, desc, status) {
        editId.value = id;
        editName.value = name;
        editDesc.value = desc;
        editStatus.value = status;
        new bootstrap.Modal(document.getElementById("editModal")).show();
    }

    function openDetail(id, name, desc, status) {
        dId.innerHTML = id;
        dName.innerHTML = name;
        dDesc.innerHTML = desc;
        dStatus.innerHTML = status;
        new bootstrap.Modal(document.getElementById("detailModal")).show();
    }

    function validateAdd() {
        if (addName.value.trim() === "") {
            alert("Name required");
            return false;
        }
        return true;
    }

    function validateEdit() {
        if (editName.value.trim() === "") {
            alert("Name required");
            return false;
        }
        return true;
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
