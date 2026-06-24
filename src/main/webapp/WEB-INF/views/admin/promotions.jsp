<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/admin-sidebar.jsp" />

<main class="mx-auto w-full max-w-[1180px] px-4 pb-12">
    <section class="mb-6 flex flex-col gap-4 md:flex-row md:items-end md:justify-between">
        <div>
            <span class="inline-flex rounded-full border border-cyanx/40 bg-cyanx/10 px-3 py-1 text-xs font-black uppercase tracking-wide text-cyanx">Promotions</span>
            <h1 class="mt-4 text-3xl font-black text-white md:text-5xl">Gestion des promotions</h1>
            <p class="mt-2 text-slate-400">Creez des remises et fixez des periodes de validite.</p>
        </div>
        <a class="inline-flex min-h-11 items-center justify-center rounded-md bg-gradient-to-r from-cyanx to-greenx px-5 font-black text-ink shadow-glow" href="${ctx}/admin/promotions?action=new">Creer une promotion</a>
    </section>

    <section class="rounded-lg border border-line bg-panel/80 p-5">
        <c:choose>
            <c:when test="${empty promotions}">
                <div class="rounded-lg border border-line bg-ink/50 p-6 text-slate-400">Aucune offre promotionnelle enregistree.</div>
            </c:when>
            <c:otherwise>
                <div class="overflow-x-auto">
                    <table class="w-full min-w-[880px] text-left text-sm">
                        <thead class="border-b border-line text-xs uppercase text-slate-400">
                            <tr>
                                <th class="px-3 py-3">ID</th>
                                <th class="px-3 py-3">Offre</th>
                                <th class="px-3 py-3">Remise</th>
                                <th class="px-3 py-3">Debut</th>
                                <th class="px-3 py-3">Fin</th>
                                <th class="px-3 py-3">Etat</th>
                                <th class="px-3 py-3 text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-line">
                            <c:forEach var="p" items="${promotions}">
                                <tr class="hover:bg-white/5">
                                    <td class="px-3 py-4 font-black text-white">#PRM-${p.id}</td>
                                    <td class="px-3 py-4 font-black text-white">${p.nom}</td>
                                    <td class="px-3 py-4 font-black text-cyanx">
                                        <c:choose>
                                            <c:when test="${p.type == 'PRIX_FIXE'}">-<fmt:formatNumber value="${p.valeur}" type="currency" currencySymbol="MAD " /></c:when>
                                            <c:otherwise>-${p.valeur}%</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-3 py-4 text-slate-300">${p.dateDebut}</td>
                                    <td class="px-3 py-4 text-slate-300">${p.dateFin}</td>
                                    <td class="px-3 py-4">
                                        <c:choose>
                                            <c:when test="${p.actif}">
                                                <span class="inline-flex rounded-full bg-greenx/10 px-3 py-1 text-xs font-black text-greenx">Active</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="inline-flex rounded-full bg-slate-600/30 px-3 py-1 text-xs font-black text-slate-300">Inactive</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-3 py-4">
                                        <div class="flex justify-end gap-2">
                                            <a class="inline-flex min-h-9 items-center rounded-md border border-line bg-white/10 px-3 text-sm font-bold text-white hover:border-cyanx hover:text-cyanx" href="${ctx}/admin/promotions?action=edit&id=${p.id}">Editer</a>
                                            <form action="${ctx}/admin/promotions" method="post">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="${p.id}">
                                                <button class="min-h-9 rounded-md border border-red-400/40 bg-red-400/10 px-3 text-sm font-bold text-red-200 hover:bg-red-400/20" type="submit" onclick="return confirm('Supprimer cette promotion ?');">Supprimer</button>
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
