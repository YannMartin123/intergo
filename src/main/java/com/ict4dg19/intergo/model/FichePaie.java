package com.ict4dg19.intergo.model;

import java.math.BigDecimal;

public class FichePaie {
    private Long id;
    private Long employeId;
    private Employe employe;
    private String mois;
    private BigDecimal salaireBase;
    private BigDecimal heuresSup;
    private BigDecimal montantHeuresSup;
    private BigDecimal primes;
    private BigDecimal retenues;
    private BigDecimal salaireBrut;
    private BigDecimal salaireNet;

    public FichePaie() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getEmployeId() { return employeId; }
    public void setEmployeId(Long employeId) { this.employeId = employeId; }
    public Employe getEmploye() { return employe; }
    public void setEmploye(Employe employe) { this.employe = employe; }
    public String getMois() { return mois; }
    public void setMois(String mois) { this.mois = mois; }
    public BigDecimal getSalaireBase() { return salaireBase; }
    public void setSalaireBase(BigDecimal salaireBase) { this.salaireBase = salaireBase; }
    public BigDecimal getHeuresSup() { return heuresSup; }
    public void setHeuresSup(BigDecimal heuresSup) { this.heuresSup = heuresSup; }
    public BigDecimal getMontantHeuresSup() { return montantHeuresSup; }
    public void setMontantHeuresSup(BigDecimal montantHeuresSup) { this.montantHeuresSup = montantHeuresSup; }
    public BigDecimal getPrimes() { return primes; }
    public void setPrimes(BigDecimal primes) { this.primes = primes; }
    public BigDecimal getRetenues() { return retenues; }
    public void setRetenues(BigDecimal retenues) { this.retenues = retenues; }
    public BigDecimal getSalaireBrut() { return salaireBrut; }
    public void setSalaireBrut(BigDecimal salaireBrut) { this.salaireBrut = salaireBrut; }
    public BigDecimal getSalaireNet() { return salaireNet; }
    public void setSalaireNet(BigDecimal salaireNet) { this.salaireNet = salaireNet; }
}
