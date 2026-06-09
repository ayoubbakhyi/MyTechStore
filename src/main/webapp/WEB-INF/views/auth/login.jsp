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
                            <i class="fa-solid fa-lock fs-3"></i>
                        </div>
                        <h3 class="fw-bold">Connexion</h3>
                        <p class="text-muted">Accédez à votre compte MyTechStore</p>
                    </div>
                    
                    <c:if test="${not empty param.error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fa-solid fa-triangle-exclamation me-2"></i>${param.error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty requestScope.error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fa-solid fa-triangle-exclamation me-2"></i>${requestScope.error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty requestScope.success}">
                        <div class="alert alert-success alert-dismissible fade show alert-dismissible-auto" role="alert">
                            <i class="fa-solid fa-circle-check me-2"></i>${requestScope.success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/login" method="post">
                        <div class="mb-3">
                            <label for="email" class="form-label fw-semibold">Adresse E-mail</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i class="fa-solid fa-envelope text-muted"></i></span>
                                <input type="email" class="form-control border-start-0" id="email" name="email" required placeholder="nom@exemple.com" style="background-color: #f8fafc;">
                            </div>
                        </div>
                        <div class="mb-4">
                            <label for="password" class="form-label fw-semibold">Mot de passe</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i class="fa-solid fa-key text-muted"></i></span>
                                <input type="password" class="form-control border-start-0" id="password" name="password" required placeholder="Votre mot de passe" style="background-color: #f8fafc;">
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 py-2 mb-3">
                            <i class="fa-solid fa-right-to-bracket me-2"></i>Se Connecter
                        </button>
                        <div class="text-center mt-3">
                            <p class="mb-0 text-muted">Pas encore membre ? <a href="${pageContext.request.contextPath}/register" class="text-primary fw-bold text-decoration-none">Créer un compte</a></p>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../layout/footer.jsp" />
