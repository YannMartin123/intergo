package com.ict4dg19.intergo.dao;

import com.ict4dg19.intergo.model.Departement;
import com.ict4dg19.intergo.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DepartementDAOImpl implements DepartementDAO {

    @Override
    public void create(Departement departement) {
        String sql = "INSERT INTO departement (nom, responsable, budget_masse_salariale) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, departement.getNom());
            stmt.setString(2, departement.getResponsable());
            stmt.setBigDecimal(3, departement.getBudgetMasseSalariale());
            stmt.executeUpdate();
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    departement.setId(generatedKeys.getLong(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Departement findById(Long id) {
        String sql = "SELECT * FROM departement WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractDepartement(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Departement> findAll() {
        List<Departement> departements = new ArrayList<>();
        String sql = "SELECT * FROM departement";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                departements.add(extractDepartement(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return departements;
    }

    @Override
    public void update(Departement departement) {
        String sql = "UPDATE departement SET nom = ?, responsable = ?, budget_masse_salariale = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, departement.getNom());
            stmt.setString(2, departement.getResponsable());
            stmt.setBigDecimal(3, departement.getBudgetMasseSalariale());
            stmt.setLong(4, departement.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(Long id) {
        String sql = "DELETE FROM departement WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Departement extractDepartement(ResultSet rs) throws SQLException {
        Departement dept = new Departement();
        dept.setId(rs.getLong("id"));
        dept.setNom(rs.getString("nom"));
        dept.setResponsable(rs.getString("responsable"));
        dept.setBudgetMasseSalariale(rs.getBigDecimal("budget_masse_salariale"));
        return dept;
    }
}
