package com.mytechstore.service;

import com.mytechstore.config.DBConnection;
import com.mytechstore.dao.*;
import com.mytechstore.model.*;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public class CommandeService {
    private final CommandeDAO commandeDAO = new CommandeDAO();
    private final LigneCommandeDAO ligneCommandeDAO = new LigneCommandeDAO();
    private final PanierDAO panierDAO = new PanierDAO();
    private final ProduitDAO produitDAO = new ProduitDAO();
    private final LivraisonDAO livraisonDAO = new LivraisonDAO();

    /**
     * Places a customer order from their shopping cart.
     * Implements transaction isolation, stock validation, and decrementing, and persistent cart cleanup.
     */
    public Commande checkout(int userId, String adresse, String ville, String codePostal) throws SQLException, IllegalArgumentException {
        Panier panier = panierDAO.getOrCreateCart(userId);
        List<PanierProduit> items = panier.getItems();
        
        if (items.isEmpty()) {
            throw new IllegalArgumentException("Votre panier est vide.");
        }

        // 1. Stock validation before beginning transaction
        for (PanierProduit item : items) {
            Produit currentProd = produitDAO.getById(item.getIdProduit());
            if (currentProd == null) {
                throw new IllegalArgumentException("Produit inexistant dans le catalogue: ID " + item.getIdProduit());
            }
            if (currentProd.getStock() < item.getQuantite()) {
                throw new IllegalArgumentException("Stock insuffisant pour le produit: " + currentProd.getNom() + 
                                                   " (Disponible: " + currentProd.getStock() + ", Demandé: " + item.getQuantite() + ")");
            }
        }

        Connection conn = DBConnection.getConnection();
        boolean originalAutoCommit = conn.getAutoCommit();
        
        try {
            conn.setAutoCommit(false); // Begin Transaction

            // 2. Create Commande
            Commande c = new Commande();
            c.setIdUtilisateur(userId);
            c.setStatut("EN_ATTENTE");
            c.setTotal(0.0);
            c = commandeDAO.create(c);

            // 3. Create Livraison
            Livraison liv = new Livraison();
            liv.setAdresse(adresse);
            liv.setVille(ville);
            liv.setCodePostal(codePostal);
            liv.setStatut("EN_PREPARATION");
            liv.setIdCommande(c.getId());
            livraisonDAO.create(liv);

            double orderTotal = 0.0;

            // 4. Create LigneCommande records and update stock
            for (PanierProduit item : items) {
                // Fetch product details for current pricing & stock
                Produit currentProd = produitDAO.getById(item.getIdProduit());
                double unitPrice = currentProd.getPrixEffectif(); // Promotional pricing applied
                double lineTotal = unitPrice * item.getQuantite();
                orderTotal += lineTotal;

                // Create LigneCommande
                LigneCommande lc = new LigneCommande();
                lc.setIdCommande(c.getId());
                lc.setIdProduit(item.getIdProduit());
                lc.setQuantite(item.getQuantite());
                lc.setPrixUnitaire(unitPrice);
                ligneCommandeDAO.create(lc);

                // Decrement stock
                int newStock = currentProd.getStock() - item.getQuantite();
                produitDAO.updateStock(currentProd.getId(), newStock);
            }

            // 5. Update overall Commande total in DB
            commandeDAO.updateTotal(c.getId(), orderTotal);
            c.setTotal(orderTotal);

            // 6. Clear shopping cart
            panierDAO.clearCart(panier.getId());

            conn.commit(); // Commit Transaction
            return c;

        } catch (SQLException | IllegalArgumentException e) {
            conn.rollback(); // Rollback on error
            throw e;
        } finally {
            conn.setAutoCommit(originalAutoCommit);
        }
    }

    public Commande getOrderById(int id) throws SQLException {
        Commande c = commandeDAO.getById(id);
        if (c != null) {
            c.setLignes(ligneCommandeDAO.getByCommandeId(id));
            c.setLivraison(livraisonDAO.getByCommandeId(id));
        }
        return c;
    }

    public List<Commande> getAllOrders() throws SQLException {
        return commandeDAO.getAll();
    }

    public List<Commande> getOrdersByUserId(int userId) throws SQLException {
        return commandeDAO.getByUserId(userId);
    }

    public void updateOrderStatus(int orderId, String status) throws SQLException {
        commandeDAO.updateStatus(orderId, status);
        
        // If order status changes to "EXPEDIEE" or "LIVREE", synchronize delivery status
        Livraison liv = livraisonDAO.getByCommandeId(orderId);
        if (liv != null) {
            if ("EXPEDIEE".equalsIgnoreCase(status)) {
                livraisonDAO.updateStatus(liv.getId(), "EXPEDIEE");
                livraisonDAO.updateDates(liv.getId(), new java.sql.Date(System.currentTimeMillis()), new java.sql.Date(System.currentTimeMillis() + 3 * 24 * 60 * 60 * 1000L));
            } else if ("LIVREE".equalsIgnoreCase(status)) {
                livraisonDAO.updateStatus(liv.getId(), "LIVREE");
                // Set delivery date to today
                liv.setDateLivraisonPrevue(new java.sql.Date(System.currentTimeMillis()));
                livraisonDAO.updateDates(liv.getId(), liv.getDateExpedition(), new java.sql.Date(System.currentTimeMillis()));
            } else if ("ANNULEE".equalsIgnoreCase(status)) {
                // If cancelled, restore stocks
                List<LigneCommande> items = ligneCommandeDAO.getByCommandeId(orderId);
                for (LigneCommande item : items) {
                    Produit p = produitDAO.getById(item.getIdProduit());
                    if (p != null) {
                        produitDAO.updateStock(p.getId(), p.getStock() + item.getQuantite());
                    }
                }
            }
        }
    }

    public int countOrders() throws SQLException {
        return commandeDAO.countOrders();
    }

    public double getTotalRevenue() throws SQLException {
        return commandeDAO.getTotalRevenue();
    }

    public List<Commande> getRecentOrders(int limit) throws SQLException {
        return commandeDAO.getRecentOrders(limit);
    }
}
