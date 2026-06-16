package com.ict4dg19.intergo.controller;

import com.ict4dg19.intergo.dao.UtilisateurDao;
import com.ict4dg19.intergo.dao.UtilisateurDaoImpl;
import com.ict4dg19.intergo.model.Role;
import com.ict4dg19.intergo.model.Utilisateur;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

/**
 * RegisterServlet — Gère la création de compte utilisateur.
 *
 * Déclaré dans web.xml (pas d'annotation @WebServlet, exigence projet).
 * - GET  /register  → affiche le formulaire register.jsp
 * - POST /register  → valide les données, crée l'utilisateur en BD, redirige vers login
 */
public class RegisterServlet extends HttpServlet {

    /** DAO instancié une seule fois au démarrage du servlet. */
    private UtilisateurDao utilisateurDao;

    @Override
    public void init() throws ServletException {
        utilisateurDao = new UtilisateurDaoImpl();
    }

    // ──────────────────────────────────────────────────────────
    // GET — Affiche le formulaire d'inscription
    // ──────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Si l'utilisateur est déjà connecté, redirige vers le dashboard
        if (request.getSession(false) != null
                && request.getSession(false).getAttribute("utilisateurConnecte") != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    // ──────────────────────────────────────────────────────────
    // POST — Traite la soumission du formulaire d'inscription
    // ──────────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // reCAPTCHA v3 verification disabled in local environment


        // 1. Lecture des paramètres du formulaire
        String email               = trim(request.getParameter("email"));
        String motDePasse          = request.getParameter("motDePasse");
        String confirmerMotDePasse = request.getParameter("confirmerMotDePasse");
        String employeIdStr        = trim(request.getParameter("employeId"));
        String roleDemande         = trim(request.getParameter("roleDemande"));

        // 2. Validation côté serveur
        String erreurValidation = validerFormulaire(email, motDePasse, confirmerMotDePasse, employeIdStr);
        if (erreurValidation != null) {
            redirectToRegisterWithError(request, response, erreurValidation);
            return;
        }

        try {
            // 3. Vérification de l'unicité de l'email en base de données
            if (utilisateurDao.trouverParEmail(email) != null) {
                redirectToRegisterWithError(request, response,
                        "Cette adresse e-mail est déjà associée à un compte.");
                return;
            }

            // 4. Construction de l'objet Utilisateur
            Utilisateur nouvelUtilisateur = new Utilisateur();
            nouvelUtilisateur.setEmail(email);
            nouvelUtilisateur.setMotDePasse(motDePasse); // Le hash BCrypt est fait dans le DAO
            nouvelUtilisateur.setEstActif(true);

            // 4a. Résolution de l'employe_id (optionnel)
            if (employeIdStr != null && !employeIdStr.isEmpty()) {
                try {
                    long employeId = Long.parseLong(employeIdStr);
                    if (employeId > 0) {
                        nouvelUtilisateur.setEmployeId(employeId);
                    }
                } catch (NumberFormatException e) {
                    redirectToRegisterWithError(request, response,
                            "L'identifiant employé doit être un nombre entier positif.");
                    return;
                }
            }

            // 4b. Résolution du rôle demandé
            //     → Si vide ou EMPLOYE, la liste reste vide et le DAO assigne EMPLOYE par défaut.
            //     → Pour les autres rôles, on résout l'ID via le DAO.
            if (roleDemande != null && !roleDemande.isEmpty() && !roleDemande.equals("EMPLOYE")) {
                Role role = utilisateurDao.trouverRoleParNom(roleDemande);
                if (role == null) {
                    redirectToRegisterWithError(request, response,
                            "Le rôle sélectionné est invalide. Veuillez en choisir un autre.");
                    return;
                }
                nouvelUtilisateur.getRoles().add(role);
            }
            // Si roleDemande == "EMPLOYE" ou vide → on laisse la liste vide,
            // le DAO appellera obtenirIdRoleParNom(conn, "EMPLOYE") automatiquement.

            // 5. Persistance en base de données (transaction gérée dans le DAO)
            boolean succes = utilisateurDao.inscrire(nouvelUtilisateur);

            if (succes) {
                log("Nouveau compte créé pour : " + email);
                
                // Trigger SendGrid welcome email notification
                String emailSubject = "Bienvenue chez InterGo - Compte créé avec succès";
                String emailBody = "<h2>Bienvenue chez InterGo !</h2>"
                        + "<p>Votre compte utilisateur a été créé avec succès pour l'adresse e-mail : <strong>" + email + "</strong>.</p>"
                        + "<p>Vous pouvez désormais vous connecter à votre espace RH InterGo pour soumettre vos demandes de congés et consulter vos fiches de paie.</p>"
                        + "<br><hr><p style='font-size:11px;color:#666;'>Ceci est un e-mail automatique de notification de sécurité InterGo.</p>";
                com.ict4dg19.intergo.util.SendGridEmailUtil.sendEmail(email, emailSubject, emailBody);

                // Send SMS notification if employee has a telephone number
                try {
                    com.ict4dg19.intergo.dao.EmployeDAO employeDAO = new com.ict4dg19.intergo.dao.EmployeDAOImpl();
                    com.ict4dg19.intergo.model.Employe e = null;
                    if (nouvelUtilisateur.getEmployeId() != null) {
                        e = employeDAO.findById(nouvelUtilisateur.getEmployeId());
                    } else {
                        e = employeDAO.findByEmail(email);
                    }
                    if (e != null && e.getTelephone() != null && !e.getTelephone().trim().isEmpty()) {
                        String smsMessage = "Bienvenue chez InterGo ! Votre compte utilisateur a ete cree pour " + email + ".";
                        com.ict4dg19.intergo.util.SMSUtil.sendSMS(e.getTelephone(), smsMessage);
                    }
                } catch (Exception ex) {
                    System.err.println("[RegisterServlet] Failed to send registration SMS: " + ex.getMessage());
                }

                // 6. Redirection vers login avec un message de succès (pattern Post-Redirect-Get)
                response.sendRedirect(request.getContextPath()
                        + "/login?message=" + encode("Compte créé avec succès ! Vous pouvez vous connecter."));
            } else {
                redirectToRegisterWithError(request, response,
                        "L'inscription a échoué. Veuillez réessayer.");
            }

        } catch (SQLException e) {
            log("Erreur SQL dans RegisterServlet.doPost : " + e.getMessage(), e);

            // Détecter une violation de contrainte d'unicité (email ou employe_id déjà utilisé)
            if (e.getMessage() != null && e.getMessage().toLowerCase().contains("duplicate")) {
                if (e.getMessage().contains("uq_utilisateur_email")) {
                    redirectToRegisterWithError(request, response,
                            "Cette adresse e-mail est déjà utilisée.");
                } else if (e.getMessage().contains("employe_id")) {
                    redirectToRegisterWithError(request, response,
                            "Cet identifiant employé est déjà lié à un autre compte.");
                } else {
                    redirectToRegisterWithError(request, response,
                            "Une valeur en double a été détectée. Vérifiez vos données.");
                }
            } else if (e.getMessage() != null && (e.getMessage().toLowerCase().contains("foreign key") || e.getMessage().contains("fk_utilisateur_employe"))) {
                redirectToRegisterWithError(request, response,
                        "L'identifiant employé saisi n'existe pas.");
            } else {
                redirectToRegisterWithError(request, response,
                        "Une erreur technique est survenue. Veuillez réessayer plus tard.");
            }
        }
    }

    // ──────────────────────────────────────────────────────────
    // Validation des champs du formulaire
    // Retourne null si tout est valide, sinon le message d'erreur.
    // ──────────────────────────────────────────────────────────
    private String validerFormulaire(String email, String motDePasse,
                                     String confirmer, String employeIdStr) {
        if (email == null || email.isEmpty()) {
            return "L'adresse e-mail est obligatoire.";
        }
        if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            return "Adresse e-mail invalide.";
        }
        if (motDePasse == null || motDePasse.isEmpty()) {
            return "Le mot de passe est obligatoire.";
        }
        if (motDePasse.length() < 8) {
            return "Le mot de passe doit contenir au moins 8 caractères.";
        }
        if (confirmer == null || !confirmer.equals(motDePasse)) {
            return "Les mots de passe ne correspondent pas.";
        }
        if (employeIdStr != null && !employeIdStr.isEmpty()) {
            try {
                long id = Long.parseLong(employeIdStr);
                if (id <= 0) return "L'identifiant employé doit être un nombre positif.";
            } catch (NumberFormatException e) {
                return "L'identifiant employé doit être un nombre entier valide.";
            }
        }
        return null; // Toutes les validations sont passées
    }

    // ──────────────────────────────────────────────────────────
    // Méthodes utilitaires privées
    // ──────────────────────────────────────────────────────────

    private void redirectToRegisterWithError(HttpServletRequest request,
                                             HttpServletResponse response,
                                             String message)
            throws ServletException, IOException {
        request.setAttribute("erreur", message);
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    private String trim(String value) {
        return (value != null) ? value.trim() : null;
    }

    /** Encode une chaîne pour l'inclure dans une URL (query param). */
    private String encode(String value) {
        try {
            return java.net.URLEncoder.encode(value, "UTF-8");
        } catch (java.io.UnsupportedEncodingException e) {
            return value;
        }
    }
}
