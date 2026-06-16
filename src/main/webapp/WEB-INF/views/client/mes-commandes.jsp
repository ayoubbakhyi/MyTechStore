<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/navbar.jsp" />

<h2>Mes Commandes</h2>

<c:if test="${not empty param.success}">
    <div><strong>Succès : </strong>${param.success}</div>
</c:if>

<c:choose>
    <c:when test="${empty commandes}">
        <p>Aucune commande enregistrée.</p>
        <p><a href="${pageContext.request.contextPath}/catalogue">Parcourir le catalogue</a></p>
    </c:when>
    <c:otherwise>
        <table border="1" cellpadding="5">
            <thead>
                <tr>
                    <th>Numéro de Commande</th>
                    <th>Date</th>
                    <th>Total</th>
                    <th>Statut</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="c" items="${commandes}">
                    <tr>
                        <td><strong>#CMD-${c.id}</strong></td>
                        <td>
                            <fmt:formatDate value="${c.dateCommande}" pattern="dd/MM/yyyy HH:mm" />
                        </td>
                        <td>
                            <strong><fmt:formatNumber value="${c.total}" type="currency" currencySymbol="€" /></strong>
                        </td>
                        <td>
                            ${c.statut == 'EN_ATTENTE' ? 'En attente' : 
                              c.statut == 'CONFIRMEE' ? 'Confirmée' : 
                              c.statut == 'EXPEDIEE' ? 'Expédiée' : 
                              c.statut == 'LIVREE' ? 'Livrée' : 'Annulée'}
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/mes-commandes?id=${c.id}">Détails</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:otherwise>
</c:choose>

<jsp:include page="../layout/footer.jsp" />
