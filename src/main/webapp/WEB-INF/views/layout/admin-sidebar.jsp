<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="admin-sidebar d-flex flex-column p-0">
    <div class="px-4 py-3 d-flex align-items-center gap-2 border-bottom border-secondary mb-3">
        <i class="fa-solid fa-user-shield text-warning fs-4"></i>
        <h5 class="mb-0 text-white font-weight-bold">Back-Office</h5>
    </div>
    
    <div class="sidebar-heading">Principal</div>
    <ul class="nav flex-column mb-3">
        <li class="nav-item">
            <a class="nav-link ${requestScope['javax.servlet.forward.servlet_path'] == '/admin' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin">
                <i class="fa-solid fa-chart-line"></i>Dashboard
            </a>
        </li>
    </ul>

    <div class="sidebar-heading">Gestion Stock</div>
    <ul class="nav flex-column mb-3">
        <li class="nav-item">
            <a class="nav-link ${requestScope['javax.servlet.forward.servlet_path'] == '/admin/produits' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/produits">
                <i class="fa-solid fa-laptop"></i>Produits
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${requestScope['javax.servlet.forward.servlet_path'] == '/admin/categories' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/categories">
                <i class="fa-solid fa-tags"></i>Catégories
            </a>
        </li>
    </ul>

    <div class="sidebar-heading">Commandes & Ventes</div>
    <ul class="nav flex-column mb-3">
        <li class="nav-item">
            <a class="nav-link ${requestScope['javax.servlet.forward.servlet_path'] == '/admin/commandes' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/commandes">
                <i class="fa-solid fa-receipt"></i>Commandes
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${requestScope['javax.servlet.forward.servlet_path'] == '/admin/livraisons' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/livraisons">
                <i class="fa-solid fa-truck-ramp-box"></i>Livraisons
            </a>
        </li>
    </ul>

    <div class="sidebar-heading">Marketing</div>
    <ul class="nav flex-column mb-3">
        <li class="nav-item">
            <a class="nav-link ${requestScope['javax.servlet.forward.servlet_path'] == '/admin/promotions' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/promotions">
                <i class="fa-solid fa-percent"></i>Promotions
            </a>
        </li>
    </ul>
    
    <div class="mt-auto p-3 border-top border-secondary">
        <a class="btn btn-outline-light btn-sm w-100" href="${pageContext.request.contextPath}/catalogue">
            <i class="fa-solid fa-eye me-2"></i>Voir le Store
        </a>
    </div>
</div>
