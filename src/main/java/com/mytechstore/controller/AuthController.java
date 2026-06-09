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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        
        if ("/logout".equals(path)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if ("/login".equals(path)) {
            // If already logged in, redirect
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("user") != null) {
                redirectUser(response, request, (Utilisateur) session.getAttribute("user"));
                return;
            }
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            return;
        }

        if ("/register".equals(path)) {
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("user") != null) {
                redirectUser(response, request, (Utilisateur) session.getAttribute("user"));
                return;
            }
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/login".equals(path)) {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
                request.setAttribute("error", "Veuillez remplir tous les champs.");
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
                return;
            }

            try {
                Utilisateur u = utilisateurService.login(email, password);
                if (u != null) {
                    HttpSession session = request.getSession(true);
                    session.setAttribute("user", u);
                    redirectUser(response, request, u);
                } else {
                    request.setAttribute("error", "Identifiants incorrects.");
                    request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
                }
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("error", "Une erreur technique est survenue.");
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            }
            return;
        }

        if ("/register".equals(path)) {
            String nom = request.getParameter("nom");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");

            if (nom == null || nom.trim().isEmpty() || email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty() || confirmPassword == null || confirmPassword.trim().isEmpty()) {
                request.setAttribute("error", "Veuillez remplir tous les champs.");
                request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
                return;
            }

            if (!password.equals(confirmPassword)) {
                request.setAttribute("error", "Les mots de passe ne correspondent pas.");
                request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
                return;
            }

            Utilisateur u = new Utilisateur(nom, email, password, "CLIENT");
            try {
                utilisateurService.register(u);
                request.setAttribute("success", "Inscription réussie ! Veuillez vous connecter.");
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", e.getMessage());
                request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("error", "Une erreur technique est survenue lors de l'enregistrement.");
                request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            }
        }
    }

    private void redirectUser(HttpServletResponse response, HttpServletRequest request, Utilisateur u) throws IOException {
        if ("ADMIN".equals(u.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin");
        } else {
            response.sendRedirect(request.getContextPath() + "/catalogue");
        }
    }
}
