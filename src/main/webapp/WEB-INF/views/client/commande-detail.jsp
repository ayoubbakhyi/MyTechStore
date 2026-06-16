<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/navbar.jsp" />

<div>
    <p>
        <a href="${pageContext.request.contextPath}/mes-commandes">Mes Commandes</a> &gt; Commande #CMD-${commande.id}
    </p>
</div>

<h2>Détails Commande #CMD-${commande.id}</h2>
<p>Passée le <fmt:formatDate value="${commande.dateCommande}" pattern="dd/MM/yyyy HH:mm" /></p>
<p>Statut : 
    <strong>
        ${commande.statut == 'EN_ATTENTE' ? 'En attente' : 
          commande.statut == 'CONFIRMEE' ? 'Confirmée' : 
          commande.statut == 'EXPEDIEE' ? 'Expédiée' : 
          commande.statut == 'LIVREE' ? 'Livrée' : 'Annulée'}
    </strong>
</p>

<table border="1" cellpadding="5">
    <thead>
        <tr>
            <th>Image</th>
            <th>Désignation</th>
            <th>Prix Unitaire</th>
            <th>Quantité</th>
            <th>Total</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="line" items="${commande.lignes}">
            <tr>
                <td>
                    <img src="${pageContext.request.contextPath}/static/images/${line.produit.image != null && line.produit.image != '' ? line.produit.image : 'logo.png'}" 
                         alt="${line.produit.nom}" width="50" height="50"
                         onerror="this.src='https://placehold.co/50x50?text=Image'">
                </td>
                <td>
                    <strong>${line.produit.nom}</strong><br>
                    Marque: ${line.produit.marque}
                </td>
                <td>
                    <fmt:formatNumber value="${line.prixUnitaire}" type="currency" currencySymbol="€" />
                </td>
                <td>${line.quantite}</td>
                <td>
                    <strong><fmt:formatNumber value="${line.prixUnitaire * line.quantite}" type="currency" currencySymbol="€" /></strong>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>

<p>Montant Total TTC : <strong><fmt:formatNumber value="${commande.total}" type="currency" currencySymbol="€" /></strong></p>

<hr>

<h3>Informations de Livraison</h3>
<c:choose>
    <c:when test="${commande.livraison != null}">
        <p>Statut de la livraison : 
            <strong>
                ${commande.livraison.statut == 'EN_PREPARATION' ? 'En préparation' : 
                  commande.livraison.statut == 'EXPEDIEE' ? 'Expédiée' : 'Livrée'}
            </strong>
        </p>
        <c:if test="${commande.livraison.dateExpedition != null}">
            <p>Expédiée le : ${commande.livraison.dateExpedition}</p>
        </c:if>
        <c:if test="${commande.livraison.dateLivraisonPrevue != null}">
            <p>Livraison prévue le : ${commande.livraison.dateLivraisonPrevue}</p>
        </c:if>
        <p>
            <strong>Adresse de Livraison :</strong><br>
            ${commande.utilisateur.nom}<br>
            ${commande.livraison.adresse}<br>
            ${commande.livraison.codePostal} ${commande.livraison.ville}
        </p>
    </c:when>
    <c:otherwise>
        <p>Aucune information de livraison disponible.</p>
    </c:otherwise>
</c:choose>

<p><a href="${pageContext.request.contextPath}/mes-commandes">Retour à mes commandes</a></p>

<jsp:include page="../layout/footer.jsp" />
