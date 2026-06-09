<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="InterGo — La plateforme de gestion des Ressources Humaines pour votre entreprise.">
    <title>InterGo — Plateforme RH Moderne</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="home-layout">

    <!-- ══ NAVBAR ══ -->
    <nav class="navbar" role="navigation" aria-label="Navigation principale">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/" aria-label="Accueil InterGo">
            <div class="navbar-logo">🧭</div>
            <span class="navbar-name">Inter<span>Go</span></span>
        </a>

        <div class="navbar-links">
            <a href="#fonctionnalites" class="navbar-link">Fonctionnalités</a>
            <a href="#apropos" class="navbar-link">À propos</a>
            <a href="#contact" class="navbar-link">Contact</a>
        </div>

        <div class="navbar-actions">
            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">Connexion</a>
            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">
                Commencer <span style="margin-left:4px;">→</span>
            </a>
        </div>
    </nav>

    <!-- ══ HERO ══ -->
    <section class="hero" aria-labelledby="heroTitle">
        <div class="hero-content">
            <div class="hero-badge fade-in">
                ✨ <span>Nouveau — Rapports PDF intégrés</span>
            </div>
            <h1 id="heroTitle" class="fade-in-delay-1">
                La gestion RH,<br><span>réinventée.</span>
            </h1>
            <p class="fade-in-delay-1">
                InterGo centralise tout ce dont votre département RH a besoin :
                gestion des employés, contrôle des accès, présences, et rapports —
                dans une interface moderne et intuitive.
            </p>
            <div class="hero-actions fade-in-delay-2">
                <a href="${pageContext.request.contextPath}/register" class="btn btn-white btn-lg">
                    🚀 Créer un compte gratuit
                </a>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-ghost btn-lg">
                    Se connecter →
                </a>
            </div>
        </div>
    </section>

    <!-- ══ STATS BAR ══ -->
    <div class="stats-bar" role="region" aria-label="Statistiques">
        <div class="stat-item">
            <span class="stat-value" id="statEmployes">0</span>
            <span class="stat-label">Employés gérés</span>
        </div>
        <div class="stat-item">
            <span class="stat-value" id="statDept">0</span>
            <span class="stat-label">Départements</span>
        </div>
        <div class="stat-item">
            <span class="stat-value" id="statRapports">0</span>
            <span class="stat-label">Rapports générés</span>
        </div>
        <div class="stat-item">
            <span class="stat-value" id="statUptime">99.9%</span>
            <span class="stat-label">Disponibilité</span>
        </div>
    </div>

    <!-- ══ FEATURES SECTION ══ -->
    <section class="section" id="fonctionnalites" aria-labelledby="featuresTitle">
        <div class="section-header">
            <div class="section-tag">Fonctionnalités</div>
            <h2 id="featuresTitle">Tout ce dont vous avez besoin</h2>
            <p class="subtitle">
                Une suite complète d'outils RH, conçue pour être simple à utiliser et puissante à exploiter.
            </p>
        </div>

        <div class="cards-grid">

            <div class="feature-card fade-in">
                <div class="card-icon indigo">👥</div>
                <h3>Gestion des Employés</h3>
                <p>Ajoutez, modifiez et consultez les profils de tous vos employés. Gérez les contrats, postes, et départements en quelques clics.</p>
            </div>

            <div class="feature-card fade-in-delay-1">
                <div class="card-icon blue">🔐</div>
                <h3>Contrôle des Accès</h3>
                <p>Définissez des rôles précis (Admin, RH, Manager, Employé) et sécurisez chaque action avec BCrypt et la gestion de sessions.</p>
            </div>

            <div class="feature-card fade-in-delay-2">
                <div class="card-icon green">📊</div>
                <h3>Rapports & Exports PDF</h3>
                <p>Générez des rapports détaillés sur les présences, les contrats ou les équipes, exportables en PDF grâce à iText7.</p>
            </div>

            <div class="feature-card fade-in">
                <div class="card-icon orange">🏢</div>
                <h3>Gestion des Départements</h3>
                <p>Organisez vos équipes par département. Visualisez les effectifs, les managers et les ressources de chaque unité.</p>
            </div>

            <div class="feature-card fade-in-delay-1">
                <div class="card-icon purple">🗓️</div>
                <h3>Présences & Congés</h3>
                <p>Suivez les entrées/sorties et les demandes de congés de vos employés avec un historique complet et filtrable.</p>
            </div>

            <div class="feature-card fade-in-delay-2">
                <div class="card-icon red">🔔</div>
                <h3>Alertes & Notifications</h3>
                <p>Soyez alerté automatiquement lors de demandes en attente, d'expirations de contrats ou d'événements importants.</p>
            </div>

        </div>
    </section>

    <!-- ══ CTA SECTION ══ -->
    <section class="cta-section" id="apropos" aria-labelledby="ctaTitle">
        <div class="hero-badge" style="margin-bottom:24px;">
            🎯 <span>Pour les équipes de toutes tailles</span>
        </div>
        <h2 id="ctaTitle">Prêt à moderniser votre RH ?</h2>
        <p>Rejoignez InterGo et donnez à votre équipe RH les outils qu'elle mérite.</p>
        <div class="hero-actions">
            <a href="${pageContext.request.contextPath}/register" class="btn btn-white btn-lg">
                ✨ Créer un compte — C'est gratuit
            </a>
            <a href="${pageContext.request.contextPath}/login" class="btn btn-ghost btn-lg">
                Se connecter →
            </a>
        </div>
    </section>

    <!-- ══ FOOTER ══ -->
    <footer id="contact" role="contentinfo">
        <div class="footer-brand">🧭 InterGo</div>
        <div class="footer-copy">© 2026 InterGo — ICT4D G19. Tous droits réservés.</div>
        <div class="footer-links">
            <a href="#">Confidentialité</a>
            <a href="#">CGU</a>
            <a href="#">Contact</a>
        </div>
    </footer>

</div>

<script>
    // ── Animated stats counter ──
    function animateCounter(elementId, target, suffix, duration) {
        const el = document.getElementById(elementId);
        if (!el) return;
        const start = 0;
        const startTime = performance.now();

        function update(currentTime) {
            const elapsed = currentTime - startTime;
            const progress = Math.min(elapsed / duration, 1);
            const eased = 1 - Math.pow(1 - progress, 3); // ease-out cubic
            const value = Math.round(start + (target - start) * eased);
            el.textContent = value.toLocaleString('fr-FR') + (suffix || '');
            if (progress < 1) requestAnimationFrame(update);
        }
        requestAnimationFrame(update);
    }

    // Trigger on scroll into view
    const statsObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                animateCounter('statEmployes', 1250, '+', 1800);
                animateCounter('statDept',    32,   '',  1400);
                animateCounter('statRapports', 4800, '+', 2000);
                statsObserver.disconnect();
            }
        });
    }, { threshold: 0.3 });

    const statsBar = document.querySelector('.stats-bar');
    if (statsBar) statsObserver.observe(statsBar);

    // ── Smooth scroll for anchor links ──
    document.querySelectorAll('a[href^="#"]').forEach(link => {
        link.addEventListener('click', function(e) {
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                e.preventDefault();
                target.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        });
    });

    // ── Navbar scroll shadow ──
    const navbar = document.querySelector('.navbar');
    window.addEventListener('scroll', () => {
        if (window.scrollY > 10) {
            navbar.style.boxShadow = '0 4px 24px rgba(79,70,229,0.12)';
        } else {
            navbar.style.boxShadow = '';
        }
    });

    // ── Feature cards staggered reveal ──
    const cardObserver = new IntersectionObserver((entries) => {
        entries.forEach((entry, i) => {
            if (entry.isIntersecting) {
                entry.target.style.animationPlayState = 'running';
                cardObserver.unobserve(entry.target);
            }
        });
    }, { threshold: 0.1 });

    document.querySelectorAll('.feature-card').forEach(card => {
        card.style.animationPlayState = 'paused';
        cardObserver.observe(card);
    });
</script>

</body>
</html>