package com.mytechstore.controller;

import com.mytechstore.model.Panier;
import com.mytechstore.model.Utilisateur;
import com.mytechstore.service.PanierService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(urlPatterns = {"/panier"})
public class PanierController extends HttpServlet {
    private final PanierService panierService = new PanierService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=Veuillez vous connecter pour acceder a votre panier.");
            return;
        }

        Utilisateur u = (Utilisateur) session.getAttribute("user");
        try {
            Panier panier = panierService.getCartForUser(u.getId());
            request.setAttribute("panier", panier);
            request.getRequestDispatcher("/WEB-INF/views/client/panier.jsp").forward(request, response);
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
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                int quantity = 1;
                String qtyParam = request.getParameter("quantity");
                if (qtyParam != null && !qtyParam.trim().isEmpty()) {
                    quantity = Integer.parseInt(qtyParam);
                }
                panierService.addItemToCart(u.getId(), productId, quantity);
                
                String redirect = request.getParameter("redirect");
                if ("produit".equals(redirect)) {
                    response.sendRedirect(request.getContextPath() + "/produit?id=" + productId + "&success=Produit ajoute au panier.");
                } else {
                    response.sendRedirect(request.getContextPath() + "/catalogue?success=Produit ajoute au panier.");
                }
                return;
            }

            if ("update".equals(action)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                panierService.updateCartItemQuantity(u.getId(), productId, quantity);
                response.sendRedirect(request.getContextPath() + "/panier");
                return;
            }

            if ("remove".equals(action)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                panierService.removeItemFromCart(u.getId(), productId);
                response.sendRedirect(request.getContextPath() + "/panier");
                return;
            }

            if ("clear".equals(action)) {
                panierService.clearCart(u.getId());
                response.sendRedirect(request.getContextPath() + "/panier");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
}
