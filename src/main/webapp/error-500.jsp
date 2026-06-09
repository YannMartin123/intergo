<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="noindex, nofollow">
    <title>Erreur serveur — InterGo RH</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <!-- Navbar -->
    <nav class="error-navbar">
        <a href="${pageContext.request.contextPath}/" style="display:flex;align-items:center;gap:10px;text-decoration:none;">
            <div style="width:32px;height:32px;font-size:16px;border-radius:8px;background:linear-gradient(135deg,#4F46E5,#6366F1);display:flex;align-items:center;justify-content:center;color:white;">🧭</div>
            <span style="font-size:18px;font-weight:800;color:#1E1B4B;">Inter<span style="color:#4F46E5;">Go</span></span>
        </a>
    </nav>

    <div class="error-layout" style="padding-top:64px;">
        <div class="error-card fade-in">

            <span class="error-icon">⚙️</span>
            <span class="error-code danger-code">500</span>

            <h2>Erreur interne du serveur</h2>
            <p>
                Une erreur inattendue s'est produite côté serveur.
                Notre équipe technique a été notifiée. Veuillez réessayer dans quelques instants.
            </p>

            <!-- Error details (for debugging — only show in development) -->
            <%
                Throwable throwable = (Throwable) request.getAttribute("jakarta.servlet.error.exception");
                String errorMessage = (String) request.getAttribute("jakarta.servlet.error.message");
                Integer statusCode  = (Integer) request.getAttribute("jakarta.servlet.error.status_code");
                String requestUri   = (String) request.getAttribute("jakarta.servlet.error.request_uri");

                // Hide stack traces in production — check context param or env
                String env = application.getInitParameter("app.environment");
                boolean isDev = (env == null || "development".equalsIgnoreCase(env));
            %>

            <% if (isDev && throwable != null) { %>
            <div class="error-details">
                <strong>Erreur :</strong> <%= throwable.getClass().getName() %><br>
                <strong>Message :</strong> <%= throwable.getMessage() != null ? throwable.getMessage() : "Aucun détail disponible" %><br>
                <% if (requestUri != null) { %>
                <strong>URI :</strong> <%= requestUri %>
                <% } %>
            </div>
            <% } else if (isDev && errorMessage != null) { %>
            <div class="error-details">
                <strong>Message :</strong> <%= errorMessage %>
                <% if (requestUri != null) { %><br><strong>URI :</strong> <%= requestUri %><% } %>
            </div>
            <% } %>

            <!-- Actions -->
            <div class="error-actions">
                <button onclick="window.location.reload()" class="btn btn-danger">
                    🔄 Réessayer
                </button>
                <a href="${pageContext.request.contextPath}/" class="btn btn-outline">
                    🏠 Retour à l'accueil
                </a>
            </div>

            <!-- Status + Timestamp -->
            <div style="margin-top:32px;padding-top:24px;border-top:1px solid #E5E7EB;display:flex;justify-content:center;gap:24px;flex-wrap:wrap;">
                <div style="text-align:center;">
                    <span style="display:block;font-size:11px;text-transform:uppercase;letter-spacing:0.05em;color:#9CA3AF;font-weight:600;margin-bottom:4px;">Code HTTP</span>
                    <span style="font-size:22px;font-weight:800;color:#EF4444;">500</span>
                </div>
                <div style="text-align:center;">
                    <span style="display:block;font-size:11px;text-transform:uppercase;letter-spacing:0.05em;color:#9CA3AF;font-weight:600;margin-bottom:4px;">Horodatage</span>
                    <span style="font-size:13px;font-weight:600;color:#6B7280;" id="errorTime">–</span>
                </div>
                <div style="text-align:center;">
                    <span style="display:block;font-size:11px;text-transform:uppercase;letter-spacing:0.05em;color:#9CA3AF;font-weight:600;margin-bottom:4px;">Statut</span>
                    <span style="font-size:13px;font-weight:600;color:#F59E0B;">🟡 En cours d'examen</span>
                </div>
            </div>

            <!-- Help note -->
            <div style="margin-top:24px;background:#FFFBEB;border:1px solid #FDE68A;border-radius:8px;padding:14px 16px;font-size:13px;color:#92400E;text-align:left;display:flex;gap:10px;align-items:flex-start;">
                <span style="font-size:16px;">💡</span>
                <span>Si le problème persiste, contactez votre administrateur système ou l'équipe ICT4D G19.</span>
            </div>

        </div>
    </div>

    <script>
        // Timestamp
        const el = document.getElementById('errorTime');
        if (el) {
            const now = new Date();
            el.textContent = now.toLocaleString('fr-FR', {
                day: '2-digit', month: '2-digit', year: 'numeric',
                hour: '2-digit', minute: '2-digit'
            });
        }

        // Floating broken gear particles
        document.addEventListener('DOMContentLoaded', () => {
            const emojis = ['⚙️', '🔧', '💥', '⚠️', '🛠️'];
            for (let i = 0; i < 6; i++) {
                const el = document.createElement('div');
                el.textContent = emojis[Math.floor(Math.random() * emojis.length)];
                el.style.cssText = `
                    position: fixed;
                    font-size: ${14 + Math.random() * 18}px;
                    opacity: 0.05;
                    top: ${Math.random() * 100}vh;
                    left: ${Math.random() * 100}vw;
                    pointer-events: none;
                    animation: float ${5 + Math.random() * 5}s ease-in-out infinite;
                    animation-delay: ${Math.random() * 3}s;
                    z-index: 0;
                `;
                document.body.appendChild(el);
            }
        });
    </script>

</body>
</html>
