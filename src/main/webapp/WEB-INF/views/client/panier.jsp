<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/navbar.jsp" />
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="container my-5">
    <h1 class="fw-bold mb-4"><i class="fa-solid fa-cart-shopping me-2 text-primary"></i>Votre Panier</h1>

    <c:if test="${not empty param.error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fa-solid fa-triangle-exclamation me-2"></i>${param.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${empty panier.items}">
            <div class="card border-0 shadow-sm p-5 text-center">
                <i class="fa-solid fa-basket-shopping text-muted fa-4x mb-3"></i>
                <h4 class="fw-bold text-muted">Votre panier est vide</h4>
                <p class="text-muted mb-4">Parcourez notre catalogue pour ajouter des articles.</p>
                <div class="d-flex justify-content-center">
                    <a href="${pageContext.request.contextPath}/catalogue" class="btn btn-primary px-4"><i class="fa-solid fa-arrow-left me-2"></i>Continuer mes achats</a>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row g-4">
                <!-- Cart Items Table -->
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm p-4">
                        <div class="table-responsive">
                            <table class="table align-middle">
                                <thead>
                                    <tr>
                                        <th scope="col" style="width: 100px;">Produit</th>
                                        <th scope="col">Description</th>
                                        <th scope="col" class="text-center">Prix Unitaire</th>
                                        <th scope="col" class="text-center" style="width: 140px;">Quantité</th>
                                        <th scope="col" class="text-center">Total</th>
                                        <th scope="col" class="text-end">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${panier.items}">
                                        <tr>
                                            <td>
                                                <img src="${pageContext.request.contextPath}/static/images/${item.produit.image != null && item.produit.image != '' ? item.produit.image : 'logo.png'}" 
                                                     alt="${item.produit.nom}" class="img-fluid rounded" style="max-height: 70px; object-fit: contain;"
                                                     onerror="this.src='https://placehold.co/100x70/white/2563eb?text=${item.produit.nom}'">
                                            </td>
                                            <td>
                                                <h6 class="fw-bold mb-1">${item.produit.nom}</h6>
                                                <small class="text-muted">Marque: ${item.produit.marque}</small>
                                            </td>
                                            <td class="text-center">
                                                <span class="fw-semibold"><fmt:formatNumber value="${item.produit.prixEffectif}" type="currency" currencySymbol="€" /></span>
                                                <c:if test="${item.produit.enPromotion}">
                                                    <br><small class="text-danger text-decoration-line-through"><fmt:formatNumber value="${item.produit.prix}" type="currency" currencySymbol="€" /></small>
                                                </c:if>
                                            </td>
                                            <td class="text-center">
                                                <!-- Form which gets auto-submitted via JS when quantity updates -->
                                                <form action="${pageContext.request.contextPath}/panier" method="post" class="quantity-update-form">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="productId" value="${item.produit.id}">
                                                    <div class="input-group quantity-control">
                                                        <button class="btn btn-outline-secondary btn-sm btn-minus" type="button"><i class="fa-solid fa-minus"></i></button>
                                                        <input type="number" name="quantity" class="form-control form-control-sm" value="${item.quantite}" min="1" max="${item.produit.stock}" readonly>
                                                        <button class="btn btn-outline-secondary btn-sm btn-plus" type="button"><i class="fa-solid fa-plus"></i></button>
                                                    </div>
                                                </form>
                                            </td>
                                            <td class="text-center fw-bold text-primary">
                                                <fmt:formatNumber value="${item.produit.prixEffectif * item.quantite}" type="currency" currencySymbol="€" />
                                            </td>
                                            <td class="text-end">
                                                <form action="${pageContext.request.contextPath}/panier" method="post">
                                                    <input type="hidden" name="action" value="remove">
                                                    <input type="hidden" name="productId" value="${item.produit.id}">
                                                    <button type="submit" class="btn btn-outline-danger btn-sm confirm-delete" data-type="cet article">
                                                        <i class="fa-solid fa-trash-can"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        <div class="d-flex justify-content-between mt-3">
                            <a href="${pageContext.request.contextPath}/catalogue" class="btn btn-outline-secondary"><i class="fa-solid fa-arrow-left me-2"></i>Continuer mes achats</a>
                            <form action="${pageContext.request.contextPath}/panier" method="post">
                                <input type="hidden" name="action" value="clear">
                                <button type="submit" class="btn btn-outline-danger confirm-clear-cart"><i class="fa-solid fa-circle-xmark me-2"></i>Vider le panier</button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Summary Card -->
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm p-4">
                        <h4 class="fw-bold mb-4">Récapitulatif</h4>
                        <div class="d-flex justify-content-between mb-3 border-bottom pb-2">
                            <span class="text-muted">Total articles</span>
                            <span class="fw-semibold">
                                <c:set var="totalItems" value="0" />
                                <c:forEach var="item" items="${panier.items}">
                                    <c:set var="totalItems" value="${totalItems + item.quantite}" />
                                </c:forEach>
                                ${totalItems}
                            </span>
                        </div>
                        <div class="d-flex justify-content-between mb-4">
                            <span class="text-muted fs-5">Total TTC</span>
                            <span class="fs-4 fw-bold text-primary"><fmt:formatNumber value="${panier.total}" type="currency" currencySymbol="€" /></span>
                        </div>
                        <a href="${pageContext.request.contextPath}/commande" class="btn btn-accent w-100 py-3 fs-5">
                            <i class="fa-solid fa-cash-register me-2"></i>Passer à la caisse
                        </a>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="../layout/footer.jsp" />
