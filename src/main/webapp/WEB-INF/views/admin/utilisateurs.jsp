<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/admin-sidebar.jsp" />

<main>
    <div>
        <h1>Gestion des Utilisateurs</h1>
        <p>Liste de tous les comptes enregistrés sur la plateforme.</p>
    </div>

    <!-- Error message if any -->
    <c:if test="${not empty error}">
        <div style="color: red; border: 1px solid red; padding: 10px; margin-bottom: 15px;">
            ${error}
        </div>
    </c:if>

    <!-- Create User Link -->
    <div>
        <a href="${pageContext.request.contextPath}/admin/utilisateurs?action=new">Ajouter un nouvel utilisateur</a>
    </div>
    <br/>

    <!-- Users Table -->
    <table border="1" cellpadding="5" cellspacing="0">
        <thead>
            <tr>
                <th>ID</th>
                <th>Nom</th>
                <th>E-mail</th>
                <th>Rôle</th>
                <th>Date de Création</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="u" items="${utilisateurs}">
                <tr>
                    <td>${u.id}</td>
                    <td>${u.nom}</td>
                    <td>${u.email}</td>
                    <td>${u.role}</td>
                    <td>
                        <fmt:formatDate value="${u.dateCreation}" pattern="dd/MM/yyyy HH:mm" />
                    </td>
                    <td>
                        <!-- Edit link -->
                        <a href="${pageContext.request.contextPath}/admin/utilisateurs?action=edit&id=${u.id}">Modifier</a>
                        
                        <!-- Delete form -->
                        <form action="${pageContext.request.contextPath}/admin/utilisateurs" method="post" style="display:inline;" onsubmit="return confirm('Êtes-vous sûr de vouloir supprimer cet utilisateur ?');">
                            <input type="hidden" name="action" value="delete" />
                            <input type="hidden" name="id" value="${u.id}" />
                            <button type="submit">Supprimer</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</main>

<jsp:include page="../layout/footer.jsp" />
