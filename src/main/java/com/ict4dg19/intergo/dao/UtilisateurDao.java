package com.ict4dg19.intergo.dao;

import com.ict4dg19.intergo.model.Role;
import com.ict4dg19.intergo.model.Utilisateur;
import java.sql.SQLException;

public interface UtilisateurDao {

    // Utile pour l'inscription (Création de compte)
    boolean inscrire(Utilisateur utilisateur) throws SQLException;

    // Utile pour la connexion
    Utilisateur trouverParEmail(String email) throws SQLException;

    // Utile pour résoudre un rôle par son nom (ex: "ADMIN", "RH", "MANAGER", "EMPLOYE")
    // Retourne null si le rôle n'existe pas en base de données.
    Role trouverRoleParNom(String nom) throws SQLException;
}

