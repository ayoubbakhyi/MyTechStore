<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/admin-sidebar.jsp" />

<main class="mx-auto w-full max-w-[1180px] px-4 pb-12">
    <section class="mb-6 flex flex-col gap-4 md:flex-row md:items-end md:justify-between">
        <div>
            <span class="inline-flex rounded-full border border-cyanx/40 bg-cyanx/10 px-3 py-1 text-xs font-black uppercase tracking-wide text-cyanx">Commande</span>
            <h1 class="mt-4 text-3xl font-black text-white md:text-5xl">Commande #CMD-${commande.id}</h1>
            <p class="mt-2 text-slate-400">Gerez les details de facturation, statut et expedition.</p>
        </div>
        <a class="inline-flex min-h-11 items-center justify-center rounded-md border border-line bg-white/10 px-5 font-bold text-white hover:border-cyanx hover:text-cyanx" href="${ctx}/admin/commandes">Retour a la liste</a>
    </section>

    <c:if test="${not empty param.success}">
        <div class="mb-6 rounded-lg border border-greenx/30 bg-greenx/10 px-4 py-3 text-greenx">${param.success}</div>
    </c:if>

    <div class="grid gap-6 lg:grid-cols-[1fr_360px]">
        <section class="rounded-lg border border-line bg-panel/80 p-5">
            <h2 class="mb-4 text-2xl font-black text-white">Designations de commande</h2>
            <div class="overflow-x-auto">
                <table class="w-full min-w-[760px] text-left text-sm">
                    <thead class="border-b border-line text-xs uppercase text-slate-400">
                        <tr>
                            <th class="px-3 py-3">Produit</th>
                            <th class="px-3 py-3">Description</th>
                            <th class="px-3 py-3">Prix unitaire</th>
                            <th class="px-3 py-3">Quantite</th>
                            <th class="px-3 py-3 text-right">Total</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-line">
                        <c:forEach var="line" items="${commande.lignes}">
                            <tr class="hover:bg-white/5">
                                <td class="px-3 py-4">
                                    <div class="grid h-12 w-16 place-items-center overflow-hidden rounded-md bg-slate-900">
                                        <c:if test="${not empty line.produit.image}">
                                            <img class="h-full w-full object-cover" src="${ctx}/static/images/${line.produit.image}" alt="${line.produit.nom}" onerror="this.style.display='none'; this.nextElementSibling.classList.remove('hidden');">
                                        </c:if>
                                        <div class="${not empty line.produit.image ? 'hidden' : ''} h-7 w-10 rounded border border-cyanx/40 bg-ink"></div>
                                    </div>
                                </td>
                                <td class="px-3 py-4">
                                    <strong class="block text-white">${line.produit.nom}</strong>
                                    <span class="text-slate-400">Marque: ${line.produit.marque}</span>
                                </td>
                                <td class="px-3 py-4 text-slate-300"><fmt:formatNumber value="${line.prixUnitaire}" type="currency" currencySymbol="MAD " /></td>
                                <td class="px-3 py-4 text-slate-300">${line.quantite}</td>
                                <td class="px-3 py-4 text-right font-black text-cyanx"><fmt:formatNumber value="${line.prixUnitaire * line.quantite}" type="currency" currencySymbol="MAD " /></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <div class="mt-5 flex justify-end border-t border-line pt-4">
                <div class="text-right">
                    <span class="text-slate-400">Montant total TTC</span>
                    <strong class="block text-3xl font-black text-cyanx"><fmt:formatNumber value="${commande.total}" type="currency" currencySymbol="MAD " /></strong>
                </div>
            </div>
        </section>

        <aside class="grid gap-6">
            <section class="rounded-lg border border-line bg-panel/80 p-5">
                <h2 class="text-xl font-black text-white">Profil client</h2>
                <p class="mt-4 text-slate-300"><strong class="text-white">Nom:</strong> ${commande.utilisateur.nom}</p>
                <p class="mt-1 text-slate-300"><strong class="text-white">E-mail:</strong> ${commande.utilisateur.email}</p>
            </section>

            <section class="rounded-lg border border-line bg-panel/80 p-5">
                <h2 class="text-xl font-black text-white">Statut commande</h2>
                <form class="mt-4 grid gap-4" action="${ctx}/admin/commandes" method="post">
                    <input type="hidden" name="id" value="${commande.id}">
                    <div>
                        <label class="mb-2 block text-sm font-bold text-slate-200" for="statut">Changer le statut</label>
                        <select class="min-h-11 w-full rounded-md border border-line bg-ink/70 px-4 text-white outline-none focus:border-cyanx focus:ring-2 focus:ring-cyanx/20" id="statut" name="statut">
                            <option value="EN_ATTENTE" ${commande.statut == 'EN_ATTENTE' ? 'selected' : ''}>En attente</option>
                            <option value="CONFIRMEE" ${commande.statut == 'CONFIRMEE' ? 'selected' : ''}>Confirmee</option>
                            <option value="EXPEDIEE" ${commande.statut == 'EXPEDIEE' ? 'selected' : ''}>Expediee</option>
                            <option value="LIVREE" ${commande.statut == 'LIVREE' ? 'selected' : ''}>Livree</option>
                            <option value="ANNULEE" ${commande.statut == 'ANNULEE' ? 'selected' : ''}>Annulee</option>
                        </select>
                    </div>
                    <button class="min-h-11 rounded-md bg-gradient-to-r from-cyanx to-greenx px-5 font-black text-ink" type="submit">Mettre a jour</button>
                </form>
            </section>

            <c:if test="${commande.livraison != null}">
                <section class="rounded-lg border border-line bg-panel/80 p-5">
                    <h2 class="text-xl font-black text-white">Expedition & adresse</h2>
                    <p class="mt-4 text-slate-300">
                        <strong class="text-white">Statut livraison:</strong>
                        <span class="ml-2 inline-flex rounded-full border border-cyanx/30 bg-cyanx/10 px-3 py-1 text-xs font-black text-cyanx">
                            ${commande.livraison.statut == 'EN_PREPARATION' ? 'En preparation' :
                              commande.livraison.statut == 'EXPEDIEE' ? 'Expediee' : 'Livree'}
                        </span>
                    </p>
                    <p class="mt-3 text-slate-300"><strong class="text-white">Adresse:</strong> ${commande.livraison.adresse}</p>
                    <p class="mt-1 text-slate-300"><strong class="text-white">Ville:</strong> ${commande.livraison.codePostal} ${commande.livraison.ville}</p>
                </section>
            </c:if>
        </aside>
    </div>
</main>

<jsp:include page="../layout/footer.jsp" />
