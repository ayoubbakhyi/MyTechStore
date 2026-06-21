<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/admin-sidebar.jsp" />

<main class="mx-auto w-full max-w-[1180px] px-4 pb-12">
    <section class="mb-6 flex flex-col gap-4 md:flex-row md:items-end md:justify-between">
        <div>
            <span class="inline-flex rounded-full border border-cyanx/40 bg-cyanx/10 px-3 py-1 text-xs font-black uppercase tracking-wide text-cyanx">Promotion</span>
            <h1 class="mt-4 text-3xl font-black text-white md:text-5xl">${promotion != null ? 'Modifier' : 'Creer'} une promotion</h1>
            <p class="mt-2 text-slate-400">Remplissez les informations de l'offre commerciale.</p>
        </div>
        <a class="inline-flex min-h-11 items-center justify-center rounded-md border border-line bg-white/10 px-5 font-bold text-white hover:border-cyanx hover:text-cyanx" href="${ctx}/admin/promotions">Retour a la liste</a>
    </section>

    <form class="max-w-3xl rounded-lg border border-line bg-panel/80 p-6 shadow-glow" action="${ctx}/admin/promotions" method="post">
        <c:if test="${promotion != null}">
            <input type="hidden" name="id" value="${promotion.id}">
        </c:if>

        <div class="grid gap-5 md:grid-cols-2">
            <div class="md:col-span-2">
                <label class="mb-2 block text-sm font-bold text-slate-200" for="nom">Nom de la promotion</label>
                <input class="min-h-11 w-full rounded-md border border-line bg-ink/70 px-4 text-white outline-none placeholder:text-slate-500 focus:border-cyanx focus:ring-2 focus:ring-cyanx/20" type="text" id="nom" name="nom" value="${promotion.nom}" required placeholder="Ex: Soldes Ramadan">
            </div>
            <div>
                <label class="mb-2 block text-sm font-bold text-slate-200" for="type">Type de remise</label>
                <select class="min-h-11 w-full rounded-md border border-line bg-ink/70 px-4 text-white outline-none focus:border-cyanx focus:ring-2 focus:ring-cyanx/20" id="type" name="type">
                    <option value="POURCENTAGE" ${promotion == null || promotion.type == 'POURCENTAGE' ? 'selected' : ''}>Pourcentage (%)</option>
                    <option value="PRIX_FIXE" ${promotion != null && promotion.type == 'PRIX_FIXE' ? 'selected' : ''}>Montant fixe (MAD)</option>
                </select>
            </div>
            <div>
                <label class="mb-2 block text-sm font-bold text-slate-200" for="valeur">Valeur du rabais</label>
                <input class="min-h-11 w-full rounded-md border border-line bg-ink/70 px-4 text-white outline-none placeholder:text-slate-500 focus:border-cyanx focus:ring-2 focus:ring-cyanx/20" type="number" step="0.01" id="valeur" name="valeur" value="${promotion != null ? promotion.valeur : 0}" required min="0">
            </div>
            <div>
                <label class="mb-2 block text-sm font-bold text-slate-200" for="dateDebut">Date de debut</label>
                <input class="min-h-11 w-full rounded-md border border-line bg-ink/70 px-4 text-white outline-none focus:border-cyanx focus:ring-2 focus:ring-cyanx/20" type="date" id="dateDebut" name="dateDebut" value="${promotion.dateDebut}" required>
            </div>
            <div>
                <label class="mb-2 block text-sm font-bold text-slate-200" for="dateFin">Date de fin</label>
                <input class="min-h-11 w-full rounded-md border border-line bg-ink/70 px-4 text-white outline-none focus:border-cyanx focus:ring-2 focus:ring-cyanx/20" type="date" id="dateFin" name="dateFin" value="${promotion.dateFin}" required>
            </div>
            <div class="md:col-span-2">
                <label class="flex items-center gap-3 rounded-md border border-line bg-ink/60 p-4">
                    <input class="h-5 w-5 accent-cyanx" type="checkbox" id="actif" name="actif" value="true" ${promotion == null || promotion.actif ? 'checked' : ''}>
                    <span class="font-bold text-white">Rendre cette promotion active immediatement</span>
                </label>
            </div>
        </div>

        <div class="mt-6 flex flex-wrap justify-end gap-3 border-t border-line pt-5">
            <a class="inline-flex min-h-11 items-center rounded-md border border-line bg-white/10 px-5 font-bold text-white hover:border-cyanx hover:text-cyanx" href="${ctx}/admin/promotions">Annuler</a>
            <button class="min-h-11 rounded-md bg-gradient-to-r from-cyanx to-greenx px-5 font-black text-ink" type="submit">Enregistrer l'offre</button>
        </div>
    </form>
</main>

<jsp:include page="../layout/footer.jsp" />
