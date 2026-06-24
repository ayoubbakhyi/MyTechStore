<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/navbar.jsp" />

<main class="mx-auto w-full max-w-[1180px] px-4 py-8 md:py-12" id="main-content">
    <section>
        <span class="inline-flex rounded-full border border-cyanx/40 bg-cyanx/10 px-3 py-1 text-xs font-black uppercase tracking-wide text-cyanx">Cart</span>
        <h1 class="mt-4 text-4xl font-black text-white md:text-5xl">Votre panier</h1>
        <p class="mt-3 max-w-2xl text-slate-400">Review quantities, remove products, and continue to checkout.</p>
    </section>

    <c:if test="${not empty param.error}">
        <div class="mt-6 rounded-lg border border-red-400/30 bg-red-400/10 px-4 py-3 text-red-200"><strong>Erreur :</strong> ${param.error}</div>
    </c:if>

    <c:choose>
        <c:when test="${empty panier.items}">
            <div class="mt-8 rounded-lg border border-line bg-panel/80 p-10 text-center">
                <h2 class="text-2xl font-black text-white">Your cart is empty</h2>
                <p class="mt-2 text-slate-400">Build your next setup from the catalogue.</p>
                <a class="mt-5 inline-flex min-h-11 items-center rounded-md bg-gradient-to-r from-cyanx to-greenx px-5 font-black text-ink" href="${ctx}/catalogue">Continue shopping</a>
            </div>
        </c:when>
        <c:otherwise>
            <c:set var="totalItems" value="0" />
            <c:forEach var="item" items="${panier.items}">
                <c:set var="totalItems" value="${totalItems + item.quantite}" />
            </c:forEach>

            <div class="mt-8 grid gap-6 lg:grid-cols-[1fr_360px]">
                <section class="grid gap-4" aria-label="Articles du panier">
                    <c:forEach var="item" items="${panier.items}">
                        <article class="grid gap-4 rounded-lg border border-line bg-panel/75 p-4 md:grid-cols-[90px_1fr_auto] md:items-center">
                            <a class="grid h-20 w-24 place-items-center overflow-hidden rounded-md bg-slate-900" href="${ctx}/produit?id=${item.produit.id}" aria-label="Voir ${item.produit.nom}">
                                <c:if test="${not empty item.produit.image}">
                                    <img class="h-full w-full object-cover" src="${ctx}/static/images/${item.produit.image}" alt="${item.produit.nom}" onerror="this.style.display='none'; this.nextElementSibling.classList.remove('hidden');">
                                </c:if>
                                <div class="${not empty item.produit.image ? 'hidden' : ''} h-12 w-16 rounded border border-cyanx/40 bg-ink"></div>
                            </a>

                            <div>
                                <span class="text-xs font-black uppercase text-slate-400">${item.produit.marque}</span>
                                <h2 class="mt-1 text-lg font-black text-white"><a class="hover:text-cyanx" href="${ctx}/produit?id=${item.produit.id}">${item.produit.nom}</a></h2>
                                <div class="mt-2 flex flex-wrap items-center gap-2">
                                    <span class="font-black text-white"><fmt:formatNumber value="${item.produit.prixEffectif}" type="currency" currencySymbol="MAD " /></span>
                                    <c:if test="${item.produit.enPromotion}">
                                        <span class="text-sm text-slate-500 line-through"><fmt:formatNumber value="${item.produit.prix}" type="currency" currencySymbol="MAD " /></span>
                                    </c:if>
                                </div>
                                <span class="mt-2 inline-flex items-center gap-2 text-sm text-slate-300">
                                    <span class="h-2 w-2 rounded-full ${item.produit.stock <= 0 ? 'bg-red-400' : item.produit.stock < 10 ? 'bg-amberx' : 'bg-greenx'}"></span>
                                    Stock ${item.produit.stock}
                                </span>
                            </div>

                            <div class="grid gap-3 md:min-w-56">
                                <form class="grid grid-cols-[80px_1fr] gap-2" action="${ctx}/panier" method="post">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="productId" value="${item.produit.id}">
                                    <input class="min-h-10 rounded-md border border-line bg-ink/70 px-3 text-white outline-none focus:border-cyanx" type="number" name="quantity" value="${item.quantite}" min="1" max="${item.produit.stock}" aria-label="Quantite pour ${item.produit.nom}">
                                    <button class="min-h-10 rounded-md bg-gradient-to-r from-cyanx to-greenx px-3 text-sm font-black text-ink" type="submit">Update</button>
                                </form>
                                <strong class="text-white"><fmt:formatNumber value="${item.produit.prixEffectif * item.quantite}" type="currency" currencySymbol="MAD " /></strong>
                                <form action="${ctx}/panier" method="post">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="productId" value="${item.produit.id}">
                                    <button class="min-h-10 w-full rounded-md border border-red-400/40 bg-red-400/10 px-3 text-sm font-bold text-red-200 hover:bg-red-400/20" type="submit" onclick="return confirm('Retirer cet article ?');">Remove</button>
                                </form>
                            </div>
                        </article>
                    </c:forEach>
                </section>

                <aside class="h-fit rounded-lg border border-line bg-panel/85 p-5 shadow-glow lg:sticky lg:top-24" aria-labelledby="cart-summary-title">
                    <h2 class="text-2xl font-black text-white" id="cart-summary-title">Recapitulatif</h2>
                    <div class="mt-4 divide-y divide-line">
                        <div class="flex items-center justify-between py-3 text-slate-300"><span>Total articles</span><strong class="text-white">${totalItems}</strong></div>
                        <div class="flex items-center justify-between py-3 text-slate-300"><span>Livraison</span><strong class="text-white">Gratuite</strong></div>
                        <div class="flex items-center justify-between py-3 text-slate-300"><span>Total TTC</span><strong class="text-2xl font-black text-cyanx"><fmt:formatNumber value="${panier.total}" type="currency" currencySymbol="MAD " /></strong></div>
                    </div>

                    <div class="mt-5 grid gap-3">
                        <a class="inline-flex min-h-11 items-center justify-center rounded-md bg-gradient-to-r from-cyanx to-greenx px-5 font-black text-ink" href="${ctx}/commande">Checkout</a>
                        <a class="inline-flex min-h-11 items-center justify-center rounded-md border border-line bg-white/10 px-5 font-bold text-white hover:border-cyanx hover:text-cyanx" href="${ctx}/catalogue">Continue shopping</a>
                    </div>

                    <form class="mt-4" action="${ctx}/panier" method="post">
                        <input type="hidden" name="action" value="clear">
                        <button class="min-h-11 w-full rounded-md border border-red-400/40 bg-red-400/10 px-5 font-bold text-red-200 hover:bg-red-400/20" type="submit" onclick="return confirm('Vider votre panier ?');">Clear cart</button>
                    </form>
                </aside>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="../layout/footer.jsp" />
