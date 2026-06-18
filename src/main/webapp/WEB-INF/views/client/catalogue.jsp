<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/navbar.jsp" />

<main class="mx-auto w-full max-w-[1180px] px-4 py-8 md:py-12" id="main-content">
    <section class="grid min-h-[420px] items-center gap-8 lg:grid-cols-[1.05fr_0.95fr]">
        <div>
            <span class="inline-flex rounded-full border border-cyanx/40 bg-cyanx/10 px-3 py-1 text-xs font-black uppercase tracking-wide text-cyanx">New gear available</span>
            <h1 class="mt-5 max-w-3xl text-4xl font-black leading-tight text-white md:text-6xl">
                Level up your <span class="text-cyanx">gaming setup</span>
            </h1>
            <p class="mt-5 max-w-2xl text-base leading-7 text-slate-400">
                Explore laptops, GPUs, CPUs, monitors and gaming peripherals with live stock,
                promotions and a checkout flow connected to your Java backend.
            </p>
            <div class="mt-7 flex flex-wrap gap-3">
                <a class="inline-flex min-h-11 items-center rounded-md bg-gradient-to-r from-cyanx to-greenx px-5 py-3 font-black text-ink shadow-glow hover:brightness-110" href="#products">Shop now</a>
                <a class="inline-flex min-h-11 items-center rounded-md border border-line bg-white/10 px-5 py-3 font-bold text-white hover:border-cyanx hover:text-cyanx" href="#filters">View catalogue</a>
            </div>
            <div class="mt-8 grid gap-4 sm:grid-cols-3">
                <div><strong class="block text-2xl font-black text-cyanx">50K+</strong><span class="text-sm text-slate-400">Happy customers</span></div>
                <div><strong class="block text-2xl font-black text-cyanx">2K+</strong><span class="text-sm text-slate-400">Products ready</span></div>
                <div><strong class="block text-2xl font-black text-cyanx">4.9</strong><span class="text-sm text-slate-400">Average rating</span></div>
            </div>
        </div>

        <div class="relative min-h-[330px] overflow-hidden rounded-lg border border-line bg-gradient-to-br from-panel via-slate-900 to-ink p-6 shadow-glow">
            <div class="absolute right-8 top-8 h-40 w-64 rounded-md border border-cyanx/30 bg-slate-950/80 shadow-2xl"></div>
            <div class="absolute bottom-16 left-10 h-20 w-[70%] rounded-md border border-greenx/30 bg-slate-950/90"></div>
            <div class="absolute bottom-7 left-7 right-7 rounded-lg border border-line bg-ink/80 p-4">
                <small class="text-xs font-black uppercase text-cyanx">Featured build</small>
                <strong class="mt-1 block text-white">Ultimate Gaming Rig 2026</strong>
            </div>
        </div>
    </section>

    <c:if test="${not empty param.success}">
        <div class="mt-6 rounded-lg border border-greenx/30 bg-greenx/10 px-4 py-3 text-greenx"><strong>Succes :</strong> ${param.success}</div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="mt-6 rounded-lg border border-red-400/30 bg-red-400/10 px-4 py-3 text-red-200"><strong>Erreur :</strong> ${param.error}</div>
    </c:if>

    <section class="mt-8 grid gap-4 lg:grid-cols-[1fr_auto]" id="filters" aria-label="Filtres catalogue">
        <div class="rounded-lg border border-line bg-panel/80 p-4">
            <form class="grid gap-3 md:grid-cols-[1fr_auto_auto]" action="${ctx}/catalogue" method="get">
                <c:if test="${selectedCat != null}">
                    <input type="hidden" name="category" value="${selectedCat}">
                </c:if>
                <input class="min-h-11 rounded-md border border-line bg-ink/70 px-4 text-white outline-none placeholder:text-slate-500 focus:border-cyanx focus:ring-2 focus:ring-cyanx/20" type="search" name="search" value="${searchVal}" placeholder="Search GPUs, laptops, accessories...">
                <button class="min-h-11 rounded-md bg-gradient-to-r from-cyanx to-greenx px-5 font-black text-ink hover:brightness-110" type="submit">Search</button>
                <c:if test="${not empty searchVal || selectedCat != null}">
                    <a class="inline-flex min-h-11 items-center justify-center rounded-md border border-line bg-white/10 px-5 font-bold text-white hover:border-cyanx hover:text-cyanx" href="${ctx}/catalogue">Reset</a>
                </c:if>
            </form>
        </div>

        <div class="flex flex-wrap gap-2 rounded-lg border border-line bg-panel/80 p-4">
            <c:url var="allCategoriesUrl" value="/catalogue">
                <c:if test="${not empty searchVal}">
                    <c:param name="search" value="${searchVal}" />
                </c:if>
            </c:url>
            <a class="inline-flex min-h-9 items-center rounded-full border px-3 text-sm font-bold ${selectedCat == null ? 'border-cyanx bg-cyanx text-ink' : 'border-line bg-white/5 text-slate-300 hover:border-cyanx hover:text-cyanx'}" href="${allCategoriesUrl}">All</a>
            <c:forEach var="cat" items="${categories}">
                <c:url var="categoryUrl" value="/catalogue">
                    <c:param name="category" value="${cat.id}" />
                    <c:if test="${not empty searchVal}">
                        <c:param name="search" value="${searchVal}" />
                    </c:if>
                </c:url>
                <a class="inline-flex min-h-9 items-center rounded-full border px-3 text-sm font-bold ${selectedCat == cat.id ? 'border-cyanx bg-cyanx text-ink' : 'border-line bg-white/5 text-slate-300 hover:border-cyanx hover:text-cyanx'}" href="${categoryUrl}">${cat.nom}</a>
            </c:forEach>
        </div>
    </section>

    <section class="mt-10" id="products" aria-labelledby="products-title">
        <div class="mb-5 flex flex-col gap-2 md:flex-row md:items-end md:justify-between">
            <div>
                <h2 class="text-2xl font-black text-white" id="products-title">Catalogue produits</h2>
                <p class="text-slate-400">Prices, stock and promotions are rendered from the backend.</p>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty produits}">
                <div class="rounded-lg border border-line bg-panel/80 p-10 text-center">
                    <h2 class="text-2xl font-black text-white">No products found</h2>
                    <p class="mt-2 text-slate-400">Try another keyword or clear the category filter.</p>
                    <a class="mt-5 inline-flex min-h-11 items-center rounded-md bg-gradient-to-r from-cyanx to-greenx px-5 font-black text-ink" href="${ctx}/catalogue">Show all products</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="grid gap-5 md:grid-cols-2 xl:grid-cols-3">
                    <c:forEach var="p" items="${produits}">
                        <article class="overflow-hidden rounded-lg border border-line bg-panel/70 transition hover:-translate-y-1 hover:border-cyanx/60">
                            <a class="grid h-48 place-items-center bg-gradient-to-br from-slate-900 to-ink" href="${ctx}/produit?id=${p.id}" aria-label="Voir ${p.nom}">
                                <c:if test="${not empty p.image}">
                                    <img class="h-48 w-full object-cover" src="${ctx}/static/images/${p.image}" alt="${p.nom}" onerror="this.style.display='none'; this.nextElementSibling.classList.remove('hidden');">
                                </c:if>
                                <div class="${not empty p.image ? 'hidden' : ''} h-28 w-44 rounded-lg border border-cyanx/40 bg-ink p-4 shadow-glow">
                                    <div class="h-3 rounded-full bg-gradient-to-r from-cyanx via-greenx to-amberx"></div>
                                    <div class="mt-5 h-12 rounded border border-line bg-slate-900"></div>
                                </div>
                            </a>
                            <div class="p-5">
                                <div class="text-xs font-black uppercase tracking-wide text-slate-400">
                                    <c:out value="${p.marque}" />
                                    <c:if test="${p.categorie != null}"> / <c:out value="${p.categorie.nom}" /></c:if>
                                </div>
                                <h3 class="mt-2 min-h-14 text-lg font-black leading-tight text-white">
                                    <a class="hover:text-cyanx" href="${ctx}/produit?id=${p.id}">${p.nom}</a>
                                </h3>
                                <p class="mt-2 min-h-16 text-sm leading-6 text-slate-400">
                                    <c:choose>
                                        <c:when test="${not empty p.description}">${p.description}</c:when>
                                        <c:otherwise>Performance hardware selected for serious gaming builds.</c:otherwise>
                                    </c:choose>
                                </p>

                                <div class="mt-4 flex flex-wrap items-center gap-2">
                                    <c:choose>
                                        <c:when test="${p.enPromotion}">
                                            <span class="text-xl font-black text-white"><fmt:formatNumber value="${p.prixEffectif}" type="currency" currencySymbol="EUR " /></span>
                                            <span class="text-sm text-slate-500 line-through"><fmt:formatNumber value="${p.prix}" type="currency" currencySymbol="EUR " /></span>
                                            <span class="rounded-full bg-cyanx/10 px-2 py-1 text-xs font-black uppercase text-cyanx">Promo</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-xl font-black text-white"><fmt:formatNumber value="${p.prix}" type="currency" currencySymbol="EUR " /></span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <c:choose>
                                    <c:when test="${p.stock >= 10}">
                                        <span class="mt-3 inline-flex items-center gap-2 text-sm text-slate-300"><span class="h-2 w-2 rounded-full bg-greenx"></span>In stock (${p.stock})</span>
                                    </c:when>
                                    <c:when test="${p.stock > 0}">
                                        <span class="mt-3 inline-flex items-center gap-2 text-sm text-slate-300"><span class="h-2 w-2 rounded-full bg-amberx"></span>Low stock (${p.stock})</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="mt-3 inline-flex items-center gap-2 text-sm text-slate-300"><span class="h-2 w-2 rounded-full bg-red-400"></span>Out of stock</span>
                                    </c:otherwise>
                                </c:choose>

                                <form class="mt-5 flex flex-wrap gap-2" action="${ctx}/panier" method="post">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="productId" value="${p.id}">
                                    <a class="inline-flex min-h-10 items-center rounded-md border border-line bg-white/10 px-4 text-sm font-bold text-white hover:border-cyanx hover:text-cyanx" href="${ctx}/produit?id=${p.id}">Details</a>
                                    <button class="min-h-10 rounded-md bg-gradient-to-r from-cyanx to-greenx px-4 text-sm font-black text-ink hover:brightness-110 disabled:cursor-not-allowed disabled:opacity-50" type="submit" ${p.stock <= 0 ? 'disabled' : ''}>Add to cart</button>
                                </form>
                            </div>
                        </article>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>

<jsp:include page="../layout/footer.jsp" />
