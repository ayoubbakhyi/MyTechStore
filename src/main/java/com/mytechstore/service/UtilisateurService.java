package com.mytechstore.service;

import com.mytechstore.dao.UtilisateurDAO;
import com.mytechstore.model.Utilisateur;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.SQLException;
import java.util.List;

public class UtilisateurService {
    private final UtilisateurDAO utilisateurDAO = new UtilisateurDAO();

    public Utilisateur register(Utilisateur u) throws SQLException, IllegalArgumentException {
        if (utilisateurDAO.getByEmail(u.getEmail()) != null) {
            throw new IllegalArgumentException("Un utilisateur avec cet e-mail existe déjà.");
        }
        // Hash password
        String hashedPassword = BCrypt.hashpw(u.getMotDePasse(), BCrypt.gensalt(10));
        u.setMotDePasse(hashedPassword);
        return utilisateurDAO.create(u);
    }

    public Utilisateur login(String email, String password) throws SQLException {
        Utilisateur u = utilisateurDAO.getByEmail(email);
        if (u != null && BCrypt.checkpw(password, u.getMotDePasse())) {
            return u;
        }
        return null;
    }

    public int countClients() throws SQLException {
        return utilisateurDAO.countClients();
    }

    public List<Utilisateur> getAllUsers() throws SQLException {
        return utilisateurDAO.getAll();
    }

    public Utilisateur getUserById(int id) throws SQLException {
        return utilisateurDAO.getById(id);
    }

    public void updateUser(Utilisateur u, boolean updatePassword) throws SQLException {
        if (updatePassword) {
            String hashedPassword = BCrypt.hashpw(u.getMotDePasse(), BCrypt.gensalt(10));
            u.setMotDePasse(hashedPassword);
        } else {
            Utilisateur existing = utilisateurDAO.getById(u.getId());
            if (existing != null) {
                u.setMotDePasse(existing.getMotDePasse());
            }
        }
        utilisateurDAO.update(u);
    }

    public void deleteUser(int id) throws SQLException {
        utilisateurDAO.delete(id);
    }
}
