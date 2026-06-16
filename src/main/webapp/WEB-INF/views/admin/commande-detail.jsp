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
                    <h2 class="fw-bold mb-0">Commande #CMD-${commande.id}</h2>
                    <p class="text-muted mb-0">Gérez les détails de facturation et d'expédition</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/commandes" class="btn btn-outline-secondary">
                    <i class="fa-solid fa-arrow-left me-1"></i>Retour à la liste
                </a>
            </div>

            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show alert-dismissible-auto" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>${param.success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <div class="row g-4">
                <!-- Order Items and Total -->
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm p-4 mb-4">
                        <h5 class="fw-bold mb-3"><i class="fa-solid fa-receipt me-2 text-primary"></i>Désignations de Commande</h5>
                        <div class="table-responsive">
                            <table class="table align-middle">
                                <thead>
                                    <tr>
                                        <th scope="col">Produit</th>
                                        <th scope="col">Description</th>
                                        <th scope="col" class="text-center">Prix Unitaire</th>
                                        <th scope="col" class="text-center">Quantité</th>
                                        <th scope="col" class="text-end">Total</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="line" items="${commande.lignes}">
                                        <tr>
                                            <td>
                                                <img src="${pageContext.request.contextPath}/static/images/${line.produit.image != null && line.produit.image != '' ? line.produit.image : 'logo.png'}" 
                                                     alt="${line.produit.nom}" class="img-fluid rounded" style="max-height: 45px; object-fit: contain;"
                                                     onerror="this.src='https://placehold.co/80x45/white/2563eb?text=${line.produit.nom}'">
                                            </td>
                                            <td>
                                                <h6 class="fw-bold mb-0">${line.produit.nom}</h6>
                                                <small class="text-muted">Marque: ${line.produit.marque}</small>
                                            </td>
                                            <td class="text-center fw-semibold">
                                                <fmt:formatNumber value="${line.prixUnitaire}" type="currency" currencySymbol="€" />
                                            </td>
                                            <td class="text-center">${line.quantite}</td>
                                            <td class="text-end fw-bold text-primary">
                                                <fmt:formatNumber value="${line.prixUnitaire * line.quantite}" type="currency" currencySymbol="€" />
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        <div class="d-flex justify-content-end mt-3 border-top pt-3">
                            <div class="text-end">
                                <span class="text-muted">Montant Total TTC :</span>
                                <h3 class="fw-bold text-primary"><fmt:formatNumber value="${commande.total}" type="currency" currencySymbol="€" /></h3>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Customer Details & Order Status updates -->
                <div class="col-lg-4">
                    <!-- Client profile -->
                    <div class="card border-0 shadow-sm p-4 mb-4">
                        <h5 class="fw-bold mb-3"><i class="fa-solid fa-user me-2 text-primary"></i>Profil Client</h5>
                        <p class="mb-1"><strong>Nom:</strong> ${commande.utilisateur.nom}</p>
                        <p class="mb-0"><strong>E-mail:</strong> ${commande.utilisateur.email}</p>
                    </div>

                    <!-- Update Status -->
                    <div class="card border-0 shadow-sm p-4 mb-4">
                        <h5 class="fw-bold mb-3"><i class="fa-solid fa-pen-fancy me-2 text-primary"></i>Statut Commande</h5>
                        <form action="${pageContext.request.contextPath}/admin/commandes" method="post">
                            <input type="hidden" name="id" value="${commande.id}">
                            <div class="mb-3">
                                <label for="statut" class="form-label">Changer le statut</label>
                                <select id="statut" name="statut" class="form-select">
                                    <option value="EN_ATTENTE" ${commande.statut == 'EN_ATTENTE' ? 'selected' : ''}>En attente</option>
                                    <option value="CONFIRMEE" ${commande.statut == 'CONFIRMEE' ? 'selected' : ''}>Confirmée</option>
                                    <option value="EXPEDIEE" ${commande.statut == 'EXPEDIEE' ? 'selected' : ''}>Expédiée</option>
                                    <option value="LIVREE" ${commande.statut == 'LIVREE' ? 'selected' : ''}>Livrée</option>
                                    <option value="ANNULEE" ${commande.statut == 'ANNULEE' ? 'selected' : ''}>Annulée</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Mettre à jour le statut</button>
                        </form>
                    </div>

                    <!-- Delivery info -->
                    <c:if test="${commande.livraison != null}">
                        <div class="card border-0 shadow-sm p-4">
                            <h5 class="fw-bold mb-3"><i class="fa-solid fa-truck me-2 text-primary"></i>Expédition & Adresse</h5>
                            <p class="mb-2"><strong>Statut Livraison:</strong> 
                                <span class="badge badge-${commande.livraison.statut.toLowerCase().replace('_', '-')}">
                                    ${commande.livraison.statut == 'EN_PREPARATION' ? 'En préparation' : 
                                      commande.livraison.statut == 'EXPEDIEE' ? 'Expédiée' : 'Livrée'}
                                </span>
                            </p>
                            <p class="mb-1"><strong>Adresse:</strong> ${commande.livraison.adresse}</p>
                            <p class="mb-0"><strong>Ville:</strong> ${commande.livraison.codePostal} ${commande.livraison.ville}</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap 5.3 JS Bundle CDN -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
