<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="InterGo — La plateforme de gestion des Ressources Humaines pour votre entreprise.">
    <title>InterGo — Plateforme RH Moderne</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<!-- Ambient background glow -->
<div class="bg-glow-container">
    <div class="glow-blob blob-1"></div>
    <div class="glow-blob blob-2"></div>
    <div class="glow-blob blob-3"></div>
</div>

<!-- Decorative background circles -->
<div class="decorations">
    <div class="decor-circle circle-1"></div>
    <div class="decor-circle circle-2"></div>
    <div class="decor-circle circle-3"></div>
</div>


<div class="home-layout">

    <!-- ══ NAVBAR ══ -->
    <nav class="navbar" role="navigation" aria-label="Navigation principale">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/" aria-label="Accueil InterGo">
            <div class="navbar-logo"><i class="fa-solid fa-compass navbar-brand-icon"></i></div>
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
                Commencer <i class="fa-solid fa-arrow-right"></i>
            </a>
        </div>
    </nav>

    <!-- ══ HERO ══ -->
    <section class="hero" aria-labelledby="heroTitle">
        <div class="hero-grid">
            <div class="hero-content">
                <div class="hero-badge fade-in">
                    <i class="fa-solid fa-star text-gradient"></i> <span>Nouveau — Rapports PDF intégrés</span>
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
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-lg">
                        <i class="fa-solid fa-rocket"></i> Créer un compte gratuit
                    </a>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-ghost btn-lg">
                        Se connecter <i class="fa-solid fa-arrow-right" style="margin-left:4px;"></i>
                    </a>
                </div>
            </div>
            
            <div class="hero-image-area fade-in-delay-1">
                <div class="browser-mockup neon-glow-active">
                    <div class="browser-header">
                        <span class="browser-dot red"></span>
                        <span class="browser-dot yellow"></span>
                        <span class="browser-dot green"></span>
                        <div class="browser-address-bar"><i class="fa-solid fa-lock"></i> intergo.io/dashboard</div>
                    </div>
                    <div class="browser-content">
                        <video autoplay loop muted playsinline class="hero-video-3d" poster="${pageContext.request.contextPath}/images/hero_illustration.png">
                            <source src="${pageContext.request.contextPath}/images/hero_video.mp4" type="video/mp4">
                            <img src="${pageContext.request.contextPath}/images/hero_illustration.png" alt="Futuristic 3D sphere" class="hero-image-fallback">
                        </video>
                    </div>
                </div>
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

    <!-- ══ SHOWCASE EMPLOYEES ══ -->
    <section class="section" id="showcase-employees" aria-labelledby="showcaseEmployeesTitle">
        <div class="showcase-grid">
            <div class="showcase-content fade-in">
                <div class="section-tag">Gestion d'Équipe</div>
                <h2 id="showcaseEmployeesTitle">Visualisez et gérez vos talents sans effort</h2>
                <p>
                    Notre module de gestion des employés offre une vue d'ensemble claire et structurée.
                    Accédez instantanément aux profils, suivez les rôles, les dates d'embauche et
                    organisez vos effectifs avec une précision inégalée.
                </p>
                <ul class="showcase-list">
                    <li><i class="fa-solid fa-circle-check text-gradient"></i> Profils détaillés et complets</li>
                    <li><i class="fa-solid fa-circle-check text-gradient"></i> Attribution des rôles et départements</li>
                    <li><i class="fa-solid fa-circle-check text-gradient"></i> Recherche et filtrage multicritères</li>
                </ul>
            </div>
            <div class="showcase-image-area fade-in-delay-1">
                <div class="showcase-image-container">
                    <img src="${pageContext.request.contextPath}/images/employee_card.png" alt="Employee profile visualization" class="showcase-image-3d">
                </div>
            </div>
        </div>
    </section>

    <!-- ══ SHOWCASE REPORTS ══ -->
    <section class="section" id="showcase-reports" aria-labelledby="showcaseReportsTitle">
        <div class="showcase-grid reverse">
            <div class="showcase-content fade-in">
                <div class="section-tag">Analyses & Rapports</div>
                <h2 id="showcaseReportsTitle">Prenez des décisions basées sur les données</h2>
                <p>
                    Visualisez les statistiques de vos ressources humaines en temps réel. Générez en un instant
                    des rapports complets sur la masse salariale, la répartition par département,
                    et exportez le tout au format PDF professionnel en un seul clic.
                </p>
                <ul class="showcase-list">
                    <li><i class="fa-solid fa-circle-check text-gradient-cyan"></i> Exportations PDF professionnelles</li>
                    <li><i class="fa-solid fa-circle-check text-gradient-cyan"></i> Graphiques interactifs et modernes</li>
                    <li><i class="fa-solid fa-circle-check text-gradient-cyan"></i> Historique complet des transactions</li>
                </ul>
            </div>
            <div class="showcase-image-area fade-in-delay-1">
                <div class="showcase-image-container">
                    <img src="${pageContext.request.contextPath}/images/chart_illustration.png" alt="Analytics and charts showcase" class="showcase-image-3d">
                </div>
            </div>
        </div>
    </section>

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
                <div class="card-icon indigo"><i class="fa-solid fa-users"></i></div>
                <h3>Gestion des Employés</h3>
                <p>Ajoutez, modifiez et consultez les profils de tous vos employés. Gérez les contrats, postes, et départements en quelques clics.</p>
            </div>

            <div class="feature-card fade-in-delay-1">
                <div class="card-icon cyan"><i class="fa-solid fa-shield-halved"></i></div>
                <h3>Contrôle des Accès</h3>
                <p>Définissez des rôles précis (Admin, RH, Manager, Employé) et sécurisez chaque action avec BCrypt et la gestion de sessions.</p>
            </div>

            <div class="feature-card fade-in-delay-2">
                <div class="card-icon green"><i class="fa-solid fa-chart-line"></i></div>
                <h3>Rapports & Exports PDF</h3>
                <p>Générez des rapports détaillés sur les présences, les contrats ou les équipes, exportables en PDF grâce à iText7.</p>
            </div>

            <div class="feature-card fade-in">
                <div class="card-icon orange"><i class="fa-solid fa-building"></i></div>
                <h3>Gestion des Départements</h3>
                <p>Organisez vos équipes par département. Visualisez les effectifs, les managers et les ressources de chaque unité.</p>
            </div>

            <div class="feature-card fade-in-delay-1">
                <div class="card-icon violet"><i class="fa-solid fa-calendar-alt"></i></div>
                <h3>Présences & Congés</h3>
                <p>Suivez les entrées/sorties et les demandes de congés de vos employés avec un historique complet et filtrable.</p>
            </div>

            <div class="feature-card fade-in-delay-2">
                <div class="card-icon red"><i class="fa-solid fa-bell"></i></div>
                <h3>Alertes & Notifications</h3>
                <p>Soyez alerté automatiquement lors de demandes en attente, d'expirations de contrats ou d'événements importants.</p>
            </div>

        </div>
    </section>

    <!-- ══ CTA SECTION ══ -->
    <section class="cta-section" id="apropos" aria-labelledby="ctaTitle">
        <div class="hero-badge" style="margin-bottom:24px;">
            <i class="fa-solid fa-bullseye"></i> <span>Pour les équipes de toutes tailles</span>
        </div>
        <h2 id="ctaTitle">Prêt à moderniser votre RH ?</h2>
        <p>Rejoignez InterGo et donnez à votre équipe RH les outils qu'elle mérite.</p>
        <div class="hero-actions">
            <a href="${pageContext.request.contextPath}/register" class="btn btn-white btn-lg">
                <i class="fa-solid fa-wand-magic-sparkles"></i> Créer un compte — C'est gratuit
            </a>
            <a href="${pageContext.request.contextPath}/login" class="btn btn-ghost btn-lg">
                Se connecter <i class="fa-solid fa-arrow-right" style="margin-left:4px;"></i>
            </a>
        </div>
    </section>

    <!-- ══ FOOTER ══ -->
    <footer id="contact" role="contentinfo">
        <div class="footer-brand"><i class="fa-solid fa-compass" style="color:var(--accent); margin-right: 8px;"></i>InterGo</div>
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

    // ── Crazy 3D Card Hover Tilt Effect ──
    document.querySelectorAll('.feature-card').forEach(card => {
        card.addEventListener('mousemove', e => {
            const rect = card.getBoundingClientRect();
            const x = e.clientX - rect.left;
            const y = e.clientY - rect.top;
            const xc = rect.width / 2;
            const yc = rect.height / 2;
            const angleX = (yc - y) / 12;
            const angleY = (x - xc) / 12;
            card.style.transform = `perspective(1000px) rotateX(${angleX}deg) rotateY(${angleY}deg) translateY(-10px)`;
        });
        card.addEventListener('mouseleave', () => {
            card.style.transform = '';
        });
    });

    // ── Lambda User Interaction Simulation ──
    function runUserSimulation() {
        const cursor = document.createElement('div');
        cursor.className = 'virtual-cursor';
        document.body.appendChild(cursor);

        const getElementCoords = (selector) => {
            const el = document.querySelector(selector);
            if (!el) return null;
            const rect = el.getBoundingClientRect();
            return {
                x: rect.left + rect.width / 2,
                y: rect.top + rect.height / 2,
                element: el
            };
        };

        function moveCursor(x, y, duration, callback) {
            cursor.style.opacity = '1';
            const startX = parseFloat(cursor.style.left) || window.innerWidth / 2;
            const startY = parseFloat(cursor.style.top) || window.innerHeight + 100;
            const startTime = performance.now();

            function animate(time) {
                const elapsed = time - startTime;
                const progress = Math.min(elapsed / duration, 1);
                const ease = progress < 0.5 ? 4 * progress * progress * progress : 1 - Math.pow(-2 * progress + 2, 3) / 2;
                
                const currentX = startX + (x - startX) * ease;
                const currentY = startY + (y - startY) * ease;
                
                cursor.style.left = currentX + 'px';
                cursor.style.top = currentY + 'px';

                if (progress < 1) {
                    requestAnimationFrame(animate);
                } else if (callback) {
                    callback();
                }
            }
            requestAnimationFrame(animate);
        }

        function clickEffect(x, y) {
            const wave = document.createElement('div');
            wave.className = 'click-wave';
            wave.style.left = x + 'px';
            wave.style.top = y + 'px';
            document.body.appendChild(wave);
            setTimeout(() => wave.remove(), 800);
        }

        function step1() {
            const coords = getElementCoords('.hero-badge');
            if (!coords) return;
            moveCursor(coords.x, coords.y, 1500, () => {
                setTimeout(step2, 800);
            });
        }

        function step2() {
            const coords = getElementCoords('.hero-actions .btn-primary');
            if (!coords) return;
            moveCursor(coords.x, coords.y, 1200, () => {
                coords.element.classList.add('hover-simulated');
                setTimeout(() => {
                    clickEffect(coords.x, coords.y);
                    coords.element.classList.remove('hover-simulated');
                    setTimeout(step3, 1000);
                }, 500);
            });
        }

        function step3() {
            window.scrollTo({ top: 600, behavior: 'smooth' });
            setTimeout(() => {
                const coords = getElementCoords('#showcase-employees .showcase-image-3d');
                if (!coords) return;
                moveCursor(coords.x, coords.y, 1500, () => {
                    const card = coords.element;
                    card.style.transform = 'perspective(1000px) rotateX(10deg) rotateY(-15deg) scale(1.05)';
                    card.style.boxShadow = '0 30px 60px rgba(99, 102, 241, 0.4)';
                    setTimeout(() => {
                        card.style.transform = '';
                        card.style.boxShadow = '';
                        setTimeout(step4, 1000);
                    }, 1500);
                });
            }, 1000);
        }

        function step4() {
            window.scrollTo({ top: 1800, behavior: 'smooth' });
            setTimeout(() => {
                const cards = document.querySelectorAll('.feature-card');
                if (cards.length === 0) return;
                const targetCard = cards[0];
                const rect = targetCard.getBoundingClientRect();
                const cx = rect.left + rect.width / 2;
                const cy = rect.top + rect.height / 2;
                moveCursor(cx, cy, 1500, () => {
                    targetCard.style.transform = 'perspective(1000px) rotateX(5deg) rotateY(5deg) translateY(-10px)';
                    targetCard.style.borderColor = 'var(--border-glow-active)';
                    targetCard.style.boxShadow = '0 20px 45px rgba(99, 102, 241, 0.25)';
                    setTimeout(() => {
                        targetCard.style.transform = '';
                        targetCard.style.borderColor = '';
                        targetCard.style.boxShadow = '';
                        cursor.style.opacity = '0';
                        setTimeout(() => {
                            window.scrollTo({ top: 0, behavior: 'smooth' });
                            setTimeout(runUserSimulationLoop, 8000);
                        }, 1500);
                    }, 2000);
                });
            }, 1000);
        }

        function runUserSimulationLoop() {
            cursor.style.left = (window.innerWidth / 2) + 'px';
            cursor.style.top = (window.innerHeight + 100) + 'px';
            step1();
        }

        setTimeout(runUserSimulationLoop, 4000);
    }

    window.addEventListener('load', () => {
        runUserSimulation();
    });
</script>

</body>
</html>