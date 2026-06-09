<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="../layout/header.jsp" />
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="container-fluid p-0">
    <div class="row g-0">
        <!-- Sidebar Column -->
        <div class="col-md-3 col-lg-2">
            <jsp:include page="../layout/admin-sidebar.jsp" />
        </div>

        <!-- Content Column -->
        <div class="col-md-9 col-lg-10 p-4">
            <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
                <div>
                    <h2 class="fw-bold mb-0">${produit != null ? 'Modifier' : 'Ajouter'} un Produit</h2>
                    <p class="text-muted mb-0">Remplissez les détails du produit ci-dessous</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/produits" class="btn btn-outline-secondary">
                    <i class="fa-solid fa-arrow-left me-1"></i>Retour à la liste
                </a>
            </div>

            <div class="card border-0 shadow-sm p-4" style="max-width: 800px;">
                <form action="${pageContext.request.contextPath}/admin/produits" method="post" enctype="multipart/form-data">
                    <c:if test="${produit != null}">
                        <input type="hidden" name="id" value="${produit.id}">
                    </c:if>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="nom" class="form-label">Nom du Produit</label>
                            <input type="text" class="form-control" id="nom" name="nom" value="${produit.nom}" required placeholder="Ex: GeForce RTX 4070">
                        </div>
                        <div class="col-md-6">
                            <label for="marque" class="form-label">Marque</label>
                            <input type="text" class="form-control" id="marque" name="marque" value="${produit.marque}" required placeholder="Ex: ASUS, MSI, NVIDIA">
                        </div>
                        
                        <div class="col-md-6">
                            <label for="prix" class="form-label">Prix (Original)</label>
                            <div class="input-group">
                                <input type="number" step="0.01" class="form-control" id="prix" name="prix" value="${produit.prix}" required placeholder="0.00">
                                <span class="input-group-text">€</span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label for="stock" class="form-label">Stock Initial</label>
                            <input type="number" class="form-control" id="stock" name="stock" value="${produit != null ? produit.stock : 0}" required min="0">
                        </div>

                        <div class="col-md-6">
                            <label for="idCategorie" class="form-label">Catégorie</label>
                            <select class="form-select" id="idCategorie" name="idCategorie">
                                <option value="-1">-- Aucune catégorie --</option>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.id}" ${produit != null && produit.idCategorie == cat.id ? 'selected' : ''}>${cat.nom}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="idPromotion" class="form-label">Promotion</label>
                            <select class="form-select" id="idPromotion" name="idPromotion">
                                <option value="-1">-- Aucune promotion --</option>
                                <c:forEach var="promo" items="${promotions}">
                                    <option value="${promo.id}" ${produit != null && produit.idPromotion == promo.id ? 'selected' : ''}>${promo.nom} (-${promo.valeur}%)</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-12">
                            <label for="imageFile" class="form-label">Image du Produit</label>
                            <c:if test="${not empty produit.image}">
                                <div class="mb-2 p-2 border rounded bg-light d-flex align-items-center gap-3">
                                    <img src="${pageContext.request.contextPath}/static/images/${produit.image}" alt="Image actuelle" style="max-height: 80px;" class="img-thumbnail">
                                    <div>
                                        <span class="text-muted small d-block">Fichier actuel :</span>
                                        <span class="fw-semibold small">${produit.image}</span>
                                        <input type="hidden" name="image" value="${produit.image}">
                                    </div>
                                </div>
                            </c:if>
                            <input type="file" class="form-control" id="imageFile" name="imageFile" accept="image/*">
                            <div class="form-text">Formats acceptés : PNG, JPG, JPEG, WEBP. Laissez vide pour conserver l'image actuelle.</div>
                        </div>

                        <div class="col-12">
                            <label for="description" class="form-label">Description Technique</label>
                            <textarea class="form-control" id="description" name="description" rows="5" required placeholder="Saisissez les caractéristiques détaillées du produit...">${produit.description}</textarea>
                        </div>
                    </div>

                    <hr class="my-4">

                    <div class="d-flex gap-2 justify-content-end">
                        <a href="${pageContext.request.contextPath}/admin/produits" class="btn btn-outline-secondary">Annuler</a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fa-solid fa-save me-1"></i>Enregistrer le Produit
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap 5.3 JS Bundle CDN -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<!-- Custom JS -->
<script src="${pageContext.request.contextPath}/static/js/main.js"></script>
</body>
</html>
