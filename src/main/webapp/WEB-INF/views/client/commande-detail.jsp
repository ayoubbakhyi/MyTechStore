<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/navbar.jsp" />

<main class="mx-auto w-full max-w-[1180px] px-4 py-8 md:py-12" id="main-content">
    <nav class="mb-6 flex flex-wrap gap-2 text-sm text-slate-400" aria-label="Fil d'Ariane">
        <a class="text-cyanx hover:text-white" href="${ctx}/mes-commandes">Mes commandes</a>
        <span>/</span>
        <span>#CMD-${commande.id}</span>
    </nav>

    <section>
        <span class="inline-flex rounded-full border border-cyanx/40 bg-cyanx/10 px-3 py-1 text-xs font-black uppercase tracking-wide text-cyanx">Order detail</span>
        <h1 class="mt-4 text-4xl font-black text-white md:text-5xl">Commande #CMD-${commande.id}</h1>
        <p class="mt-3 text-slate-400">Placed on <fmt:formatDate value="${commande.dateCommande}" pattern="dd/MM/yyyy HH:mm" /></p>
    </section>

    <div class="mt-8 grid gap-6 lg:grid-cols-[1fr_360px]">
        <section class="rounded-lg border border-line bg-panel/80 p-5" aria-labelledby="order-lines-title">
            <div class="mb-5 flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
                <div>
                    <h2 class="text-2xl font-black text-white" id="order-lines-title">Articles commandes</h2>
                    <span class="mt-2 inline-flex rounded-full border border-cyanx/30 bg-cyanx/10 px-3 py-1 text-sm font-black text-cyanx">
                        ${commande.statut == 'EN_ATTENTE' ? 'En attente' :
                          commande.statut == 'CONFIRMEE' ? 'Confirmee' :
                          commande.statut == 'EXPEDIEE' ? 'Expediee' :
                          commande.statut == 'LIVREE' ? 'Livree' : 'Annulee'}
                    </span>
                </div>
            </div>

            <div class="grid gap-3">
                <c:forEach var="line" items="${commande.lignes}">
                    <article class="grid gap-4 rounded-lg border border-line bg-white/5 p-4 md:grid-cols-[76px_1fr_auto] md:items-center">
                        <a class="grid h-16 w-20 place-items-center overflow-hidden rounded-md bg-slate-900" href="${ctx}/produit?id=${line.produit.id}" aria-label="Voir ${line.produit.nom}">
                            <c:if test="${not empty line.produit.image}">
                                <img class="h-full w-full object-cover" src="${ctx}/static/images/${line.produit.image}" alt="${line.produit.nom}" onerror="this.style.display='none'; this.nextElementSibling.classList.remove('hidden');">
                            </c:if>
                            <div class="${not empty line.produit.image ? 'hidden' : ''} h-10 w-14 rounded border border-cyanx/40 bg-ink"></div>
                        </a>
                        <div>
                            <span class="text-xs font-black uppercase text-slate-400">${line.produit.marque}</span>
                            <h3 class="font-black text-white">${line.produit.nom}</h3>
                            <span class="text-sm text-slate-400">Quantity: ${line.quantite}</span>
                        </div>
                        <strong class="text-white"><fmt:formatNumber value="${line.prixUnitaire * line.quantite}" type="currency" currencySymbol="MAD " /></strong>
                    </article>
                </c:forEach>
            </div>
        </section>

        <aside class="h-fit rounded-lg border border-line bg-panel/85 p-5 shadow-glow lg:sticky lg:top-24" aria-labelledby="delivery-title">
            <h2 class="text-2xl font-black text-white" id="delivery-title">Livraison</h2>
            <c:choose>
                <c:when test="${commande.livraison != null}">
                    <div class="mt-4 divide-y divide-line">
                        <div class="flex items-center justify-between py-3 text-slate-300">
                            <span>Statut</span>
                            <strong class="rounded-full border border-cyanx/30 bg-cyanx/10 px-3 py-1 text-sm text-cyanx">
                                ${commande.livraison.statut == 'EN_PREPARATION' ? 'En preparation' :
                                  commande.livraison.statut == 'EXPEDIEE' ? 'Expediee' : 'Livree'}
                            </strong>
                        </div>
                        <c:if test="${commande.livraison.dateExpedition != null}">
                            <div class="flex items-center justify-between py-3 text-slate-300"><span>Expedition</span><strong class="text-white">${commande.livraison.dateExpedition}</strong></div>
                        </c:if>
                        <c:if test="${commande.livraison.dateLivraisonPrevue != null}">
                            <div class="flex items-center justify-between py-3 text-slate-300"><span>Livraison prevue</span><strong class="text-white">${commande.livraison.dateLivraisonPrevue}</strong></div>
                        </c:if>
                    </div>
                    <p class="mt-4 leading-7 text-slate-300">
                        <strong class="text-white">Adresse</strong><br>
                        ${commande.utilisateur.nom}<br>
                        ${commande.livraison.adresse}<br>
                        ${commande.livraison.codePostal} ${commande.livraison.ville}
                    </p>
                </c:when>
                <c:otherwise>
                    <p class="mt-4 text-slate-400">Aucune information de livraison disponible.</p>
                </c:otherwise>
            </c:choose>

            <div class="mt-5 flex items-center justify-between border-t border-line pt-4 text-slate-300">
                <span>Total TTC</span>
                <strong class="text-2xl font-black text-cyanx"><fmt:formatNumber value="${commande.total}" type="currency" currencySymbol="MAD " /></strong>
            </div>
            <a class="mt-5 inline-flex min-h-11 w-full items-center justify-center rounded-md border border-line bg-white/10 px-5 font-bold text-white hover:border-cyanx hover:text-cyanx" href="${ctx}/mes-commandes">Back to orders</a>
        </aside>
    </div>
</main>

<jsp:include page="../layout/footer.jsp" />
