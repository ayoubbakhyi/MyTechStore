<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../layout/header.jsp" />

<div>
    <!-- Sidebar -->
    <jsp:include page="../layout/admin-sidebar.jsp" />

    <!-- Content -->
    <div>
        <h2>${produit != null ? 'Modifier' : 'Ajouter'} un Produit</h2>
        <p>Remplissez les détails du produit ci-dessous</p>
        <p><a href="${pageContext.request.contextPath}/admin/produits">Retour à la liste</a></p>

        <form action="${pageContext.request.contextPath}/admin/produits" method="post" enctype="multipart/form-data">
            <c:if test="${produit != null}">
                <input type="hidden" name="id" value="${produit.id}">
            </c:if>

            <div>
                <label for="nom">Nom du Produit :</label><br>
                <input type="text" id="nom" name="nom" value="${produit.nom}" required placeholder="Ex: GeForce RTX 4070">
            </div>
            <br>
            <div>
                <label for="marque">Marque :</label><br>
                <input type="text" id="marque" name="marque" value="${produit.marque}" required placeholder="Ex: ASUS, MSI, NVIDIA">
            </div>
            <br>
            <div>
                <label for="prix">Prix (Original) :</label><br>
                <input type="number" step="0.01" id="prix" name="prix" value="${produit.prix}" required placeholder="0.00"> €
            </div>
            <br>
            <div>
                <label for="stock">Stock Initial :</label><br>
                <input type="number" id="stock" name="stock" value="${produit != null ? produit.stock : 0}" required min="0">
            </div>
            <br>
            <div>
                <label for="idCategorie">Catégorie :</label><br>
                <select id="idCategorie" name="idCategorie">
                    <option value="-1">-- Aucune catégorie --</option>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat.id}" ${produit != null && produit.idCategorie == cat.id ? 'selected' : ''}>${cat.nom}</option>
                    </c:forEach>
                </select>
            </div>
            <br>
            <div>
                <label for="idPromotion">Promotion :</label><br>
                <select id="idPromotion" name="idPromotion">
                    <option value="-1">-- Aucune promotion --</option>
                    <c:forEach var="promo" items="${promotions}">
                        <option value="${promo.id}" ${produit != null && produit.idPromotion == promo.id ? 'selected' : ''}>${promo.nom} (-${promo.valeur}%)</option>
                    </c:forEach>
                </select>
            </div>
            <br>
            <div>
                <label for="imageFile">Image du Produit :</label><br>
                <c:if test="${not empty produit.image}">
                    <div>
                        <img src="${pageContext.request.contextPath}/static/images/${produit.image}" alt="Image actuelle" width="80" height="80">
                        <p>Fichier actuel : ${produit.image}</p>
                        <input type="hidden" name="image" value="${produit.image}">
                    </div>
                </c:if>
                <input type="file" id="imageFile" name="imageFile" accept="image/*">
                <p><small>Formats acceptés : PNG, JPG, JPEG, WEBP. Laissez vide pour conserver l'image actuelle.</small></p>
            </div>
            <br>
            <div>
                <label for="description">Description Technique :</label><br>
                <textarea id="description" name="description" rows="5" cols="50" required placeholder="Saisissez les caractéristiques détaillées...">${produit.description}</textarea>
            </div>
            <br>
            <button type="submit">Enregistrer le Produit</button>
            <a href="${pageContext.request.contextPath}/admin/produits">Annuler</a>
        </form>
    </div>
</div>

</body>
</html>
