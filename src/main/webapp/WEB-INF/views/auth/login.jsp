<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/navbar.jsp" />

<h2>Connexion</h2>
<p>Accédez à votre compte MyTechStore</p>

<c:if test="${not empty param.error}">
    <div><strong>Erreur : </strong>${param.error}</div>
</c:if>
<c:if test="${not empty requestScope.error}">
    <div><strong>Erreur : </strong>${requestScope.error}</div>
</c:if>
<c:if test="${not empty requestScope.success}">
    <div><strong>Succès : </strong>${requestScope.success}</div>
</c:if>

<form action="${pageContext.request.contextPath}/login" method="post">
    <div>
        <label for="email">Adresse E-mail :</label>
        <input type="email" id="email" name="email" required placeholder="nom@exemple.com">
    </div>
    <div>
        <label for="password">Mot de passe :</label>
        <input type="password" id="password" name="password" required placeholder="Votre mot de passe">
    </div>
    <button type="submit">Se Connecter</button>
</form>

<p>Pas encore membre ? <a href="${pageContext.request.contextPath}/register">Créer un compte</a></p>

<jsp:include page="../layout/footer.jsp" />
