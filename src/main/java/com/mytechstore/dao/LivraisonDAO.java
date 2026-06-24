package com.mytechstore.dao;

import com.mytechstore.config.DBConnection;
import com.mytechstore.model.Livraison;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LivraisonDAO {

    public Livraison create(Livraison l) throws SQLException {
        String query = "INSERT INTO livraison (adresse, ville, code_postal, statut, date_expedition, date_livraison_prevue, id_commande) VALUES (?, ?, ?, ?, ?, ?, ?)";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, l.getAdresse());
            ps.setString(2, l.getVille());
            ps.setString(3, l.getCodePostal());
            ps.setString(4, l.getStatut() != null ? l.getStatut() : "EN_PREPARATION");
            ps.setDate(5, l.getDateExpedition());
            ps.setDate(6, l.getDateLivraisonPrevue());
            ps.setInt(7, l.getIdCommande());
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    l.setId(rs.getInt(1));
                }
            }
        }
        return l;
    }

    public Livraison getById(int id) throws SQLException {
        String query = "SELECT * FROM livraison WHERE id = ?";
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

    public Livraison getByCommandeId(int commandeId) throws SQLException {
        String query = "SELECT * FROM livraison WHERE id_commande = ?";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, commandeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public List<Livraison> getAll() throws SQLException {
        String query = "SELECT * FROM livraison ORDER BY id DESC";
        List<Livraison> list = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    public void updateStatus(int id, String status) throws SQLException {
        String query = "UPDATE livraison SET statut = ? WHERE id = ?";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }

    public void updateDates(int id, Date dateExpedition, Date dateLivraisonPrevue) throws SQLException {
        String query = "UPDATE livraison SET date_expedition = ?, date_livraison_prevue = ? WHERE id = ?";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setDate(1, dateExpedition);
            ps.setDate(2, dateLivraisonPrevue);
            ps.setInt(3, id);
            ps.executeUpdate();
        }
    }

    private Livraison mapRow(ResultSet rs) throws SQLException {
        return new Livraison(
                rs.getInt("id"),
                rs.getString("adresse"),
                rs.getString("ville"),
                rs.getString("code_postal"),
                rs.getString("statut"),
                rs.getDate("date_expedition"),
                rs.getDate("date_livraison_prevue"),
                rs.getInt("id_commande")
        );
    }
}
