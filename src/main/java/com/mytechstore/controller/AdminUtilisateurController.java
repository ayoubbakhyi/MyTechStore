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

@WebServlet(urlPatterns = {"/admin/utilisateurs"})
public class AdminUtilisateurController extends HttpServlet {
    private final UtilisateurService utilisateurService = new UtilisateurService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdminAccess(request, response)) return;

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        try {
            if ("edit".equals(action) && idParam != null) {
                int id = Integer.parseInt(idParam);
                Utilisateur u = utilisateurService.getUserById(id);
                if (u != null) {
                    request.setAttribute("utilisateur", u);
                    request.getRequestDispatcher("/WEB-INF/views/admin/utilisateur-form.jsp").forward(request, response);
                    return;
                }
            }

            if ("new".equals(action)) {
                request.getRequestDispatcher("/WEB-INF/views/admin/utilisateur-form.jsp").forward(request, response);
                return;
            }

            // List users
            request.setAttribute("utilisateurs", utilisateurService.getAllUsers());
            request.getRequestDispatcher("/WEB-INF/views/admin/utilisateurs.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdminAccess(request, response)) return;

        String action = request.getParameter("action");

        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                
                // Optional: Prevent admin from deleting themselves
                HttpSession session = request.getSession(false);
                Utilisateur currentUser = (Utilisateur) session.getAttribute("user");
                if (currentUser != null && currentUser.getId() == id) {
                    request.setAttribute("error", "Vous ne pouvez pas supprimer votre propre compte.");
                    request.setAttribute("utilisateurs", utilisateurService.getAllUsers());
                    request.getRequestDispatcher("/WEB-INF/views/admin/utilisateurs.jsp").forward(request, response);
                    return;
                }

                utilisateurService.deleteUser(id);
                response.sendRedirect(request.getContextPath() + "/admin/utilisateurs");
                return;
            }

            // Add or Edit user
            String idParam = request.getParameter("id");
            String nom = request.getParameter("nom");
            String email = request.getParameter("email");
            String role = request.getParameter("role");
            String password = request.getParameter("password");

            // Input Validation
            if (nom == null || nom.trim().isEmpty() || email == null || email.trim().isEmpty() || role == null || role.trim().isEmpty()) {
                request.setAttribute("error", "Veuillez remplir tous les champs obligatoires (Nom, Email, Rôle).");
                if (idParam != null && !idParam.trim().isEmpty()) {
                    int id = Integer.parseInt(idParam);
                    request.setAttribute("utilisateur", utilisateurService.getUserById(id));
                }
                request.getRequestDispatcher("/WEB-INF/views/admin/utilisateur-form.jsp").forward(request, response);
                return;
            }

            if (idParam != null && !idParam.trim().isEmpty()) {
                // Edit
                int id = Integer.parseInt(idParam);
                Utilisateur u = new Utilisateur();
                u.setId(id);
                u.setNom(nom);
                u.setEmail(email);
                u.setRole(role);
                
                boolean updatePassword = false;
                if (password != null && !password.trim().isEmpty()) {
                    u.setMotDePasse(password);
                    updatePassword = true;
                }

                try {
                    utilisateurService.updateUser(u, updatePassword);
                } catch (SQLException e) {
                    request.setAttribute("error", "Erreur lors de la mise à jour (l'e-mail est peut-être déjà utilisé).");
                    request.setAttribute("utilisateur", utilisateurService.getUserById(id));
                    request.getRequestDispatcher("/WEB-INF/views/admin/utilisateur-form.jsp").forward(request, response);
                    return;
                }
            } else {
                // Add new
                if (password == null || password.trim().isEmpty()) {
                    request.setAttribute("error", "Le mot de passe est obligatoire pour un nouvel utilisateur.");
                    request.getRequestDispatcher("/WEB-INF/views/admin/utilisateur-form.jsp").forward(request, response);
                    return;
                }

                Utilisateur u = new Utilisateur(nom, email, password, role);
                try {
                    utilisateurService.register(u);
                } catch (IllegalArgumentException e) {
                    request.setAttribute("error", e.getMessage());
                    request.getRequestDispatcher("/WEB-INF/views/admin/utilisateur-form.jsp").forward(request, response);
                    return;
                }
            }

            response.sendRedirect(request.getContextPath() + "/admin/utilisateurs");
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    private boolean checkAdminAccess(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        Utilisateur u = (Utilisateur) session.getAttribute("user");
        if (!"ADMIN".equals(u.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès refusé.");
            return false;
        }
        return true;
    }
}
