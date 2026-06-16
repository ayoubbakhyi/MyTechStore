<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../layout/header.jsp" />

<div>
    <!-- Sidebar -->
    <jsp:include page="../layout/admin-sidebar.jsp" />

    <!-- Content -->
    <div>
        <h2>Gestion du Catalogue Produits</h2>
        <p>Ajoutez, modifiez ou supprimez des articles du magasin</p>
        <p><a href="${pageContext.request.contextPath}/admin/produits?action=new"><button type="button">Ajouter un Produit</button></a></p>

        <table border="1" cellpadding="5">
            <thead>
                <tr>
                    <th>Image</th>
                    <th>Nom</th>
                    <th>Marque</th>
                    <th>Catégorie</th>
                    <th>Prix original</th>
                    <th>Stock</th>
                    <th>Promotion active</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${produits}">
                    <tr>
                        <td>
                            <img src="${pageContext.request.contextPath}/static/images/${p.image != null && p.image != '' ? p.image : 'logo.png'}" 
                                 alt="${p.nom}" width="40" height="40"
                                 onerror="this.src='https://placehold.co/40x40?text=Image'">
                        </td>
                        <td><strong>${p.nom}</strong></td>
                        <td>${p.marque}</td>
                        <td>
                            <c:choose>
                                <c:when test="${p.categorie != null}">
                                    ${p.categorie.nom}
                                </c:when>
                                <c:otherwise>
                                    Aucune
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <fmt:formatNumber value="${p.prix}" type="currency" currencySymbol="€" />
                        </td>
                        <td>
                            ${p.stock}
                            <c:choose>
                                <c:when test="${p.stock >= 10}"> (OK)</c:when>
                                <c:when test="${p.stock >= 5}"> (Bas)</c:when>
                                <c:otherwise> (Alerte)</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${p.enPromotion}">
                                    <strong>-${p.promotion.valeur}% (${p.promotion.nom})</strong>
                                </c:when>
                                <c:otherwise>
                                    Aucune
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/produits?action=edit&id=${p.id}">Éditer</a>
                            |
                            <form action="${pageContext.request.contextPath}/admin/produits" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="${p.id}">
                                <button type="submit" onclick="return confirm('Supprimer ce produit ?');">Supprimer</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>
