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
                    <h2 class="fw-bold mb-0">${promotion != null ? 'Modifier' : 'Créer'} une Promotion</h2>
                    <p class="text-muted mb-0">Remplissez les informations de l'offre commerciale</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/promotions" class="btn btn-outline-secondary">
                    <i class="fa-solid fa-arrow-left me-1"></i>Retour à la liste
                </a>
            </div>

            <div class="card border-0 shadow-sm p-4" style="max-width: 600px;">
                <form action="${pageContext.request.contextPath}/admin/promotions" method="post">
                    <c:if test="${promotion != null}">
                        <input type="hidden" name="id" value="${promotion.id}">
                    </c:if>

                    <div class="mb-3">
                        <label for="nom" class="form-label">Nom de la Promotion</label>
                        <input type="text" class="form-control" id="nom" name="nom" value="${promotion.nom}" required placeholder="Ex: Black Friday 2026">
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label for="type" class="form-label">Type de Remise</label>
                            <select id="type" name="type" class="form-select">
                                <option value="POURCENTAGE" selected>Pourcentage (%)</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="valeur" class="form-label">Valeur du Rabais</label>
                            <div class="input-group">
                                <input type="number" step="0.01" class="form-control" id="valeur" name="valeur" value="${promotion != null ? promotion.valeur : 0}" required min="0" max="100">
                                <span class="input-group-text">%</span>
                            </div>
                        </div>
                    </div>

                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label for="dateDebut" class="form-label">Date de Début</label>
                            <input type="date" class="form-control" id="dateDebut" name="dateDebut" value="${promotion.dateDebut}" required>
                        </div>
                        <div class="col-md-6">
                            <label for="dateFin" class="form-label">Date de Fin</label>
                            <input type="date" class="form-control" id="dateFin" name="dateFin" value="${promotion.dateFin}" required>
                        </div>
                    </div>

                    <div class="form-check mb-4">
                        <input class="form-check-input" type="checkbox" id="actif" name="actif" value="true" ${promotion == null || promotion.actif ? 'checked' : ''}>
                        <label class="form-check-label fw-bold" for="actif">
                            Rendre cette promotion active immédiatement
                        </label>
                    </div>

                    <hr class="my-4">

                    <div class="d-flex gap-2 justify-content-end">
                        <a href="${pageContext.request.contextPath}/admin/promotions" class="btn btn-outline-secondary">Annuler</a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fa-solid fa-save me-1"></i>Enregistrer l'offre
                        </button>
                    </div>
                </form>
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
