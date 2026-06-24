<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/navbar.jsp" />

<main class="mx-auto w-full max-w-[1180px] px-4 py-8 md:py-12" id="main-content">
    <nav class="mb-6 flex flex-wrap gap-2 text-sm text-slate-400" aria-label="Fil d'Ariane">
        <a class="text-cyanx hover:text-white" href="${ctx}/catalogue">Catalogue</a>
        <span>/</span>
        <c:if test="${produit.categorie != null}">
            <a class="text-cyanx hover:text-white" href="${ctx}/catalogue?category=${produit.idCategorie}">${produit.categorie.nom}</a>
            <span>/</span>
        </c:if>
        <span>${produit.nom}</span>
    </nav>

    <c:if test="${not empty param.success}">
        <div class="mb-6 rounded-lg border border-greenx/30 bg-greenx/10 px-4 py-3 text-greenx"><strong>Succes :</strong> ${param.success}</div>
    </c:if>

    <section class="grid gap-8 lg:grid-cols-[0.9fr_1.1fr]">
        <div class="grid min-h-[420px] place-items-center overflow-hidden rounded-lg border border-line bg-gradient-to-br from-slate-900 to-ink shadow-glow">
            <c:if test="${not empty produit.image}">
                <img class="h-[420px] w-full object-cover" src="${ctx}/static/images/${produit.image}" alt="${produit.nom}" onerror="this.style.display='none'; this.nextElementSibling.classList.remove('hidden');">
            </c:if>
            <div class="${not empty produit.image ? 'hidden' : ''} h-40 w-72 rounded-lg border border-cyanx/40 bg-ink p-6 shadow-glow">
                <div class="h-4 rounded-full bg-gradient-to-r from-cyanx via-greenx to-amberx"></div>
                <div class="mt-8 h-20 rounded border border-line bg-slate-900"></div>
            </div>
        </div>

        <div class="rounded-lg border border-line bg-panel/80 p-6">
            <span class="text-xs font-black uppercase tracking-wide text-slate-400">
                <c:out value="${produit.marque}" />
                <c:if test="${produit.categorie != null}"> / <c:out value="${produit.categorie.nom}" /></c:if>
            </span>
            <h1 class="mt-3 text-3xl font-black leading-tight text-white md:text-5xl">${produit.nom}</h1>

            <div class="mt-5 flex flex-wrap items-center gap-3">
                <c:choose>
                    <c:when test="${produit.enPromotion}">
                        <span class="text-3xl font-black text-white"><fmt:formatNumber value="${produit.prixEffectif}" type="currency" currencySymbol="MAD " /></span>
                        <span class="text-lg text-slate-500 line-through"><fmt:formatNumber value="${produit.prix}" type="currency" currencySymbol="MAD " /></span>
                        <span class="rounded-full border border-cyanx/40 bg-cyanx/10 px-3 py-1 text-xs font-black uppercase text-cyanx">Promo active</span>
                    </c:when>
                    <c:otherwise>
                        <span class="text-3xl font-black text-white"><fmt:formatNumber value="${produit.prix}" type="currency" currencySymbol="MAD " /></span>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="mt-7">
                <h2 class="text-lg font-black text-white">Description</h2>
                <p class="mt-2 leading-7 text-slate-400">
                    <c:choose>
                        <c:when test="${not empty produit.description}">${produit.description}</c:when>
                        <c:otherwise>Aucune description disponible pour ce produit.</c:otherwise>
                    </c:choose>
                </p>
            </div>

            <div class="mt-7">
                <h2 class="text-lg font-black text-white">Disponibilite</h2>
                <c:choose>
                    <c:when test="${produit.stock >= 10}">
                        <span class="mt-2 inline-flex items-center gap-2 text-slate-300"><span class="h-2 w-2 rounded-full bg-greenx"></span>In stock (${produit.stock} restants)</span>
                    </c:when>
                    <c:when test="${produit.stock > 0}">
                        <span class="mt-2 inline-flex items-center gap-2 text-slate-300"><span class="h-2 w-2 rounded-full bg-amberx"></span>Stock limite (${produit.stock} restants)</span>
                    </c:when>
                    <c:otherwise>
                        <span class="mt-2 inline-flex items-center gap-2 text-slate-300"><span class="h-2 w-2 rounded-full bg-red-400"></span>Rupture de stock</span>
                    </c:otherwise>
                </c:choose>
            </div>

            <c:choose>
                <c:when test="${produit.stock > 0}">
                    <form class="mt-8 flex flex-wrap items-end gap-3" action="${ctx}/panier" method="post">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="productId" value="${produit.id}">
                        <input type="hidden" name="redirect" value="produit">
                        <div>
                            <label class="mb-2 block text-sm font-bold text-slate-200" for="quantity">Quantity</label>
                            <input class="min-h-11 w-28 rounded-md border border-line bg-ink/70 px-3 text-white outline-none focus:border-cyanx focus:ring-2 focus:ring-cyanx/20" type="number" id="quantity" name="quantity" value="1" min="1" max="${produit.stock}">
                        </div>
                        <button class="min-h-11 rounded-md bg-gradient-to-r from-cyanx to-greenx px-5 font-black text-ink hover:brightness-110" type="submit">Add to cart</button>
                        <a class="inline-flex min-h-11 items-center rounded-md border border-line bg-white/10 px-5 font-bold text-white hover:border-cyanx hover:text-cyanx" href="${ctx}/catalogue">Continue shopping</a>
                    </form>
                </c:when>
                <c:otherwise>
                    <div class="mt-8 flex flex-wrap gap-3">
                        <button class="min-h-11 cursor-not-allowed rounded-md bg-slate-700 px-5 font-black text-slate-400" type="button" disabled>Indisponible</button>
                        <a class="inline-flex min-h-11 items-center rounded-md border border-line bg-white/10 px-5 font-bold text-white hover:border-cyanx hover:text-cyanx" href="${ctx}/catalogue">Back to catalogue</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <c:if test="${not empty relatedProduits}">
        <section class="mt-12" aria-labelledby="related-title">
            <div class="mb-5">
                <h2 class="text-2xl font-black text-white" id="related-title">Produits similaires</h2>
                <p class="text-slate-400">More hardware from the same category.</p>
            </div>
            <div class="grid gap-5 md:grid-cols-2 xl:grid-cols-4">
                <c:forEach var="rp" items="${relatedProduits}">
                    <article class="overflow-hidden rounded-lg border border-line bg-panel/70">
                        <a class="grid h-40 place-items-center bg-gradient-to-br from-slate-900 to-ink" href="${ctx}/produit?id=${rp.id}">
                            <c:if test="${not empty rp.image}">
                                <img class="h-40 w-full object-cover" src="${ctx}/static/images/${rp.image}" alt="${rp.nom}" onerror="this.style.display='none'; this.nextElementSibling.classList.remove('hidden');">
                            </c:if>
                            <div class="${not empty rp.image ? 'hidden' : ''} h-24 w-36 rounded-lg border border-cyanx/40 bg-ink p-4">
                                <div class="h-2 rounded-full bg-gradient-to-r from-cyanx to-greenx"></div>
                                <div class="mt-4 h-10 rounded border border-line bg-slate-900"></div>
                            </div>
                        </a>
                        <div class="p-4">
                            <div class="text-xs font-black uppercase text-slate-400">${rp.marque}</div>
                            <h3 class="mt-2 font-black text-white"><a class="hover:text-cyanx" href="${ctx}/produit?id=${rp.id}">${rp.nom}</a></h3>
                            <div class="mt-3 text-lg font-black text-white"><fmt:formatNumber value="${rp.prixEffectif}" type="currency" currencySymbol="MAD " /></div>
                            <a class="mt-4 inline-flex min-h-9 items-center rounded-md border border-line bg-white/10 px-3 text-sm font-bold text-white hover:border-cyanx hover:text-cyanx" href="${ctx}/produit?id=${rp.id}">View details</a>
                        </div>
                    </article>
                </c:forEach>
            </div>
        </section>
    </c:if>
</main>

<jsp:include page="../layout/footer.jsp" />
