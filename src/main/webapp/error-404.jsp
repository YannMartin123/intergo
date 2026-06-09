<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="noindex, nofollow">
    <title>Page introuvable — InterGo RH</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <!-- Navbar -->
    <nav class="error-navbar">
        <a href="${pageContext.request.contextPath}/" style="display:flex;align-items:center;gap:10px;text-decoration:none;">
            <div class="navbar-logo" style="width:32px;height:32px;font-size:16px;border-radius:8px;background:linear-gradient(135deg,#4F46E5,#6366F1);display:flex;align-items:center;justify-content:center;color:white;">🧭</div>
            <span style="font-size:18px;font-weight:800;color:#1E1B4B;">Inter<span style="color:#4F46E5;">Go</span></span>
        </a>
    </nav>

    <div class="error-layout" style="padding-top:64px;">
        <div class="error-card fade-in">

            <span class="error-icon">🗺️</span>
            <span class="error-code">404</span>

            <h2>Page introuvable</h2>
            <p>
                Oups ! La page que vous cherchez semble avoir disparu ou n'existe pas.
                Vérifiez l'URL ou retournez à l'accueil.
            </p>

            <!-- Requested URL info -->
            <div style="background:#F0F4FF;border:1px solid #E0E7FF;border-radius:8px;padding:12px 16px;margin-bottom:28px;font-size:13px;color:#4F46E5;text-align:left;">
                <strong>URL demandée :</strong>
                <span style="font-family:'Courier New',monospace;word-break:break-all;">
                    ${pageContext.errorData.requestURI}
                </span>
            </div>

            <div class="error-actions">
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                    🏠 Retour à l'accueil
                </a>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">
                    🔐 Se connecter
                </a>
            </div>

            <!-- Quick links -->
            <div style="margin-top:36px;padding-top:28px;border-top:1px solid #E5E7EB;">
                <p style="font-size:13px;color:#9CA3AF;margin-bottom:14px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;">Liens utiles</p>
                <div style="display:flex;gap:12px;justify-content:center;flex-wrap:wrap;">
                    <a href="${pageContext.request.contextPath}/" style="font-size:13px;color:#4F46E5;font-weight:500;">🏠 Accueil</a>
                    <a href="${pageContext.request.contextPath}/login" style="font-size:13px;color:#4F46E5;font-weight:500;">🔐 Connexion</a>
                    <a href="${pageContext.request.contextPath}/register" style="font-size:13px;color:#4F46E5;font-weight:500;">✨ Inscription</a>
                </div>
            </div>

        </div>
    </div>

    <script>
        // Add a fun particle effect in the background
        document.addEventListener('DOMContentLoaded', () => {
            const emojis = ['🗺️', '🔍', '❓', '💭', '🌐'];
            for (let i = 0; i < 8; i++) {
                const el = document.createElement('div');
                el.textContent = emojis[Math.floor(Math.random() * emojis.length)];
                el.style.cssText = `
                    position: fixed;
                    font-size: ${16 + Math.random() * 20}px;
                    opacity: 0.06;
                    top: ${Math.random() * 100}vh;
                    left: ${Math.random() * 100}vw;
                    pointer-events: none;
                    animation: float ${4 + Math.random() * 4}s ease-in-out infinite;
                    animation-delay: ${Math.random() * 3}s;
                    z-index: 0;
                `;
                document.body.appendChild(el);
            }
        });
    </script>

</body>
</html>
