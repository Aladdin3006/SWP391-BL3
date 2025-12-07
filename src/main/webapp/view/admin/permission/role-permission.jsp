<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>Role Permission Mapping</title>

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <style>
        body { background-color: #f8f9fa; }
        .sidebar { background-color: #343a40; color: white; min-height: calc(100vh - 56px); padding-top: 20px; }
        .sidebar .nav-link { color: rgba(255, 255, 255, 0.8); padding: 10px 15px; }
        .sidebar .nav-link:hover { color: white; background-color: rgba(255, 255, 255, 0.1); }
        .sidebar .nav-link.active { color: white; background-color: #0d6efd; }
        th, td { text-align: center; vertical-align: middle; }
        td.desc { text-align: left !important; }
        .assigned { background: #d1ffd1 !important; }
    </style>
</head>

<body>
<jsp:include page="/view/fragments/navbar.jsp"/>

<div class="container-fluid">
    <div class="row">
        <c:set var="activePage" value="role" scope="request"/>
        <jsp:include page="/view/fragments/sidebar.jsp"/>

        <main class="col-md-10 ms-sm-auto px-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Role Permission Management – <span class="text-primary">${role.roleName}</span></h1>
            </div>

            <!-- SEARCH + SORT -->
            <form class="row g-3 mb-3">
                <input type="hidden" name="roleId" value="${roleId}"/>

                <div class="col-md-4">
                    <input name="search" value="${search}" class="form-control"
                           placeholder="Search permission..."/>
                </div>

                <div class="col-md-3">
                    <select name="sort" class="form-select">
                        <option value="permissionId" ${sort=="permissionId"?"selected":""}>Sort by ID</option>
                        <option value="permissionName" ${sort=="permissionName"?"selected":""}>Sort by Name</option>
                    </select>
                </div>

                <div class="col-md-2">
                    <select name="dir" class="form-select">
                        <option value="ASC" ${dir=="ASC"?"selected":""}>ASC</option>
                        <option value="DESC" ${dir=="DESC"?"selected":""}>DESC</option>
                    </select>
                </div>

                <div class="col-md-2">
                    <button class="btn btn-primary w-100">
                        <i class="fa fa-search"></i> Search
                    </button>
                </div>

                <div class="col-md-1">
                    <a href="${pageContext.request.contextPath}/view-role-list" class="btn btn-secondary w-100">
                        <i class="fa fa-arrow-left"></i>
                    </a>
                </div>
            </form>

            <!-- TABLE -->
            <table class="table table-bordered table-striped">
                <thead class="table-info">
                <tr>
                    <th>#</th>
                    <th>Name</th>
                    <th>URL</th>
                    <th>Description</th>
                    <th>Assigned?</th>
                    <th>Action</th>
                </tr>
                </thead>

                <tbody>
                <c:forEach var="p" items="${permissions}" varStatus="i">
                    <tr class="${assigned.contains(p.permissionId) ? 'assigned' : ''}">
                        <td>${(page-1)*6 + i.index + 1}</td>
                        <td>${p.permissionName}</td>
                        <td>${p.url}</td>
                        <td class="desc">${p.description}</td>

                        <td>
                            <c:choose>
                                <c:when test="${assigned.contains(p.permissionId)}">
                                    <span class="badge bg-success">YES</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger">NO</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <!-- Assign -->
                            <c:if test="${!assigned.contains(p.permissionId)}">
                                <form method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="assign"/>
                                    <input type="hidden" name="roleId" value="${roleId}"/>
                                    <input type="hidden" name="permissionId" value="${p.permissionId}"/>
                                    <button class="btn btn-success btn-sm">
                                        <i class="fa fa-plus"></i> Assign
                                    </button>
                                </form>
                            </c:if>

                            <!-- Remove -->
                            <c:if test="${assigned.contains(p.permissionId)}">
                                <form method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="remove"/>
                                    <input type="hidden" name="roleId" value="${roleId}"/>
                                    <input type="hidden" name="permissionId" value="${p.permissionId}"/>
                                    <button class="btn btn-danger btn-sm">
                                        <i class="fa fa-trash"></i> Remove
                                    </button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <!-- PAGINATION -->
            <nav>
                <ul class="pagination justify-content-center">
                    <c:forEach begin="1" end="${totalPage}" var="p">
                        <li class="page-item ${p==page?'active':''}">
                            <a class="page-link"
                               href="?roleId=${roleId}&page=${p}&search=${search}&sort=${sort}&dir=${dir}">
                                    ${p}
                            </a>
                        </li>
                    </c:forEach>
                </ul>
            </nav>
        </main>
    </div>
</div>
</body>
</html>