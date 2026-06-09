package com.mytechstore.dao;

import com.mytechstore.config.DBConnection;
import com.mytechstore.model.LigneCommande;
import com.mytechstore.model.Produit;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LigneCommandeDAO {

    public LigneCommande create(LigneCommande lc) throws SQLException {
        String query = "INSERT INTO ligne_commande (id_commande, id_produit, quantite, prix_unitaire) VALUES (?, ?, ?, ?)";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, lc.getIdCommande());
            ps.setInt(2, lc.getIdProduit());
            ps.setInt(3, lc.getQuantite());
            ps.setDouble(4, lc.getPrixUnitaire());
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    lc.setId(rs.getInt(1));
                }
            }
        }
        return lc;
    }

    public List<LigneCommande> getByCommandeId(int commandeId) throws SQLException {
        String query = "SELECT lc.*, p.nom as prod_nom, p.image as prod_image, p.marque as prod_marque " +
                "FROM ligne_commande lc " +
                "JOIN produit p ON lc.id_produit = p.id " +
                "WHERE lc.id_commande = ?";
        List<LigneCommande> list = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, commandeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LigneCommande lc = new LigneCommande(
                            rs.getInt("id"),
                            rs.getInt("id_commande"),
                            rs.getInt("id_produit"),
                            rs.getInt("quantite"),
                            rs.getDouble("prix_unitaire")
                    );
                    
                    Produit p = new Produit();
                    p.setId(rs.getInt("id_produit"));
                    p.setNom(rs.getString("prod_nom"));
                    p.setImage(rs.getString("prod_image"));
                    p.setMarque(rs.getString("prod_marque"));
                    lc.setProduit(p);
                    
                    list.add(lc);
                }
            }
        }
        return list;
    }
}
