<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../layout/header.jsp" />

<div>
    <!-- Sidebar -->
    <jsp:include page="../layout/admin-sidebar.jsp" />

    <!-- Content -->
    <div>
        <h2>Tableau de Bord Administrateur</h2>
        <p>Vue globale sur les statistiques et opérations de MyTechStore</p>

        <!-- KPI Metrics -->
        <div>
            <ul>
                <li>Revenu Total : <strong><fmt:formatNumber value="${revenue}" type="currency" currencySymbol="€" /></strong></li>
                <li>Commandes : <strong>${totalOrders}</strong></li>
                <li>Produits : <strong>${totalProducts}</strong></li>
                <li>Clients : <strong>${totalClients}</strong></li>
            </ul>
        </div>

        <hr>

        <!-- Recent Orders -->
        <div>
            <h3>Commandes Récentes</h3>
            <c:choose>
                <c:when test="${empty recentOrders}">
                    <p>Aucune commande enregistrée.</p>
                </c:when>
                <c:otherwise>
                    <table border="1" cellpadding="5">
                        <thead>
                            <tr>
                                <th>Commande</th>
                                <th>Client</th>
                                <th>Date</th>
                                <th>Total</th>
                                <th>Statut</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="ord" items="${recentOrders}">
                                <tr>
                                    <td><strong>#CMD-${ord.id}</strong></td>
                                    <td>${ord.utilisateur.nom}</td>
                                    <td><fmt:formatDate value="${ord.dateCommande}" pattern="dd/MM/yyyy HH:mm" /></td>
                                    <td>
                                        <strong><fmt:formatNumber value="${ord.total}" type="currency" currencySymbol="€" /></strong>
                                    </td>
                                    <td>
                                        ${ord.statut == 'EN_ATTENTE' ? 'En attente' : 
                                          ord.statut == 'CONFIRMEE' ? 'Confirmée' : 
                                          ord.statut == 'EXPEDIEE' ? 'Expédiée' : 
                                          ord.statut == 'LIVREE' ? 'Livrée' : 'Annulée'}
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/commandes?id=${ord.id}">Détails</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>

        <hr>

        <!-- Stock Warnings -->
        <div>
            <h3>Alertes Stocks Faibles</h3>
            <c:choose>
                <c:when test="${empty lowStockProducts}">
                    <p>Tous les produits ont un stock suffisant.</p>
                </c:when>
                <c:otherwise>
                    <ul>
                        <c:forEach var="lp" items="${lowStockProducts}">
                            <li>
                                <strong>${lp.nom}</strong> (Marque: ${lp.marque}) - 
                                <span style="color: red;">Stock: ${lp.stock}</span>
                            </li>
                        </c:forEach>
                    </ul>
                    <p><a href="${pageContext.request.contextPath}/admin/produits">Gérer les produits</a></p>
                </c:otherwise>
            </c:choose>
        </div>

        <hr>

        <!-- Category Distribution -->
        <c:if test="${not empty categoryStats}">
            <div>
                <h3>Distribution des Produits par Catégorie</h3>
                <ul>
                    <c:forEach var="stat" items="${categoryStats}">
                        <li>
                            <strong>${stat.categorie}</strong> : ${stat.count} produits <br>
                            <progress value="${stat.count}" max="15"></progress>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </c:if>
    </div>
</div>

</body>
</html>
