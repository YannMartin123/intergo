package com.ict4dg19.intergo.model;

import java.util.ArrayList;
import java.util.List;

public class Utilisateur {
    private Long id;
    private String email;
    private String motDePasse;
    private boolean estActif;
    private Long employeId; // Peut être null si c'est un admin pur
    private List<Role> roles = new ArrayList<>();

    public Utilisateur() {}

    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getMotDePasse() { return motDePasse; }
    public void setMotDePasse(String motDePasse) { this.motDePasse = motDePasse; }
    public boolean isEstActif() { return estActif; }
    public void setEstActif(boolean estActif) { this.estActif = estActif; }
    public Long getEmployeId() { return employeId; }
    public void setEmployeId(Long employeId) { this.employeId = employeId; }
    public List<Role> getRoles() { return roles; }
    public void setRoles(List<Role> roles) { this.roles = roles; }
}
