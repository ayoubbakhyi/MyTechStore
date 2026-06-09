package com.mytechstore.model;

import java.util.ArrayList;
import java.util.List;

public class Panier {
    private int id;
    private int idUtilisateur;
    
    // Associations
    private List<PanierProduit> items = new ArrayList<>();

    public Panier() {
    }

    public Panier(int id, int idUtilisateur) {
        this.id = id;
        this.idUtilisateur = idUtilisateur;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getIdUtilisateur() {
        return idUtilisateur;
    }

    public void setIdUtilisateur(int idUtilisateur) {
        this.idUtilisateur = idUtilisateur;
    }

    public List<PanierProduit> getItems() {
        return items;
    }

    public void setItems(List<PanierProduit> items) {
        this.items = items;
    }

    public double getTotal() {
        double total = 0.0;
        for (PanierProduit item : items) {
            if (item.getProduit() != null) {
                total += item.getProduit().getPrixEffectif() * item.getQuantite();
            }
        }
        return total;
    }

    @Override
    public String toString() {
        return "Panier{" +
                "id=" + id +
                ", idUtilisateur=" + idUtilisateur +
                '}';
    }
}
