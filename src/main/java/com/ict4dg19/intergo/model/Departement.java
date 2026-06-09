package com.ict4dg19.intergo.model;

import java.math.BigDecimal;

public class Departement {
    private Long id;
    private String nom;
    private String responsable;
    private BigDecimal budgetMasseSalariale;

    public Departement() {}

    public Departement(Long id, String nom, String responsable, BigDecimal budgetMasseSalariale) {
        this.id = id;
        this.nom = nom;
        this.responsable = responsable;
        this.budgetMasseSalariale = budgetMasseSalariale;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    
    public String getResponsable() { return responsable; }
    public void setResponsable(String responsable) { this.responsable = responsable; }
    
    public BigDecimal getBudgetMasseSalariale() { return budgetMasseSalariale; }
    public void setBudgetMasseSalariale(BigDecimal budgetMasseSalariale) { this.budgetMasseSalariale = budgetMasseSalariale; }
}
