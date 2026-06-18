<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<header class="sticky top-0 z-40 border-b border-line/80 bg-ink/90 backdrop-blur">
    <nav class="mx-auto flex min-h-16 w-full max-w-[1180px] flex-wrap items-center gap-4 px-4 py-3" aria-label="Navigation principale">
        <a class="inline-flex items-center gap-3 font-black tracking-wide text-white" href="${ctx}/catalogue">
            <span class="grid h-9 w-9 place-items-center rounded-md bg-gradient-to-br from-cyanx to-greenx text-xs font-black text-ink shadow-glow">MTS</span>
            <span>MyTechStore</span>
        </a>

        <button class="ml-auto inline-flex rounded-md border border-line bg-panel px-3 py-2 text-sm font-bold text-slate-100 md:hidden" type="button" data-nav-toggle aria-expanded="false" aria-controls="main-navigation">
            Menu
        </button>

        <div class="hidden w-full flex-col gap-2 md:ml-auto md:flex md:w-auto md:flex-row md:items-center" id="main-navigation" data-nav-links>
            <a class="rounded-md px-3 py-2 text-sm font-bold text-slate-300 hover:bg-white/10 hover:text-white" href="${ctx}/catalogue">Catalogue</a>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <c:if test="${sessionScope.user.role == 'ADMIN'}">
                        <a class="rounded-md px-3 py-2 text-sm font-bold text-slate-300 hover:bg-white/10 hover:text-white" href="${ctx}/admin">Dashboard</a>
                        <a class="rounded-md px-3 py-2 text-sm font-bold text-slate-300 hover:bg-white/10 hover:text-white" href="${ctx}/admin/produits">Produits</a>
                    </c:if>
                    <c:if test="${sessionScope.user.role == 'CLIENT'}">
                        <a class="rounded-md px-3 py-2 text-sm font-bold text-slate-300 hover:bg-white/10 hover:text-white" href="${ctx}/panier">Panier</a>
                        <a class="rounded-md px-3 py-2 text-sm font-bold text-slate-300 hover:bg-white/10 hover:text-white" href="${ctx}/mes-commandes">Mes commandes</a>
                    </c:if>
                    <div class="flex flex-col gap-2 border-line pt-2 md:ml-2 md:flex-row md:items-center md:border-l md:pl-4 md:pt-0">
                        <span class="text-sm text-slate-300">Bonjour, <strong class="text-white">${sessionScope.user.nom}</strong></span>
                        <a class="inline-flex min-h-9 items-center justify-center rounded-md border border-line bg-white/10 px-3 py-2 text-sm font-bold text-white hover:border-cyanx hover:text-cyanx" href="${ctx}/logout">Deconnexion</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <a class="rounded-md px-3 py-2 text-sm font-bold text-slate-300 hover:bg-white/10 hover:text-white" href="${ctx}/login">Connexion</a>
                    <a class="inline-flex min-h-9 items-center justify-center rounded-md bg-gradient-to-r from-cyanx to-greenx px-3 py-2 text-sm font-black text-ink shadow-glow hover:brightness-110" href="${ctx}/register">Creer un compte</a>
                </c:otherwise>
            </c:choose>
        </div>
    </nav>
</header>
