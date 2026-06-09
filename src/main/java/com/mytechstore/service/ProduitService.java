package com.mytechstore.service;

import com.mytechstore.dao.ProduitDAO;
import com.mytechstore.model.Produit;

import java.sql.SQLException;
import java.util.List;

public class ProduitService {
    private final ProduitDAO produitDAO = new ProduitDAO();

    public List<Produit> getAllProducts() throws SQLException {
        return produitDAO.getAll();
    }

    public List<Produit> getProducts(String keyword, Integer categoryId) throws SQLException {
        return produitDAO.searchAndFilter(keyword, categoryId);
    }

    public Produit getProductById(int id) throws SQLException {
        return produitDAO.getById(id);
    }

    public Produit createProduct(Produit p) throws SQLException {
        return produitDAO.create(p);
    }

    public void updateProduct(Produit p) throws SQLException {
        produitDAO.update(p);
    }

    public void deleteProduct(int id) throws SQLException {
        produitDAO.delete(id);
    }

    public int countProducts() throws SQLException {
        return produitDAO.countProducts();
    }

    public List<Produit> getLowStockProducts() throws SQLException {
        return produitDAO.getLowStockProducts();
    }

    public List<Produit> getRelatedProducts(int categoryId, int excludeId, int limit) throws SQLException {
        return produitDAO.getRelatedProducts(categoryId, excludeId, limit);
    }

    public void updateStock(int id, int stock) throws SQLException {
        produitDAO.updateStock(id, stock);
    }
}
