package com.ict4dg19.intergo.dao;

import com.ict4dg19.intergo.model.Role;
import com.ict4dg19.intergo.model.Utilisateur;
import com.ict4dg19.intergo.util.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UtilisateurDaoImpl implements UtilisateurDao {

    @Override
    public boolean inscrire(Utilisateur utilisateur) throws SQLException {
        String sqlUser = "INSERT INTO utilisateur (email, mot_de_passe, est_actif, employe_id) VALUES (?, ?, ?, ?)";
        String sqlRole = "INSERT INTO utilisateur_roles (utilisateur_id, role_id) VALUES (?, ?)";
        
        Connection conn = null;
        PreparedStatement psUser = null;
        PreparedStatement psRole = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Début de la transaction

            // 1. Hachage sécurisé du mot de passe avec jBCrypt
            String passwordHache = BCrypt.hashpw(utilisateur.getMotDePasse(), BCrypt.gensalt());

            // 2. Insertion de l'utilisateur
            psUser = conn.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS);
            psUser.setString(1, utilisateur.getEmail());
            psUser.setString(2, passwordHache);
            psUser.setBoolean(3, utilisateur.isEstActif());
            if (utilisateur.getEmployeId() != null) {
                psUser.setLong(4, utilisateur.getEmployeId());
            } else {
                psUser.setNull(4, Types.BIGINT);
            }
            
            int rowsAffected = psUser.executeUpdate();
            if (rowsAffected == 0) {
                conn.rollback();
                return false;
            }

            // Récupération de l'ID généré
            ResultSet rsKeys = psUser.getGeneratedKeys();
            long userId = 0;
            if (rsKeys.next()) {
                userId = rsKeys.getLong(1);
            }

            // 3. Liaison avec les rôles (par défaut EMPLOYE si aucun rôle spécifié)
            psRole = conn.prepareStatement(sqlRole);
            if (utilisateur.getRoles().isEmpty()) {
                // Requête pour récupérer l'id du rôle 'EMPLOYE' dynamiquement
                long roleId = obtenirIdRoleParNom(conn, "EMPLOYE");
                psRole.setLong(1, userId);
                psRole.setLong(2, roleId);
                psRole.executeUpdate();
            } else {
                for (Role role : utilisateur.getRoles()) {
                    psRole.setLong(1, userId);
                    psRole.setLong(2, role.getId());
                    psRole.addBatch();
                }
                psRole.executeBatch();
            }

            conn.commit(); // Validation de la transaction
            return true;
            
        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (psUser != null) psUser.close();
            if (psRole != null) psRole.close();
            if (conn != null) conn.close();
        }
    }

    @Override
    public Utilisateur trouverParEmail(String email) throws SQLException {
        String sql = "SELECT u.*, r.id AS role_id, r.nom AS role_nom FROM utilisateur u " +
                     "LEFT JOIN utilisateur_roles ur ON u.id = ur.utilisateur_id " +
                     "LEFT JOIN role r ON ur.role_id = r.id " +
                     "WHERE u.email = ?";
                     
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                Utilisateur utilisateur = null;
                
                while (rs.next()) {
                    if (utilisateur == null) {
                        utilisateur = new Utilisateur();
                        utilisateur.setId(rs.getLong("id"));
                        utilisateur.setEmail(rs.getString("email"));
                        utilisateur.setMotDePasse(rs.getString("mot_de_passe"));
                        utilisateur.setEstActif(rs.getBoolean("est_actif"));
                        utilisateur.setEmployeId(rs.getObject("employe_id") != null ? rs.getLong("employe_id") : null);
                    }
                    
                    // On charge la liste des rôles associés à cet utilisateur
                    long roleId = rs.getLong("role_id");
                    if (roleId > 0) {
                        Role role = new Role(roleId, rs.getString("role_nom"));
                        utilisateur.getRoles().add(role);
                    }
                }
                return utilisateur;
            }
        }
    }

    // Méthode utilitaire interne pour éviter les IDs en dur
    private long obtenirIdRoleParNom(Connection conn, String nomRole) throws SQLException {
        String sql = "SELECT id FROM role WHERE nom = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nomRole);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getLong("id");
            }
        }
        throw new SQLException("Le rôle " + nomRole + " n'existe pas en base de données.");
    }

    /**
     * Recherche un rôle par son nom (ex: "ADMIN", "RH", "MANAGER", "EMPLOYE").
     * Utilisé par RegisterServlet pour résoudre l'ID du rôle demandé par l'utilisateur.
     *
     * @param nom Le nom exact du rôle tel qu'il est stocké en base de données.
     * @return L'objet Role correspondant, ou null si le rôle est introuvable.
     */
    @Override
    public Role trouverRoleParNom(String nom) throws SQLException {
        String sql = "SELECT id, nom FROM role WHERE nom = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nom);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Role(rs.getLong("id"), rs.getString("nom"));
                }
            }
        }
        return null; // Rôle introuvable — le servlet gèrera ce cas
    }
}