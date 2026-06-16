<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/navbar.jsp" />

<h2>Votre Panier</h2>

<c:if test="${not empty param.error}">
    <div><strong>Erreur : </strong>${param.error}</div>
</c:if>

<c:choose>
    <c:when test="${empty panier.items}">
        <p>Votre panier est vide.</p>
        <p><a href="${pageContext.request.contextPath}/catalogue">Continuer mes achats</a></p>
    </c:when>
    <c:otherwise>
        <table border="1" cellpadding="5">
            <thead>
                <tr>
                    <th>Produit</th>
                    <th>Description</th>
                    <th>Prix Unitaire</th>
                    <th>Quantité</th>
                    <th>Total</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${panier.items}">
                    <tr>
                        <td>
                            <img src="${pageContext.request.contextPath}/static/images/${item.produit.image != null && item.produit.image != '' ? item.produit.image : 'logo.png'}" 
                                 alt="${item.produit.nom}" width="50" height="50"
                                 onerror="this.src='https://placehold.co/50x50?text=Image'">
                        </td>
                        <td>
                            <strong>${item.produit.nom}</strong><br>
                            Marque: ${item.produit.marque}
                        </td>
                        <td>
                            <fmt:formatNumber value="${item.produit.prixEffectif}" type="currency" currencySymbol="€" />
                            <c:if test="${item.produit.enPromotion}">
                                <br><small><del><fmt:formatNumber value="${item.produit.prix}" type="currency" currencySymbol="€" /></del></small>
                            </c:if>
                        </td>
                        <td>
                            <form action="${pageContext.request.contextPath}/panier" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="productId" value="${item.produit.id}">
                                <input type="number" name="quantity" value="${item.quantite}" min="1" max="${item.produit.stock}" style="width: 50px;">
                                <button type="submit">Modifier</button>
                            </form>
                        </td>
                        <td>
                            <strong><fmt:formatNumber value="${item.produit.prixEffectif * item.quantite}" type="currency" currencySymbol="€" /></strong>
                        </td>
                        <td>
                            <form action="${pageContext.request.contextPath}/panier" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="remove">
                                <input type="hidden" name="productId" value="${item.produit.id}">
                                <button type="submit" onclick="return confirm('Retirer cet article ?');">Retirer</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <br>
        
        <div>
            <form action="${pageContext.request.contextPath}/panier" method="post" style="display:inline;">
                <input type="hidden" name="action" value="clear">
                <button type="submit" onclick="return confirm('Vider votre panier ?');">Vider le panier</button>
            </form>
            | <a href="${pageContext.request.contextPath}/catalogue">Continuer mes achats</a>
        </div>

        <hr>

        <div>
            <h3>Récapitulatif</h3>
            <p>Total articles : 
                <c:set var="totalItems" value="0" />
                <c:forEach var="item" items="${panier.items}">
                    <c:set var="totalItems" value="${totalItems + item.quantite}" />
                </c:forEach>
                <strong>${totalItems}</strong>
            </p>
            <p>Total TTC : <strong><fmt:formatNumber value="${panier.total}" type="currency" currencySymbol="€" /></strong></p>
            <p><a href="${pageContext.request.contextPath}/commande"><button type="button" style="font-size: 1.2rem; padding: 5px 15px;">Passer à la caisse</button></a></p>
        </div>
    </c:otherwise>
</c:choose>

<jsp:include page="../layout/footer.jsp" />
