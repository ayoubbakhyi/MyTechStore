<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/admin-sidebar.jsp" />

<main class="mx-auto w-full max-w-[1180px] px-4 pb-12">
    <section class="mb-6">
        <span class="inline-flex rounded-full border border-cyanx/40 bg-cyanx/10 px-3 py-1 text-xs font-black uppercase tracking-wide text-cyanx">Admin</span>
        <h1 class="mt-4 text-3xl font-black text-white md:text-5xl">Tableau de bord</h1>
        <p class="mt-2 text-slate-400">Vue globale sur les ventes, commandes, clients et stocks de MyTechStore.</p>
    </section>

    <section class="grid gap-4 md:grid-cols-2 xl:grid-cols-4" aria-label="Indicateurs admin">
        <article class="rounded-lg border border-line bg-panel/80 p-5 shadow-glow">
            <span class="text-sm font-bold text-slate-400">Revenu total</span>
            <strong class="mt-2 block text-2xl font-black text-cyanx"><fmt:formatNumber value="${revenue}" type="currency" currencySymbol="MAD " /></strong>
        </article>
        <article class="rounded-lg border border-line bg-panel/80 p-5">
            <span class="text-sm font-bold text-slate-400">Commandes</span>
            <strong class="mt-2 block text-2xl font-black text-white">${totalOrders}</strong>
        </article>
        <article class="rounded-lg border border-line bg-panel/80 p-5">
            <span class="text-sm font-bold text-slate-400">Produits</span>
            <strong class="mt-2 block text-2xl font-black text-white">${totalProducts}</strong>
        </article>
        <article class="rounded-lg border border-line bg-panel/80 p-5">
            <span class="text-sm font-bold text-slate-400">Clients</span>
            <strong class="mt-2 block text-2xl font-black text-white">${totalClients}</strong>
        </article>
    </section>

    <section class="mt-6 grid gap-6 xl:grid-cols-[1fr_360px]">
        <div class="rounded-lg border border-line bg-panel/80 p-5">
            <div class="mb-4 flex flex-col gap-2 md:flex-row md:items-end md:justify-between">
                <div>
                    <h2 class="text-2xl font-black text-white">Commandes recentes</h2>
                    <p class="text-sm text-slate-400">Les dernieres commandes creees par les clients.</p>
                </div>
                <a class="inline-flex min-h-10 items-center rounded-md border border-line bg-white/10 px-4 text-sm font-bold text-white hover:border-cyanx hover:text-cyanx" href="${ctx}/admin/commandes">Voir tout</a>
            </div>

            <c:choose>
                <c:when test="${empty recentOrders}">
                    <div class="rounded-lg border border-line bg-ink/50 p-6 text-slate-400">Aucune commande enregistree.</div>
                </c:when>
                <c:otherwise>
                    <div class="overflow-x-auto">
                        <table class="w-full min-w-[760px] text-left text-sm">
                            <thead class="border-b border-line text-xs uppercase text-slate-400">
                                <tr>
                                    <th class="px-3 py-3">Commande</th>
                                    <th class="px-3 py-3">Client</th>
                                    <th class="px-3 py-3">Date</th>
                                    <th class="px-3 py-3">Total</th>
                                    <th class="px-3 py-3">Statut</th>
                                    <th class="px-3 py-3 text-right">Action</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-line">
                                <c:forEach var="ord" items="${recentOrders}">
                                    <tr class="hover:bg-white/5">
                                        <td class="px-3 py-4 font-black text-white">#CMD-${ord.id}</td>
                                        <td class="px-3 py-4 text-slate-300">${ord.utilisateur.nom}</td>
                                        <td class="px-3 py-4 text-slate-400"><fmt:formatDate value="${ord.dateCommande}" pattern="dd/MM/yyyy HH:mm" /></td>
                                        <td class="px-3 py-4 font-black text-cyanx"><fmt:formatNumber value="${ord.total}" type="currency" currencySymbol="MAD " /></td>
                                        <td class="px-3 py-4">
                                            <span class="inline-flex rounded-full border border-cyanx/30 bg-cyanx/10 px-3 py-1 text-xs font-black text-cyanx">
                                                ${ord.statut == 'EN_ATTENTE' ? 'En attente' :
                                                  ord.statut == 'CONFIRMEE' ? 'Confirmee' :
                                                  ord.statut == 'EXPEDIEE' ? 'Expediee' :
                                                  ord.statut == 'LIVREE' ? 'Livree' : 'Annulee'}
                                            </span>
                                        </td>
                                        <td class="px-3 py-4 text-right">
                                            <a class="text-sm font-bold text-cyanx hover:text-white" href="${ctx}/admin/commandes?id=${ord.id}">Details</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <aside class="grid gap-6">
            <section class="rounded-lg border border-line bg-panel/80 p-5">
                <h2 class="text-xl font-black text-white">Alertes stock</h2>
                <c:choose>
                    <c:when test="${empty lowStockProducts}">
                        <p class="mt-3 text-slate-400">Tous les produits ont un stock suffisant.</p>
                    </c:when>
                    <c:otherwise>
                        <div class="mt-4 grid gap-3">
                            <c:forEach var="lp" items="${lowStockProducts}">
                                <div class="rounded-md border border-amberx/30 bg-amberx/10 p-3">
                                    <strong class="block text-white">${lp.nom}</strong>
                                    <span class="text-sm text-amber-200">${lp.marque} - Stock: ${lp.stock}</span>
                                </div>
                            </c:forEach>
                        </div>
                        <a class="mt-4 inline-flex min-h-10 items-center rounded-md bg-gradient-to-r from-cyanx to-greenx px-4 text-sm font-black text-ink" href="${ctx}/admin/produits">Gerer les produits</a>
                    </c:otherwise>
                </c:choose>
            </section>

            <c:if test="${not empty categoryStats}">
                <section class="rounded-lg border border-line bg-panel/80 p-5">
                    <h2 class="text-xl font-black text-white">Produits par categorie</h2>
                    <div class="mt-4 grid gap-4">
                        <c:forEach var="stat" items="${categoryStats}">
                            <div>
                                <div class="mb-1 flex items-center justify-between text-sm">
                                    <strong class="text-white">${stat.categorie}</strong>
                                    <span class="text-slate-400">${stat.count}</span>
                                </div>
                                <progress class="h-2 w-full accent-cyanx" value="${stat.count}" max="15"></progress>
                            </div>
                        </c:forEach>
                    </div>
                </section>
            </c:if>
        </aside>
    </section>
</main>

<jsp:include page="../layout/footer.jsp" />
