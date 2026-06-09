<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/navbar.jsp" />
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="container my-5">
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/catalogue">Catalogue</a></li>
            <c:if test="${produit.categorie != null}">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/catalogue?category=${produit.idCategorie}">${produit.categorie.nom}</a></li>
            </c:if>
            <li class="breadcrumb-item active" aria-current="page">${produit.nom}</li>
        </ol>
    </nav>

    <!-- Feedback alerts -->
    <c:if test="${not empty param.success}">
        <div class="alert alert-success alert-dismissible fade show alert-dismissible-auto" role="alert">
            <i class="fa-solid fa-circle-check me-2"></i>${param.success}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="row g-5">
        <!-- Image Column -->
        <div class="col-md-6">
            <div class="card border-0 shadow-sm p-4 text-center bg-white rounded-3">
                <img src="${pageContext.request.contextPath}/static/images/${produit.image != null && produit.image != '' ? produit.image : 'logo.png'}" 
                     class="img-fluid product-detail-img" alt="${produit.nom}"
                     onerror="this.src='https://placehold.co/500x400/white/2563eb?text=${produit.nom}'">
            </div>
        </div>

        <!-- Info Column -->
        <div class="col-md-6">
            <div class="d-flex flex-column h-100">
                <div class="mb-3">
                    <span class="badge bg-secondary mb-2">${produit.marque}</span>
                    <c:if test="${produit.categorie != null}">
                        <span class="badge bg-light text-dark border ms-1">${produit.categorie.nom}</span>
                    </c:if>
                    <h1 class="fw-bold text-dark mt-1">${produit.nom}</h1>
                </div>

                <div class="mb-4">
                    <c:choose>
                        <c:when test="${produit.enPromotion}">
                            <div class="d-flex align-items-center gap-2">
                                <span class="fs-4 text-muted text-decoration-line-through"><fmt:formatNumber value="${produit.prix}" type="currency" currencySymbol="€" /></span>
                                <span class="fs-2 fw-bold text-danger"><fmt:formatNumber value="${produit.prixEffectif}" type="currency" currencySymbol="€" /></span>
                                <span class="badge badge-promo">-${produit.promotion.valeur}% (${produit.promotion.nom})</span>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <span class="fs-2 fw-bold text-dark"><fmt:formatNumber value="${produit.prix}" type="currency" currencySymbol="€" /></span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="mb-4">
                    <h5 class="fw-bold">Description</h5>
                    <p class="text-muted" style="line-height: 1.6;">${produit.description != null && produit.description != '' ? produit.description : 'Aucune description disponible pour ce produit.'}</p>
                </div>

                <div class="mb-4">
                    <h5 class="fw-bold mb-2">Disponibilité</h5>
                    <c:choose>
                        <c:when test="${produit.stock >= 10}">
                            <span class="badge badge-stock-in px-3 py-2 fs-6"><i class="fa-solid fa-circle-check me-2"></i>En stock (${produit.stock} unités disponibles)</span>
                        </c:when>
                        <c:when test="${produit.stock > 0}">
                            <span class="badge badge-stock-low px-3 py-2 fs-6"><i class="fa-solid fa-triangle-exclamation me-2"></i>Stock limité (${produit.stock} restants)</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge badge-stock-out px-3 py-2 fs-6"><i class="fa-solid fa-circle-xmark me-2"></i>Rupture de stock</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="mt-auto pt-3 border-top">
                    <c:choose>
                        <c:when test="${produit.stock > 0}">
                            <form action="${pageContext.request.contextPath}/panier" method="post" class="row g-2 align-items-center">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="productId" value="${produit.id}">
                                <input type="hidden" name="redirect" value="produit">
                                
                                <div class="col-auto">
                                    <div class="input-group quantity-control">
                                        <button class="btn btn-outline-secondary btn-minus" type="button"><i class="fa-solid fa-minus"></i></button>
                                        <input type="number" name="quantity" class="form-control" value="1" min="1" max="${produit.stock}" readonly>
                                        <button class="btn btn-outline-secondary btn-plus" type="button"><i class="fa-solid fa-plus"></i></button>
                                    </div>
                                </div>
                                <div class="col">
                                    <button type="submit" class="btn btn-primary w-100 py-2">
                                        <i class="fa-solid fa-cart-shopping me-2"></i>Ajouter au panier
                                    </button>
                                </div>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <button class="btn btn-secondary w-100 py-2" disabled>
                                <i class="fa-solid fa-circle-xmark me-2"></i>Indisponible
                            </button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- Related Products -->
    <c:if test="${not empty relatedProduits}">
        <div class="mt-5 pt-5 border-top">
            <h3 class="fw-bold mb-4"><i class="fa-solid fa-cubes me-2 text-primary"></i>Produits Similaires</h3>
            <div class="row row-cols-1 row-cols-md-4 g-3">
                <c:forEach var="rp" items="${relatedProduits}">
                    <div class="col">
                        <div class="product-card">
                            <img src="${pageContext.request.contextPath}/static/images/${rp.image != null && rp.image != '' ? rp.image : 'logo.png'}" 
                                 class="card-img-top" alt="${rp.nom}"
                                 onerror="this.src='https://placehold.co/300x200/white/2563eb?text=${rp.nom}'">
                            <div class="card-body">
                                <span class="brand-label">${rp.marque}</span>
                                <h6 class="card-title text-truncate">${rp.nom}</h6>
                                <span class="price-tag"><fmt:formatNumber value="${rp.prixEffectif}" type="currency" currencySymbol="€" /></span>
                            </div>
                            <div class="card-footer bg-transparent border-0 p-3 pt-0">
                                <a href="${pageContext.request.contextPath}/produit?id=${rp.id}" class="btn btn-outline-primary btn-sm w-100">Voir le produit</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>
</div>

<jsp:include page="../layout/footer.jsp" />
