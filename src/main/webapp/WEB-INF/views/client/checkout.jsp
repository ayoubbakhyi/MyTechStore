<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/navbar.jsp" />

<h2>Validation de Commande</h2>

<c:if test="${not empty requestScope.error}">
    <div><strong>Erreur : </strong>${requestScope.error}</div>
</c:if>

<div>
    <!-- Delivery Form -->
    <div>
        <h3>Informations de Livraison</h3>
        <form action="${pageContext.request.contextPath}/commande" method="post">
            <div>
                <label for="nom">Nom du destinataire :</label>
                <input type="text" id="nom" name="nom" value="${sessionScope.user.nom}" required>
            </div>
            <div>
                <label for="telephone">Numéro de Téléphone :</label>
                <input type="tel" id="telephone" name="telephone" required placeholder="06 12 34 56 78">
            </div>
            <div>
                <label for="adresse">Adresse Complète :</label><br>
                <textarea id="adresse" name="adresse" rows="3" required placeholder="Ex: 12 Rue des Claviers Gaming"></textarea>
            </div>
            <div>
                <label for="ville">Ville :</label>
                <input type="text" id="ville" name="ville" required placeholder="Paris">
            </div>
            <div>
                <label for="codePostal">Code Postal :</label>
                <input type="text" id="codePostal" name="codePostal" required placeholder="75000">
            </div>
            
            <br>
            <button type="submit">Confirmer et Commander</button>
        </form>
    </div>

    <hr>

    <!-- Order Summary -->
    <div>
        <h3>Résumé de la Commande</h3>
        <ul>
            <c:forEach var="item" items="${panier.items}">
                <li>
                    <strong>${item.produit.nom}</strong> (Quantité: ${item.quantite}) - 
                    <fmt:formatNumber value="${item.produit.prixEffectif * item.quantite}" type="currency" currencySymbol="€" />
                </li>
            </c:forEach>
        </ul>
        
        <p>Frais de livraison : <strong>Gratuit</strong></p>
        <p>Total Commande : <strong><fmt:formatNumber value="${panier.total}" type="currency" currencySymbol="€" /></strong></p>
        
        <p><a href="${pageContext.request.contextPath}/panier">Retour au Panier</a></p>
    </div>
</div>

<jsp:include page="../layout/footer.jsp" />
