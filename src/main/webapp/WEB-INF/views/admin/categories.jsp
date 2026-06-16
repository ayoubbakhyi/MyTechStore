<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../layout/header.jsp" />

<div>
    <!-- Sidebar -->
    <jsp:include page="../layout/admin-sidebar.jsp" />

    <!-- Content -->
    <div>
        <h2>Gestion des Catégories</h2>
        <p>Créez ou supprimez des catégories d'articles</p>

        <div>
            <!-- Add Category -->
            <div>
                <h3>Ajouter une Catégorie</h3>
                <form action="${pageContext.request.contextPath}/admin/categories" method="post">
                    <input type="hidden" name="action" value="add">
                    <div>
                        <label for="nom">Nom de la Catégorie :</label>
                        <input type="text" id="nom" name="nom" required placeholder="Ex: Claviers Gamer">
                    </div>
                    <br>
                    <button type="submit">Créer la Catégorie</button>
                </form>
            </div>

            <hr>

            <!-- List Categories -->
            <div>
                <h3>Catégories Enregistrées</h3>
                <c:choose>
                    <c:when test="${empty categories}">
                        <p>Aucune catégorie enregistrée.</p>
                    </c:when>
                    <c:otherwise>
                        <table border="1" cellpadding="5">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Nom de la Catégorie</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="cat" items="${categories}">
                                    <tr>
                                        <td><strong>#CAT-${cat.id}</strong></td>
                                        <td>${cat.nom}</td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/admin/categories" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="${cat.id}">
                                                <button type="submit" onclick="return confirm('Supprimer cette catégorie ?');">Supprimer</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

</body>
</html>
