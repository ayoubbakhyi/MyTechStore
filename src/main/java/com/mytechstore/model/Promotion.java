package com.mytechstore.model;

import java.sql.Date;

public class Promotion {
    private int id;
    private String nom;
    private String type; // 'POURCENTAGE' or 'PRIX_FIXE'
    private double valeur;
    private Date dateDebut;
    private Date dateFin;
    private boolean actif;

    public Promotion() {
    }

    public Promotion(int id, String nom, String type, double valeur, Date dateDebut, Date dateFin, boolean actif) {
        this.id = id;
        this.nom = nom;
        this.type = type;
        this.valeur = valeur;
        this.dateDebut = dateDebut;
        this.dateFin = dateFin;
        this.actif = actif;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public double getValeur() {
        return valeur;
    }

    public void setValeur(double valeur) {
        this.valeur = valeur;
    }

    public Date getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(Date dateDebut) {
        this.dateDebut = dateDebut;
    }

    public Date getDateFin() {
        return dateFin;
    }

    public void setDateFin(Date dateFin) {
        this.dateFin = dateFin;
    }

    public boolean isActif() {
        return actif;
    }

    public void setActif(boolean actif) {
        this.actif = actif;
    }

    // Business helper to check if the promo is currently active
    public boolean isPromoValide() {
        if (!actif) return false;
        long now = System.currentTimeMillis();
        Date currentDate = new Date(now);
        return (currentDate.equals(dateDebut) || currentDate.after(dateDebut)) && 
               (currentDate.equals(dateFin) || currentDate.before(dateFin));
    }

    @Override
    public String toString() {
        return "Promotion{" +
                "id=" + id +
                ", nom='" + nom + '\'' +
                ", type='" + type + '\'' +
                ", valeur=" + valeur +
                ", dateDebut=" + dateDebut +
                ", dateFin=" + dateFin +
                ", actif=" + actif +
                '}';
    }
}
