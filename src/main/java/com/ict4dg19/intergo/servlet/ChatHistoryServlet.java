package com.ict4dg19.intergo.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.ict4dg19.intergo.dao.ChatMessageDAO;
import com.ict4dg19.intergo.dao.ChatMessageDAOImpl;
import com.ict4dg19.intergo.model.ChatMessage;
import com.ict4dg19.intergo.model.Utilisateur;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet("/chat/history")
public class ChatHistoryServlet extends HttpServlet {
    private ChatMessageDAO chatMessageDAO;
    private ObjectMapper mapper;

    @Override
    public void init() {
        chatMessageDAO = new ChatMessageDAOImpl();
        mapper = new ObjectMapper()
            .registerModule(new JavaTimeModule())
            .configure(com.fasterxml.jackson.databind.SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        HttpSession session = request.getSession(false);
        Utilisateur user = (session != null) ? (Utilisateur) session.getAttribute("utilisateurConnecte") : null;
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Unauthorized\"}");
            return;
        }

        String contactEmail = request.getParameter("contact");
        if (contactEmail == null || contactEmail.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Contact email is required\"}");
            return;
        }

        try {
            List<ChatMessage> history = chatMessageDAO.findHistory(user.getEmail(), contactEmail);
            response.getWriter().write(mapper.writeValueAsString(history));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }
}
