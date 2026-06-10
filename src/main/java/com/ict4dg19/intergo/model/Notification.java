package com.ict4dg19.intergo.model;

import java.time.LocalDateTime;

public class Notification {
    private Long id;
    private String expediteur;
    private String destinataire;
    private String sujet;
    private String message;
    private LocalDateTime dateEnvoi;
    private boolean lu;

    public Notification() {}

    public Notification(Long id, String expediteur, String destinataire, String sujet, String message, LocalDateTime dateEnvoi, boolean lu) {
        this.id = id;
        this.expediteur = expediteur;
        this.destinataire = destinataire;
        this.sujet = sujet;
        this.message = message;
        this.dateEnvoi = dateEnvoi;
        this.lu = lu;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getExpediteur() {
        return expediteur;
    }

    public void setExpediteur(String expediteur) {
        this.expediteur = expediteur;
    }

    public String getDestinataire() {
        return destinataire;
    }

    public void setDestinataire(String destinataire) {
        this.destinataire = destinataire;
    }

    public String getSujet() {
        return sujet;
    }

    public void setSujet(String sujet) {
        this.sujet = sujet;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public LocalDateTime getDateEnvoi() {
        return dateEnvoi;
    }

    public void setDateEnvoi(LocalDateTime dateEnvoi) {
        this.dateEnvoi = dateEnvoi;
    }

    public boolean isLu() {
        return lu;
    }

    public void setLu(boolean lu) {
        this.lu = lu;
    }
}
