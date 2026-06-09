package com.mytechstore.filter;

import com.mytechstore.model.Utilisateur;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        // Allow static resources without restriction
        if (path.startsWith("/static/") || path.startsWith("/favicon.ico")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = httpRequest.getSession(false);
        Utilisateur user = (session != null) ? (Utilisateur) session.getAttribute("user") : null;

        // Route protection
        boolean isAdminRoute = path.startsWith("/admin");
        boolean isClientAuthRoute = path.startsWith("/commande") || path.startsWith("/mes-commandes") || path.equals("/checkout");

        if (isAdminRoute) {
            if (user == null) {
                // Not logged in: Redirect to login with alert message
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login?error=Veuillez vous connecter pour acceder a l'administration.");
                return;
            } else if (!"ADMIN".equals(user.getRole())) {
                // Logged in but not Admin: Access forbidden or redirect
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès interdit : privilèges administrateur requis.");
                return;
            }
        }

        if (isClientAuthRoute) {
            if (user == null) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login?error=Veuillez vous connecter pour passer ou voir vos commandes.");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}
