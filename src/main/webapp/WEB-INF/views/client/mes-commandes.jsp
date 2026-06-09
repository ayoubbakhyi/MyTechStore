<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/navbar.jsp" />
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="container my-5">
    <h1 class="fw-bold mb-4"><i class="fa-solid fa-box-open me-2 text-primary"></i>Mes Commandes</h1>

    <c:if test="${not empty param.success}">
        <div class="alert alert-success alert-dismissible fade show alert-dismissible-auto" role="alert">
            <i class="fa-solid fa-circle-check me-2"></i>${param.success}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${empty commandes}">
            <div class="card border-0 shadow-sm p-5 text-center">
                <i class="fa-solid fa-receipt text-muted fa-4x mb-3"></i>
                <h4 class="fw-bold text-muted">Aucune commande enregistrée</h4>
                <p class="text-muted mb-4">Vous n'avez pas encore effectué d'achats sur notre site.</p>
                <div class="d-flex justify-content-center">
                    <a href="${pageContext.request.contextPath}/catalogue" class="btn btn-primary px-4"><i class="fa-solid fa-bag-shopping me-2"></i>Parcourir le catalogue</a>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card border-0 shadow-sm p-4">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr>
                                <th scope="col">Numéro de Commande</th>
                                <th scope="col">Date</th>
                                <th scope="col" class="text-center">Total</th>
                                <th scope="col" class="text-center">Statut</th>
                                <th scope="col" class="text-end">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="c" items="${commandes}">
                                <tr>
                                    <td><strong>#CMD-${c.id}</strong></td>
                                    <td>
                                        <fmt:formatDate value="${c.dateCommande}" pattern="dd MMMM yyyy HH:mm" />
                                    </td>
                                    <td class="text-center fw-bold text-primary">
                                        <fmt:formatNumber value="${c.total}" type="currency" currencySymbol="€" />
                                    </td>
                                    <td class="text-center">
                                        <span class="badge badge-${c.statut.toLowerCase().replace('_', '-')}">
                                            ${c.statut == 'EN_ATTENTE' ? 'En attente' : 
                                              c.statut == 'CONFIRMEE' ? 'Confirmée' : 
                                              c.statut == 'EXPEDIEE' ? 'Expédiée' : 
                                              c.statut == 'LIVREE' ? 'Livrée' : 'Annulée'}
                                        </span>
                                    </td>
                                    <td class="text-end">
                                        <a href="${pageContext.request.contextPath}/mes-commandes?id=${c.id}" class="btn btn-outline-primary btn-sm">
                                            <i class="fa-solid fa-eye me-1"></i>Détails
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="../layout/footer.jsp" />
