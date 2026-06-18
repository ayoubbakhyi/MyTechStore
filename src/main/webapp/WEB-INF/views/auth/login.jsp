<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/navbar.jsp" />

<main class="mx-auto grid min-h-[calc(100vh-9rem)] w-full max-w-[1180px] items-center gap-8 px-4 py-8 lg:grid-cols-[0.9fr_1.1fr]" id="main-content">
    <section class="rounded-lg border border-line bg-panel/85 p-6 shadow-glow">
        <span class="inline-flex rounded-full border border-cyanx/40 bg-cyanx/10 px-3 py-1 text-xs font-black uppercase tracking-wide text-cyanx">Welcome back</span>
        <h1 class="mt-4 text-4xl font-black text-white md:text-5xl">Connexion</h1>
        <p class="mt-3 text-slate-400">Access your cart, orders and admin dashboard from one account.</p>

        <c:if test="${not empty param.error}">
            <div class="mt-5 rounded-lg border border-red-400/30 bg-red-400/10 px-4 py-3 text-red-200"><strong>Erreur :</strong> ${param.error}</div>
        </c:if>
        <c:if test="${not empty requestScope.error}">
            <div class="mt-5 rounded-lg border border-red-400/30 bg-red-400/10 px-4 py-3 text-red-200"><strong>Erreur :</strong> ${requestScope.error}</div>
        </c:if>
        <c:if test="${not empty requestScope.success}">
            <div class="mt-5 rounded-lg border border-greenx/30 bg-greenx/10 px-4 py-3 text-greenx"><strong>Succes :</strong> ${requestScope.success}</div>
        </c:if>

        <form class="mt-6 grid gap-4" action="${ctx}/login" method="post">
            <div>
                <label class="mb-2 block text-sm font-bold text-slate-200" for="email">Adresse e-mail</label>
                <input class="min-h-11 w-full rounded-md border border-line bg-ink/70 px-4 text-white outline-none placeholder:text-slate-500 focus:border-cyanx focus:ring-2 focus:ring-cyanx/20" type="email" id="email" name="email" required placeholder="nom@example.com" autocomplete="email">
            </div>
            <div>
                <label class="mb-2 block text-sm font-bold text-slate-200" for="password">Mot de passe</label>
                <input class="min-h-11 w-full rounded-md border border-line bg-ink/70 px-4 text-white outline-none placeholder:text-slate-500 focus:border-cyanx focus:ring-2 focus:ring-cyanx/20" type="password" id="password" name="password" required placeholder="Votre mot de passe" autocomplete="current-password">
            </div>
            <div class="flex flex-wrap gap-3">
                <button class="min-h-11 rounded-md bg-gradient-to-r from-cyanx to-greenx px-5 font-black text-ink" type="submit">Se connecter</button>
                <a class="inline-flex min-h-11 items-center rounded-md border border-line bg-white/10 px-5 font-bold text-white hover:border-cyanx hover:text-cyanx" href="${ctx}/register">Creer un compte</a>
            </div>
        </form>
    </section>

    <aside class="hidden min-h-[420px] place-items-center rounded-lg border border-line bg-gradient-to-br from-panel via-slate-900 to-ink shadow-glow lg:grid" aria-hidden="true">
        <div class="h-40 w-72 rounded-lg border border-cyanx/40 bg-ink p-6">
            <div class="h-4 rounded-full bg-gradient-to-r from-cyanx via-greenx to-amberx"></div>
            <div class="mt-8 h-20 rounded border border-line bg-slate-900"></div>
        </div>
    </aside>
</main>

<jsp:include page="../layout/footer.jsp" />
