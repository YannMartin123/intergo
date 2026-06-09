package com.ict4dg19.intergo.dao;

import com.ict4dg19.intergo.model.FichePaie;
import com.ict4dg19.intergo.model.Employe;
import com.ict4dg19.intergo.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FichePaieDAOImpl implements FichePaieDAO {

    @Override
    public void create(FichePaie fiche) {
        String sql = "INSERT INTO fiche_paie (employe_id, mois, salaire_base, heures_sup, montant_heures_sup, primes, retenues, salaire_brut, salaire_net) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setLong(1, fiche.getEmployeId());
            stmt.setString(2, fiche.getMois());
            stmt.setBigDecimal(3, fiche.getSalaireBase());
            stmt.setBigDecimal(4, fiche.getHeuresSup());
            stmt.setBigDecimal(5, fiche.getMontantHeuresSup());
            stmt.setBigDecimal(6, fiche.getPrimes());
            stmt.setBigDecimal(7, fiche.getRetenues());
            stmt.setBigDecimal(8, fiche.getSalaireBrut());
            stmt.setBigDecimal(9, fiche.getSalaireNet());
            stmt.executeUpdate();
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    fiche.setId(generatedKeys.getLong(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public FichePaie findById(Long id) {
        String sql = "SELECT f.*, e.nom, e.prenom, e.matricule FROM fiche_paie f JOIN employe e ON f.employe_id = e.id WHERE f.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractFiche(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<FichePaie> findAll() {
        List<FichePaie> fiches = new ArrayList<>();
        String sql = "SELECT f.*, e.nom, e.prenom, e.matricule FROM fiche_paie f JOIN employe e ON f.employe_id = e.id";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                fiches.add(extractFiche(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return fiches;
    }

    @Override
    public List<FichePaie> findByEmployeId(Long employeId) {
        List<FichePaie> fiches = new ArrayList<>();
        String sql = "SELECT f.*, e.nom, e.prenom, e.matricule FROM fiche_paie f JOIN employe e ON f.employe_id = e.id WHERE f.employe_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, employeId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    fiches.add(extractFiche(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return fiches;
    }

    @Override
    public void update(FichePaie fiche) {
        String sql = "UPDATE fiche_paie SET employe_id=?, mois=?, salaire_base=?, heures_sup=?, montant_heures_sup=?, primes=?, retenues=?, salaire_brut=?, salaire_net=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, fiche.getEmployeId());
            stmt.setString(2, fiche.getMois());
            stmt.setBigDecimal(3, fiche.getSalaireBase());
            stmt.setBigDecimal(4, fiche.getHeuresSup());
            stmt.setBigDecimal(5, fiche.getMontantHeuresSup());
            stmt.setBigDecimal(6, fiche.getPrimes());
            stmt.setBigDecimal(7, fiche.getRetenues());
            stmt.setBigDecimal(8, fiche.getSalaireBrut());
            stmt.setBigDecimal(9, fiche.getSalaireNet());
            stmt.setLong(10, fiche.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(Long id) {
        String sql = "DELETE FROM fiche_paie WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public BigDecimal sumMasseSalariale() {
        String sql = "SELECT SUM(salaire_net) FROM fiche_paie";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                BigDecimal sum = rs.getBigDecimal(1);
                return sum != null ? sum : BigDecimal.ZERO;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    private FichePaie extractFiche(ResultSet rs) throws SQLException {
        FichePaie fiche = new FichePaie();
        fiche.setId(rs.getLong("id"));
        fiche.setEmployeId(rs.getLong("employe_id"));
        fiche.setMois(rs.getString("mois"));
        fiche.setSalaireBase(rs.getBigDecimal("salaire_base"));
        fiche.setHeuresSup(rs.getBigDecimal("heures_sup"));
        fiche.setMontantHeuresSup(rs.getBigDecimal("montant_heures_sup"));
        fiche.setPrimes(rs.getBigDecimal("primes"));
        fiche.setRetenues(rs.getBigDecimal("retenues"));
        fiche.setSalaireBrut(rs.getBigDecimal("salaire_brut"));
        fiche.setSalaireNet(rs.getBigDecimal("salaire_net"));

        Employe employe = new Employe();
        employe.setId(rs.getLong("employe_id"));
        employe.setNom(rs.getString("nom"));
        employe.setPrenom(rs.getString("prenom"));
        employe.setMatricule(rs.getString("matricule"));
        fiche.setEmploye(employe);

        return fiche;
    }
}
