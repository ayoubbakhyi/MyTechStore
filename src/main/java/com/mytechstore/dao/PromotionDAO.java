package com.mytechstore.dao;

import com.mytechstore.config.DBConnection;
import com.mytechstore.model.Promotion;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PromotionDAO {

    public Promotion create(Promotion p) throws SQLException {
        String query = "INSERT INTO promotion (nom, type, valeur, date_debut, date_fin, actif) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, p.getNom());
            ps.setString(2, p.getType());
            ps.setDouble(3, p.getValeur());
            ps.setDate(4, p.getDateDebut());
            ps.setDate(5, p.getDateFin());
            ps.setBoolean(6, p.isActif());
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    p.setId(rs.getInt(1));
                }
            }
        }
        return p;
    }

    public Promotion getById(int id) throws SQLException {
        String query = "SELECT * FROM promotion WHERE id = ?";
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

    public List<Promotion> getAll() throws SQLException {
        String query = "SELECT * FROM promotion ORDER BY id DESC";
        List<Promotion> list = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    public void update(Promotion p) throws SQLException {
        String query = "UPDATE promotion SET nom = ?, type = ?, valeur = ?, date_debut = ?, date_fin = ?, actif = ? WHERE id = ?";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, p.getNom());
            ps.setString(2, p.getType());
            ps.setDouble(3, p.getValeur());
            ps.setDate(4, p.getDateDebut());
            ps.setDate(5, p.getDateFin());
            ps.setBoolean(6, p.isActif());
            ps.setInt(7, p.getId());
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String query = "DELETE FROM promotion WHERE id = ?";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    private Promotion mapRow(ResultSet rs) throws SQLException {
        return new Promotion(
                rs.getInt("id"),
                rs.getString("nom"),
                rs.getString("type"),
                rs.getDouble("valeur"),
                rs.getDate("date_debut"),
                rs.getDate("date_fin"),
                rs.getBoolean("actif")
        );
    }
}
