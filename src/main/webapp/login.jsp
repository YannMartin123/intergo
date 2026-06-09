<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Connectez-vous à InterGo, la plateforme de gestion RH de votre entreprise.">
    <title>Connexion — InterGo RH</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="auth-layout">

    <!-- ── Left Panel ── -->
    <div class="auth-left">
        <div class="auth-left-content">
            <div class="auth-brand fade-in">
                <div class="auth-brand-icon">🧭</div>
                <span class="auth-brand-name">InterGo</span>
            </div>

            <h1 class="fade-in-delay-1">Gérez vos&nbsp;<br>Ressources Humaines</h1>
            <p class="fade-in-delay-1">Une plateforme centralisée pour gérer vos employés, rôles, présences et bien plus encore.</p>

            <div class="auth-features fade-in-delay-2">
                <div class="auth-feature">
                    <span class="auth-feature-icon">👥</span>
                    <span class="auth-feature-text">Gestion complète des employés</span>
                </div>
                <div class="auth-feature">
                    <span class="auth-feature-icon">📊</span>
                    <span class="auth-feature-text">Tableaux de bord & rapports PDF</span>
                </div>
                <div class="auth-feature">
                    <span class="auth-feature-icon">🔐</span>
                    <span class="auth-feature-text">Contrôle d'accès par rôles</span>
                </div>
                <div class="auth-feature">
                    <span class="auth-feature-icon">⚡</span>
                    <span class="auth-feature-text">Interface rapide et intuitive</span>
                </div>
            </div>
        </div>
    </div>

    <!-- ── Right Panel ── -->
    <div class="auth-right">
        <div class="auth-card fade-in">

            <div class="auth-card-header">
                <h2>Bon retour 👋</h2>
                <p>Connectez-vous à votre espace InterGo</p>
            </div>

            <!-- Messages d'erreur / succès -->
            <c:if test="${not empty erreur}">
                <div class="alert alert-error" role="alert">
                    <span class="alert-icon">⚠️</span>
                    <span>${erreur}</span>
                </div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="alert alert-success" role="alert">
                    <span class="alert-icon">✅</span>
                    <span>${message}</span>
                </div>
            </c:if>

            <form id="loginForm" action="${pageContext.request.contextPath}/login" method="post" novalidate>

                <!-- Email -->
                <div class="form-group">
                    <label class="form-label" for="email">Adresse e-mail</label>
                    <div class="input-wrapper">
                        <span class="input-icon">✉️</span>
                        <input
                            type="email"
                            id="email"
                            name="email"
                            class="form-input"
                            placeholder="nom@entreprise.com"
                            value="${not empty param.email ? param.email : ''}"
                            required
                            autocomplete="email"
                        >
                    </div>
                    <div class="field-error" id="emailError" style="color:#EF4444;font-size:12px;margin-top:4px;display:none;"></div>
                </div>

                <!-- Mot de passe -->
                <div class="form-group">
                    <label class="form-label" for="motDePasse">Mot de passe</label>
                    <div class="input-wrapper">
                        <span class="input-icon">🔒</span>
                        <input
                            type="password"
                            id="motDePasse"
                            name="motDePasse"
                            class="form-input"
                            placeholder="••••••••"
                            required
                            autocomplete="current-password"
                        >
                        <button type="button" class="btn-toggle-password" id="togglePassword" aria-label="Afficher/Masquer le mot de passe">👁️</button>
                    </div>
                    <div class="field-error" id="mdpError" style="color:#EF4444;font-size:12px;margin-top:4px;display:none;"></div>
                </div>

                <!-- Options -->
                <div class="form-options">
                    <label class="checkbox-label">
                        <input type="checkbox" id="rememberMe" name="rememberMe"> Se souvenir de moi
                    </label>
                    <a href="${pageContext.request.contextPath}/mot-de-passe-oublie" class="link-sm">Mot de passe oublié ?</a>
                </div>

                <!-- Submit -->
                <button type="submit" id="loginBtn" class="btn btn-primary btn-full btn-lg">
                    <span id="loginBtnText">Se connecter</span>
                    <span id="loginSpinner" style="display:none;">⏳</span>
                </button>

            </form>

            <div class="auth-divider">
                <span>ou continuez avec</span>
            </div>

            <div style="display:flex;gap:10px;">
                <button type="button" class="btn btn-outline" style="flex:1;" disabled>
                    <span>🏢</span> SSO Entreprise
                </button>
                <button type="button" class="btn btn-outline" style="flex:1;" disabled>
                    <span>📧</span> LDAP
                </button>
            </div>

            <div class="auth-footer">
                Pas encore de compte ?
                <a href="${pageContext.request.contextPath}/register">Créer un compte</a>
            </div>

        </div>
    </div>
</div>

<script>
    // Toggle password visibility
    const toggleBtn = document.getElementById('togglePassword');
    const passwordInput = document.getElementById('motDePasse');
    let visible = false;
    toggleBtn.addEventListener('click', () => {
        visible = !visible;
        passwordInput.type = visible ? 'text' : 'password';
        toggleBtn.textContent = visible ? '🙈' : '👁️';
    });

    // Client-side validation
    const loginForm = document.getElementById('loginForm');
    loginForm.addEventListener('submit', function(e) {
        let valid = true;
        const email = document.getElementById('email').value.trim();
        const mdp   = document.getElementById('motDePasse').value;
        const emailError = document.getElementById('emailError');
        const mdpError   = document.getElementById('mdpError');

        emailError.style.display = 'none';
        mdpError.style.display   = 'none';

        if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
            emailError.textContent = 'Veuillez entrer une adresse e-mail valide.';
            emailError.style.display = 'block';
            document.getElementById('email').style.borderColor = '#EF4444';
            valid = false;
        }
        if (!mdp || mdp.length < 6) {
            mdpError.textContent = 'Le mot de passe doit contenir au moins 6 caractères.';
            mdpError.style.display = 'block';
            document.getElementById('motDePasse').style.borderColor = '#EF4444';
            valid = false;
        }
        if (!valid) {
            e.preventDefault();
            return;
        }

        // Loading state
        const btn  = document.getElementById('loginBtn');
        const text = document.getElementById('loginBtnText');
        const spin = document.getElementById('loginSpinner');
        btn.disabled = true;
        text.textContent = 'Connexion…';
        spin.style.display = 'inline';
    });

    // Reset border on input
    document.getElementById('email').addEventListener('input', function() { this.style.borderColor = ''; });
    document.getElementById('motDePasse').addEventListener('input', function() { this.style.borderColor = ''; });
</script>

</body>
</html>
