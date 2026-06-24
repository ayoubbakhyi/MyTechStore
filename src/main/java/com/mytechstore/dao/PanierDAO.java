package com.mytechstore.dao;

import com.mytechstore.config.DBConnection;
import com.mytechstore.model.Categorie;
import com.mytechstore.model.Panier;
import com.mytechstore.model.PanierProduit;
import com.mytechstore.model.Produit;
import com.mytechstore.model.Promotion;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PanierDAO {

    public Panier getOrCreateCart(int userId) throws SQLException {
        String selectQuery = "SELECT * FROM panier WHERE id_utilisateur = ?";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(selectQuery)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Panier p = new Panier(rs.getInt("id"), rs.getInt("id_utilisateur"));
                    p.setItems(getCartItems(p.getId()));
                    return p;
                }
            }
        }
        
        // Cart does not exist, create it
        String insertQuery = "INSERT INTO panier (id_utilisateur) VALUES (?)";
        try (PreparedStatement ps = conn.prepareStatement(insertQuery, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return new Panier(rs.getInt(1), userId);
                }
            }
        }
        throw new SQLException("Failed to create cart for user ID " + userId);
    }

    public List<PanierProduit> getCartItems(int panierId) throws SQLException {
        String query = "SELECT pp.*, p.nom as prod_nom, p.description as prod_desc, p.prix as prod_prix, " +
                "p.image as prod_image, p.stock as prod_stock, p.marque as prod_marque, p.id_categorie, p.id_promotion, " +
                "c.nom as cat_nom, " +
                "pr.nom as promo_nom, pr.type as promo_type, pr.valeur as promo_valeur, pr.date_debut as promo_date_debut, pr.date_fin as promo_date_fin, pr.actif as promo_actif " +
                "FROM panier_produit pp " +
                "JOIN produit p ON pp.id_produit = p.id " +
                "LEFT JOIN categorie c ON p.id_categorie = c.id " +
                "LEFT JOIN promotion pr ON p.id_promotion = pr.id " +
                "WHERE pp.id_panier = ?";
        
        List<PanierProduit> list = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, panierId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PanierProduit pp = new PanierProduit(
                            rs.getInt("id_panier"),
                            rs.getInt("id_produit"),
                            rs.getInt("quantite")
                    );
                    
                    Produit p = new Produit();
                    p.setId(rs.getInt("id_produit"));
                    p.setNom(rs.getString("prod_nom"));
                    p.setDescription(rs.getString("prod_desc"));
                    p.setPrix(rs.getDouble("prod_prix"));
                    p.setImage(rs.getString("prod_image"));
                    p.setStock(rs.getInt("prod_stock"));
                    p.setMarque(rs.getString("prod_marque"));
                    
                    int catId = rs.getInt("id_categorie");
                    if (!rs.wasNull()) {
                        p.setIdCategorie(catId);
                        p.setCategorie(new Categorie(catId, rs.getString("cat_nom")));
                    }
                    
                    int promoId = rs.getInt("id_promotion");
                    if (!rs.wasNull()) {
                        p.setIdPromotion(promoId);
                        Promotion promo = new Promotion(
                                promoId,
                                rs.getString("promo_nom"),
                                rs.getString("promo_type"),
                                rs.getDouble("promo_valeur"),
                                rs.getDate("promo_date_debut"),
                                rs.getDate("promo_date_fin"),
                                rs.getBoolean("promo_actif")
                        );
                        p.setPromotion(promo);
                    }
                    
                    pp.setProduit(p);
                    list.add(pp);
                }
            }
        }
        return list;
    }

    public void addItem(int panierId, int productId, int quantity) throws SQLException {
        String checkQuery = "SELECT * FROM panier_produit WHERE id_panier = ? AND id_produit = ?";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(checkQuery)) {
            ps.setInt(1, panierId);
            ps.setInt(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Item already in cart, increment quantity
                    int existingQty = rs.getInt("quantite");
                    updateQuantity(panierId, productId, existingQty + quantity);
                    return;
                }
            }
        }
        
        // Add new item
        String insertQuery = "INSERT INTO panier_produit (id_panier, id_produit, quantite) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(insertQuery)) {
            ps.setInt(1, panierId);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);
            ps.executeUpdate();
        }
    }

    public void updateQuantity(int panierId, int productId, int quantity) throws SQLException {
        if (quantity <= 0) {
            removeItem(panierId, productId);
            return;
        }
        String query = "UPDATE panier_produit SET quantite = ? WHERE id_panier = ? AND id_produit = ?";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, quantity);
            ps.setInt(2, panierId);
            ps.setInt(3, productId);
            ps.executeUpdate();
        }
    }

    public void removeItem(int panierId, int productId) throws SQLException {
        String query = "DELETE FROM panier_produit WHERE id_panier = ? AND id_produit = ?";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, panierId);
            ps.setInt(2, productId);
            ps.executeUpdate();
        }
    }

    public void clearCart(int panierId) throws SQLException {
        String query = "DELETE FROM panier_produit WHERE id_panier = ?";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, panierId);
            ps.executeUpdate();
        }
    }
}
