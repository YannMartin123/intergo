<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="noindex, nofollow">
    <title>Page introuvable — InterGo RH</title>
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
            border: 1px solid rgba(99, 102, 241, 0.2);
            box-shadow: 0 0 30px rgba(99, 102, 241, 0.15), 0 15px 50px rgba(0, 0, 0, 0.4);
            border-radius: 24px;
            padding: 48px;
            text-align: center;
        }
        .error-icon {
            font-size: 54px;
            display: block;
            margin-bottom: 16px;
            animation: bounce-question 2s infinite ease-in-out;
        }
        @keyframes bounce-question {
            0% { transform: translateY(0); }
            50% { transform: translateY(-8px); filter: drop-shadow(0 0 10px rgba(99, 102, 241, 0.4)); }
            100% { transform: translateY(0); }
        }
        .error-code {
            font-size: 84px;
            font-weight: 900;
            line-height: 1;
            margin-bottom: 16px;
            letter-spacing: -2px;
            background: linear-gradient(135deg, var(--accent) 0%, var(--primary) 50%, var(--secondary) 100%);
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
        .url-box {
            background: rgba(11, 15, 25, 0.8);
            border: 1px solid rgba(99, 102, 241, 0.15);
            border-radius: 12px;
            padding: 16px 20px;
            font-size: 13px;
            color: #a5b4fc;
            text-align: left;
            margin-bottom: 28px;
        }
        .error-actions {
            display: flex;
            gap: 16px;
            justify-content: center;
            margin-bottom: 32px;
        }
        .quick-links {
            border-top: 1px solid rgba(255, 255, 255, 0.05);
            padding-top: 24px;
        }
        .quick-links p {
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--text-muted);
            font-weight: 600;
            margin-bottom: 12px !important;
        }
        .links-container {
            display: flex;
            gap: 16px;
            justify-content: center;
        }
        .links-container a {
            font-size: 13px;
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s;
        }
        .links-container a:hover {
            color: var(--accent);
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
            <span class="error-icon"><i class="fa-solid fa-map-location-dot" style="font-size:48px; background: linear-gradient(135deg, var(--accent), var(--primary)); -webkit-background-clip: text; -webkit-text-fill-color: transparent;"></i></span>
            <div class="error-code">404</div>

            <h2>Page introuvable</h2>
            <p>
                Oups ! La page que vous cherchez semble avoir disparu ou n'existe pas.
                Vérifiez l'URL ou retournez à l'accueil.
            </p>

            <!-- Requested URL info -->
            <div class="url-box">
                <strong>URL demandée :</strong>
                <span style="font-family: monospace; word-break: break-all; display: block; margin-top: 4px; color: var(--text-main);">
                    ${pageContext.errorData.requestURI}
                </span>
            </div>

            <!-- Actions -->
            <div class="error-actions">
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary btn-lg">
                    <i class="fa-solid fa-house"></i> Accueil
                </a>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-outline btn-lg">
                    <i class="fa-solid fa-lock"></i> Se connecter
                </a>
            </div>

            <!-- Quick links -->
            <div class="quick-links">
                <p>Liens utiles</p>
                <div class="links-container">
                    <a href="${pageContext.request.contextPath}/"><i class="fa-solid fa-house" style="font-size:11px;"></i> Accueil</a>
                    <a href="${pageContext.request.contextPath}/login"><i class="fa-solid fa-lock" style="font-size:11px;"></i> Connexion</a>
                    <a href="${pageContext.request.contextPath}/register"><i class="fa-solid fa-user-plus" style="font-size:11px;"></i> Inscription</a>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
