package com.ict4dg19.intergo.servlet;

import com.ict4dg19.intergo.model.Utilisateur;
import com.ict4dg19.intergo.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/chat")
public class ChatServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Utilisateur user = (session != null) ? (Utilisateur) session.getAttribute("utilisateurConnecte") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<ChatContact> listContacts = loadContacts(user.getEmail());
        request.setAttribute("listContacts", listContacts);
        request.getRequestDispatcher("/chat.jsp").forward(request, response);
    }

    private List<ChatContact> loadContacts(String currentUserEmail) {
        List<ChatContact> contacts = new ArrayList<>();
        String sql = "SELECT u.email, e.nom, e.prenom, e.poste, " +
                     "(SELECT COUNT(*) FROM chat_message WHERE sender_email = u.email AND receiver_email = ? AND lu = FALSE) AS unread_count " +
                     "FROM utilisateur u " +
                     "LEFT JOIN employe e ON u.employe_id = e.id " +
                     "WHERE u.est_actif = TRUE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, currentUserEmail);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ChatContact c = new ChatContact();
                    c.setEmail(rs.getString("email"));
                    String nom = rs.getString("nom");
                    String prenom = rs.getString("prenom");
                    String poste = rs.getString("poste");
                    c.setUnreadCount(rs.getInt("unread_count"));
                    if (nom == null || nom.trim().isEmpty()) {
                        c.setNom("Administrateur");
                        c.setPrenom("Système");
                        c.setPoste("Admin");
                    } else {
                        c.setNom(nom);
                        c.setPrenom(prenom);
                        c.setPoste(poste);
                    }
                    contacts.add(c);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return contacts;
    }

    public static class ChatContact {
        private String email;
        private String nom;
        private String prenom;
        private String poste;
        private int unreadCount;

        public ChatContact() {}

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        public String getNom() {
            return nom;
        }

        public void setNom(String nom) {
            this.nom = nom;
        }

        public String getPrenom() {
            return prenom;
        }

        public void setPrenom(String prenom) {
            this.prenom = prenom;
        }

        public String getPoste() {
            return poste;
        }

        public void setPoste(String poste) {
            this.poste = poste;
        }

        public int getUnreadCount() {
            return unreadCount;
        }

        public void setUnreadCount(int unreadCount) {
            this.unreadCount = unreadCount;
        }
    }
}
