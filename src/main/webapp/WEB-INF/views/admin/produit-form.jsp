<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/admin-sidebar.jsp" />

<main class="mx-auto w-full max-w-[1180px] px-4 pb-12">
    <section class="mb-6 flex flex-col gap-4 md:flex-row md:items-end md:justify-between">
        <div>
            <span class="inline-flex rounded-full border border-cyanx/40 bg-cyanx/10 px-3 py-1 text-xs font-black uppercase tracking-wide text-cyanx">Produit</span>
            <h1 class="mt-4 text-3xl font-black text-white md:text-5xl">${produit != null ? 'Modifier' : 'Ajouter'} un produit</h1>
            <p class="mt-2 text-slate-400">Remplissez les details techniques et commerciaux du produit.</p>
        </div>
        <a class="inline-flex min-h-11 items-center justify-center rounded-md border border-line bg-white/10 px-5 font-bold text-white hover:border-cyanx hover:text-cyanx" href="${ctx}/admin/produits">Retour a la liste</a>
    </section>

    <form class="rounded-lg border border-line bg-panel/80 p-6 shadow-glow" action="${ctx}/admin/produits" method="post" enctype="multipart/form-data">
        <c:if test="${produit != null}">
            <input type="hidden" name="id" value="${produit.id}">
        </c:if>

        <div class="grid gap-5 md:grid-cols-2">
            <div>
                <label class="mb-2 block text-sm font-bold text-slate-200" for="nom">Nom du produit</label>
                <input class="min-h-11 w-full rounded-md border border-line bg-ink/70 px-4 text-white outline-none placeholder:text-slate-500 focus:border-cyanx focus:ring-2 focus:ring-cyanx/20" type="text" id="nom" name="nom" value="${produit.nom}" required placeholder="Ex: GeForce RTX 4070">
            </div>
            <div>
                <label class="mb-2 block text-sm font-bold text-slate-200" for="marque">Marque</label>
                <input class="min-h-11 w-full rounded-md border border-line bg-ink/70 px-4 text-white outline-none placeholder:text-slate-500 focus:border-cyanx focus:ring-2 focus:ring-cyanx/20" type="text" id="marque" name="marque" value="${produit.marque}" required placeholder="Ex: ASUS, MSI, NVIDIA">
            </div>
            <div>
                <label class="mb-2 block text-sm font-bold text-slate-200" for="prix">Prix original (MAD)</label>
                <div class="flex">
                    <input class="min-h-11 w-full rounded-l-md border border-line bg-ink/70 px-4 text-white outline-none placeholder:text-slate-500 focus:border-cyanx focus:ring-2 focus:ring-cyanx/20" type="number" step="0.01" id="prix" name="prix" value="${produit.prix}" required placeholder="0.00">
                    <span class="inline-flex min-h-11 items-center rounded-r-md border border-l-0 border-line bg-white/10 px-4 font-black text-cyanx">MAD</span>
                </div>
            </div>
            <div>
                <label class="mb-2 block text-sm font-bold text-slate-200" for="stock">Stock initial</label>
                <input class="min-h-11 w-full rounded-md border border-line bg-ink/70 px-4 text-white outline-none focus:border-cyanx focus:ring-2 focus:ring-cyanx/20" type="number" id="stock" name="stock" value="${produit != null ? produit.stock : 0}" required min="0">
            </div>
            <div>
                <label class="mb-2 block text-sm font-bold text-slate-200" for="idCategorie">Categorie</label>
                <select class="min-h-11 w-full rounded-md border border-line bg-ink/70 px-4 text-white outline-none focus:border-cyanx focus:ring-2 focus:ring-cyanx/20" id="idCategorie" name="idCategorie">
                    <option value="-1">-- Aucune categorie --</option>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat.id}" ${produit != null && produit.idCategorie == cat.id ? 'selected' : ''}>${cat.nom}</option>
                    </c:forEach>
                </select>
            </div>
            <div>
                <label class="mb-2 block text-sm font-bold text-slate-200" for="idPromotion">Promotion</label>
                <select class="min-h-11 w-full rounded-md border border-line bg-ink/70 px-4 text-white outline-none focus:border-cyanx focus:ring-2 focus:ring-cyanx/20" id="idPromotion" name="idPromotion">
                    <option value="-1">-- Aucune promotion --</option>
                    <c:forEach var="promo" items="${promotions}">
                        <option value="${promo.id}" ${produit != null && produit.idPromotion == promo.id ? 'selected' : ''}>${promo.nom} (-${promo.valeur}%)</option>
                    </c:forEach>
                </select>
            </div>
            <div class="md:col-span-2">
                <label class="mb-2 block text-sm font-bold text-slate-200" for="imageFile">Image du produit</label>
                <c:if test="${not empty produit.image}">
                    <div class="mb-3 flex items-center gap-3 rounded-md border border-line bg-ink/60 p-3">
                        <img class="h-16 w-16 rounded-md object-cover" src="${ctx}/static/images/${produit.image}" alt="Image actuelle">
                        <div>
                            <p class="font-bold text-white">Fichier actuel</p>
                            <p class="text-sm text-slate-400">${produit.image}</p>
                        </div>
                        <input type="hidden" name="image" value="${produit.image}">
                    </div>
                </c:if>
                <input class="w-full rounded-md border border-line bg-ink/70 px-4 py-3 text-white file:mr-4 file:rounded-md file:border-0 file:bg-cyanx file:px-4 file:py-2 file:font-black file:text-ink" type="file" id="imageFile" name="imageFile" accept="image/*">
                <p class="mt-2 text-sm text-slate-400">Formats acceptes : PNG, JPG, JPEG, WEBP. Laissez vide pour conserver l'image actuelle.</p>
            </div>
            <div class="md:col-span-2">
                <label class="mb-2 block text-sm font-bold text-slate-200" for="description">Description technique</label>
                <textarea class="w-full rounded-md border border-line bg-ink/70 px-4 py-3 text-white outline-none placeholder:text-slate-500 focus:border-cyanx focus:ring-2 focus:ring-cyanx/20" id="description" name="description" rows="6" required placeholder="Saisissez les caracteristiques detaillees...">${produit.description}</textarea>
            </div>
        </div>

        <div class="mt-6 flex flex-wrap justify-end gap-3 border-t border-line pt-5">
            <a class="inline-flex min-h-11 items-center rounded-md border border-line bg-white/10 px-5 font-bold text-white hover:border-cyanx hover:text-cyanx" href="${ctx}/admin/produits">Annuler</a>
            <button class="min-h-11 rounded-md bg-gradient-to-r from-cyanx to-greenx px-5 font-black text-ink" type="submit">Enregistrer le produit</button>
        </div>
    </form>
</main>

<jsp:include page="../layout/footer.jsp" />
