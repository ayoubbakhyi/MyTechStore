package com.mytechstore.controller;

import com.mytechstore.model.Livraison;
import com.mytechstore.model.Utilisateur;
import com.mytechstore.service.LivraisonService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;

@WebServlet(urlPatterns = {"/admin/livraisons"})
public class AdminLivraisonController extends HttpServlet {
    private final LivraisonService livraisonService = new LivraisonService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdminAccess(request, response)) return;

        try {
            request.setAttribute("livraisons", livraisonService.getAllDeliveries());
            request.getRequestDispatcher("/WEB-INF/views/admin/livraisons.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdminAccess(request, response)) return;

        String idParam = request.getParameter("id");
        String status = request.getParameter("statut");
        String dateExpParam = request.getParameter("dateExpedition");
        String dateLivParam = request.getParameter("dateLivraisonPrevue");

        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                if (status != null) {
                    livraisonService.updateDeliveryStatus(id, status);
                }
                
                if (dateExpParam != null && !dateExpParam.trim().isEmpty() &&
                    dateLivParam != null && !dateLivParam.trim().isEmpty()) {
                    Date dateExp = Date.valueOf(dateExpParam);
                    Date dateLiv = Date.valueOf(dateLivParam);
                    livraisonService.updateDeliveryDates(id, dateExp, dateLiv);
                }
                
                response.sendRedirect(request.getContextPath() + "/admin/livraisons?success=Livraison mise a jour.");
            } catch (SQLException | IllegalArgumentException e) {
                e.printStackTrace();
                throw new ServletException(e);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/livraisons");
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
