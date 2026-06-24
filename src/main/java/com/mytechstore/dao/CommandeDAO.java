package com.mytechstore.dao;

import com.mytechstore.config.DBConnection;
import com.mytechstore.model.Commande;
import com.mytechstore.model.Utilisateur;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommandeDAO {

    public Commande create(Commande c) throws SQLException {
        String query = "INSERT INTO commande (statut, total, id_utilisateur) VALUES (?, ?, ?)";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, c.getStatut() != null ? c.getStatut() : "EN_ATTENTE");
            ps.setDouble(2, c.getTotal());
            ps.setInt(3, c.getIdUtilisateur());
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    c.setId(rs.getInt(1));
                }
            }
        }
        return c;
    }

    public Commande getById(int id) throws SQLException {
        String query = "SELECT c.*, u.nom as user_nom, u.email as user_email " +
                "FROM commande c " +
                "JOIN utilisateur u ON c.id_utilisateur = u.id " +
                "WHERE c.id = ?";
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

    public List<Commande> getAll() throws SQLException {
        String query = "SELECT c.*, u.nom as user_nom, u.email as user_email " +
                "FROM commande c " +
                "JOIN utilisateur u ON c.id_utilisateur = u.id " +
                "ORDER BY c.date_commande DESC";
        List<Commande> list = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    public List<Commande> getByUserId(int userId) throws SQLException {
        String query = "SELECT c.*, u.nom as user_nom, u.email as user_email " +
                "FROM commande c " +
                "JOIN utilisateur u ON c.id_utilisateur = u.id " +
                "WHERE c.id_utilisateur = ? " +
                "ORDER BY c.date_commande DESC";
        List<Commande> list = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public void updateStatus(int id, String status) throws SQLException {
        String query = "UPDATE commande SET statut = ? WHERE id = ?";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }

    public void updateTotal(int id, double total) throws SQLException {
        String query = "UPDATE commande SET total = ? WHERE id = ?";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setDouble(1, total);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }

    public int countOrders() throws SQLException {
        String query = "SELECT COUNT(*) FROM commande";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public double getTotalRevenue() throws SQLException {
        String query = "SELECT SUM(total) FROM commande WHERE statut != 'ANNULEE'";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        }
        return 0.0;
    }

    public List<Commande> getRecentOrders(int limit) throws SQLException {
        String query = "SELECT c.*, u.nom as user_nom, u.email as user_email " +
                "FROM commande c " +
                "JOIN utilisateur u ON c.id_utilisateur = u.id " +
                "ORDER BY c.date_commande DESC LIMIT ?";
        List<Commande> list = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    private Commande mapRow(ResultSet rs) throws SQLException {
        Commande c = new Commande(
                rs.getInt("id"),
                rs.getTimestamp("date_commande"),
                rs.getString("statut"),
                rs.getDouble("total"),
                rs.getInt("id_utilisateur")
        );
        
        Utilisateur u = new Utilisateur();
        u.setId(rs.getInt("id_utilisateur"));
        u.setNom(rs.getString("user_nom"));
        u.setEmail(rs.getString("user_email"));
        c.setUtilisateur(u);
        
        return c;
    }
}
