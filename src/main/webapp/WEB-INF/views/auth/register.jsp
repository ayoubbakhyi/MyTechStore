<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../layout/header.jsp" />
<jsp:include page="../layout/navbar.jsp" />

<main class="flex-grow-1 d-flex align-items-center justify-content-center py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="card border-0 shadow-lg p-4" style="border-radius: 16px;">
                    <div class="text-center mb-4">
                        <div class="d-inline-flex align-items-center justify-content-center bg-primary bg-opacity-10 text-primary rounded-circle mb-3" style="width: 64px; height: 64px;">
                            <i class="fa-solid fa-user-plus fs-3"></i>
                        </div>
                        <h3 class="fw-bold">Inscription</h3>
                        <p class="text-muted">Créez votre compte client en quelques instants</p>
                    </div>
                    
                    <c:if test="${not empty requestScope.error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fa-solid fa-triangle-exclamation me-2"></i>${requestScope.error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/register" method="post">
                        <div class="mb-3">
                            <label for="nom" class="form-label fw-semibold">Nom Complet</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i class="fa-solid fa-user text-muted"></i></span>
                                <input type="text" class="form-control border-start-0" id="nom" name="nom" required placeholder="Jean Dupont" style="background-color: #f8fafc;">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label fw-semibold">Adresse E-mail</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i class="fa-solid fa-envelope text-muted"></i></span>
                                <input type="email" class="form-control border-start-0" id="email" name="email" required placeholder="nom@exemple.com" style="background-color: #f8fafc;">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label fw-semibold">Mot de passe</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i class="fa-solid fa-key text-muted"></i></span>
                                <input type="password" class="form-control border-start-0" id="password" name="password" required placeholder="Mot de passe sécurisé" style="background-color: #f8fafc;">
                            </div>
                        </div>
                        <div class="mb-4">
                            <label for="confirmPassword" class="form-label fw-semibold">Confirmer le mot de passe</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i class="fa-solid fa-key text-muted"></i></span>
                                <input type="password" class="form-control border-start-0" id="confirmPassword" name="confirmPassword" required placeholder="Confirmez le mot de passe" style="background-color: #f8fafc;">
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 py-2 mb-3">
                            <i class="fa-solid fa-user-check me-2"></i>S'inscrire
                        </button>
                        <div class="text-center mt-3">
                            <p class="mb-0 text-muted">Déjà inscrit ? <a href="${pageContext.request.contextPath}/login" class="text-primary fw-bold text-decoration-none">Se connecter</a></p>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../layout/footer.jsp" />
