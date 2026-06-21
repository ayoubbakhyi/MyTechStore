<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/admin-sidebar.jsp" />

<main class="mx-auto w-full max-w-[1180px] px-4 pb-12">
    <section class="mb-6">
        <span class="inline-flex rounded-full border border-cyanx/40 bg-cyanx/10 px-3 py-1 text-xs font-black uppercase tracking-wide text-cyanx">Livraisons</span>
        <h1 class="mt-4 text-3xl font-black text-white md:text-5xl">Suivi des livraisons</h1>
        <p class="mt-2 text-slate-400">Mettez a jour les statuts de preparation, expedition et livraison.</p>
    </section>

    <c:if test="${not empty param.success}">
        <div class="mb-6 rounded-lg border border-greenx/30 bg-greenx/10 px-4 py-3 text-greenx">${param.success}</div>
    </c:if>

    <section class="rounded-lg border border-line bg-panel/80 p-5">
        <c:choose>
            <c:when test="${empty livraisons}">
                <div class="rounded-lg border border-line bg-ink/50 p-6 text-slate-400">Aucune expedition en cours.</div>
            </c:when>
            <c:otherwise>
                <div class="grid gap-4">
                    <c:forEach var="liv" items="${livraisons}">
                        <article class="rounded-lg border border-line bg-white/5 p-4">
                            <div class="grid gap-4 lg:grid-cols-[120px_1fr_180px_1.3fr] lg:items-start">
                                <div>
                                    <span class="text-xs font-black uppercase text-slate-400">Commande</span>
                                    <strong class="mt-1 block text-white">#CMD-${liv.idCommande}</strong>
                                </div>
                                <div>
                                    <span class="text-xs font-black uppercase text-slate-400">Adresse</span>
                                    <strong class="mt-1 block text-white">${liv.adresse}</strong>
                                    <span class="text-sm text-slate-400">${liv.codePostal} ${liv.ville}</span>
                                </div>
                                <div>
                                    <span class="text-xs font-black uppercase text-slate-400">Statut</span>
                                    <span class="mt-2 inline-flex rounded-full border border-cyanx/30 bg-cyanx/10 px-3 py-1 text-xs font-black text-cyanx">
                                        ${liv.statut == 'EN_PREPARATION' ? 'En preparation' :
                                          liv.statut == 'EXPEDIEE' ? 'Expediee' : 'Livree'}
                                    </span>
                                </div>
                                <div class="grid gap-3">
                                    <form class="flex flex-wrap gap-2" action="${ctx}/admin/livraisons" method="post">
                                        <input type="hidden" name="id" value="${liv.id}">
                                        <select name="statut" class="min-h-10 rounded-md border border-line bg-ink/70 px-3 text-sm text-white outline-none focus:border-cyanx" onchange="this.form.submit()">
                                            <option value="EN_PREPARATION" ${liv.statut == 'EN_PREPARATION' ? 'selected' : ''}>En preparation</option>
                                            <option value="EXPEDIEE" ${liv.statut == 'EXPEDIEE' ? 'selected' : ''}>Expediee</option>
                                            <option value="LIVREE" ${liv.statut == 'LIVREE' ? 'selected' : ''}>Livree</option>
                                        </select>
                                    </form>

                                    <form class="grid gap-3 rounded-md border border-line bg-ink/50 p-3 md:grid-cols-[1fr_1fr_auto]" action="${ctx}/admin/livraisons" method="post">
                                        <input type="hidden" name="id" value="${liv.id}">
                                        <div>
                                            <label class="mb-1 block text-xs font-bold uppercase text-slate-400">Date expedition</label>
                                            <input class="min-h-10 w-full rounded-md border border-line bg-ink/70 px-3 text-sm text-white outline-none focus:border-cyanx" type="date" name="dateExpedition" value="${liv.dateExpedition != null ? liv.dateExpedition : ''}" required>
                                        </div>
                                        <div>
                                            <label class="mb-1 block text-xs font-bold uppercase text-slate-400">Livraison prevue</label>
                                            <input class="min-h-10 w-full rounded-md border border-line bg-ink/70 px-3 text-sm text-white outline-none focus:border-cyanx" type="date" name="dateLivraisonPrevue" value="${liv.dateLivraisonPrevue != null ? liv.dateLivraisonPrevue : ''}" required>
                                        </div>
                                        <div class="flex items-end">
                                            <button class="min-h-10 w-full rounded-md bg-gradient-to-r from-cyanx to-greenx px-4 text-sm font-black text-ink" type="submit">Valider</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </article>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>

<jsp:include page="../layout/footer.jsp" />
