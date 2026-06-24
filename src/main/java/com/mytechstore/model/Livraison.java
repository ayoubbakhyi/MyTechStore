package com.mytechstore.model;

import java.sql.Date;

public class Livraison {
    private int id;
    private String adresse;
    private String ville;
    private String codePostal;
    private String statut; // 'EN_PREPARATION', 'EXPEDIEE', 'LIVREE'
    private Date dateExpedition;
    private Date dateLivraisonPrevue;
    private int idCommande;

    public Livraison() {
    }

    public Livraison(int id, String adresse, String ville, String codePostal, String statut, Date dateExpedition, Date dateLivraisonPrevue, int idCommande) {
        this.id = id;
        this.adresse = adresse;
        this.ville = ville;
        this.codePostal = codePostal;
        this.statut = statut;
        this.dateExpedition = dateExpedition;
        this.dateLivraisonPrevue = dateLivraisonPrevue;
        this.idCommande = idCommande;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

    public String getVille() {
        return ville;
    }

    public void setVille(String ville) {
        this.ville = ville;
    }

    public String getCodePostal() {
        return codePostal;
    }

    public void setCodePostal(String codePostal) {
        this.codePostal = codePostal;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public Date getDateExpedition() {
        return dateExpedition;
    }

    public void setDateExpedition(Date dateExpedition) {
        this.dateExpedition = dateExpedition;
    }

    public Date getDateLivraisonPrevue() {
        return dateLivraisonPrevue;
    }

    public void setDateLivraisonPrevue(Date dateLivraisonPrevue) {
        this.dateLivraisonPrevue = dateLivraisonPrevue;
    }

    public int getIdCommande() {
        return idCommande;
    }

    public void setIdCommande(int idCommande) {
        this.idCommande = idCommande;
    }

    @Override
    public String toString() {
        return "Livraison{" +
                "id=" + id +
                ", adresse='" + adresse + '\'' +
                ", statut='" + statut + '\'' +
                ", idCommande=" + idCommande +
                '}';
    }
}
