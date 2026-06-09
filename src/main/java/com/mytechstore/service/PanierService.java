package com.mytechstore.service;

import com.mytechstore.dao.PanierDAO;
import com.mytechstore.model.Panier;

import java.sql.SQLException;

public class PanierService {
    private final PanierDAO panierDAO = new PanierDAO();

    public Panier getCartForUser(int userId) throws SQLException {
        return panierDAO.getOrCreateCart(userId);
    }

    public void addItemToCart(int userId, int productId, int quantity) throws SQLException {
        Panier panier = panierDAO.getOrCreateCart(userId);
        panierDAO.addItem(panier.getId(), productId, quantity);
    }

    public void updateCartItemQuantity(int userId, int productId, int quantity) throws SQLException {
        Panier panier = panierDAO.getOrCreateCart(userId);
        panierDAO.updateQuantity(panier.getId(), productId, quantity);
    }

    public void removeItemFromCart(int userId, int productId) throws SQLException {
        Panier panier = panierDAO.getOrCreateCart(userId);
        panierDAO.removeItem(panier.getId(), productId);
    }

    public void clearCart(int userId) throws SQLException {
        Panier panier = panierDAO.getOrCreateCart(userId);
        panierDAO.clearCart(panier.getId());
    }
}
