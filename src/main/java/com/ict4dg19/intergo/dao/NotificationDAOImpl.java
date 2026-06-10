package com.ict4dg19.intergo.dao;

import com.ict4dg19.intergo.model.Notification;
import com.ict4dg19.intergo.util.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAOImpl implements NotificationDAO {

    @Override
    public List<Notification> findReceived(String destinataire) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM notification WHERE destinataire = ? ORDER BY date_envoi DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, destinataire);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(extractNotification(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Notification> findSent(String expediteur) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM notification WHERE expediteur = ? ORDER BY date_envoi DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, expediteur);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(extractNotification(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public int countUnread(String destinataire) {
        String sql = "SELECT COUNT(*) FROM notification WHERE destinataire = ? AND lu = FALSE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, destinataire);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public void markAsRead(Long id) {
        String sql = "UPDATE notification SET lu = TRUE WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void create(Notification n) {
        String sql = "INSERT INTO notification (expediteur, destinataire, sujet, message, date_envoi, lu) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, n.getExpediteur());
            stmt.setString(2, n.getDestinataire());
            stmt.setString(3, n.getSujet());
            stmt.setString(4, n.getMessage());
            stmt.setTimestamp(5, Timestamp.valueOf(n.getDateEnvoi()));
            stmt.setBoolean(6, n.isLu());
            stmt.executeUpdate();
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    n.setId(generatedKeys.getLong(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Notification extractNotification(ResultSet rs) throws SQLException {
        Notification n = new Notification();
        n.setId(rs.getLong("id"));
        n.setExpediteur(rs.getString("expediteur"));
        n.setDestinataire(rs.getString("destinataire"));
        n.setSujet(rs.getString("sujet"));
        n.setMessage(rs.getString("message"));
        
        Timestamp ts = rs.getTimestamp("date_envoi");
        if (ts != null) {
            n.setDateEnvoi(ts.toLocalDateTime());
        }
        
        n.setLu(rs.getBoolean("lu"));
        return n;
    }
}
