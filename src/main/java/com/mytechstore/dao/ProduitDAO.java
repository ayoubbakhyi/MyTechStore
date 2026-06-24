package com.mytechstore.dao;

import com.mytechstore.config.DBConnection;
import com.mytechstore.model.Categorie;
import com.mytechstore.model.Produit;
import com.mytechstore.model.Promotion;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProduitDAO {

    public Produit create(Produit p) throws SQLException {
        String query = "INSERT INTO produit (nom, description, prix, image, stock, marque, id_categorie, id_promotion) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, p.getNom());
            ps.setString(2, p.getDescription());
            ps.setDouble(3, p.getPrix());
            ps.setString(4, p.getImage());
            ps.setInt(5, p.getStock());
            ps.setString(6, p.getMarque());
            if (p.getIdCategorie() != null && p.getIdCategorie() > 0) {
                ps.setInt(7, p.getIdCategorie());
            } else {
                ps.setNull(7, Types.INTEGER);
            }
            if (p.getIdPromotion() != null && p.getIdPromotion() > 0) {
                ps.setInt(8, p.getIdPromotion());
            } else {
                ps.setNull(8, Types.INTEGER);
            }
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    p.setId(rs.getInt(1));
                }
            }
        }
        return p;
    }

    public Produit getById(int id) throws SQLException {
        String query = "SELECT p.*, c.nom as cat_nom, " +
                "pr.nom as promo_nom, pr.type as promo_type, pr.valeur as promo_valeur, pr.date_debut as promo_date_debut, pr.date_fin as promo_date_fin, pr.actif as promo_actif " +
                "FROM produit p " +
                "LEFT JOIN categorie c ON p.id_categorie = c.id " +
                "LEFT JOIN promotion pr ON p.id_promotion = pr.id " +
                "WHERE p.id = ?";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public List<Produit> getAll() throws SQLException {
        String query = "SELECT p.*, c.nom as cat_nom, " +
                "pr.nom as promo_nom, pr.type as promo_type, pr.valeur as promo_valeur, pr.date_debut as promo_date_debut, pr.date_fin as promo_date_fin, pr.actif as promo_actif " +
                "FROM produit p " +
                "LEFT JOIN categorie c ON p.id_categorie = c.id " +
                "LEFT JOIN promotion pr ON p.id_promotion = pr.id " +
                "ORDER BY p.id DESC";
        List<Produit> list = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    public List<Produit> searchAndFilter(String keyword, Integer categoryId) throws SQLException {
        StringBuilder query = new StringBuilder(
                "SELECT p.*, c.nom as cat_nom, " +
                "pr.nom as promo_nom, pr.type as promo_type, pr.valeur as promo_valeur, pr.date_debut as promo_date_debut, pr.date_fin as promo_date_fin, pr.actif as promo_actif " +
                "FROM produit p " +
                "LEFT JOIN categorie c ON p.id_categorie = c.id " +
                "LEFT JOIN promotion pr ON p.id_promotion = pr.id " +
                "WHERE 1=1"
        );
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            query.append(" AND (p.nom LIKE ? OR p.description LIKE ? OR p.marque LIKE ?)");
        }
        if (categoryId != null && categoryId > 0) {
            query.append(" AND p.id_categorie = ?");
        }
        query.append(" ORDER BY p.id DESC");

        List<Produit> list = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query.toString())) {
            int paramIndex = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchPattern = "%" + keyword.trim() + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }
            if (categoryId != null && categoryId > 0) {
                ps.setInt(paramIndex++, categoryId);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public void update(Produit p) throws SQLException {
        String query = "UPDATE produit SET nom = ?, description = ?, prix = ?, image = ?, stock = ?, marque = ?, id_categorie = ?, id_promotion = ? WHERE id = ?";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, p.getNom());
            ps.setString(2, p.getDescription());
            ps.setDouble(3, p.getPrix());
            ps.setString(4, p.getImage());
            ps.setInt(5, p.getStock());
            ps.setString(6, p.getMarque());
            if (p.getIdCategorie() != null && p.getIdCategorie() > 0) {
                ps.setInt(7, p.getIdCategorie());
            } else {
                ps.setNull(7, Types.INTEGER);
            }
            if (p.getIdPromotion() != null && p.getIdPromotion() > 0) {
                ps.setInt(8, p.getIdPromotion());
            } else {
                ps.setNull(8, Types.INTEGER);
            }
            ps.setInt(9, p.getId());
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String query = "DELETE FROM produit WHERE id = ?";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public void updateStock(int id, int stock) throws SQLException {
        String query = "UPDATE produit SET stock = ? WHERE id = ?";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, stock);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }

    public int countProducts() throws SQLException {
        String query = "SELECT COUNT(*) FROM produit";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public List<Produit> getLowStockProducts() throws SQLException {
        String query = "SELECT p.*, c.nom as cat_nom, " +
                "pr.nom as promo_nom, pr.type as promo_type, pr.valeur as promo_valeur, pr.date_debut as promo_date_debut, pr.date_fin as promo_date_fin, pr.actif as promo_actif " +
                "FROM produit p " +
                "LEFT JOIN categorie c ON p.id_categorie = c.id " +
                "LEFT JOIN promotion pr ON p.id_promotion = pr.id " +
                "WHERE p.stock < 5 " +
                "ORDER BY p.stock ASC";
        List<Produit> list = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    public List<Produit> getRelatedProducts(int categoryId, int excludeId, int limit) throws SQLException {
        String query = "SELECT p.*, c.nom as cat_nom, " +
                "pr.nom as promo_nom, pr.type as promo_type, pr.valeur as promo_valeur, pr.date_debut as promo_date_debut, pr.date_fin as promo_date_fin, pr.actif as promo_actif " +
                "FROM produit p " +
                "LEFT JOIN categorie c ON p.id_categorie = c.id " +
                "LEFT JOIN promotion pr ON p.id_promotion = pr.id " +
                "WHERE p.id_categorie = ? AND p.id != ? " +
                "LIMIT ?";
        List<Produit> list = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, categoryId);
            ps.setInt(2, excludeId);
            ps.setInt(3, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    private Produit mapRow(ResultSet rs) throws SQLException {
        Produit p = new Produit();
        p.setId(rs.getInt("id"));
        p.setNom(rs.getString("nom"));
        p.setDescription(rs.getString("description"));
        p.setPrix(rs.getDouble("prix"));
        p.setImage(rs.getString("image"));
        p.setStock(rs.getInt("stock"));
        p.setMarque(rs.getString("marque"));
        
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

        return p;
    }
}
