package com.ict4dg19.intergo.dao;

import com.ict4dg19.intergo.model.ChatMessage;
import java.sql.SQLException;
import java.util.List;

public interface ChatMessageDAO {
    void create(ChatMessage message) throws SQLException;
    List<ChatMessage> findHistory(String email1, String email2) throws SQLException;
}
