package com.ict4dg19.intergo.dao;

import com.ict4dg19.intergo.model.Conge;
import com.ict4dg19.intergo.model.Employe;
import com.ict4dg19.intergo.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CongeDAOImpl implements CongeDAO {

    @Override
    public void create(Conge conge) {
        String sql = "INSERT INTO conge (employe_id, type_conge, date_debut, date_fin, nb_jours, motif, statut, approuve_par) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setLong(1, conge.getEmployeId());
            stmt.setString(2, conge.getTypeConge());
            stmt.setDate(3, Date.valueOf(conge.getDateDebut()));
            stmt.setDate(4, Date.valueOf(conge.getDateFin()));
            stmt.setInt(5, conge.getNbJours());
            stmt.setString(6, conge.getMotif());
            stmt.setString(7, conge.getStatut());
            stmt.setString(8, conge.getApprouvePar());
            stmt.executeUpdate();
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    conge.setId(generatedKeys.getLong(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Conge findById(Long id) {
        String sql = "SELECT c.*, e.nom, e.prenom, e.matricule FROM conge c JOIN employe e ON c.employe_id = e.id WHERE c.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractConge(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Conge> findAll() {
        List<Conge> conges = new ArrayList<>();
        String sql = "SELECT c.*, e.nom, e.prenom, e.matricule FROM conge c JOIN employe e ON c.employe_id = e.id";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                conges.add(extractConge(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return conges;
    }

    @Override
    public List<Conge> findByEmployeId(Long employeId) {
        List<Conge> conges = new ArrayList<>();
        String sql = "SELECT c.*, e.nom, e.prenom, e.matricule FROM conge c JOIN employe e ON c.employe_id = e.id WHERE c.employe_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, employeId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    conges.add(extractConge(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return conges;
    }

    @Override
    public void update(Conge conge) {
        String sql = "UPDATE conge SET employe_id=?, type_conge=?, date_debut=?, date_fin=?, nb_jours=?, motif=?, statut=?, approuve_par=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, conge.getEmployeId());
            stmt.setString(2, conge.getTypeConge());
            stmt.setDate(3, Date.valueOf(conge.getDateDebut()));
            stmt.setDate(4, Date.valueOf(conge.getDateFin()));
            stmt.setInt(5, conge.getNbJours());
            stmt.setString(6, conge.getMotif());
            stmt.setString(7, conge.getStatut());
            stmt.setString(8, conge.getApprouvePar());
            stmt.setLong(9, conge.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(Long id) {
        String sql = "DELETE FROM conge WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public int countCongesEnAttente() {
        String sql = "SELECT COUNT(*) FROM conge WHERE statut = 'DEMANDE'";
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

    private Conge extractConge(ResultSet rs) throws SQLException {
        Conge conge = new Conge();
        conge.setId(rs.getLong("id"));
        conge.setEmployeId(rs.getLong("employe_id"));
        conge.setTypeConge(rs.getString("type_conge"));
        if(rs.getDate("date_debut") != null) {
            conge.setDateDebut(rs.getDate("date_debut").toLocalDate());
        }
        if(rs.getDate("date_fin") != null) {
            conge.setDateFin(rs.getDate("date_fin").toLocalDate());
        }
        conge.setNbJours(rs.getInt("nb_jours"));
        conge.setMotif(rs.getString("motif"));
        conge.setStatut(rs.getString("statut"));
        conge.setApprouvePar(rs.getString("approuve_par"));

        Employe employe = new Employe();
        employe.setId(rs.getLong("employe_id"));
        employe.setNom(rs.getString("nom"));
        employe.setPrenom(rs.getString("prenom"));
        employe.setMatricule(rs.getString("matricule"));
        conge.setEmploye(employe);

        return conge;
    }
}
