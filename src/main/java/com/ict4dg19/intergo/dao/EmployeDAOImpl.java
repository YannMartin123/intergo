package com.ict4dg19.intergo.dao;

import com.ict4dg19.intergo.model.Employe;
import com.ict4dg19.intergo.model.Departement;
import com.ict4dg19.intergo.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeDAOImpl implements EmployeDAO {

    @Override
    public void create(Employe employe) {
        String sql = "INSERT INTO employe (matricule, nom, prenom, poste, departement_id, date_embauche, salaire_base, type_contrat, telephone, email, photo_filename, solde_conges_jours) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, employe.getMatricule());
            stmt.setString(2, employe.getNom());
            stmt.setString(3, employe.getPrenom());
            stmt.setString(4, employe.getPoste());
            stmt.setLong(5, employe.getDepartementId());
            stmt.setDate(6, Date.valueOf(employe.getDateEmbauche()));
            stmt.setBigDecimal(7, employe.getSalaireBase());
            stmt.setString(8, employe.getTypeContrat());
            stmt.setString(9, employe.getTelephone());
            stmt.setString(10, employe.getEmail());
            stmt.setString(11, employe.getPhotoFilename());
            stmt.setInt(12, employe.getSoldeCongesJours());
            stmt.executeUpdate();
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    employe.setId(generatedKeys.getLong(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Employe findById(Long id) {
        String sql = "SELECT e.*, d.nom AS dept_nom, d.responsable AS dept_resp FROM employe e JOIN departement d ON e.departement_id = d.id WHERE e.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractEmploye(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Employe findByEmail(String email) {
        String sql = "SELECT e.*, d.nom AS dept_nom, d.responsable AS dept_resp FROM employe e JOIN departement d ON e.departement_id = d.id WHERE e.email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractEmploye(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Employe> findAll() {
        List<Employe> employes = new ArrayList<>();
        String sql = "SELECT e.*, d.nom AS dept_nom, d.responsable AS dept_resp FROM employe e JOIN departement d ON e.departement_id = d.id";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                employes.add(extractEmploye(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return employes;
    }

    @Override
    public void update(Employe employe) {
        String sql = "UPDATE employe SET matricule=?, nom=?, prenom=?, poste=?, departement_id=?, date_embauche=?, salaire_base=?, type_contrat=?, telephone=?, email=?, photo_filename=?, solde_conges_jours=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, employe.getMatricule());
            stmt.setString(2, employe.getNom());
            stmt.setString(3, employe.getPrenom());
            stmt.setString(4, employe.getPoste());
            stmt.setLong(5, employe.getDepartementId());
            stmt.setDate(6, Date.valueOf(employe.getDateEmbauche()));
            stmt.setBigDecimal(7, employe.getSalaireBase());
            stmt.setString(8, employe.getTypeContrat());
            stmt.setString(9, employe.getTelephone());
            stmt.setString(10, employe.getEmail());
            stmt.setString(11, employe.getPhotoFilename());
            stmt.setInt(12, employe.getSoldeCongesJours());
            stmt.setLong(13, employe.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(Long id) {
        String sql = "DELETE FROM employe WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public int countTotalEmployes() {
        String sql = "SELECT COUNT(*) FROM employe";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Employe extractEmploye(ResultSet rs) throws SQLException {
        Employe employe = new Employe();
        employe.setId(rs.getLong("id"));
        employe.setMatricule(rs.getString("matricule"));
        employe.setNom(rs.getString("nom"));
        employe.setPrenom(rs.getString("prenom"));
        employe.setPoste(rs.getString("poste"));
        employe.setDepartementId(rs.getLong("departement_id"));
        if(rs.getDate("date_embauche") != null) {
            employe.setDateEmbauche(rs.getDate("date_embauche").toLocalDate());
        }
        employe.setSalaireBase(rs.getBigDecimal("salaire_base"));
        employe.setTypeContrat(rs.getString("type_contrat"));
        employe.setTelephone(rs.getString("telephone"));
        employe.setEmail(rs.getString("email"));
        employe.setPhotoFilename(rs.getString("photo_filename"));
        employe.setSoldeCongesJours(rs.getInt("solde_conges_jours"));

        Departement dept = new Departement();
        dept.setId(rs.getLong("departement_id"));
        dept.setNom(rs.getString("dept_nom"));
        dept.setResponsable(rs.getString("dept_resp"));
        employe.setDepartement(dept);

        return employe;
    }
}
