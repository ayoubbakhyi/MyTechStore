package com.mytechstore.controller;

import com.mytechstore.dao.CategorieDAO;
import com.mytechstore.model.Produit;
import com.mytechstore.model.Utilisateur;
import com.mytechstore.service.ProduitService;
import com.mytechstore.service.PromotionService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.SQLException;

@WebServlet(urlPatterns = {"/admin/produits"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AdminProduitController extends HttpServlet {
    private final ProduitService produitService = new ProduitService();
    private final CategorieDAO categorieDAO = new CategorieDAO();
    private final PromotionService promotionService = new PromotionService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdminAccess(request, response)) return;

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        try {
            if ("edit".equals(action) && idParam != null) {
                int id = Integer.parseInt(idParam);
                Produit p = produitService.getProductById(id);
                request.setAttribute("produit", p);
                request.setAttribute("categories", categorieDAO.getAll());
                request.setAttribute("promotions", promotionService.getAllPromotions());
                request.getRequestDispatcher("/WEB-INF/views/admin/produit-form.jsp").forward(request, response);
                return;
            }

            if ("new".equals(action)) {
                request.setAttribute("categories", categorieDAO.getAll());
                request.setAttribute("promotions", promotionService.getAllPromotions());
                request.getRequestDispatcher("/WEB-INF/views/admin/produit-form.jsp").forward(request, response);
                return;
            }

            // List products
            request.setAttribute("produits", produitService.getAllProducts());
            request.getRequestDispatcher("/WEB-INF/views/admin/produits.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdminAccess(request, response)) return;

        String action = request.getParameter("action");
        
        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                produitService.deleteProduct(id);
                response.sendRedirect(request.getContextPath() + "/admin/produits");
                return;
            }

            // Add or Edit product
            String idParam = request.getParameter("id");
            String nom = request.getParameter("nom");
            String description = request.getParameter("description");
            double prix = Double.parseDouble(request.getParameter("prix"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            String marque = request.getParameter("marque");
            
            String catParam = request.getParameter("idCategorie");
            Integer idCategorie = (catParam != null && !catParam.trim().isEmpty() && !"-1".equals(catParam)) ? Integer.parseInt(catParam) : null;
            
            String promoParam = request.getParameter("idPromotion");
            Integer idPromotion = (promoParam != null && !promoParam.trim().isEmpty() && !"-1".equals(promoParam)) ? Integer.parseInt(promoParam) : null;

            // Handle file upload
            String image = null;
            try {
                Part filePart = request.getPart("imageFile");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    String uploadPath = request.getServletContext().getRealPath("/static/images");
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    filePart.write(uploadPath + File.separator + fileName);
                    image = fileName;
                }
            } catch (Exception e) {
                System.err.println("Error uploading file: " + e.getMessage());
            }

            if (image == null) {
                String hiddenImage = request.getParameter("image");
                image = (hiddenImage != null && !hiddenImage.trim().isEmpty()) ? hiddenImage : "default.png";
            }

            Produit p = new Produit();
            p.setNom(nom);
            p.setDescription(description);
            p.setPrix(prix);
            p.setImage(image);
            p.setStock(stock);
            p.setMarque(marque);
            p.setIdCategorie(idCategorie);
            p.setIdPromotion(idPromotion);

            if (idParam != null && !idParam.trim().isEmpty()) {
                p.setId(Integer.parseInt(idParam));
                produitService.updateProduct(p);
            } else {
                produitService.createProduct(p);
            }

            response.sendRedirect(request.getContextPath() + "/admin/produits");
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    private boolean checkAdminAccess(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        Utilisateur u = (Utilisateur) session.getAttribute("user");
        if (!"ADMIN".equals(u.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès refusé.");
            return false;
        }
        return true;
    }
}
