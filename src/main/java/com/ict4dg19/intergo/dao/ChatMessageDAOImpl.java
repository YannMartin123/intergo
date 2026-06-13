package com.ict4dg19.intergo.dao;

import com.ict4dg19.intergo.model.ChatMessage;
import com.ict4dg19.intergo.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ChatMessageDAOImpl implements ChatMessageDAO {

    @Override
    public void create(ChatMessage message) throws SQLException {
        String sql = "INSERT INTO chat_message (sender_email, receiver_email, message, timestamp, file_name, file_type, file_url) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, message.getSenderEmail());
            ps.setString(2, message.getReceiverEmail());
            ps.setString(3, message.getMessage());
            ps.setTimestamp(4, message.getTimestamp() != null ? Timestamp.valueOf(message.getTimestamp()) : new Timestamp(System.currentTimeMillis()));
            ps.setString(5, message.getFileName());
            ps.setString(6, message.getFileType());
            ps.setString(7, message.getFileUrl());
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    message.setId(rs.getLong(1));
                }
            }
        }
    }

    @Override
    public List<ChatMessage> findHistory(String email1, String email2) throws SQLException {
        List<ChatMessage> list = new ArrayList<>();
        String sql = "SELECT * FROM chat_message WHERE " +
                "(sender_email = ? AND receiver_email = ?) OR " +
                "(sender_email = ? AND receiver_email = ?) " +
                "ORDER BY timestamp ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email1);
            ps.setString(2, email2);
            ps.setString(3, email2);
            ps.setString(4, email1);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ChatMessage msg = new ChatMessage();
                    msg.setId(rs.getLong("id"));
                    msg.setSenderEmail(rs.getString("sender_email"));
                    msg.setReceiverEmail(rs.getString("receiver_email"));
                    msg.setMessage(rs.getString("message"));
                    Timestamp ts = rs.getTimestamp("timestamp");
                    if (ts != null) {
                        msg.setTimestamp(ts.toLocalDateTime());
                    }
                    msg.setFileName(rs.getString("file_name"));
                    msg.setFileType(rs.getString("file_type"));
                    msg.setFileUrl(rs.getString("file_url"));
                    list.add(msg);
                }
            }
        }
        return list;
    }
}
