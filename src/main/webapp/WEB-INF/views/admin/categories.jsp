<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/admin-sidebar.jsp" />

<main class="mx-auto w-full max-w-[1180px] px-4 pb-12">
    <section class="mb-6">
        <span class="inline-flex rounded-full border border-cyanx/40 bg-cyanx/10 px-3 py-1 text-xs font-black uppercase tracking-wide text-cyanx">Categories</span>
        <h1 class="mt-4 text-3xl font-black text-white md:text-5xl">Gestion des categories</h1>
        <p class="mt-2 text-slate-400">Creez ou supprimez les familles de produits du catalogue.</p>
    </section>

    <div class="grid gap-6 lg:grid-cols-[360px_1fr]">
        <section class="h-fit rounded-lg border border-line bg-panel/80 p-5 shadow-glow">
            <h2 class="text-2xl font-black text-white">Ajouter une categorie</h2>
            <form class="mt-5 grid gap-4" action="${ctx}/admin/categories" method="post">
                <input type="hidden" name="action" value="add">
                <div>
                    <label class="mb-2 block text-sm font-bold text-slate-200" for="nom">Nom de la categorie</label>
                    <input class="min-h-11 w-full rounded-md border border-line bg-ink/70 px-4 text-white outline-none placeholder:text-slate-500 focus:border-cyanx focus:ring-2 focus:ring-cyanx/20" type="text" id="nom" name="nom" required placeholder="Ex: Claviers Gamer">
                </div>
                <button class="min-h-11 rounded-md bg-gradient-to-r from-cyanx to-greenx px-5 font-black text-ink" type="submit">Creer la categorie</button>
            </form>
        </section>

        <section class="rounded-lg border border-line bg-panel/80 p-5">
            <h2 class="text-2xl font-black text-white">Categories enregistrees</h2>
            <c:choose>
                <c:when test="${empty categories}">
                    <div class="mt-5 rounded-lg border border-line bg-ink/50 p-6 text-slate-400">Aucune categorie enregistree.</div>
                </c:when>
                <c:otherwise>
                    <div class="mt-5 overflow-x-auto">
                        <table class="w-full min-w-[520px] text-left text-sm">
                            <thead class="border-b border-line text-xs uppercase text-slate-400">
                                <tr>
                                    <th class="px-3 py-3">ID</th>
                                    <th class="px-3 py-3">Nom</th>
                                    <th class="px-3 py-3 text-right">Action</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-line">
                                <c:forEach var="cat" items="${categories}">
                                    <tr class="hover:bg-white/5">
                                        <td class="px-3 py-4 font-black text-white">#CAT-${cat.id}</td>
                                        <td class="px-3 py-4 text-slate-300">${cat.nom}</td>
                                        <td class="px-3 py-4">
                                            <form class="flex justify-end" action="${ctx}/admin/categories" method="post">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="${cat.id}">
                                                <button class="min-h-9 rounded-md border border-red-400/40 bg-red-400/10 px-3 text-sm font-bold text-red-200 hover:bg-red-400/20" type="submit" onclick="return confirm('Supprimer cette categorie ?');">Supprimer</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </div>
</main>

<jsp:include page="../layout/footer.jsp" />
