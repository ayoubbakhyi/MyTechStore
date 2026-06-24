package com.mytechstore.controller;

import com.mytechstore.model.Commande;
import com.mytechstore.model.Utilisateur;
import com.mytechstore.service.CommandeService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(urlPatterns = {"/admin/commandes"})
public class AdminCommandeController extends HttpServlet {
    private final CommandeService commandeService = new CommandeService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdminAccess(request, response)) return;

        String idParam = request.getParameter("id");
        try {
            if (idParam != null && !idParam.trim().isEmpty()) {
                int id = Integer.parseInt(idParam);
                Commande c = commandeService.getOrderById(id);
                if (c == null) {
                    response.sendRedirect(request.getContextPath() + "/admin/commandes");
                    return;
                }
                request.setAttribute("commande", c);
                request.getRequestDispatcher("/WEB-INF/views/admin/commande-detail.jsp").forward(request, response);
            } else {
                request.setAttribute("commandes", commandeService.getAllOrders());
                request.getRequestDispatcher("/WEB-INF/views/admin/commandes.jsp").forward(request, response);
            }
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

        if (idParam != null && status != null) {
            try {
                int id = Integer.parseInt(idParam);
                commandeService.updateOrderStatus(id, status);
                response.sendRedirect(request.getContextPath() + "/admin/commandes?id=" + id + "&success=Statut mis a jour.");
            } catch (SQLException e) {
                e.printStackTrace();
                throw new ServletException(e);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/commandes");
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
