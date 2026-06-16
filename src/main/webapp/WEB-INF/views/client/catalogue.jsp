<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/navbar.jsp" />

<h2>Catalogue Produits</h2>

<c:if test="${not empty param.success}">
    <div><strong>Succès : </strong>${param.success}</div>
</c:if>
<c:if test="${not empty param.error}">
    <div><strong>Erreur : </strong>${param.error}</div>
</c:if>

<div>
    <h3>Filtres & Recherche</h3>
    <!-- Search Form -->
    <form action="${pageContext.request.contextPath}/catalogue" method="get">
        <c:if test="${selectedCat != null}">
            <input type="hidden" name="category" value="${selectedCat}">
        </c:if>
        <input type="text" placeholder="Rechercher..." name="search" value="${searchVal}">
        <button type="submit">Rechercher</button>
        <c:if test="${not empty searchVal || selectedCat != null}">
            | <a href="${pageContext.request.contextPath}/catalogue">Réinitialiser</a>
        </c:if>
    </form>

    <!-- Categories List -->
    <ul>
        <li>
            <a href="${pageContext.request.contextPath}/catalogue?search=${searchVal != null ? searchVal : ''}">
                Toutes les catégories
            </a>
        </li>
        <c:forEach var="cat" items="${categories}">
            <li>
                <a href="${pageContext.request.contextPath}/catalogue?category=${cat.id}&search=${searchVal != null ? searchVal : ''}">
                    ${cat.nom}
                </a>
            </li>
        </c:forEach>
    </ul>
</div>

<hr>

<div>
    <c:choose>
        <c:when test="${empty produits}">
            <p>Aucun produit trouvé.</p>
        </c:when>
        <c:otherwise>
            <table border="1" cellpadding="5">
                <thead>
                    <tr>
                        <th>Image</th>
                        <th>Nom</th>
                        <th>Marque</th>
                        <th>Stock</th>
                        <th>Prix original</th>
                        <th>Prix effectif</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${produits}">
                        <tr>
                            <td>
                                <!-- Placeholder or image tag -->
                                <img src="${pageContext.request.contextPath}/static/images/${p.image != null && p.image != '' ? p.image : 'logo.png'}" 
                                     alt="${p.nom}" width="50" height="50"
                                     onerror="this.src='https://placehold.co/50x50?text=Image'">
                            </td>
                            <td><strong>${p.nom}</strong></td>
                            <td>${p.marque}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.stock >= 10}">En stock (${p.stock})</c:when>
                                    <c:when test="${p.stock > 0}">Stock faible (${p.stock})</c:when>
                                    <c:otherwise>Rupture de stock</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <fmt:formatNumber value="${p.prix}" type="currency" currencySymbol="€" />
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.enPromotion}">
                                        <strong><fmt:formatNumber value="${p.prixEffectif}" type="currency" currencySymbol="€" /> (-${p.promotion.valeur}%)</strong>
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:formatNumber value="${p.prix}" type="currency" currencySymbol="€" />
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/produit?id=${p.id}">Détails</a>
                                |
                                <form action="${pageContext.request.contextPath}/panier" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="productId" value="${p.id}">
                                    <button type="submit" ${p.stock <= 0 ? 'disabled' : ''}>Acheter</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="../layout/footer.jsp" />
