<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/navbar.jsp" />

<main class="mx-auto w-full max-w-[1180px] px-4 py-8 md:py-12" id="main-content">
    <section>
        <span class="inline-flex rounded-full border border-cyanx/40 bg-cyanx/10 px-3 py-1 text-xs font-black uppercase tracking-wide text-cyanx">Orders</span>
        <h1 class="mt-4 text-4xl font-black text-white md:text-5xl">Mes commandes</h1>
        <p class="mt-3 max-w-2xl text-slate-400">Follow every purchase and delivery status from your account.</p>
    </section>

    <c:if test="${not empty param.success}">
        <div class="mt-6 rounded-lg border border-greenx/30 bg-greenx/10 px-4 py-3 text-greenx"><strong>Succes :</strong> ${param.success}</div>
    </c:if>

    <c:choose>
        <c:when test="${empty commandes}">
            <div class="mt-8 rounded-lg border border-line bg-panel/80 p-10 text-center">
                <h2 class="text-2xl font-black text-white">No orders yet</h2>
                <p class="mt-2 text-slate-400">Your completed orders will appear here.</p>
                <a class="mt-5 inline-flex min-h-11 items-center rounded-md bg-gradient-to-r from-cyanx to-greenx px-5 font-black text-ink" href="${ctx}/catalogue">Browse catalogue</a>
            </div>
        </c:when>
        <c:otherwise>
            <section class="mt-8 grid gap-4" aria-label="Liste des commandes">
                <c:forEach var="c" items="${commandes}">
                    <article class="grid gap-4 rounded-lg border border-line bg-panel/75 p-5 md:grid-cols-[1fr_auto] md:items-center">
                        <div>
                            <span class="text-xs font-black uppercase tracking-wide text-slate-400">Commande #CMD-${c.id}</span>
                            <h2 class="mt-1 text-lg font-black text-white"><fmt:formatDate value="${c.dateCommande}" pattern="dd/MM/yyyy HH:mm" /></h2>
                            <span class="mt-3 inline-flex rounded-full border border-cyanx/30 bg-cyanx/10 px-3 py-1 text-sm font-black text-cyanx">
                                ${c.statut == 'EN_ATTENTE' ? 'En attente' :
                                  c.statut == 'CONFIRMEE' ? 'Confirmee' :
                                  c.statut == 'EXPEDIEE' ? 'Expediee' :
                                  c.statut == 'LIVREE' ? 'Livree' : 'Annulee'}
                            </span>
                        </div>
                        <div class="flex flex-wrap items-center gap-3 md:justify-end">
                            <strong class="text-2xl font-black text-cyanx"><fmt:formatNumber value="${c.total}" type="currency" currencySymbol="MAD " /></strong>
                            <a class="inline-flex min-h-10 items-center rounded-md border border-line bg-white/10 px-4 text-sm font-bold text-white hover:border-cyanx hover:text-cyanx" href="${ctx}/mes-commandes?id=${c.id}">Details</a>
                        </div>
                    </article>
                </c:forEach>
            </section>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="../layout/footer.jsp" />
