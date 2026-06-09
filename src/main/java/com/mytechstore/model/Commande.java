package com.mytechstore.model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Commande {
    private int id;
    private Timestamp dateCommande;
    private String statut; // 'EN_ATTENTE', 'CONFIRMEE', 'EXPEDIEE', 'LIVREE', 'ANNULEE'
    private double total;
    private int idUtilisateur;
    
    // Associations
    private Utilisateur utilisateur;
    private List<LigneCommande> lignes = new ArrayList<>();
    private Livraison livraison;

    public Commande() {
    }

    public Commande(int id, Timestamp dateCommande, String statut, double total, int idUtilisateur) {
        this.id = id;
        this.dateCommande = dateCommande;
        this.statut = statut;
        this.total = total;
        this.idUtilisateur = idUtilisateur;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Timestamp getDateCommande() {
        return dateCommande;
    }

    public void setDateCommande(Timestamp dateCommande) {
        this.dateCommande = dateCommande;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public int getIdUtilisateur() {
        return idUtilisateur;
    }

    public void setIdUtilisateur(int idUtilisateur) {
        this.idUtilisateur = idUtilisateur;
    }

    public Utilisateur getUtilisateur() {
        return utilisateur;
    }

    public void setUtilisateur(Utilisateur utilisateur) {
        this.utilisateur = utilisateur;
    }

    public List<LigneCommande> getLignes() {
        return lignes;
    }

    public void setLignes(List<LigneCommande> lignes) {
        this.lignes = lignes;
    }

    public Livraison getLivraison() {
        return livraison;
    }

    public void setLivraison(Livraison livraison) {
        this.livraison = livraison;
    }

    @Override
    public String toString() {
        return "Commande{" +
                "id=" + id +
                ", dateCommande=" + dateCommande +
                ", statut='" + statut + '\'' +
                ", total=" + total +
                ", idUtilisateur=" + idUtilisateur +
                '}';
    }
}
