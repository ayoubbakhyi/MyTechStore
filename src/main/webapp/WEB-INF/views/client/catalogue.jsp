<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/navbar.jsp" />
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="container my-4">
    <!-- Feedback alerts -->
    <c:if test="${not empty param.success}">
        <div class="alert alert-success alert-dismissible fade show alert-dismissible-auto" role="alert">
            <i class="fa-solid fa-circle-check me-2"></i>${param.success}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="alert alert-danger alert-dismissible fade show alert-dismissible-auto" role="alert">
            <i class="fa-solid fa-triangle-exclamation me-2"></i>${param.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <!-- Banner section for promotions -->
    <div class="p-4 mb-4 bg-dark text-white rounded-3 d-flex align-items-center justify-content-between shadow-sm">
        <div>
            <span class="badge bg-danger mb-2 px-3 py-2 text-uppercase fw-bold"><i class="fa-solid fa-fire me-1"></i>Soldes Exceptionnels</span>
            <h1 class="display-6 fw-bold">Équipez-vous pour la Victoire</h1>
            <p class="fs-5 mb-0 text-muted">Jusqu'à -15% sur les meilleurs composants gaming du moment.</p>
        </div>
        <div class="d-none d-md-block">
            <i class="fa-solid fa-gamepad fa-5x text-secondary opacity-50"></i>
        </div>
    </div>

    <div class="row">
        <!-- Sidebar filters -->
        <div class="col-lg-3 mb-4">
            <div class="card border-0 shadow-sm p-3 mb-3">
                <h5 class="fw-bold mb-3"><i class="fa-solid fa-filter me-2 text-primary"></i>Catégories</h5>
                <div class="list-group list-group-flush">
                    <a href="${pageContext.request.contextPath}/catalogue?search=${searchVal != null ? searchVal : ''}" 
                       class="list-group-item list-group-item-action border-0 px-2 rounded-2 ${selectedCat == null ? 'active bg-primary' : ''}">
                        <i class="fa-solid fa-border-all me-2"></i>Toutes les catégories
                    </a>
                    <c:forEach var="cat" items="${categories}">
                        <a href="${pageContext.request.contextPath}/catalogue?category=${cat.id}&search=${searchVal != null ? searchVal : ''}" 
                           class="list-group-item list-group-item-action border-0 px-2 rounded-2 ${selectedCat == cat.id ? 'active bg-primary' : ''}">
                            <i class="fa-solid fa-chevron-right me-2 small"></i>${cat.nom}
                        </a>
                    </c:forEach>
                </div>
            </div>
            
            <!-- Search Widget -->
            <div class="card border-0 shadow-sm p-3">
                <h5 class="fw-bold mb-3"><i class="fa-solid fa-magnifying-glass me-2 text-primary"></i>Rechercher</h5>
                <form action="${pageContext.request.contextPath}/catalogue" method="get">
                    <c:if test="${selectedCat != null}">
                        <input type="hidden" name="category" value="${selectedCat}">
                    </c:if>
                    <div class="input-group">
                        <input type="text" class="form-control" placeholder="Processeur, RTX, Asus..." name="search" value="${searchVal}">
                        <button class="btn btn-primary" type="submit"><i class="fa-solid fa-search"></i></button>
                    </div>
                    <c:if test="${not empty searchVal || selectedCat != null}">
                        <a href="${pageContext.request.contextPath}/catalogue" class="btn btn-link btn-sm text-decoration-none px-0 mt-2 text-danger">
                            <i class="fa-solid fa-rotate-left me-1"></i>Réinitialiser les filtres
                        </a>
                    </c:if>
                </form>
            </div>
        </div>

        <!-- Product Grid -->
        <div class="col-lg-9">
            <c:choose>
                <c:when test="${empty produits}">
                    <div class="card border-0 shadow-sm p-5 text-center">
                        <i class="fa-solid fa-circle-question text-muted fa-4x mb-3"></i>
                        <h4 class="fw-bold text-muted">Aucun produit trouvé</h4>
                        <p class="text-muted mb-0">Essayez de modifier vos critères de recherche ou de catégorie.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row row-cols-1 row-cols-md-3 g-3">
                        <c:forEach var="p" items="${produits}">
                            <div class="col">
                                <div class="product-card">
                                    <!-- Product Image -->
                                    <div class="position-relative">
                                        <img src="${pageContext.request.contextPath}/static/images/${p.image != null && p.image != '' ? p.image : 'logo.png'}" 
                                             class="card-img-top" alt="${p.nom}" 
                                             onerror="this.src='https://placehold.co/300x200/white/2563eb?text=${p.nom}'">
                                        <c:if test="${p.enPromotion}">
                                            <span class="position-absolute top-2 start-2 badge badge-promo">
                                                <i class="fa-solid fa-tag me-1"></i>-${p.promotion.valeur}%
                                            </span>
                                        </c:if>
                                    </div>
                                    <!-- Product Info -->
                                    <div class="card-body">
                                        <span class="brand-label">${p.marque}</span>
                                        <h5 class="card-title">${p.nom}</h5>
                                        
                                        <!-- Stock status -->
                                        <div class="mb-3">
                                            <c:choose>
                                                <c:when test="${p.stock >= 10}">
                                                    <span class="badge badge-stock-in"><i class="fa-solid fa-check me-1"></i>En stock</span>
                                                </c:when>
                                                <c:when test="${p.stock > 0}">
                                                    <span class="badge badge-stock-low"><i class="fa-solid fa-triangle-exclamation me-1"></i>Stock faible (${p.stock})</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-stock-out"><i class="fa-solid fa-xmark me-1"></i>Rupture</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <div class="mt-auto d-flex justify-content-between align-items-center">
                                            <div>
                                                <c:choose>
                                                    <c:when test="${p.enPromotion}">
                                                        <span class="price-original"><fmt:formatNumber value="${p.prix}" type="currency" currencySymbol="€" /></span>
                                                        <span class="price-tag"><fmt:formatNumber value="${p.prixEffectif}" type="currency" currencySymbol="€" /></span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="price-tag"><fmt:formatNumber value="${p.prix}" type="currency" currencySymbol="€" /></span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-footer bg-transparent border-top-0 p-3 pt-0 d-flex gap-2">
                                        <a href="${pageContext.request.contextPath}/produit?id=${p.id}" class="btn btn-outline-secondary btn-sm flex-fill">
                                            <i class="fa-solid fa-circle-info me-1"></i>Détails
                                        </a>
                                        <form action="${pageContext.request.contextPath}/panier" method="post" class="flex-fill">
                                            <input type="hidden" name="action" value="add">
                                            <input type="hidden" name="productId" value="${p.id}">
                                            <button type="submit" class="btn btn-primary btn-sm w-100" ${p.stock <= 0 ? 'disabled' : ''}>
                                                <i class="fa-solid fa-cart-plus me-1"></i>Acheter
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<jsp:include page="../layout/footer.jsp" />
