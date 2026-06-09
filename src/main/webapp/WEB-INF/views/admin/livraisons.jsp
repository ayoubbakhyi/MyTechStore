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
                    <h2 class="fw-bold mb-0">Suivi et Expédition des Livraisons</h2>
                    <p class="text-muted mb-0">Mettez à jour les statuts de préparation et d'acheminement, et planifiez les dates de livraison</p>
                </div>
            </div>

            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show alert-dismissible-auto" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>${param.success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <div class="card border-0 shadow-sm p-4">
                <c:choose>
                    <c:when test="${empty livraisons}">
                        <p class="text-muted mb-0">Aucune expédition en cours.</p>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table align-middle">
                                <thead>
                                    <tr>
                                        <th scope="col" style="width: 100px;">Commande</th>
                                        <th scope="col">Destinataire & Adresse</th>
                                        <th scope="col" class="text-center">Statut Livraison</th>
                                        <th scope="col" class="text-center">Dates d'expédition & prévue</th>
                                        <th scope="col" class="text-end" style="width: 380px;">Actions de Suivi</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="liv" items="${livraisons}">
                                        <tr>
                                            <td><strong>#CMD-${liv.idCommande}</strong></td>
                                            <td>
                                                <div class="fw-semibold">${liv.adresse}</div>
                                                <small class="text-muted">${liv.codePostal} ${liv.ville}</small>
                                            </td>
                                            <td class="text-center">
                                                <span class="badge badge-${liv.statut.toLowerCase().replace('_', '-')}">
                                                    ${liv.statut == 'EN_PREPARATION' ? 'En préparation' : 
                                                      liv.statut == 'EXPEDIEE' ? 'Expédiée' : 'Livrée'}
                                                </span>
                                            </td>
                                            <td class="text-center small">
                                                <div>Expédition: <strong>${liv.dateExpedition != null ? liv.dateExpedition : '--'}</strong></div>
                                                <div>Prévue le: <strong>${liv.dateLivraisonPrevue != null ? liv.dateLivraisonPrevue : '--'}</strong></div>
                                            </td>
                                            <td class="text-end">
                                                <div class="d-flex flex-wrap gap-2 justify-content-end">
                                                    <!-- Update status -->
                                                    <form action="${pageContext.request.contextPath}/admin/livraisons" method="post" class="d-inline-flex align-items-center m-0">
                                                        <input type="hidden" name="id" value="${liv.id}">
                                                        <select name="statut" class="form-select form-select-sm me-2" style="width: 150px;" onchange="this.form.submit()">
                                                            <option value="EN_PREPARATION" ${liv.statut == 'EN_PREPARATION' ? 'selected' : ''}>En préparation</option>
                                                            <option value="EXPEDIEE" ${liv.statut == 'EXPEDIEE' ? 'selected' : ''}>Expédiée</option>
                                                            <option value="LIVREE" ${liv.statut == 'LIVREE' ? 'selected' : ''}>Livrée</option>
                                                        </select>
                                                    </form>
                                                    
                                                    <!-- Plan dates -->
                                                    <button class="btn btn-sm btn-outline-secondary" type="button" data-bs-toggle="collapse" data-bs-target="#datesCollapse-${liv.id}" aria-expanded="false">
                                                        <i class="fa-solid fa-calendar-days me-1"></i>Planifier
                                                    </button>
                                                </div>
                                                
                                                <!-- Collapse form for planning dates -->
                                                <div class="collapse mt-2 text-start" id="datesCollapse-${liv.id}">
                                                    <div class="card card-body p-2 border-secondary-subtle">
                                                        <form action="${pageContext.request.contextPath}/admin/livraisons" method="post" class="m-0">
                                                            <input type="hidden" name="id" value="${liv.id}">
                                                            <div class="row g-2">
                                                                <div class="col-6">
                                                                    <label class="form-label small mb-1">Date d'Exp.</label>
                                                                    <input type="date" name="dateExpedition" class="form-control form-control-sm" value="${liv.dateExpedition != null ? liv.dateExpedition : ''}" required>
                                                                </div>
                                                                <div class="col-6">
                                                                    <label class="form-label small mb-1">Livraison Prév.</label>
                                                                    <input type="date" name="dateLivraisonPrevue" class="form-control form-control-sm" value="${liv.dateLivraisonPrevue != null ? liv.dateLivraisonPrevue : ''}" required>
                                                                </div>
                                                                <div class="col-12 text-end">
                                                                    <button type="submit" class="btn btn-primary btn-sm px-3 py-1">Valider</button>
                                                                </div>
                                                            </div>
                                                        </form>
                                                    </div>
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
<!-- Custom JS -->
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>
</body>
</html>
