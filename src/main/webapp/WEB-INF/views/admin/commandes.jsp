<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/admin-sidebar.jsp" />

<main class="mx-auto w-full max-w-[1180px] px-4 pb-12">
    <section class="mb-6">
        <span class="inline-flex rounded-full border border-cyanx/40 bg-cyanx/10 px-3 py-1 text-xs font-black uppercase tracking-wide text-cyanx">Commandes</span>
        <h1 class="mt-4 text-3xl font-black text-white md:text-5xl">Gestion des commandes</h1>
        <p class="mt-2 text-slate-400">Validez les commandes, expediez les colis et modifiez les statuts.</p>
    </section>

    <section class="rounded-lg border border-line bg-panel/80 p-5">
        <c:choose>
            <c:when test="${empty commandes}">
                <div class="rounded-lg border border-line bg-ink/50 p-6 text-slate-400">Aucune commande enregistree dans le systeme.</div>
            </c:when>
            <c:otherwise>
                <div class="overflow-x-auto">
                    <table class="w-full min-w-[980px] text-left text-sm">
                        <thead class="border-b border-line text-xs uppercase text-slate-400">
                            <tr>
                                <th class="px-3 py-3">Commande</th>
                                <th class="px-3 py-3">Client</th>
                                <th class="px-3 py-3">Date</th>
                                <th class="px-3 py-3">Montant</th>
                                <th class="px-3 py-3">Statut</th>
                                <th class="px-3 py-3 text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-line">
                            <c:forEach var="c" items="${commandes}">
                                <tr class="hover:bg-white/5">
                                    <td class="px-3 py-4 font-black text-white">#CMD-${c.id}</td>
                                    <td class="px-3 py-4">
                                        <strong class="block text-white">${c.utilisateur.nom}</strong>
                                        <span class="text-slate-400">${c.utilisateur.email}</span>
                                    </td>
                                    <td class="px-3 py-4 text-slate-400"><fmt:formatDate value="${c.dateCommande}" pattern="dd/MM/yyyy HH:mm" /></td>
                                    <td class="px-3 py-4 font-black text-cyanx"><fmt:formatNumber value="${c.total}" type="currency" currencySymbol="MAD " /></td>
                                    <td class="px-3 py-4">
                                        <span class="inline-flex rounded-full border border-cyanx/30 bg-cyanx/10 px-3 py-1 text-xs font-black text-cyanx">
                                            ${c.statut == 'EN_ATTENTE' ? 'En attente' :
                                              c.statut == 'CONFIRMEE' ? 'Confirmee' :
                                              c.statut == 'EXPEDIEE' ? 'Expediee' :
                                              c.statut == 'LIVREE' ? 'Livree' : 'Annulee'}
                                        </span>
                                    </td>
                                    <td class="px-3 py-4">
                                        <div class="flex flex-wrap justify-end gap-2">
                                            <a class="inline-flex min-h-9 items-center rounded-md border border-line bg-white/10 px-3 text-sm font-bold text-white hover:border-cyanx hover:text-cyanx" href="${ctx}/admin/commandes?id=${c.id}">Gerer</a>
                                            <form action="${ctx}/admin/commandes" method="post">
                                                <input type="hidden" name="id" value="${c.id}">
                                                <select name="statut" class="min-h-9 rounded-md border border-line bg-ink/70 px-3 text-sm text-white outline-none focus:border-cyanx" onchange="this.form.submit()">
                                                    <option value="EN_ATTENTE" ${c.statut == 'EN_ATTENTE' ? 'selected' : ''}>En attente</option>
                                                    <option value="CONFIRMEE" ${c.statut == 'CONFIRMEE' ? 'selected' : ''}>Confirmee</option>
                                                    <option value="EXPEDIEE" ${c.statut == 'EXPEDIEE' ? 'selected' : ''}>Expediee</option>
                                                    <option value="LIVREE" ${c.statut == 'LIVREE' ? 'selected' : ''}>Livree</option>
                                                    <option value="ANNULEE" ${c.statut == 'ANNULEE' ? 'selected' : ''}>Annulee</option>
                                                </select>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>

<jsp:include page="../layout/footer.jsp" />
