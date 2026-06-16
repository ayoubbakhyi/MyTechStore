<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div>
    <a href="${pageContext.request.contextPath}/">MyTechStore</a>
    |
    <a href="${pageContext.request.contextPath}/catalogue">Catalogue</a>
    <c:choose>
        <c:when test="${not empty sessionScope.user}">
            | Bonjour, <strong>${sessionScope.user.nom}</strong>
            <c:if test="${sessionScope.user.role == 'ADMIN'}">
                | <a href="${pageContext.request.contextPath}/admin">Tableau de Bord</a>
            </c:if>
            <c:if test="${sessionScope.user.role == 'CLIENT'}">
                | <a href="${pageContext.request.contextPath}/panier">Panier</a>
                | <a href="${pageContext.request.contextPath}/mes-commandes">Mes Commandes</a>
            </c:if>
            | <a href="${pageContext.request.contextPath}/logout">Déconnexion</a>
        </c:when>
        <c:otherwise>
            | <a href="${pageContext.request.contextPath}/login">Connexion</a>
            | <a href="${pageContext.request.contextPath}/register">Inscription</a>
        </c:otherwise>
    </c:choose>
</div>
<hr>
