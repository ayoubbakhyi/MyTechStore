package com.mytechstore.service;

import com.mytechstore.dao.PromotionDAO;
import com.mytechstore.model.Promotion;

import java.sql.SQLException;
import java.util.List;

public class PromotionService {
    private final PromotionDAO promotionDAO = new PromotionDAO();

    public List<Promotion> getAllPromotions() throws SQLException {
        return promotionDAO.getAll();
    }

    public Promotion getPromotionById(int id) throws SQLException {
        return promotionDAO.getById(id);
    }

    public Promotion createPromotion(Promotion p) throws SQLException {
        return promotionDAO.create(p);
    }

    public void updatePromotion(Promotion p) throws SQLException {
        promotionDAO.update(p);
    }

    public void deletePromotion(int id) throws SQLException {
        promotionDAO.delete(id);
    }
}
