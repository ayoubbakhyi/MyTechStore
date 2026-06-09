<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="../layout/header.jsp" />
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="container-fluid p-0">
    <div class="row g-0">
        <!-- Sidebar Column -->
        <div class="col-md-3 col-lg-2">
            <jsp:include page="../layout/admin-sidebar.jsp" />
        </div>

        <!-- Content Column -->
        <div class="col-md-9 col-lg-10 p-4">
            <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
                <div>
                    <h2 class="fw-bold mb-0">Gestion des Catégories</h2>
                    <p class="text-muted mb-0">Créez ou supprimez des catégories d'articles</p>
                </div>
            </div>

            <div class="row g-4">
                <!-- Add Category Card -->
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm p-4">
                        <h5 class="fw-bold mb-3"><i class="fa-solid fa-plus-circle me-2 text-primary"></i>Ajouter une Catégorie</h5>
                        <form action="${pageContext.request.contextPath}/admin/categories" method="post">
                            <input type="hidden" name="action" value="add">
                            <div class="mb-3">
                                <label for="nom" class="form-label">Nom de la Catégorie</label>
                                <input type="text" class="form-control" id="nom" name="nom" required placeholder="Ex: Claviers Gamer">
                            </div>
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="fa-solid fa-plus me-1"></i>Créer la Catégorie
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Category List Table -->
                <div class="col-md-8">
                    <div class="card border-0 shadow-sm p-4">
                        <h5 class="fw-bold mb-3"><i class="fa-solid fa-tags me-2 text-primary"></i>Catégories Enregistrées</h5>
                        <c:choose>
                            <c:when test="${empty categories}">
                                <p class="text-muted mb-0">Aucune catégorie enregistrée.</p>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle">
                                        <thead>
                                            <tr>
                                                <th scope="col" style="width: 80px;">ID</th>
                                                <th scope="col">Nom de la Catégorie</th>
                                                <th scope="col" class="text-end">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="cat" items="${categories}">
                                                <tr>
                                                    <td><strong>#CAT-${cat.id}</strong></td>
                                                    <td>${cat.nom}</td>
                                                    <td class="text-end">
                                                        <form action="${pageContext.request.contextPath}/admin/categories" method="post" class="m-0">
                                                            <input type="hidden" name="action" value="delete">
                                                            <input type="hidden" name="id" value="${cat.id}">
                                                            <button type="submit" class="btn btn-sm btn-outline-danger confirm-delete" data-type="cette catégorie">
                                                                <i class="fa-solid fa-trash-can me-1"></i>Supprimer
                                                            </button>
                                                        </form>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap 5.3 JS Bundle CDN -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<!-- Custom JS -->
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>
</body>
</html>
