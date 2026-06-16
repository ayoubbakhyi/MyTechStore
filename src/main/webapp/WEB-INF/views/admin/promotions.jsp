<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="../layout/header.jsp" />
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

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
                    <h2 class="fw-bold mb-0">Gestion des Offres Promotionnelles</h2>
                    <p class="text-muted mb-0">Créez des remises sur vos produits et fixez des périodes de validité</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/promotions?action=new" class="btn btn-primary">
                    <i class="fa-solid fa-plus-circle me-2"></i>Créer une Promotion
                </a>
            </div>

            <div class="card border-0 shadow-sm p-4">
                <c:choose>
                    <c:when test="${empty promotions}">
                        <p class="text-muted mb-0">Aucune offre promotionnelle enregistrée.</p>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead>
                                    <tr>
                                        <th scope="col" style="width: 80px;">ID</th>
                                        <th scope="col">Nom de l'offre</th>
                                        <th scope="col" class="text-center">Valeur Remise</th>
                                        <th scope="col" class="text-center">Date Début</th>
                                        <th scope="col" class="text-center">Date Fin</th>
                                        <th scope="col" class="text-center">État</th>
                                        <th scope="col" class="text-end" style="width: 180px;">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="p" items="${promotions}">
                                        <tr>
                                            <td><strong>#PRM-${p.id}</strong></td>
                                            <td><strong>${p.nom}</strong></td>
                                            <td class="text-center text-danger fw-bold">-${p.valeur}%</td>
                                            <td class="text-center">${p.dateDebut}</td>
                                            <td class="text-center">${p.dateFin}</td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${p.actif}">
                                                        <span class="badge bg-success text-white px-2 py-1"><i class="fa-solid fa-circle-check me-1"></i>Active</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary text-white px-2 py-1"><i class="fa-solid fa-circle-xmark me-1"></i>Inactive</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end">
                                                <div class="d-inline-flex gap-2">
                                                    <a href="${pageContext.request.contextPath}/admin/promotions?action=edit&id=${p.id}" class="btn btn-sm btn-outline-secondary">
                                                        <i class="fa-solid fa-pen-to-square me-1"></i>Éditer
                                                    </a>
                                                    <form action="${pageContext.request.contextPath}/admin/promotions" method="post" class="m-0">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="id" value="${p.id}">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger confirm-delete" data-type="cette promotion">
                                                            <i class="fa-solid fa-trash-can"></i>
                                                        </button>
                                                    </form>
                                                </div>
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

<!-- Bootstrap 5.3 JS Bundle CDN -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
