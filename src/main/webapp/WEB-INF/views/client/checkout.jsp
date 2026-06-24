<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/navbar.jsp" />

<main class="mx-auto w-full max-w-[1180px] px-4 py-8 md:py-12" id="main-content">
    <section>
        <span class="inline-flex rounded-full border border-cyanx/40 bg-cyanx/10 px-3 py-1 text-xs font-black uppercase tracking-wide text-cyanx">Checkout</span>
        <h1 class="mt-4 text-4xl font-black text-white md:text-5xl">Validation de commande</h1>
        <p class="mt-3 max-w-2xl text-slate-400">Delivery details are sent to the existing commande servlet.</p>
    </section>

    <c:if test="${not empty requestScope.error}">
        <div class="mt-6 rounded-lg border border-red-400/30 bg-red-400/10 px-4 py-3 text-red-200"><strong>Erreur :</strong> ${requestScope.error}</div>
    </c:if>

    <div class="mt-8 grid gap-6 lg:grid-cols-[1fr_360px]">
        <section class="rounded-lg border border-line bg-panel/80 p-6" aria-labelledby="delivery-title">
            <h2 class="text-2xl font-black text-white" id="delivery-title">Informations de livraison</h2>
            <form class="mt-5 grid gap-4 md:grid-cols-2" action="${ctx}/commande" method="post">
                <div>
                    <label class="mb-2 block text-sm font-bold text-slate-200" for="nom">Nom du destinataire</label>
                    <input class="min-h-11 w-full rounded-md border border-line bg-ink/70 px-4 text-white outline-none placeholder:text-slate-500 focus:border-cyanx focus:ring-2 focus:ring-cyanx/20" type="text" id="nom" name="nom" value="${sessionScope.user.nom}" autocomplete="name">
                </div>
                <div>
                    <label class="mb-2 block text-sm font-bold text-slate-200" for="telephone">Telephone</label>
                    <input class="min-h-11 w-full rounded-md border border-line bg-ink/70 px-4 text-white outline-none placeholder:text-slate-500 focus:border-cyanx focus:ring-2 focus:ring-cyanx/20" type="tel" id="telephone" name="telephone" placeholder="06 12 34 56 78" autocomplete="tel">
                </div>
                <div class="md:col-span-2">
                    <label class="mb-2 block text-sm font-bold text-slate-200" for="adresse">Adresse complete</label>
                    <textarea class="w-full rounded-md border border-line bg-ink/70 px-4 py-3 text-white outline-none placeholder:text-slate-500 focus:border-cyanx focus:ring-2 focus:ring-cyanx/20" id="adresse" name="adresse" rows="4" required placeholder="12 Rue des Claviers Gaming" autocomplete="street-address"></textarea>
                </div>
                <div>
                    <label class="mb-2 block text-sm font-bold text-slate-200" for="ville">Ville</label>
                    <input class="min-h-11 w-full rounded-md border border-line bg-ink/70 px-4 text-white outline-none placeholder:text-slate-500 focus:border-cyanx focus:ring-2 focus:ring-cyanx/20" type="text" id="ville" name="ville" required placeholder="Paris" autocomplete="address-level2">
                </div>
                <div>
                    <label class="mb-2 block text-sm font-bold text-slate-200" for="codePostal">Code postal</label>
                    <input class="min-h-11 w-full rounded-md border border-line bg-ink/70 px-4 text-white outline-none placeholder:text-slate-500 focus:border-cyanx focus:ring-2 focus:ring-cyanx/20" type="text" id="codePostal" name="codePostal" required placeholder="75000" autocomplete="postal-code">
                </div>
                <div class="flex flex-wrap gap-3 md:col-span-2">
                    <button class="min-h-11 rounded-md bg-gradient-to-r from-cyanx to-greenx px-5 font-black text-ink" type="submit">Confirm order</button>
                    <a class="inline-flex min-h-11 items-center rounded-md border border-line bg-white/10 px-5 font-bold text-white hover:border-cyanx hover:text-cyanx" href="${ctx}/panier">Back to cart</a>
                </div>
            </form>
        </section>

        <aside class="h-fit rounded-lg border border-line bg-panel/85 p-5 shadow-glow lg:sticky lg:top-24" aria-labelledby="order-summary-title">
            <h2 class="text-2xl font-black text-white" id="order-summary-title">Resume de commande</h2>
            <div class="mt-4 divide-y divide-line">
                <c:forEach var="item" items="${panier.items}">
                    <div class="flex items-center justify-between gap-4 py-3 text-slate-300">
                        <span>${item.produit.nom} x ${item.quantite}</span>
                        <strong class="text-white"><fmt:formatNumber value="${item.produit.prixEffectif * item.quantite}" type="currency" currencySymbol="MAD " /></strong>
                    </div>
                </c:forEach>
                <div class="flex items-center justify-between py-3 text-slate-300"><span>Frais de livraison</span><strong class="text-white">Gratuit</strong></div>
                <div class="flex items-center justify-between py-3 text-slate-300"><span>Total</span><strong class="text-2xl font-black text-cyanx"><fmt:formatNumber value="${panier.total}" type="currency" currencySymbol="MAD " /></strong></div>
            </div>
        </aside>
    </div>
</main>

<jsp:include page="../layout/footer.jsp" />
