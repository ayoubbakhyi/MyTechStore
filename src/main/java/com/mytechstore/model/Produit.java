package com.mytechstore.model;

public class Produit {
    private int id;
    private String nom;
    private String description;
    private double prix;
    private String image;
    private int stock;
    private String marque;
    private Integer idCategorie; // Nullable
    private Integer idPromotion; // Nullable
    
    // Associations
    private Categorie categorie;
    private Promotion promotion;

    public Produit() {
    }

    public Produit(int id, String nom, String description, double prix, String image, int stock, String marque, Integer idCategorie, Integer idPromotion) {
        this.id = id;
        this.nom = nom;
        this.description = description;
        this.prix = prix;
        this.image = image;
        this.stock = stock;
        this.marque = marque;
        this.idCategorie = idCategorie;
        this.idPromotion = idPromotion;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrix() {
        return prix;
    }

    public void setPrix(double prix) {
        this.prix = prix;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public String getMarque() {
        return marque;
    }

    public void setMarque(String marque) {
        this.marque = marque;
    }

    public Integer getIdCategorie() {
        return idCategorie;
    }

    public void setIdCategorie(Integer idCategorie) {
        this.idCategorie = idCategorie;
    }

    public Integer getIdPromotion() {
        return idPromotion;
    }

    public void setIdPromotion(Integer idPromotion) {
        this.idPromotion = idPromotion;
    }

    public Categorie getCategorie() {
        return categorie;
    }

    public void setCategorie(Categorie categorie) {
        this.categorie = categorie;
    }

    public Promotion getPromotion() {
        return promotion;
    }

    public void setPromotion(Promotion promotion) {
        this.promotion = promotion;
    }

    // Business helper: calculate effective price based on active promotion
    public double getPrixEffectif() {
        if (promotion != null && promotion.isPromoValide()) {
            if ("POURCENTAGE".equalsIgnoreCase(promotion.getType())) {
                double discount = prix * (promotion.getValeur() / 100.0);
                return Math.max(0, prix - discount);
            } else if ("PRIX_FIXE".equalsIgnoreCase(promotion.getType())) {
                return Math.max(0, prix - promotion.getValeur());
            }
        }
        return prix;
    }

    public boolean isEnPromotion() {
        return promotion != null && promotion.isPromoValide();
    }

    @Override
    public String toString() {
        return "Produit{" +
                "id=" + id +
                ", nom='" + nom + '\'' +
                ", prix=" + prix +
                ", stock=" + stock +
                ", marque='" + marque + '\'' +
                '}';
    }
}
