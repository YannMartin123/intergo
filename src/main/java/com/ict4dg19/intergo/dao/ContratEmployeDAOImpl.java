package com.ict4dg19.intergo.dao;

import com.ict4dg19.intergo.model.ContratEmploye;
import com.ict4dg19.intergo.model.Employe;
import com.ict4dg19.intergo.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContratEmployeDAOImpl implements ContratEmployeDAO {

    @Override
    public void create(ContratEmploye contrat) {
        String sql = "INSERT INTO contrat_employe (employe_id, type_contrat, date_debut, date_fin, salaire, avantages) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setLong(1, contrat.getEmployeId());
            stmt.setString(2, contrat.getTypeContrat());
            stmt.setDate(3, Date.valueOf(contrat.getDateDebut()));
            if (contrat.getDateFin() != null) {
                stmt.setDate(4, Date.valueOf(contrat.getDateFin()));
            } else {
                stmt.setNull(4, Types.DATE);
            }
            stmt.setBigDecimal(5, contrat.getSalaire());
            stmt.setString(6, contrat.getAvantages());
            stmt.executeUpdate();
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    contrat.setId(generatedKeys.getLong(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public ContratEmploye findById(Long id) {
        String sql = "SELECT c.*, e.nom, e.prenom, e.matricule FROM contrat_employe c JOIN employe e ON c.employe_id = e.id WHERE c.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractContrat(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<ContratEmploye> findAll() {
        List<ContratEmploye> contrats = new ArrayList<>();
        String sql = "SELECT c.*, e.nom, e.prenom, e.matricule FROM contrat_employe c JOIN employe e ON c.employe_id = e.id";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                contrats.add(extractContrat(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return contrats;
    }

    @Override
    public List<ContratEmploye> findByEmployeId(Long employeId) {
        List<ContratEmploye> contrats = new ArrayList<>();
        String sql = "SELECT c.*, e.nom, e.prenom, e.matricule FROM contrat_employe c JOIN employe e ON c.employe_id = e.id WHERE c.employe_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, employeId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    contrats.add(extractContrat(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return contrats;
    }

    @Override
    public void update(ContratEmploye contrat) {
        String sql = "UPDATE contrat_employe SET employe_id=?, type_contrat=?, date_debut=?, date_fin=?, salaire=?, avantages=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, contrat.getEmployeId());
            stmt.setString(2, contrat.getTypeContrat());
            stmt.setDate(3, Date.valueOf(contrat.getDateDebut()));
            if (contrat.getDateFin() != null) {
                stmt.setDate(4, Date.valueOf(contrat.getDateFin()));
            } else {
                stmt.setNull(4, Types.DATE);
            }
            stmt.setBigDecimal(5, contrat.getSalaire());
            stmt.setString(6, contrat.getAvantages());
            stmt.setLong(7, contrat.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(Long id) {
        String sql = "DELETE FROM contrat_employe WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private ContratEmploye extractContrat(ResultSet rs) throws SQLException {
        ContratEmploye contrat = new ContratEmploye();
        contrat.setId(rs.getLong("id"));
        contrat.setEmployeId(rs.getLong("employe_id"));
        contrat.setTypeContrat(rs.getString("type_contrat"));
        if(rs.getDate("date_debut") != null) {
            contrat.setDateDebut(rs.getDate("date_debut").toLocalDate());
        }
        if(rs.getDate("date_fin") != null) {
            contrat.setDateFin(rs.getDate("date_fin").toLocalDate());
        }
        contrat.setSalaire(rs.getBigDecimal("salaire"));
        contrat.setAvantages(rs.getString("avantages"));

        Employe employe = new Employe();
        employe.setId(rs.getLong("employe_id"));
        employe.setNom(rs.getString("nom"));
        employe.setPrenom(rs.getString("prenom"));
        employe.setMatricule(rs.getString("matricule"));
        contrat.setEmploye(employe);

        return contrat;
    }
}
