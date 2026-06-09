package com.mytechstore.service;

import com.mytechstore.dao.LivraisonDAO;
import com.mytechstore.model.Livraison;

import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

public class LivraisonService {
    private final LivraisonDAO livraisonDAO = new LivraisonDAO();

    public List<Livraison> getAllDeliveries() throws SQLException {
        return livraisonDAO.getAll();
    }

    public Livraison getDeliveryById(int id) throws SQLException {
        return livraisonDAO.getById(id);
    }

    public Livraison getDeliveryByOrderId(int orderId) throws SQLException {
        return livraisonDAO.getByCommandeId(orderId);
    }

    public void updateDeliveryStatus(int id, String status) throws SQLException {
        livraisonDAO.updateStatus(id, status);
    }

    public void updateDeliveryDates(int id, Date exp, Date prev) throws SQLException {
        livraisonDAO.updateDates(id, exp, prev);
    }
}
