package com.ict4dg19.intergo.websocket;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.ict4dg19.intergo.dao.ChatMessageDAO;
import com.ict4dg19.intergo.dao.ChatMessageDAOImpl;
import com.ict4dg19.intergo.dao.NotificationDAO;
import com.ict4dg19.intergo.dao.NotificationDAOImpl;
import com.ict4dg19.intergo.model.ChatMessage;
import com.ict4dg19.intergo.model.Notification;
import com.ict4dg19.intergo.util.SendGridEmailUtil;
import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;

import java.io.IOException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint("/chatws")
public class ChatWebSocket {

    private static final Map<String, Session> activeSessions = new ConcurrentHashMap<>();
    private static final ObjectMapper mapper = new ObjectMapper().registerModule(new JavaTimeModule());
    private static final ChatMessageDAO chatMessageDAO = new ChatMessageDAOImpl();
    private static final NotificationDAO notificationDAO = new NotificationDAOImpl();

    @OnOpen
    public void onOpen(Session session) {
        String email = getEmailFromSession(session);
        if (email != null && !email.trim().isEmpty()) {
            activeSessions.put(email, session);
            System.out.println("[ChatWebSocket] User connected: " + email + " (Session ID: " + session.getId() + ")");
            broadcastOnlineStatus();
        } else {
            try {
                session.close(new CloseReason(CloseReason.CloseCodes.CANNOT_ACCEPT, "Email parameter missing"));
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    @OnMessage
    public void onMessage(String messageJson, Session session) {
        String senderEmail = getEmailFromSession(session);
        if (senderEmail == null) return;

        try {
            ChatMessage chatMsg = mapper.readValue(messageJson, ChatMessage.class);
            chatMsg.setSenderEmail(senderEmail);
            chatMsg.setTimestamp(LocalDateTime.now());

            // 1. Enregistrement en base de données
            chatMessageDAO.create(chatMsg);

            String chatMsgJson = mapper.writeValueAsString(chatMsg);

            // 2. Envoi au destinataire s'il est en ligne
            Session receiverSession = activeSessions.get(chatMsg.getReceiverEmail());
            if (receiverSession != null && receiverSession.isOpen()) {
                receiverSession.getBasicRemote().sendText(chatMsgJson);
            } else {
                // S'il est hors ligne, générer une notification classique dans l'application
                Notification noti = new Notification();
                noti.setExpediteur(senderEmail);
                noti.setDestinataire(chatMsg.getReceiverEmail());
                noti.setSujet("Nouveau message de chat de " + senderEmail);
                noti.setMessage(chatMsg.getMessage());
                noti.setDateEnvoi(LocalDateTime.now());
                noti.setLu(false);
                notificationDAO.create(noti);

                // Envoi d'un e-mail d'alerte
                String subject = "Nouveau message de chat de la part de " + senderEmail;
                String htmlContent = "<h3>Vous avez reçu un nouveau message de chat</h3>"
                        + "<p><strong>De :</strong> " + senderEmail + "</p>"
                        + "<p><strong>Message :</strong> " + chatMsg.getMessage() + "</p>"
                        + "<p>Connectez-vous sur InterGo pour répondre : <a href='http://localhost:8082/intergo/chat'>Accéder au Chat</a></p>";
                SendGridEmailUtil.sendEmail(chatMsg.getReceiverEmail(), subject, htmlContent);
            }

            // 3. Renvoyer au format de confirmation à l'expéditeur
            session.getBasicRemote().sendText(chatMsgJson);

        } catch (Exception e) {
            System.err.println("[ChatWebSocket] Error processing message: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @OnClose
    public void onClose(Session session, CloseReason reason) {
        String email = getEmailFromSession(session);
        if (email != null) {
            activeSessions.remove(email);
            System.out.println("[ChatWebSocket] User disconnected: " + email + " (Reason: " + reason.getReasonPhrase() + ")");
            broadcastOnlineStatus();
        }
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        System.err.println("[ChatWebSocket] Error in session " + session.getId() + " : " + throwable.getMessage());
    }

    private String getEmailFromSession(Session session) {
        String queryString = session.getQueryString();
        if (queryString != null) {
            for (String param : queryString.split("&")) {
                String[] pair = param.split("=");
                if (pair.length == 2 && "email".equals(pair[0])) {
                    return URLDecoder.decode(pair[1], StandardCharsets.UTF_8);
                }
            }
        }
        return null;
    }

    private void broadcastOnlineStatus() {
        try {
            String onlineUsersJson = mapper.writeValueAsString(Map.of(
                "type", "STATUS_UPDATE",
                "onlineUsers", activeSessions.keySet()
            ));
            for (Session s : activeSessions.values()) {
                if (s.isOpen()) {
                    s.getBasicRemote().sendText(onlineUsersJson);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
