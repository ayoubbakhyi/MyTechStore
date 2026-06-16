<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/navbar.jsp" />

<h2>Inscription</h2>
<p>Créez votre compte client en quelques instants</p>

<c:if test="${not empty requestScope.error}">
    <div><strong>Erreur : </strong>${requestScope.error}</div>
</c:if>

<form action="${pageContext.request.contextPath}/register" method="post">
    <div>
        <label for="nom">Nom Complet :</label>
        <input type="text" id="nom" name="nom" required placeholder="Jean Dupont">
    </div>
    <div>
        <label for="email">Adresse E-mail :</label>
        <input type="email" id="email" name="email" required placeholder="nom@exemple.com">
    </div>
    <div>
        <label for="password">Mot de passe :</label>
        <input type="password" id="password" name="password" required placeholder="Mot de passe sécurisé">
    </div>
    <div>
        <label for="confirmPassword">Confirmer le mot de passe :</label>
        <input type="password" id="confirmPassword" name="confirmPassword" required placeholder="Confirmez le mot de passe">
    </div>
    <button type="submit">S'inscrire</button>
</form>

<p>Déjà inscrit ? <a href="${pageContext.request.contextPath}/login">Se connecter</a></p>

<jsp:include page="../layout/footer.jsp" />
