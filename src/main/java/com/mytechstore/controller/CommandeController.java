package com.mytechstore.controller;

import com.mytechstore.model.Commande;
import com.mytechstore.model.Panier;
import com.mytechstore.model.Utilisateur;
import com.mytechstore.service.CommandeService;
import com.mytechstore.service.PanierService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(urlPatterns = {"/commande", "/mes-commandes"})
public class CommandeController extends HttpServlet {
    private final CommandeService commandeService = new CommandeService();
    private final PanierService panierService = new PanierService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=Veuillez vous connecter pour continuer.");
            return;
        }

        Utilisateur u = (Utilisateur) session.getAttribute("user");
        String path = request.getServletPath();

        try {
            if ("/commande".equals(path)) {
                // Checkout page
                Panier panier = panierService.getCartForUser(u.getId());
                if (panier.getItems().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/panier?error=Votre panier est vide.");
                    return;
                }
                request.setAttribute("panier", panier);
                request.getRequestDispatcher("/WEB-INF/views/client/checkout.jsp").forward(request, response);
                return;
            }

            if ("/mes-commandes".equals(path)) {
                String idParam = request.getParameter("id");
                if (idParam != null && !idParam.trim().isEmpty()) {
                    // Order detail page
                    int orderId = Integer.parseInt(idParam);
                    Commande c = commandeService.getOrderById(orderId);
                    
                    // Security check: ensure order belongs to the logged-in user
                    if (c == null || c.getIdUtilisateur() != u.getId()) {
                        response.sendRedirect(request.getContextPath() + "/mes-commandes");
                        return;
                    }
                    
                    request.setAttribute("commande", c);
                    request.getRequestDispatcher("/WEB-INF/views/client/commande-detail.jsp").forward(request, response);
                } else {
                    // Orders list page
                    List<Commande> orders = commandeService.getOrdersByUserId(u.getId());
                    request.setAttribute("commandes", orders);
                    request.getRequestDispatcher("/WEB-INF/views/client/mes-commandes.jsp").forward(request, response);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Utilisateur u = (Utilisateur) session.getAttribute("user");
        String path = request.getServletPath();

        if ("/commande".equals(path)) {
            String adresse = request.getParameter("adresse");
            String ville = request.getParameter("ville");
            String codePostal = request.getParameter("codePostal");

            if (adresse == null || adresse.trim().isEmpty() ||
                ville == null || ville.trim().isEmpty() ||
                codePostal == null || codePostal.trim().isEmpty()) {
                
                request.setAttribute("error", "Veuillez remplir tous les champs de livraison.");
                try {
                    request.setAttribute("panier", panierService.getCartForUser(u.getId()));
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                request.getRequestDispatcher("/WEB-INF/views/client/checkout.jsp").forward(request, response);
                return;
            }

            try {
                Commande c = commandeService.checkout(u.getId(), adresse, ville, codePostal);
                response.sendRedirect(request.getContextPath() + "/mes-commandes?id=" + c.getId() + "&success=Votre commande a ete enregistree avec succes.");
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", e.getMessage());
                try {
                    request.setAttribute("panier", panierService.getCartForUser(u.getId()));
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
                request.getRequestDispatcher("/WEB-INF/views/client/checkout.jsp").forward(request, response);
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("error", "Une erreur est survenue lors de la validation de la commande.");
                try {
                    request.setAttribute("panier", panierService.getCartForUser(u.getId()));
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
                request.getRequestDispatcher("/WEB-INF/views/client/checkout.jsp").forward(request, response);
            }
        }
    }
}
