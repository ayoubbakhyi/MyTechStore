<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/navbar.jsp" />
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="container my-5">
    <h1 class="fw-bold mb-4"><i class="fa-solid fa-cash-register me-2 text-primary"></i>Validation de Commande</h1>

    <c:if test="${not empty requestScope.error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fa-solid fa-triangle-exclamation me-2"></i>${requestScope.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="row g-4">
        <!-- Delivery Form -->
        <div class="col-lg-7">
            <div class="card border-0 shadow-sm p-4">
                <h4 class="fw-bold mb-4"><i class="fa-solid fa-truck me-2 text-primary"></i>Informations de Livraison</h4>
                <form action="${pageContext.request.contextPath}/commande" method="post">
                    <div class="row g-3">
                        <div class="col-md-12">
                            <label for="nom" class="form-label">Nom du destinataire</label>
                            <input type="text" class="form-control" id="nom" name="nom" value="${sessionScope.user.nom}" required>
                        </div>
                        <div class="col-md-12">
                            <label for="telephone" class="form-label">Numéro de Téléphone</label>
                            <input type="tel" class="form-control" id="telephone" name="telephone" required placeholder="06 12 34 56 78">
                        </div>
                        <div class="col-md-12">
                            <label for="adresse" class="form-label">Adresse Complète</label>
                            <textarea class="form-control" id="adresse" name="adresse" rows="3" required placeholder="Ex: 12 Rue des Claviers Gaming"></textarea>
                        </div>
                        <div class="col-md-6">
                            <label for="ville" class="form-label">Ville</label>
                            <input type="text" class="form-control" id="ville" name="ville" required placeholder="Paris">
                        </div>
                        <div class="col-md-6">
                            <label for="codePostal" class="form-label">Code Postal</label>
                            <input type="text" class="form-control" id="codePostal" name="codePostal" required placeholder="75000">
                        </div>
                    </div>
                    
                    <hr class="my-4">
                    
                    <button type="submit" class="btn btn-primary w-100 py-3 fs-5">
                        <i class="fa-solid fa-circle-check me-2"></i>Confirmer et Commander
                    </button>
                </form>
            </div>
        </div>

        <!-- Order Summary Recaps -->
        <div class="col-lg-5">
            <div class="card border-0 shadow-sm p-4">
                <h4 class="fw-bold mb-4"><i class="fa-solid fa-receipt me-2 text-primary"></i>Résumé de la Commande</h4>
                <div class="list-group list-group-flush mb-4">
                    <c:forEach var="item" items="${panier.items}">
                        <div class="list-group-item bg-transparent px-0 d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="fw-semibold mb-0">${item.produit.nom}</h6>
                                <small class="text-muted">Quantité: ${item.quantite}</small>
                            </div>
                            <span class="fw-bold text-primary">
                                <fmt:formatNumber value="${item.produit.prixEffectif * item.quantite}" type="currency" currencySymbol="€" />
                            </span>
                        </div>
                    </c:forEach>
                </div>
                
                <div class="d-flex justify-content-between mb-2">
                    <span class="text-muted">Frais de livraison</span>
                    <span class="text-success fw-bold">Gratuit</span>
                </div>
                
                <div class="d-flex justify-content-between fs-4 fw-bold border-top pt-3">
                    <span>Total Commande</span>
                    <span class="text-primary"><fmt:formatNumber value="${panier.total}" type="currency" currencySymbol="€" /></span>
                </div>
                
                <div class="mt-4">
                    <a href="${pageContext.request.contextPath}/panier" class="btn btn-outline-secondary btn-sm w-100">
                        <i class="fa-solid fa-arrow-left me-1"></i>Retour au Panier
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../layout/footer.jsp" />
