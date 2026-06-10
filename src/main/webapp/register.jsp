<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Créez votre compte InterGo pour accéder à la plateforme RH.">
    <title>Créer un compte — InterGo RH</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Custom CSS -->
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <!-- Google reCAPTCHA v3 disabled in local
    <script src="https://www.google.com/recaptcha/api.js?render=6LfIVQQtAAAAAFbeVPQ83R9Xiwzsvz35gfYH9k4j"></script>
    -->
</head>
<body>

<!-- Ambient background glow -->
<div class="bg-glow-container">
    <div class="glow-blob blob-1"></div>
    <div class="glow-blob blob-2"></div>
    <div class="glow-blob blob-3"></div>
</div>

<div class="auth-layout">

    <!-- ── Left Panel ── -->
    <div class="auth-left">
        <div class="auth-left-content">
            <a class="auth-brand fade-in" href="${pageContext.request.contextPath}/">
                <i class="fa-solid fa-compass navbar-brand-icon"></i>
                <span class="auth-brand-name">InterGo</span>
            </a>

            <h1 class="fade-in-delay-1">Rejoignez<br>votre équipe <i class="fa-solid fa-star text-gradient" style="font-size:36px;"></i></h1>
            <p class="fade-in-delay-1">Créez votre compte et accédez à tous les outils RH dont votre entreprise a besoin.</p>

            <div class="auth-image-container fade-in-delay-2">
                <img src="${pageContext.request.contextPath}/images/auth_illustration.png" alt="Futuristic 3D security shield" class="auth-image-3d">
            </div>
        </div>
    </div>

    <!-- ── Right Panel ── -->
    <div class="auth-right">
        <div class="auth-card fade-in neon-glow-active">

            <div class="auth-card-header">
                <h2>Créer un compte</h2>
                <p>Remplissez le formulaire pour rejoindre InterGo</p>
            </div>

            <!-- Messages -->
            <c:if test="${not empty erreur}">
                <div class="alert alert-error" role="alert">
                    <span class="alert-icon"><i class="fa-solid fa-triangle-exclamation"></i></span>
                    <span>${erreur}</span>
                </div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="alert alert-success" role="alert">
                    <span class="alert-icon"><i class="fa-solid fa-circle-check"></i></span>
                    <span>${message}</span>
                </div>
            </c:if>

            <form id="registerForm" action="${pageContext.request.contextPath}/register" method="post" novalidate>
                <input type="hidden" name="recaptcha-token" id="recaptcha-token">

                <!-- Email -->
                <div class="form-group">
                    <label class="form-label" for="email">Adresse e-mail professionnelle</label>
                    <div class="input-wrapper">
                        <span class="input-icon"><i class="fa-solid fa-envelope"></i></span>
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
                    <div class="field-error" id="emailError" style="color:#ef4444;font-size:12px;margin-top:4px;display:none;"></div>
                </div>

                <!-- Mot de passe -->
                <div class="form-group">
                    <label class="form-label" for="motDePasse">Mot de passe</label>
                    <div class="input-wrapper">
                        <span class="input-icon"><i class="fa-solid fa-lock"></i></span>
                        <input
                            type="password"
                            id="motDePasse"
                            name="motDePasse"
                            class="form-input"
                            placeholder="Au moins 8 caractères"
                            required
                            autocomplete="new-password"
                        >
                        <button type="button" class="btn-toggle-password" id="togglePassword" aria-label="Afficher le mot de passe"><i class="fa-solid fa-eye" id="toggleIcon1"></i></button>
                    </div>
                    <!-- Password strength indicator -->
                    <div class="password-strength" id="strengthContainer" style="display:none;">
                        <div class="strength-bar">
                            <div class="strength-segment" id="seg1"></div>
                            <div class="strength-segment" id="seg2"></div>
                            <div class="strength-segment" id="seg3"></div>
                            <div class="strength-segment" id="seg4"></div>
                        </div>
                        <span class="strength-label" id="strengthLabel">Sécurité du mot de passe</span>
                    </div>
                    <div class="field-error" id="mdpError" style="color:#ef4444;font-size:12px;margin-top:4px;display:none;"></div>
                </div>

                <!-- Confirmation mot de passe -->
                <div class="form-group">
                    <label class="form-label" for="confirmerMotDePasse">Confirmer le mot de passe</label>
                    <div class="input-wrapper">
                        <span class="input-icon"><i class="fa-solid fa-key"></i></span>
                        <input
                            type="password"
                            id="confirmerMotDePasse"
                            name="confirmerMotDePasse"
                            class="form-input"
                            placeholder="Répétez votre mot de passe"
                            required
                            autocomplete="new-password"
                        >
                        <button type="button" class="btn-toggle-password" id="toggleConfirm" aria-label="Afficher la confirmation"><i class="fa-solid fa-eye" id="toggleIcon2"></i></button>
                    </div>
                    <div class="field-error" id="confirmError" style="color:#ef4444;font-size:12px;margin-top:4px;display:none;"></div>
                </div>

                <!-- Lien avec un employé -->
                <div class="form-group">
                    <label class="form-label" for="employeId">
                        Identifiant Employé
                        <span style="font-weight:400;color:var(--text-muted);"> (optionnel)</span>
                    </label>
                    <div class="input-wrapper">
                        <span class="input-icon"><i class="fa-solid fa-id-card"></i></span>
                        <input
                            type="number"
                            id="employeId"
                            name="employeId"
                            class="form-input"
                            placeholder="Ex: 1042"
                            min="1"
                            value="${not empty param.employeId ? param.employeId : ''}"
                            autocomplete="off"
                        >
                    </div>
                    <div style="font-size:12px;color:var(--text-muted);margin-top:5px;">
                        <i class="fa-solid fa-circle-info" style="color:var(--accent);"></i> Si vous êtes déjà enregistré comme employé, liez votre compte avec votre ID.
                    </div>
                    <div class="field-error" id="empIdError" style="color:#ef4444;font-size:12px;margin-top:4px;display:none;"></div>
                </div>

                <!-- Rôle demandé -->
                <div class="form-group">
                    <label class="form-label" for="roleDemande">Rôle demandé</label>
                    <div class="input-wrapper">
                        <span class="input-icon"><i class="fa-solid fa-user-tag"></i></span>
                        <select id="roleDemande" name="roleDemande" class="form-select">
                            <option value="">-- Sélectionner un rôle --</option>
                            <option value="EMPLOYE" ${param.roleDemande == 'EMPLOYE' ? 'selected' : ''}>Employé</option>
                            <option value="MANAGER" ${param.roleDemande == 'MANAGER' ? 'selected' : ''}>Manager</option>
                            <option value="RH"      ${param.roleDemande == 'RH'      ? 'selected' : ''}>Ressources Humaines</option>
                            <option value="ADMIN"   ${param.roleDemande == 'ADMIN'   ? 'selected' : ''}>Administrateur</option>
                        </select>
                    </div>
                    <div style="font-size:12px;color:var(--text-muted);margin-top:5px;">
                        <i class="fa-solid fa-circle-info" style="color:var(--accent);"></i> Les rôles Administrateur seront validés par un super-admin.
                    </div>
                </div>

                <!-- CGU -->
                <div class="form-group">
                    <label class="checkbox-label" style="align-items:flex-start;gap:10px;">
                        <input type="checkbox" id="accepteCgu" name="accepteCgu" style="margin-top:3px;">
                        <span style="font-size:13px;color:var(--text-secondary);">
                            J'accepte les
                            <a href="#" class="link-sm">Conditions d'utilisation</a>
                            et la
                            <a href="#" class="link-sm">Politique de confidentialité</a>
                        </span>
                    </label>
                    <div class="field-error" id="cguError" style="color:#ef4444;font-size:12px;margin-top:4px;display:none;"></div>
                </div>

                <!-- Submit -->
                <button type="submit" id="registerBtn" class="btn btn-primary btn-full btn-lg">
                    <span id="registerBtnText">Créer mon compte</span>
                    <span id="registerSpinner" style="display:none;"><i class="fa-solid fa-circle-notch fa-spin"></i></span>
                </button>

            </form>

            <div class="auth-footer">
                Déjà un compte ?
                <a href="${pageContext.request.contextPath}/login">Se connecter</a>
            </div>

        </div>
    </div>
</div>

<script>
    // ── Toggle password visibility ──
    function setupToggle(toggleId, inputId, iconId) {
        const btn = document.getElementById(toggleId);
        const inp = document.getElementById(inputId);
        const icon = document.getElementById(iconId);
        let vis = false;
        btn.addEventListener('click', () => {
            vis = !vis;
            inp.type = vis ? 'text' : 'password';
            icon.className = vis ? 'fa-solid fa-eye-slash' : 'fa-solid fa-eye';
        });
    }
    setupToggle('togglePassword', 'motDePasse', 'toggleIcon1');
    setupToggle('toggleConfirm', 'confirmerMotDePasse', 'toggleIcon2');

    // ── Password strength ──
    const passwordInput = document.getElementById('motDePasse');
    const strengthContainer = document.getElementById('strengthContainer');
    const strengthLabel = document.getElementById('strengthLabel');
    const segments = [document.getElementById('seg1'), document.getElementById('seg2'),
                      document.getElementById('seg3'), document.getElementById('seg4')];

    function checkStrength(pwd) {
        let score = 0;
        if (pwd.length >= 8)  score++;
        if (/[A-Z]/.test(pwd))  score++;
        if (/[0-9]/.test(pwd))  score++;
        if (/[^A-Za-z0-9]/.test(pwd)) score++;
        return score;
    }

    passwordInput.addEventListener('input', function() {
        const pwd = this.value;
        if (pwd.length === 0) { strengthContainer.style.display = 'none'; return; }
        strengthContainer.style.display = 'block';
        const score = checkStrength(pwd);
        const cls = score <= 1 ? 'weak' : score <= 2 ? 'medium' : 'strong';
        const labels = { weak: '🔴 Faible', medium: '🟡 Moyen', strong: score === 4 ? '🟢 Très fort' : '🟢 Fort' };
        segments.forEach((seg, i) => {
            seg.className = 'strength-segment';
            if (i < score) seg.classList.add('active', cls);
        });
        strengthLabel.textContent = labels[cls] || '';
    });

    // ── Form Validation & reCAPTCHA trigger ──
    const registerForm = document.getElementById('registerForm');
    registerForm.addEventListener('submit', function(e) {
        e.preventDefault(); // Stop instant submission
        
        let valid = true;

        const email   = document.getElementById('email').value.trim();
        const pwd     = document.getElementById('motDePasse').value;
        const confirm = document.getElementById('confirmerMotDePasse').value;
        const empId   = document.getElementById('employeId').value;
        const cgu     = document.getElementById('accepteCgu').checked;

        const clearErrors = () => {
            ['emailError','mdpError','confirmError','empIdError','cguError'].forEach(id => {
                const el = document.getElementById(id);
                el.style.display = 'none';
                el.textContent   = '';
            });
        };
        clearErrors();

        function showError(id, msg, inputId) {
            const err = document.getElementById(id);
            err.textContent = msg;
            err.style.display = 'block';
            if (inputId) document.getElementById(inputId).style.borderColor = '#ef4444';
            valid = false;
        }

        if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
            showError('emailError', 'Adresse e-mail invalide.', 'email');
        }
        if (!pwd || pwd.length < 8) {
            showError('mdpError', 'Le mot de passe doit contenir au moins 8 caractères.', 'motDePasse');
        }
        if (pwd !== confirm) {
            showError('confirmError', 'Les mots de passe ne correspondent pas.', 'confirmerMotDePasse');
        }
        if (empId && (isNaN(empId) || parseInt(empId) < 1)) {
            showError('empIdError', "L'identifiant employé doit être un nombre positif.", 'employeId');
        }
        if (!cgu) {
            showError('cguError', 'Veuillez accepter les conditions d\'utilisation.', null);
        }

        if (!valid) { return; }

        const btn  = document.getElementById('registerBtn');
        const text = document.getElementById('registerBtnText');
        const spin = document.getElementById('registerSpinner');
        btn.disabled = true;
        text.textContent = 'Création en cours…';
        spin.style.display = 'inline-block';

        // Directly submit form in local environment
        registerForm.submit();
    });

    // Reset borders on input
    ['email','motDePasse','confirmerMotDePasse','employeId'].forEach(id => {
        document.getElementById(id).addEventListener('input', function() {
            this.style.borderColor = '';
        });
    });
</script>

</body>
</html>
