package com.ict4dg19.intergo.controller;

import com.ict4dg19.intergo.dao.UtilisateurDao;
import com.ict4dg19.intergo.dao.UtilisateurDaoImpl;
import com.ict4dg19.intergo.model.Utilisateur;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.SQLException;

/**
 * LoginServlet — Gère l'authentification des utilisateurs.
 *
 * Déclaré dans web.xml (pas d'annotation @WebServlet, exigence projet).
 * - GET  /login  → affiche le formulaire login.jsp
 * - POST /login  → valide les identifiants et crée la session HTTP
 */
public class LoginServlet extends HttpServlet {

    /** DAO instancié une seule fois au démarrage du servlet (init-safe, DAO stateless). */
    private UtilisateurDao utilisateurDao;

    @Override
    public void init() throws ServletException {
        utilisateurDao = new UtilisateurDaoImpl();
    }

    // ──────────────────────────────────────────────────────────
    // GET — Affiche le formulaire de connexion
    // ──────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Si l'utilisateur est déjà connecté, redirige vers le dashboard
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("utilisateurConnecte") != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    // ──────────────────────────────────────────────────────────
    // POST — Traite la soumission du formulaire de connexion
    // ──────────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 1. Lecture et nettoyage des paramètres du formulaire
        String email      = trim(request.getParameter("email"));
        String motDePasse = request.getParameter("motDePasse");

        // 2. Validation côté serveur (filet de sécurité — la validation JS peut être contournée)
        if (email == null || email.isEmpty()) {
            redirectToLoginWithError(request, response, "L'adresse e-mail est obligatoire.");
            return;
        }
        if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            redirectToLoginWithError(request, response, "Adresse e-mail invalide.");
            return;
        }
        if (motDePasse == null || motDePasse.isEmpty()) {
            redirectToLoginWithError(request, response, "Le mot de passe est obligatoire.");
            return;
        }

        try {
            // 3. Recherche de l'utilisateur en base de données
            Utilisateur utilisateur = utilisateurDao.trouverParEmail(email);

            // 4. Vérification : utilisateur introuvable ou inactif
            if (utilisateur == null) {
                redirectToLoginWithError(request, response, "Email ou mot de passe incorrect.");
                return;
            }
            if (!utilisateur.isEstActif()) {
                redirectToLoginWithError(request, response,
                        "Votre compte est désactivé. Contactez votre administrateur.");
                return;
            }

            // 5. Vérification du mot de passe via BCrypt
            if (!BCrypt.checkpw(motDePasse, utilisateur.getMotDePasse())) {
                redirectToLoginWithError(request, response, "Email ou mot de passe incorrect.");
                return;
            }

            // 6. Authentification réussie — création de la session HTTP
            //    On invalide l'ancienne session pour prévenir la fixation de session
            HttpSession ancienneSession = request.getSession(false);
            if (ancienneSession != null) {
                ancienneSession.invalidate();
            }

            HttpSession session = request.getSession(true);
            session.setMaxInactiveInterval(30 * 60); // 30 minutes

            // On ne stocke PAS le hash du mot de passe en session par sécurité
            utilisateur.setMotDePasse(null);
            session.setAttribute("utilisateurConnecte", utilisateur);
            session.setAttribute("userEmail", utilisateur.getEmail());
            session.setAttribute("userRoles", utilisateur.getRoles());

            // 7. Journalisation (peut être remplacée par un vrai logger)
            log("Connexion réussie pour : " + utilisateur.getEmail());

            // 8. Redirection vers le dashboard (ou l'URL demandée avant la connexion)
            String urlRedirection = (String) session.getAttribute("urlAvantConnexion");
            if (urlRedirection != null && !urlRedirection.isEmpty()) {
                session.removeAttribute("urlAvantConnexion");
                response.sendRedirect(urlRedirection);
            } else {
                response.sendRedirect(request.getContextPath() + "/dashboard");
            }

        } catch (SQLException e) {
            log("Erreur SQL dans LoginServlet.doPost : " + e.getMessage(), e);
            request.setAttribute("erreur",
                    "Une erreur technique est survenue. Veuillez réessayer plus tard.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    // ──────────────────────────────────────────────────────────
    // Méthodes utilitaires privées
    // ──────────────────────────────────────────────────────────

    /**
     * Positionne le message d'erreur et retransmet vers login.jsp.
     * On conserve l'email saisi pour ne pas obliger l'utilisateur à le ressaisir.
     */
    private void redirectToLoginWithError(HttpServletRequest request,
                                          HttpServletResponse response,
                                          String message)
            throws ServletException, IOException {
        request.setAttribute("erreur", message);
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    /** Retourne null si le paramètre est null, sinon trim(). */
    private String trim(String value) {
        return (value != null) ? value.trim() : null;
    }
}
