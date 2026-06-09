package com.mytechstore.controller;

import com.mytechstore.dao.CategorieDAO;
import com.mytechstore.model.Categorie;
import com.mytechstore.model.Produit;
import com.mytechstore.service.ProduitService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(urlPatterns = {"/catalogue", "/produit"})
public class CatalogueController extends HttpServlet {
    private final ProduitService produitService = new ProduitService();
    private final CategorieDAO categorieDAO = new CategorieDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        try {
            if ("/catalogue".equals(path)) {
                String search = request.getParameter("search");
                String catParam = request.getParameter("category");
                Integer categoryId = null;
                
                if (catParam != null && !catParam.trim().isEmpty()) {
                    try {
                        categoryId = Integer.parseInt(catParam);
                    } catch (NumberFormatException e) {
                        // Ignore invalid category ID format
                    }
                }

                List<Produit> list = produitService.getProducts(search, categoryId);
                List<Categorie> categories = categorieDAO.getAll();

                request.setAttribute("produits", list);
                request.setAttribute("categories", categories);
                request.setAttribute("searchVal", search);
                request.setAttribute("selectedCat", categoryId);

                request.getRequestDispatcher("/WEB-INF/views/client/catalogue.jsp").forward(request, response);
                return;
            }

            if ("/produit".equals(path)) {
                String idParam = request.getParameter("id");
                if (idParam == null || idParam.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/catalogue");
                    return;
                }

                int id = Integer.parseInt(idParam);
                Produit p = produitService.getProductById(id);

                if (p == null) {
                    response.sendRedirect(request.getContextPath() + "/catalogue");
                    return;
                }

                // Related products (same category, excluding current product, limit to 4)
                List<Produit> related = null;
                if (p.getIdCategorie() != null) {
                    related = produitService.getRelatedProducts(p.getIdCategorie(), p.getId(), 4);
                }

                request.setAttribute("produit", p);
                request.setAttribute("relatedProduits", related);
                request.getRequestDispatcher("/WEB-INF/views/client/produit-detail.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
}
