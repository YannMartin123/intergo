package com.ict4dg19.intergo.model;

import java.math.BigDecimal;
import java.time.LocalDate;

public class ContratEmploye {
    private Long id;
    private Long employeId;
    private Employe employe;
    private String typeContrat;
    private LocalDate dateDebut;
    private LocalDate dateFin;
    private BigDecimal salaire;
    private String avantages;

    public ContratEmploye() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getEmployeId() { return employeId; }
    public void setEmployeId(Long employeId) { this.employeId = employeId; }
    public Employe getEmploye() { return employe; }
    public void setEmploye(Employe employe) { this.employe = employe; }
    public String getTypeContrat() { return typeContrat; }
    public void setTypeContrat(String typeContrat) { this.typeContrat = typeContrat; }
    public LocalDate getDateDebut() { return dateDebut; }
    public void setDateDebut(LocalDate dateDebut) { this.dateDebut = dateDebut; }
    public LocalDate getDateFin() { return dateFin; }
    public void setDateFin(LocalDate dateFin) { this.dateFin = dateFin; }
    public BigDecimal getSalaire() { return salaire; }
    public void setSalaire(BigDecimal salaire) { this.salaire = salaire; }
    public String getAvantages() { return avantages; }
    public void setAvantages(String avantages) { this.avantages = avantages; }
}
