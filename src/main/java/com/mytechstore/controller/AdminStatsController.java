package com.mytechstore.controller;

import com.mytechstore.config.DBConnection;
import com.mytechstore.model.Utilisateur;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/admin/stats"})
public class AdminStatsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdminAccess(request, response)) return;

        // Fetch product distribution across categories
        String query = "SELECT c.nom, COUNT(p.id) as prod_count " +
                       "FROM categorie c " +
                       "LEFT JOIN produit p ON c.id = p.id_categorie " +
                       "GROUP BY c.id, c.nom " +
                       "ORDER BY prod_count DESC";
        
        List<Map<String, Object>> categoryStats = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            try (PreparedStatement ps = conn.prepareStatement(query);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> stat = new HashMap<>();
                    stat.put("categorie", rs.getString("nom"));
                    stat.put("count", rs.getInt("prod_count"));
                    categoryStats.add(stat);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("categoryStats", categoryStats);
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
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
