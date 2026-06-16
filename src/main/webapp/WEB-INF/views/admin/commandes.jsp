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
                    <h2 class="fw-bold mb-0">Gestion des Commandes Clients</h2>
                    <p class="text-muted mb-0">Validez les commandes, expédiez les colis et modifiez les statuts</p>
                </div>
            </div>

            <div class="card border-0 shadow-sm p-4">
                <c:choose>
                    <c:when test="${empty commandes}">
                        <p class="text-muted mb-0">Aucune commande enregistrée dans le système.</p>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead>
                                    <tr>
                                        <th scope="col">Commande</th>
                                        <th scope="col">Client</th>
                                        <th scope="col">Date Commande</th>
                                        <th scope="col" class="text-center">Montant Total</th>
                                        <th scope="col" class="text-center">Statut Actuel</th>
                                        <th scope="col" class="text-end" style="width: 180px;">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="c" items="${commandes}">
                                        <tr>
                                            <td><strong>#CMD-${c.id}</strong></td>
                                            <td>
                                                <h6 class="mb-0 fw-bold">${c.utilisateur.nom}</h6>
                                                <small class="text-muted">${c.utilisateur.email}</small>
                                            </td>
                                            <td><fmt:formatDate value="${c.dateCommande}" pattern="dd MMMM yyyy HH:mm" /></td>
                                            <td class="text-center fw-bold text-primary">
                                                <fmt:formatNumber value="${c.total}" type="currency" currencySymbol="€" />
                                            </td>
                                            <td class="text-center">
                                                <span class="badge badge-${c.statut.toLowerCase().replace('_', '-')}">
                                                    ${c.statut == 'EN_ATTENTE' ? 'En attente' : 
                                                      c.statut == 'CONFIRMEE' ? 'Confirmée' : 
                                                      c.statut == 'EXPEDIEE' ? 'Expédiée' : 
                                                      c.statut == 'LIVREE' ? 'Livrée' : 'Annulée'}
                                                </span>
                                            </td>
                                            <td class="text-end">
                                                <div class="d-inline-flex gap-2">
                                                    <a href="${pageContext.request.contextPath}/admin/commandes?id=${c.id}" class="btn btn-sm btn-outline-primary">
                                                        <i class="fa-solid fa-eye me-1"></i>Gérer
                                                    </a>
                                                    <!-- Simple form for fast status change -->
                                                    <form action="${pageContext.request.contextPath}/admin/commandes" method="post" class="m-0">
                                                        <input type="hidden" name="id" value="${c.id}">
                                                        <select name="statut" class="form-select form-select-sm" onchange="this.form.submit()">
                                                            <option value="EN_ATTENTE" ${c.statut == 'EN_ATTENTE' ? 'selected' : ''}>En attente</option>
                                                            <option value="CONFIRMEE" ${c.statut == 'CONFIRMEE' ? 'selected' : ''}>Confirmée</option>
                                                            <option value="EXPEDIEE" ${c.statut == 'EXPEDIEE' ? 'selected' : ''}>Expédiée</option>
                                                            <option value="LIVREE" ${c.statut == 'LIVREE' ? 'selected' : ''}>Livrée</option>
                                                            <option value="ANNULEE" ${c.statut == 'ANNULEE' ? 'selected' : ''}>Annulée</option>
                                                        </select>
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
