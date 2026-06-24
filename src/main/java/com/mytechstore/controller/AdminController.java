package com.mytechstore.controller;

import com.mytechstore.dao.CategorieDAO;
import com.mytechstore.model.Categorie;
import com.mytechstore.model.Promotion;
import com.mytechstore.model.Utilisateur;
import com.mytechstore.service.CommandeService;
import com.mytechstore.service.ProduitService;
import com.mytechstore.service.PromotionService;
import com.mytechstore.service.UtilisateurService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;

@WebServlet(urlPatterns = {"/admin", "/admin/categories", "/admin/promotions"})
public class AdminController extends HttpServlet {
    private final CommandeService commandeService = new CommandeService();
    private final ProduitService produitService = new ProduitService();
    private final UtilisateurService utilisateurService = new UtilisateurService();
    private final CategorieDAO categorieDAO = new CategorieDAO();
    private final PromotionService promotionService = new PromotionService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdminAccess(request, response)) return;

        String path = request.getServletPath();

        try {
            if ("/admin".equals(path)) {
                // Fetch KPIs
                double revenue = commandeService.getTotalRevenue();
                int totalOrders = commandeService.countOrders();
                int totalProducts = produitService.countProducts();
                int totalClients = utilisateurService.countClients();
                
                request.setAttribute("revenue", revenue);
                request.setAttribute("totalOrders", totalOrders);
                request.setAttribute("totalProducts", totalProducts);
                request.setAttribute("totalClients", totalClients);
                request.setAttribute("recentOrders", commandeService.getRecentOrders(10));
                request.setAttribute("lowStockProducts", produitService.getLowStockProducts());

                request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
                return;
            }

            if ("/admin/categories".equals(path)) {
                request.setAttribute("categories", categorieDAO.getAll());
                request.getRequestDispatcher("/WEB-INF/views/admin/categories.jsp").forward(request, response);
                return;
            }

            if ("/admin/promotions".equals(path)) {
                String idParam = request.getParameter("id");
                String action = request.getParameter("action");
                
                if ("edit".equals(action) && idParam != null) {
                    int id = Integer.parseInt(idParam);
                    request.setAttribute("promotion", promotionService.getPromotionById(id));
                    request.getRequestDispatcher("/WEB-INF/views/admin/promotion-form.jsp").forward(request, response);
                } else if ("new".equals(action)) {
                    request.getRequestDispatcher("/WEB-INF/views/admin/promotion-form.jsp").forward(request, response);
                } else {
                    request.setAttribute("promotions", promotionService.getAllPromotions());
                    request.getRequestDispatcher("/WEB-INF/views/admin/promotions.jsp").forward(request, response);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdminAccess(request, response)) return;

        String path = request.getServletPath();
        String action = request.getParameter("action");

        try {
            if ("/admin/categories".equals(path)) {
                if ("add".equals(action)) {
                    String nom = request.getParameter("nom");
                    if (nom != null && !nom.trim().isEmpty()) {
                        Categorie c = new Categorie();
                        c.setNom(nom);
                        categorieDAO.create(c);
                    }
                } else if ("delete".equals(action)) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    categorieDAO.delete(id);
                }
                response.sendRedirect(request.getContextPath() + "/admin/categories");
                return;
            }

            if ("/admin/promotions".equals(path)) {
                if ("delete".equals(action)) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    promotionService.deletePromotion(id);
                    response.sendRedirect(request.getContextPath() + "/admin/promotions");
                    return;
                }
                
                // Add or Edit promotion
                String idParam = request.getParameter("id");
                String nom = request.getParameter("nom");
                String type = request.getParameter("type");
                double valeur = Double.parseDouble(request.getParameter("valeur"));
                Date dateDebut = Date.valueOf(request.getParameter("dateDebut"));
                Date dateFin = Date.valueOf(request.getParameter("dateFin"));
                boolean actif = request.getParameter("actif") != null;

                Promotion p = new Promotion();
                p.setNom(nom);
                p.setType(type);
                p.setValeur(valeur);
                p.setDateDebut(dateDebut);
                p.setDateFin(dateFin);
                p.setActif(actif);

                if (idParam != null && !idParam.trim().isEmpty()) {
                    p.setId(Integer.parseInt(idParam));
                    promotionService.updatePromotion(p);
                } else {
                    promotionService.createPromotion(p);
                }
                response.sendRedirect(request.getContextPath() + "/admin/promotions");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    private boolean checkAdminAccess(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=Veuillez vous connecter en tant qu'administrateur.");
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
