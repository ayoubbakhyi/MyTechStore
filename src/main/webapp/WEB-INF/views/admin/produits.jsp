<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="../layout/header.jsp" />
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

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
                    <h2 class="fw-bold mb-0">Gestion du Catalogue Produits</h2>
                    <p class="text-muted mb-0">Ajoutez, modifiez ou supprimez des articles du magasin</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/produits?action=new" class="btn btn-primary">
                    <i class="fa-solid fa-plus-circle me-2"></i>Ajouter un Produit
                </a>
            </div>

            <div class="card border-0 shadow-sm p-4">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr>
                                <th scope="col" style="width: 70px;">Image</th>
                                <th scope="col">Nom</th>
                                <th scope="col">Marque</th>
                                <th scope="col">Catégorie</th>
                                <th scope="col" class="text-center">Prix original</th>
                                <th scope="col" class="text-center">Stock</th>
                                <th scope="col">Promotion active</th>
                                <th scope="col" class="text-end" style="width: 150px;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${produits}">
                                <tr>
                                    <td>
                                        <img src="${pageContext.request.contextPath}/static/images/${p.image != null && p.image != '' ? p.image : 'logo.png'}" 
                                             alt="${p.nom}" class="img-fluid rounded" style="max-height: 40px; object-fit: contain;"
                                             onerror="this.src='https://placehold.co/100x60/white/2563eb?text=${p.nom}'">
                                    </td>
                                    <td><strong>${p.nom}</strong></td>
                                    <td>${p.marque}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${p.categorie != null}">
                                                <span class="badge bg-light text-dark border">${p.categorie.nom}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted small">Aucune</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center fw-semibold">
                                        <fmt:formatNumber value="${p.prix}" type="currency" currencySymbol="€" />
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${p.stock >= 10}">
                                                <span class="badge bg-success text-white px-2 py-1 fs-7">${p.stock} (OK)</span>
                                            </c:when>
                                            <c:when test="${p.stock >= 5}">
                                                <span class="badge bg-warning text-dark px-2 py-1 fs-7">${p.stock} (Bas)</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger text-white px-2 py-1 fs-7">${p.stock} (Alerte)</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${p.enPromotion}">
                                                <span class="text-danger fw-bold"><i class="fa-solid fa-percent me-1"></i>-${p.promotion.valeur}% (${p.promotion.nom})</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted small">Aucune</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end">
                                        <div class="d-inline-flex gap-2">
                                            <a href="${pageContext.request.contextPath}/admin/produits?action=edit&id=${p.id}" class="btn btn-sm btn-outline-secondary">
                                                <i class="fa-solid fa-pen-to-square me-1"></i>Éditer
                                            </a>
                                            <form action="${pageContext.request.contextPath}/admin/produits" method="post" class="m-0">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="${p.id}">
                                                <button type="submit" class="btn btn-sm btn-outline-danger confirm-delete" data-type="ce produit">
                                                    <i class="fa-solid fa-trash-can"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
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
