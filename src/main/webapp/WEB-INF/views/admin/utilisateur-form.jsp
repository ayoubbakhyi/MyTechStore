<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/admin-sidebar.jsp" />

<main>
    <div>
        <h1>
            <c:choose>
                <c:when test="${not empty utilisateur}">
                    Modifier l'utilisateur : ${utilisateur.nom}
                </c:when>
                <c:otherwise>
                    Ajouter un nouvel utilisateur
                </c:otherwise>
            </c:choose>
        </h1>
        <a href="${pageContext.request.contextPath}/admin/utilisateurs">Retour à la liste</a>
    </div>
    <br/>

    <!-- Error message if any -->
    <c:if test="${not empty error}">
        <div style="color: red; border: 1px solid red; padding: 10px; margin-bottom: 15px;">
            ${error}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/admin/utilisateurs" method="post">
        <!-- Hidden field for ID (only when editing) -->
        <c:if test="${not empty utilisateur}">
            <input type="hidden" name="id" value="${utilisateur.id}" />
        </c:if>

        <div>
            <label for="nom">Nom :</label><br/>
            <input type="text" id="nom" name="nom" value="${not empty utilisateur ? utilisateur.nom : ''}" required />
        </div>
        <br/>

        <div>
            <label for="email">E-mail :</label><br/>
            <input type="email" id="email" name="email" value="${not empty utilisateur ? utilisateur.email : ''}" required />
        </div>
        <br/>

        <div>
            <label for="role">Rôle :</label><br/>
            <select id="role" name="role" required>
                <option value="CLIENT" ${utilisateur.role == 'CLIENT' ? 'selected' : ''}>CLIENT</option>
                <option value="ADMIN" ${utilisateur.role == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
            </select>
        </div>
        <br/>

        <div>
            <label for="password">Mot de passe :</label><br/>
            <input type="password" id="password" name="password" ${empty utilisateur ? 'required' : ''} />
            <c:if test="${not empty utilisateur}">
                <br/>
                <small style="color: gray;">Laissez vide pour conserver le mot de passe actuel.</small>
            </c:if>
        </div>
        <br/>

        <div>
            <button type="submit">
                <c:choose>
                    <c:when test="${not empty utilisateur}">
                        Enregistrer les modifications
                    </c:when>
                    <c:otherwise>
                        Créer l'utilisateur
                    </c:otherwise>
                </c:choose>
            </button>
        </div>
    </form>
</main>

<jsp:include page="../layout/footer.jsp" />
