<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="noindex, nofollow">
    <title>Erreur serveur — InterGo RH</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .error-layout {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 40px 20px;
        }
        .error-card {
            width: 100%;
            max-width: 580px;
            background: rgba(15, 23, 42, 0.55);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(239, 68, 68, 0.25);
            box-shadow: 0 0 30px rgba(239, 68, 68, 0.15), 0 15px 50px rgba(0, 0, 0, 0.4);
            border-radius: 24px;
            padding: 48px;
            text-align: center;
        }
        .error-icon {
            font-size: 54px;
            display: block;
            margin-bottom: 16px;
            animation: pulse-gear 2s infinite ease-in-out;
        }
        @keyframes pulse-gear {
            0% { transform: scale(1); }
            50% { transform: scale(1.08); filter: drop-shadow(0 0 12px rgba(239, 68, 68, 0.4)); }
            100% { transform: scale(1); }
        }
        .error-code {
            font-size: 84px;
            font-weight: 900;
            line-height: 1;
            margin-bottom: 16px;
            letter-spacing: -2px;
            background: linear-gradient(135deg, #ef4444 0%, #f43f5e 50%, #b91c1c 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .error-card h2 {
            font-size: 28px;
            font-weight: 800;
            color: var(--text-main);
            margin-bottom: 12px;
        }
        .error-card p {
            color: var(--text-secondary);
            font-size: 15px;
            line-height: 1.6;
            margin-bottom: 24px;
        }
        .error-details {
            background: rgba(11, 15, 25, 0.8);
            border: 1px solid rgba(239, 68, 68, 0.2);
            border-radius: 12px;
            padding: 16px 20px;
            font-size: 13px;
            color: #fca5a5;
            text-align: left;
            margin-bottom: 28px;
            font-family: monospace;
            word-break: break-all;
            max-height: 180px;
            overflow-y: auto;
        }
        .error-actions {
            display: flex;
            gap: 16px;
            justify-content: center;
            margin-bottom: 32px;
        }
        .error-meta {
            border-top: 1px solid rgba(255, 255, 255, 0.05);
            padding-top: 24px;
            display: flex;
            justify-content: center;
            gap: 32px;
        }
        .meta-item span {
            display: block;
        }
        .meta-label {
            font-size: 10px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--text-muted);
            font-weight: 600;
            margin-bottom: 4px;
        }
        .meta-value {
            font-size: 14px;
            font-weight: 700;
            color: var(--text-secondary);
        }
        .help-box {
            background: rgba(245, 158, 11, 0.06);
            border: 1px solid rgba(245, 158, 11, 0.15);
            border-radius: 12px;
            padding: 14px 18px;
            font-size: 13px;
            color: #fde047;
            text-align: left;
            display: flex;
            gap: 12px;
            align-items: flex-start;
            margin-top: 24px;
        }
    </style>
</head>
<body>

    <!-- Ambient background glow -->
    <div class="bg-glow-container">
        <div class="glow-blob blob-1"></div>
        <div class="glow-blob blob-2"></div>
        <div class="glow-blob blob-3"></div>
    </div>

    <div class="error-layout">
        <div class="error-card fade-in">
            <span class="error-icon"><i class="fa-solid fa-triangle-exclamation" style="font-size:48px; background: linear-gradient(135deg, #ef4444, #f43f5e); -webkit-background-clip: text; -webkit-text-fill-color: transparent;"></i></span>
            <div class="error-code">500</div>

            <h2>Erreur interne du serveur</h2>
            <p>
                Une erreur inattendue s'est produite côté serveur.
                Veuillez réessayer dans quelques instants.
            </p>

            <!-- Error details -->
            <%
                Throwable throwable = (Throwable) request.getAttribute("jakarta.servlet.error.exception");
                String errorMessage = (String) request.getAttribute("jakarta.servlet.error.message");
                Integer statusCode  = (Integer) request.getAttribute("jakarta.servlet.error.status_code");
                String requestUri   = (String) request.getAttribute("jakarta.servlet.error.request_uri");

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
                <button onclick="window.location.reload()" class="btn btn-danger btn-lg">
                    <i class="fa-solid fa-rotate-right"></i> Réessayer
                </button>
                <a href="${pageContext.request.contextPath}/" class="btn btn-outline btn-lg">
                    <i class="fa-solid fa-house"></i> Accueil
                </a>
            </div>

            <!-- Meta info -->
            <div class="error-meta">
                <div class="meta-item">
                    <span class="meta-label">Code HTTP</span>
                    <span class="meta-value" style="color:#ef4444;">500</span>
                </div>
                <div class="meta-item">
                    <span class="meta-label">Horodatage</span>
                    <span class="meta-value" id="errorTime">–</span>
                </div>
                <div class="meta-item">
                    <span class="meta-label">Statut</span>
                    <span class="meta-value" style="color:var(--warning);">En cours d'examen</span>
                </div>
            </div>

            <!-- Help box -->
            <div class="help-box">
                <i class="fa-solid fa-circle-info" style="font-size:16px; margin-top:2px;"></i>
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
    </script>

</body>
</html>
