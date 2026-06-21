<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/admin-sidebar.jsp" />

<main class="mx-auto w-full max-w-[1180px] px-4 pb-12">
    <section class="mb-6 flex flex-col gap-4 md:flex-row md:items-end md:justify-between">
        <div>
            <span class="inline-flex rounded-full border border-cyanx/40 bg-cyanx/10 px-3 py-1 text-xs font-black uppercase tracking-wide text-cyanx">Catalogue</span>
            <h1 class="mt-4 text-3xl font-black text-white md:text-5xl">Gestion des produits</h1>
            <p class="mt-2 text-slate-400">Ajoutez, modifiez ou supprimez les articles du magasin.</p>
        </div>
        <a class="inline-flex min-h-11 items-center justify-center rounded-md bg-gradient-to-r from-cyanx to-greenx px-5 font-black text-ink shadow-glow" href="${ctx}/admin/produits?action=new">Ajouter un produit</a>
    </section>

    <section class="rounded-lg border border-line bg-panel/80 p-5">
        <div class="overflow-x-auto">
            <table class="w-full min-w-[980px] text-left text-sm">
                <thead class="border-b border-line text-xs uppercase text-slate-400">
                    <tr>
                        <th class="px-3 py-3">Image</th>
                        <th class="px-3 py-3">Nom</th>
                        <th class="px-3 py-3">Marque</th>
                        <th class="px-3 py-3">Categorie</th>
                        <th class="px-3 py-3">Prix</th>
                        <th class="px-3 py-3">Stock</th>
                        <th class="px-3 py-3">Promotion</th>
                        <th class="px-3 py-3 text-right">Actions</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-line">
                    <c:forEach var="p" items="${produits}">
                        <tr class="hover:bg-white/5">
                            <td class="px-3 py-4">
                                <div class="grid h-12 w-14 place-items-center overflow-hidden rounded-md bg-slate-900">
                                    <c:if test="${not empty p.image}">
                                        <img class="h-full w-full object-cover" src="${ctx}/static/images/${p.image}" alt="${p.nom}" onerror="this.style.display='none'; this.nextElementSibling.classList.remove('hidden');">
                                    </c:if>
                                    <div class="${not empty p.image ? 'hidden' : ''} h-7 w-9 rounded border border-cyanx/40 bg-ink"></div>
                                </div>
                            </td>
                            <td class="px-3 py-4 font-black text-white">${p.nom}</td>
                            <td class="px-3 py-4 text-slate-300">${p.marque}</td>
                            <td class="px-3 py-4 text-slate-300">
                                <c:choose>
                                    <c:when test="${p.categorie != null}">${p.categorie.nom}</c:when>
                                    <c:otherwise>Aucune</c:otherwise>
                                </c:choose>
                            </td>
                            <td class="px-3 py-4 font-black text-cyanx"><fmt:formatNumber value="${p.prix}" type="currency" currencySymbol="MAD " /></td>
                            <td class="px-3 py-4">
                                <c:choose>
                                    <c:when test="${p.stock >= 10}">
                                        <span class="inline-flex rounded-full bg-greenx/10 px-3 py-1 text-xs font-black text-greenx">${p.stock} OK</span>
                                    </c:when>
                                    <c:when test="${p.stock >= 5}">
                                        <span class="inline-flex rounded-full bg-amberx/10 px-3 py-1 text-xs font-black text-amber-200">${p.stock} Bas</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="inline-flex rounded-full bg-red-400/10 px-3 py-1 text-xs font-black text-red-200">${p.stock} Alerte</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="px-3 py-4 text-slate-300">
                                <c:choose>
                                    <c:when test="${p.enPromotion}">
                                        <strong class="text-cyanx">-${p.promotion.valeur}%</strong>
                                        <span class="text-slate-400"> ${p.promotion.nom}</span>
                                    </c:when>
                                    <c:otherwise>Aucune</c:otherwise>
                                </c:choose>
                            </td>
                            <td class="px-3 py-4">
                                <div class="flex justify-end gap-2">
                                    <a class="inline-flex min-h-9 items-center rounded-md border border-line bg-white/10 px-3 text-sm font-bold text-white hover:border-cyanx hover:text-cyanx" href="${ctx}/admin/produits?action=edit&id=${p.id}">Editer</a>
                                    <form action="${ctx}/admin/produits" method="post">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="${p.id}">
                                        <button class="min-h-9 rounded-md border border-red-400/40 bg-red-400/10 px-3 text-sm font-bold text-red-200 hover:bg-red-400/20" type="submit" onclick="return confirm('Supprimer ce produit ?');">Supprimer</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </section>
</main>

<jsp:include page="../layout/footer.jsp" />
