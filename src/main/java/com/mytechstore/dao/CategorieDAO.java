package com.mytechstore.dao;

import com.mytechstore.config.DBConnection;
import com.mytechstore.model.Categorie;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategorieDAO {

    public Categorie create(Categorie c) throws SQLException {
        String query = "INSERT INTO categorie (nom) VALUES (?)";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, c.getNom());
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    c.setId(rs.getInt(1));
                }
            }
        }
        return c;
    }

    public Categorie getById(int id) throws SQLException {
        String query = "SELECT * FROM categorie WHERE id = ?";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Categorie(rs.getInt("id"), rs.getString("nom"));
                }
            }
        }
        return null;
    }

    public List<Categorie> getAll() throws SQLException {
        String query = "SELECT * FROM categorie ORDER BY nom ASC";
        List<Categorie> list = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Categorie(rs.getInt("id"), rs.getString("nom")));
            }
        }
        return list;
    }

    public void update(Categorie c) throws SQLException {
        String query = "UPDATE categorie SET nom = ? WHERE id = ?";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, c.getNom());
            ps.setInt(2, c.getId());
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String query = "DELETE FROM categorie WHERE id = ?";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
}
