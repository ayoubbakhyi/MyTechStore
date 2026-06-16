<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/navbar.jsp" />

<div>
    <p>
        <a href="${pageContext.request.contextPath}/catalogue">Catalogue</a>
        <c:if test="${produit.categorie != null}">
            &gt; <a href="${pageContext.request.contextPath}/catalogue?category=${produit.idCategorie}">${produit.categorie.nom}</a>
        </c:if>
        &gt; ${produit.nom}
    </p>
</div>

<c:if test="${not empty param.success}">
    <div><strong>Succès : </strong>${param.success}</div>
</c:if>

<div>
    <div>
        <img src="${pageContext.request.contextPath}/static/images/${produit.image != null && produit.image != '' ? produit.image : 'logo.png'}" 
             alt="${produit.nom}" width="200" height="200"
             onerror="this.src='https://placehold.co/200x200?text=Image'">
    </div>

    <div>
        <span>Marque : ${produit.marque}</span>
        <c:if test="${produit.categorie != null}">
            | Catégorie : ${produit.categorie.nom}
        </c:if>
        <h1>${produit.nom}</h1>

        <div>
            <c:choose>
                <c:when test="${produit.enPromotion}">
                    <span>Ancien prix : <del><fmt:formatNumber value="${produit.prix}" type="currency" currencySymbol="€" /></del></span><br>
                    <strong>Nouveau prix : <fmt:formatNumber value="${produit.prixEffectif}" type="currency" currencySymbol="€" /> (-${produit.promotion.valeur}%)</strong>
                </c:when>
                <c:otherwise>
                    <strong>Prix : <fmt:formatNumber value="${produit.prix}" type="currency" currencySymbol="€" /></strong>
                </c:otherwise>
            </c:choose>
        </div>

        <div>
            <h3>Description</h3>
            <p>${produit.description != null && produit.description != '' ? produit.description : 'Aucune description disponible pour ce produit.'}</p>
        </div>

        <div>
            <h3>Disponibilité</h3>
            <c:choose>
                <c:when test="${produit.stock >= 10}">
                    <span>En stock (${produit.stock} restants)</span>
                </c:when>
                <c:when test="${produit.stock > 0}">
                    <span>Stock limité (${produit.stock} restants)</span>
                </c:when>
                <c:otherwise>
                    <span>Rupture de stock</span>
                </c:otherwise>
            </c:choose>
        </div>

        <hr>

        <div>
            <c:choose>
                <c:when test="${produit.stock > 0}">
                    <form action="${pageContext.request.contextPath}/panier" method="post">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="productId" value="${produit.id}">
                        <input type="hidden" name="redirect" value="produit">
                        
                        <label for="quantity">Quantité :</label>
                        <input type="number" id="quantity" name="quantity" value="1" min="1" max="${produit.stock}">
                        <button type="submit">Ajouter au panier</button>
                    </form>
                </c:when>
                <c:otherwise>
                    <button disabled>Indisponible</button>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<c:if test="${not empty relatedProduits}">
    <hr>
    <h3>Produits Similaires</h3>
    <ul>
        <c:forEach var="rp" items="${relatedProduits}">
            <li>
                <a href="${pageContext.request.contextPath}/produit?id=${rp.id}">${rp.nom}</a> - 
                <fmt:formatNumber value="${rp.prixEffectif}" type="currency" currencySymbol="€" />
            </li>
        </c:forEach>
    </ul>
</c:if>

<jsp:include page="../layout/footer.jsp" />
