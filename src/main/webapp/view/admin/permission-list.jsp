<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>Permission Management</title>

    <!-- Bootstrap -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"/>

    <!-- FontAwesome Icons -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <!-- Custom CSS -->
    <link rel="stylesheet" href="assets/css/permission.css"/>

</head>
<body>

<div class="container mt-4">

    <!-- PAGE TITLE -->
    <h2 class="text-center mb-4 fw-bold">Permission Management</h2>

    <!-- SEARCH + SORT + ADD -->
    <form method="get" class="row g-3 mb-3">

        <!-- Search -->
        <div class="col-md-4">
            <input type="text" name="search" value="${search}"
                   class="form-control"
                   placeholder="Search permission name..."/>
        </div>

        <!-- Sort Field -->
        <div class="col-md-3">
            <select name="sort" class="form-select">
                <option value="permissionId" ${sort=="permissionId"?"selected":""}>Sort by ID</option>
                <option value="permissionName" ${sort=="permissionName"?"selected":""}>Sort by Name</option>
            </select>
        </div>

        <!-- Sort Direction -->
        <div class="col-md-2">
            <select name="dir" class="form-select">
                <option value="ASC" ${dir=="ASC"?"selected":""}>ASC</option>
                <option value="DESC" ${dir=="DESC"?"selected":""}>DESC</option>
            </select>
        </div>

        <!-- Search Button -->
        <div class="col-md-1">
            <button class="btn btn-primary w-100">
                <i class="fa fa-search"></i>
            </button>
        </div>

        <!-- Add Button -->
        <div class="col-md-2">
            <button type="button" class="btn btn-success w-100"
                    data-bs-toggle="modal" data-bs-target="#addModal">
                <i class="fa fa-plus"></i> Add
            </button>
        </div>

    </form>

    <!-- TABLE -->
    <table class="table table-striped table-bordered align-middle text-center">

        <thead class="table-primary">
        <tr>
            <th style="width: 60px;">#</th>
            <th style="width: 180px;">Permission Name</th>
            <th style="width: 200px;">URL</th>
            <th>Description</th>
            <th style="width: 220px;">Actions</th>
        </tr>
        </thead>

        <tbody>
        <c:if test="${empty permissions}">
            <tr><td colspan="5" class="text-danger">No permission found</td></tr>
        </c:if>

        <c:forEach var="p" items="${permissions}" varStatus="i">
            <tr>
                <td>${(page-1)*5 + i.index + 1}</td>
                <td>${p.permissionName}</td>
                <td>${p.url}</td>
                <td class="text-start">${p.description}</td>

                <td>

                    <!-- Edit Button -->
                    <button class="btn btn-warning btn-sm"
                            onclick="openEdit(${p.permissionId},'${p.permissionName}','${p.url}','${p.description}')">
                        <i class="fa fa-edit"></i> Edit
                    </button>

                    <!-- Delete Button -->
                    <button class="btn btn-danger btn-sm"
                            onclick="openDelete(${p.permissionId},'${p.permissionName}')">
                        <i class="fa fa-trash"></i> Delete
                    </button>

                </td>
            </tr>
        </c:forEach>
        </tbody>

    </table>

    <!-- PAGINATION -->
    <nav>
        <ul class="pagination justify-content-center">
            <c:forEach begin="1" end="${totalPage}" var="p">
                <li class="page-item ${page==p?'active':''}">
                    <a class="page-link"
                       href="?page=${p}&search=${search}&sort=${sort}&dir=${dir}">
                        ${p}
                    </a>
                </li>
            </c:forEach>
        </ul>
    </nav>

</div>


<!-- =================== MODAL: ADD =================== -->
<div class="modal fade" id="addModal">
    <div class="modal-dialog">
        <form method="post" class="modal-content">

            <input type="hidden" name="action" value="add"/>

            <div class="modal-header">
                <h5 class="modal-title"><i class="fa fa-plus"></i> Add Permission</h5>
                <button class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <label class="fw-bold">Permission Name</label>
                <input name="permissionName" class="form-control mb-2" required/>

                <label class="fw-bold">URL</label>
                <input name="url" class="form-control mb-2" required/>

                <label class="fw-bold">Description</label>
                <textarea name="description" class="form-control"></textarea>
            </div>

            <div class="modal-footer">
                <button class="btn btn-primary">
                    <i class="fa fa-save"></i> Save
                </button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    Cancel
                </button>
            </div>

        </form>
    </div>
</div>


<!-- =================== MODAL: EDIT =================== -->
<div class="modal fade" id="editModal">
    <div class="modal-dialog">
        <form method="post" class="modal-content">

            <input type="hidden" name="action" value="edit"/>
            <input type="hidden" name="permissionId" id="editId"/>

            <div class="modal-header">
                <h5 class="modal-title"><i class="fa fa-edit"></i> Edit Permission</h5>
                <button class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">

                <label class="fw-bold">Permission Name</label>
                <input id="editName" name="permissionName" class="form-control mb-2"/>

                <label class="fw-bold">URL</label>
                <input id="editUrl" name="url" class="form-control mb-2"/>

                <label class="fw-bold">Description</label>
                <textarea id="editDesc" name="description" class="form-control"></textarea>

            </div>

            <div class="modal-footer">
                <button class="btn btn-primary">
                    <i class="fa fa-save"></i> Update
                </button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    Cancel
                </button>
            </div>

        </form>
    </div>
</div>


<!-- =================== MODAL: DELETE =================== -->
<div class="modal fade" id="deleteModal">
    <div class="modal-dialog">
        <form method="post" class="modal-content">

            <input type="hidden" name="action" value="delete"/>
            <input type="hidden" name="permissionId" id="deleteId"/>

            <div class="modal-header bg-danger text-white">
                <h5><i class="fa fa-trash"></i> Confirm Delete</h5>
                <button class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <p>Do you want to delete permission:  
                   <b id="deleteName" class="text-danger"></b> ?</p>
            </div>

            <div class="modal-footer">
                <button class="btn btn-danger">
                    <i class="fa fa-trash"></i> Delete
                </button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    Cancel
                </button>
            </div>

        </form>
    </div>
</div>


<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function openEdit(id, name, url, desc) {
        editId.value = id;
        editName.value = name;
        editUrl.value = url;
        editDesc.value = desc;
        new bootstrap.Modal(document.getElementById("editModal")).show();
    }

    function openDelete(id, name) {
        deleteId.value = id;
        deleteName.innerHTML = name;
        new bootstrap.Modal(document.getElementById("deleteModal")).show();
    }
</script>

</body>
</html>
