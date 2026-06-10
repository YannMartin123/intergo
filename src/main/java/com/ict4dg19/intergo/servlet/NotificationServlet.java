package com.ict4dg19.intergo.servlet;

import com.ict4dg19.intergo.dao.*;
import com.ict4dg19.intergo.model.*;
import com.ict4dg19.intergo.util.SendGridEmailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(urlPatterns = {"/notifications", "/notifications/insert", "/notifications/read"})
public class NotificationServlet extends HttpServlet {
    private NotificationDAO notificationDAO;
    private EmployeDAO employeDAO;

    @Override
    public void init() {
        notificationDAO = new NotificationDAOImpl();
        employeDAO = new EmployeDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Utilisateur user = (session != null) ? (Utilisateur) session.getAttribute("utilisateurConnecte") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String userEmail = user.getEmail();
        List<Notification> listReceived = notificationDAO.findReceived(userEmail);
        List<Notification> listSent = notificationDAO.findSent(userEmail);
        List<Employe> listEmployes = employeDAO.findAll();

        request.setAttribute("listReceived", listReceived);
        request.setAttribute("listSent", listSent);
        request.setAttribute("listEmployes", listEmployes);
        request.setAttribute("unreadCount", notificationDAO.countUnread(userEmail));

        request.getRequestDispatcher("/notification-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Utilisateur user = (session != null) ? (Utilisateur) session.getAttribute("utilisateurConnecte") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getServletPath();

        if ("/notifications/insert".equals(action)) {
            String destinataire = request.getParameter("destinataire");
            String sujet = request.getParameter("sujet");
            String message = request.getParameter("message");

            if (destinataire != null && !destinataire.trim().isEmpty() &&
                sujet != null && !sujet.trim().isEmpty() &&
                message != null && !message.trim().isEmpty()) {

                Notification n = new Notification();
                n.setExpediteur(user.getEmail());
                n.setDestinataire(destinataire);
                n.setSujet(sujet);
                n.setMessage(message);
                n.setDateEnvoi(LocalDateTime.now());
                n.setLu(false);

                notificationDAO.create(n);

                // Send email notification in the background
                String emailHtml = "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e2e8f0; border-radius: 8px; background-color: #ffffff;'>"
                        + "<h2 style='color: #6366f1; margin-top: 0;'>Nouvelle Notification InterGo RH</h2>"
                        + "<hr style='border: 0; border-top: 1px solid #e2e8f0; margin-bottom: 20px;'>"
                        + "<p>Bonjour,</p>"
                        + "<p>Vous avez reçu un nouveau message de <strong>" + user.getEmail() + "</strong> sur votre portail InterGo RH.</p>"
                        + "<div style='background-color: #f8fafc; padding: 15px; border-radius: 6px; border-left: 4px solid #6366f1; margin: 20px 0;'>"
                        + "<p style='margin-top: 0; font-weight: bold; color: #1e293b;'>Sujet : " + sujet + "</p>"
                        + "<p style='white-space: pre-wrap; color: #334155; margin-bottom: 0;'>" + message + "</p>"
                        + "</div>"
                        + "<p style='margin-bottom: 30px;'>Connectez-vous à la plateforme pour y répondre.</p>"
                        + "<a href='http://localhost:8080/intergo/login' style='background-color: #6366f1; color: #ffffff; padding: 10px 20px; text-decoration: none; border-radius: 6px; font-weight: bold;'>Accéder au Portail</a>"
                        + "<hr style='border: 0; border-top: 1px solid #e2e8f0; margin-top: 30px; margin-bottom: 15px;'>"
                        + "<p style='font-size: 11px; color: #94a3b8; text-align: center; margin: 0;'>InterGo RH — Plateforme de Gestion des Ressources Humaines</p>"
                        + "</div>";

                SendGridEmailUtil.sendEmail(destinataire, "InterGo RH : " + sujet, emailHtml);
            }
            response.sendRedirect(request.getContextPath() + "/notifications?sent=true");

        } else if ("/notifications/read".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    Long id = Long.parseLong(idStr);
                    notificationDAO.markAsRead(id);
                    response.setContentType("application/json");
                    response.getWriter().write("{\"status\":\"success\"}");
                    return;
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
}
