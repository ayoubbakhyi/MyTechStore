<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<nav class="navbar navbar-expand-lg navbar-dark mb-4">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            <i class="fa-solid fa-microchip me-2"></i>MyTech<span>Store</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarText" aria-controls="navbarText" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarText">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link ${requestScope['javax.servlet.forward.servlet_path'] == '/catalogue' ? 'active' : ''}" href="${pageContext.request.contextPath}/catalogue">
                        <i class="fa-solid fa-list me-1"></i>Catalogue
                    </a>
                </li>
            </ul>
            <div class="d-flex align-items-center">
                <ul class="navbar-nav me-3">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <li class="nav-item me-2">
                                <span class="nav-link text-light">
                                    <i class="fa-solid fa-user me-1 text-primary"></i>Bonjour, <strong>${sessionScope.user.nom}</strong>
                                </span>
                            </li>
                            <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/admin">
                                        <i class="fa-solid fa-sliders me-1 text-warning"></i>Tableau de Bord
                                    </a>
                                </li>
                            </c:if>
                            <c:if test="${sessionScope.user.role == 'CLIENT'}">
                                <li class="nav-item me-2">
                                    <a class="nav-link ${requestScope['javax.servlet.forward.servlet_path'] == '/panier' ? 'active' : ''}" href="${pageContext.request.contextPath}/panier">
                                        <i class="fa-solid fa-cart-shopping me-1"></i>Panier
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link ${requestScope['javax.servlet.forward.servlet_path'] == '/mes-commandes' ? 'active' : ''}" href="${pageContext.request.contextPath}/mes-commandes">
                                        <i class="fa-solid fa-box-open me-1"></i>Mes Commandes
                                    </a>
                                </li>
                            </c:if>
                            <li class="nav-item ms-3">
                                <a class="btn btn-outline-danger btn-sm" href="${pageContext.request.contextPath}/logout">
                                    <i class="fa-solid fa-right-from-bracket me-1"></i>Déconnexion
                                </a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item me-2">
                                <a class="nav-link" href="${pageContext.request.contextPath}/login">
                                    <i class="fa-solid fa-right-to-bracket me-1"></i>Connexion
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="btn btn-primary btn-sm px-3" href="${pageContext.request.contextPath}/register">
                                    <i class="fa-solid fa-user-plus me-1"></i>Inscription
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </div>
</nav>
