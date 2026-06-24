package com.mytechstore.controller;

import com.mytechstore.model.Utilisateur;
import com.mytechstore.service.UtilisateurService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(urlPatterns = {"/login", "/register", "/logout"})
public class AuthController extends HttpServlet {
    private final UtilisateurService utilisateurService = new UtilisateurService();

    //  constantes pour les chemins JSP (évite les fautes de frappe)
    private static final String LOGIN_JSP    = "/WEB-INF/views/auth/login.jsp";
    private static final String REGISTER_JSP = "/WEB-INF/views/auth/register.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/logout".equals(path)) {
            HttpSession session = request.getSession(false);
            if (session != null) session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            redirectUser(response, request, (Utilisateur) session.getAttribute("user"));
            return;
        }

        if ("/login".equals(path)) {
            request.getRequestDispatcher(LOGIN_JSP).forward(request, response);
        } else if ("/register".equals(path)) {
            request.getRequestDispatcher(REGISTER_JSP).forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/login".equals(path)) {
            handleLogin(request, response);
        } else if ("/register".equals(path)) {
            handleRegister(request, response);
        }
    }

    //  méthode séparée pour le login (code plus lisible)
    private void handleLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email    = trim(request.getParameter("email"));
        String password = trim(request.getParameter("password"));

        // Validation champs vides
        if (email.isEmpty() || password.isEmpty()) {
            forwardWithError(request, response, LOGIN_JSP, "Veuillez remplir tous les champs.");
            return;
        }

        try {
            Utilisateur u = utilisateurService.login(email, password);
            if (u != null) {
                HttpSession session = request.getSession(true);
                session.setAttribute("user", u);
                redirectUser(response, request, u);
            } else {
                forwardWithError(request, response, LOGIN_JSP, "Email ou mot de passe incorrect.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            forwardWithError(request, response, LOGIN_JSP, "Erreur technique, veuillez réessayer.");
        }
    }

    // méthode séparée pour l'inscription avec validations complètes
    private void handleRegister(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nom             = trim(request.getParameter("nom"));
        String email           = trim(request.getParameter("email"));
        String password        = trim(request.getParameter("password"));
        String confirmPassword = trim(request.getParameter("confirmPassword"));

        //  validation champs vides
        if (nom.isEmpty() || email.isEmpty() || password.isEmpty() || confirmPassword.isEmpty()) {
            forwardWithError(request, response, REGISTER_JSP, "Veuillez remplir tous les champs.");
            return;
        }

        //  validation format email
        if (!email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            forwardWithError(request, response, REGISTER_JSP, "Adresse email invalide.");
            return;
        }

        //mot de passe minimum 6 caractères
        if (password.length() < 6) {
            forwardWithError(request, response, REGISTER_JSP, "Le mot de passe doit contenir au moins 6 caractères.");
            return;
        }

        //  confirmation mot de passe
        if (!password.equals(confirmPassword)) {
            forwardWithError(request, response, REGISTER_JSP, "Les mots de passe ne correspondent pas.");
            return;
        }

        //  nom minimum 2 caractères
        if (nom.length() < 2) {
            forwardWithError(request, response, REGISTER_JSP, "Le nom doit contenir au moins 2 caractères.");
            return;
        }

        try {
            Utilisateur u = new Utilisateur(nom, email, password, "CLIENT");
            utilisateurService.register(u);
            request.setAttribute("success", "Inscription réussie ! Veuillez vous connecter.");
            request.getRequestDispatcher(LOGIN_JSP).forward(request, response);
        } catch (IllegalArgumentException e) {
            forwardWithError(request, response, REGISTER_JSP, e.getMessage());
        } catch (SQLException e) {
            e.printStackTrace();
            forwardWithError(request, response, REGISTER_JSP, "Erreur technique lors de l'inscription.");
        }
    }

    // : méthode utilitaire pour éviter la répétition de code
    private void forwardWithError(HttpServletRequest request, HttpServletResponse response,
                                  String jsp, String message) throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher(jsp).forward(request, response);
    }

    // méthode utilitaire pour nettoyer les espaces
    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private void redirectUser(HttpServletResponse response, HttpServletRequest request, Utilisateur u) throws IOException {
        if ("ADMIN".equals(u.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin");
        } else {
            response.sendRedirect(request.getContextPath() + "/catalogue");
        }
    }
}