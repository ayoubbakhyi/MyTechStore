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
            <!-- Navbar-like header for admin -->
            <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
                <div>
                    <h2 class="fw-bold mb-0">Tableau de Bord Administrateur</h2>
                    <p class="text-muted mb-0">Vue globale sur les statistiques et opérations de MyTechStore</p>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">
                    <i class="fa-solid fa-right-from-bracket me-1"></i>Déconnexion
                </a>
            </div>

            <!-- KPI Cards -->
            <div class="row g-3 mb-4">
                <div class="col-md-3">
                    <div class="kpi-card shadow-sm border-start border-primary border-4">
                        <div class="kpi-icon bg-primary-subtle text-primary">
                            <i class="fa-solid fa-sack-dollar"></i>
                        </div>
                        <div>
                            <div class="kpi-title">Revenu Total</div>
                            <div class="kpi-number"><fmt:formatNumber value="${revenue}" type="currency" currencySymbol="€" /></div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="kpi-card shadow-sm border-start border-success border-4">
                        <div class="kpi-icon bg-success-subtle text-success">
                            <i class="fa-solid fa-shopping-bag"></i>
                        </div>
                        <div>
                            <div class="kpi-title">Commandes</div>
                            <div class="kpi-number">${totalOrders}</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="kpi-card shadow-sm border-start border-info border-4">
                        <div class="kpi-icon bg-info-subtle text-info">
                            <i class="fa-solid fa-laptop"></i>
                        </div>
                        <div>
                            <div class="kpi-title">Produits</div>
                            <div class="kpi-number">${totalProducts}</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="kpi-card shadow-sm border-start border-warning border-4">
                        <div class="kpi-icon bg-warning-subtle text-warning">
                            <i class="fa-solid fa-users"></i>
                        </div>
                        <div>
                            <div class="kpi-title">Clients</div>
                            <div class="kpi-number">${totalClients}</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row g-4 mb-4">
                <!-- Recent Orders Table -->
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm p-4 h-100">
                        <h5 class="fw-bold mb-3"><i class="fa-solid fa-receipt me-2 text-primary"></i>Commandes Récentes</h5>
                        <c:choose>
                            <c:when test="${empty recentOrders}">
                                <p class="text-muted mb-0">Aucune commande enregistrée.</p>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle">
                                        <thead>
                                            <tr>
                                                <th>Commande</th>
                                                <th>Client</th>
                                                <th>Date</th>
                                                <th class="text-center">Total</th>
                                                <th class="text-center">Statut</th>
                                                <th class="text-end">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="ord" items="${recentOrders}">
                                                <tr>
                                                    <td><strong>#CMD-${ord.id}</strong></td>
                                                    <td>${ord.utilisateur.nom}</td>
                                                    <td><fmt:formatDate value="${ord.dateCommande}" pattern="dd/MM/yyyy HH:mm" /></td>
                                                    <td class="text-center fw-semibold text-primary">
                                                        <fmt:formatNumber value="${ord.total}" type="currency" currencySymbol="€" />
                                                    </td>
                                                    <td class="text-center">
                                                        <span class="badge badge-${ord.statut.toLowerCase().replace('_', '-')}">
                                                            ${ord.statut == 'EN_ATTENTE' ? 'En attente' : 
                                                              ord.statut == 'CONFIRMEE' ? 'Confirmée' : 
                                                              ord.statut == 'EXPEDIEE' ? 'Expédiée' : 
                                                              ord.statut == 'LIVREE' ? 'Livrée' : 'Annulée'}
                                                        </span>
                                                    </td>
                                                    <td class="text-end">
                                                        <a href="${pageContext.request.contextPath}/admin/commandes?id=${ord.id}" class="btn btn-outline-primary btn-sm">
                                                            <i class="fa-solid fa-eye"></i>
                                                        </a>
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

                <!-- Stock warnings -->
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm p-4 h-100">
                        <h5 class="fw-bold mb-3 text-danger"><i class="fa-solid fa-triangle-exclamation me-2"></i>Alertes Stocks Faibles</h5>
                        <c:choose>
                            <c:when test="${empty lowStockProducts}">
                                <div class="text-center py-4">
                                    <i class="fa-solid fa-circle-check text-success fa-3x mb-2"></i>
                                    <p class="text-muted mb-0">Tous les produits ont un stock suffisant.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="list-group list-group-flush" style="max-height: 250px; overflow-y: auto;">
                                    <c:forEach var="lp" items="${lowStockProducts}">
                                        <div class="list-group-item bg-transparent px-0 d-flex justify-content-between align-items-center">
                                            <div>
                                                <h6 class="fw-bold mb-0 text-truncate" style="max-width: 180px;">${lp.nom}</h6>
                                                <small class="text-muted">Marque: ${lp.marque}</small>
                                            </div>
                                            <span class="badge bg-danger text-white">Stock: ${lp.stock}</span>
                                        </div>
                                    </c:forEach>
                                </div>
                                <div class="mt-3">
                                    <a href="${pageContext.request.contextPath}/admin/produits" class="btn btn-sm btn-outline-danger w-100">Gérer les produits</a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Visual Bar Chart for product distribution -->
            <c:if test="${not empty categoryStats}">
                <div class="card border-0 shadow-sm p-4">
                    <h5 class="fw-bold mb-3"><i class="fa-solid fa-chart-simple me-2 text-primary"></i>Distribution des Produits par Catégorie</h5>
                    <div class="row row-cols-1 row-cols-md-2 g-3">
                        <c:forEach var="stat" items="${categoryStats}">
                            <div class="col">
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <span class="fw-semibold">${stat.categorie}</span>
                                    <span class="badge bg-secondary">${stat.count} produits</span>
                                </div>
                                <div class="chart-bar-container mb-2">
                                    <!-- Calculate percentage against max (assume max is 15 or draw dynamically) -->
                                    <c:set var="barPercent" value="${stat.count * 10}" />
                                    <c:if var="overLimit" test="${barPercent > 100}">
                                        <c:set var="barPercent" value="100" />
                                    </c:if>
                                    <div class="chart-bar-fill" style="width: ${barPercent}%"></div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</div>

<!-- Add footer directly without including the standard layout/footer which has user elements -->
<!-- Bootstrap 5.3 JS Bundle CDN -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<!-- Custom JS -->
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>
</body>
</html>
