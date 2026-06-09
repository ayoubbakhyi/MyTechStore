<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/navbar.jsp" />
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="container my-5">
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/mes-commandes">Mes Commandes</a></li>
            <li class="breadcrumb-item active" aria-current="page">Commande #CMD-${commande.id}</li>
        </ol>
    </nav>

    <div class="row g-4">
        <!-- Order info and Items -->
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm p-4 mb-4">
                <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                    <div>
                        <h4 class="fw-bold mb-0">Détails Commande #CMD-${commande.id}</h4>
                        <small class="text-muted">Passée le <fmt:formatDate value="${commande.dateCommande}" pattern="dd MMMM yyyy HH:mm" /></small>
                    </div>
                    <span class="badge badge-${commande.statut.toLowerCase().replace('_', '-')} fs-6 px-3 py-2">
                        ${commande.statut == 'EN_ATTENTE' ? 'En attente' : 
                          commande.statut == 'CONFIRMEE' ? 'Confirmée' : 
                          commande.statut == 'EXPEDIEE' ? 'Expédiée' : 
                          commande.statut == 'LIVREE' ? 'Livrée' : 'Annulée'}
                    </span>
                </div>

                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead>
                            <tr>
                                <th scope="col" style="width: 80px;">Produit</th>
                                <th scope="col">Désignation</th>
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
                                             alt="${line.produit.nom}" class="img-fluid rounded" style="max-height: 50px; object-fit: contain;"
                                             onerror="this.src='https://placehold.co/80x50/white/2563eb?text=${line.produit.nom}'">
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

                <div class="d-flex justify-content-end mt-4 pt-3 border-top">
                    <div class="text-end">
                        <span class="text-muted">Montant Total TTC :</span>
                        <h3 class="fw-bold text-primary mt-1"><fmt:formatNumber value="${commande.total}" type="currency" currencySymbol="€" /></h3>
                    </div>
                </div>
            </div>
            
            <a href="${pageContext.request.contextPath}/mes-commandes" class="btn btn-outline-secondary"><i class="fa-solid fa-arrow-left me-2"></i>Retour à mes commandes</a>
        </div>

        <!-- Shipping and Tracking Info -->
        <div class="col-lg-4">
            <div class="card border-0 shadow-sm p-4 mb-4">
                <h5 class="fw-bold mb-3"><i class="fa-solid fa-truck-fast me-2 text-primary"></i>Statut de la Livraison</h5>
                <c:choose>
                    <c:when test="${commande.livraison != null}">
                        <div class="mb-4">
                            <span class="badge badge-${commande.livraison.statut.toLowerCase().replace('_', '-')} mb-3 px-3 py-2">
                                ${commande.livraison.statut == 'EN_PREPARATION' ? 'En préparation' : 
                                  commande.livraison.statut == 'EXPEDIEE' ? 'Expédiée' : 'Livrée'}
                            </span>
                            <div class="small text-muted">
                                <c:if test="${commande.livraison.dateExpedition != null}">
                                    <p class="mb-1"><i class="fa-solid fa-calendar-check me-2"></i>Expédiée le: <strong>${commande.livraison.dateExpedition}</strong></p>
                                </c:if>
                                <c:if test="${commande.livraison.dateLivraisonPrevue != null}">
                                    <p class="mb-0"><i class="fa-solid fa-calendar-day me-2"></i>Livraison prévue: <strong>${commande.livraison.dateLivraisonPrevue}</strong></p>
                                </c:if>
                            </div>
                        </div>

                        <hr>

                        <h5 class="fw-bold mb-3 mt-3"><i class="fa-solid fa-location-dot me-2 text-primary"></i>Adresse de Livraison</h5>
                        <p class="mb-1 fw-semibold">${commande.utilisateur.nom}</p>
                        <p class="mb-1 text-muted">${commande.livraison.adresse}</p>
                        <p class="mb-0 text-muted">${commande.livraison.codePostal} ${commande.livraison.ville}</p>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted">Aucune information de livraison disponible.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../layout/footer.jsp" />
