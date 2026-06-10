<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<jsp:include page="/layout-header.jsp">
    <jsp:param name="active" value="doc" />
</jsp:include>

<div class="page-title fade-in">
    <div>
        <h1 class="text-gradient">Spécifications & Architecture</h1>
        <p style="color:var(--text-secondary); font-size:14px; margin-top:4px;">Documentation interactive et modélisations techniques animées de la plateforme InterGo.</p>
    </div>
</div>

<!-- Navigation Tabs -->
<div class="fade-in-delay-1" style="display:flex; gap:16px; margin-bottom:32px; border-bottom:1px solid rgba(255,255,255,0.05); padding-bottom:16px;">
    <button onclick="switchTab('tab-architecture')" class="btn btn-outline active-tab-btn" id="btn-tab-architecture" style="font-size:14px; padding:10px 20px;">Architecture & Flux</button>
    <button onclick="switchTab('tab-database')" class="btn btn-outline" id="btn-tab-database" style="font-size:14px; padding:10px 20px;">MCD / MLD Schema</button>
    <button onclick="switchTab('tab-classes')" class="btn btn-outline" id="btn-tab-classes" style="font-size:14px; padding:10px 20px;">Diagramme de Classes</button>
    <button onclick="switchTab('tab-usecases')" class="btn btn-outline" id="btn-tab-usecases" style="font-size:14px; padding:10px 20px;">Cas d'Utilisation</button>
</div>

<!-- ════════ TAB: ARCHITECTURE & FLUX ════════ -->
<div id="tab-architecture" class="tab-content fade-in-delay-2">
    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:32px; margin-bottom:32px;">
        
        <!-- Technical MVC Architecture -->
        <div class="card-panel" style="position:relative; overflow:hidden;">
            <h2 style="font-size:18px; font-weight:700; margin-bottom:20px; display:flex; align-items:center; gap:8px;"><i class="fa-solid fa-server" style="color:var(--primary);"></i> Architecture Technique MVC</h2>
            <p style="color:var(--text-secondary); font-size:14px; margin-bottom:24px;">Le projet utilise le modèle standard <strong>MVC (Model-View-Controller)</strong> sous Jakarta EE 10, structurant le code en couches étanches :</p>
            
            <div style="display:flex; flex-direction:column; gap:20px; align-items:center; margin:20px 0;">
                <div class="arch-box glass-panel neon-border-blue" style="width:220px; text-align:center; padding:12px; font-weight:700; background:rgba(6,182,212,0.15);">
                    VUE (JSP, CSS, JS)<br><small style="font-weight:400; font-size:11px; color:var(--text-muted);">Interface Utilisateur</small>
                </div>
                <div class="arch-arrow" style="height:30px; width:2px; background:linear-gradient(to bottom, var(--accent), var(--primary)); position:relative;">
                    <div style="position:absolute; bottom:0; left:-4px; border-left:5px solid transparent; border-right:5px solid transparent; border-top:6px solid var(--primary);"></div>
                </div>
                <div class="arch-box glass-panel neon-border-purple" style="width:220px; text-align:center; padding:12px; font-weight:700; background:rgba(139,92,246,0.15);">
                    CONTROLLER (Servlets)<br><small style="font-weight:400; font-size:11px; color:var(--text-muted);">Filtres & Servlets de routage</small>
                </div>
                <div class="arch-arrow" style="height:30px; width:2px; background:linear-gradient(to bottom, var(--primary), var(--secondary)); position:relative;">
                    <div style="position:absolute; bottom:0; left:-4px; border-left:5px solid transparent; border-right:5px solid transparent; border-top:6px solid var(--secondary);"></div>
                </div>
                <div class="arch-box glass-panel neon-border-green" style="width:220px; text-align:center; padding:12px; font-weight:700; background:rgba(16,185,129,0.15);">
                    MODÈLE / DAO (Services)<br><small style="font-weight:400; font-size:11px; color:var(--text-muted);">Interactions JDBC & DBConnection</small>
                </div>
            </div>
        </div>

        <!-- Data Flow Animation -->
        <div class="card-panel">
            <h2 style="font-size:18px; font-weight:700; margin-bottom:20px; display:flex; align-items:center; gap:8px;"><i class="fa-solid fa-route" style="color:var(--accent);"></i> Flux de Requête Interactif (Sequence)</h2>
            <p style="color:var(--text-secondary); font-size:14px; margin-bottom:24px;">Visualisez le chemin parcouru par une requête HTTP sécurisée. Passez votre souris sur les flèches pour animer le transfert.</p>
            
            <!-- Animated SVG Flow -->
            <svg viewBox="0 0 450 300" style="width:100%; height:auto;">
                <!-- Lifelines -->
                <line x1="50" y1="30" x2="50" y2="280" stroke="rgba(255,255,255,0.1)" stroke-width="2" stroke-dasharray="4"/>
                <line x1="160" y1="30" x2="160" y2="280" stroke="rgba(255,255,255,0.1)" stroke-width="2" stroke-dasharray="4"/>
                <line x1="280" y1="30" x2="280" y2="280" stroke="rgba(255,255,255,0.1)" stroke-width="2" stroke-dasharray="4"/>
                <line x1="400" y1="30" x2="400" y2="280" stroke="rgba(255,255,255,0.1)" stroke-width="2" stroke-dasharray="4"/>
                
                <!-- Lifeline Headers -->
                <rect x="15" y="10" width="70" height="24" rx="4" fill="rgba(6, 182, 212, 0.2)" stroke="var(--accent)" stroke-width="1"/>
                <text x="50" y="26" fill="white" font-size="10" text-anchor="middle">Navigateur</text>

                <rect x="120" y="10" width="80" height="24" rx="4" fill="rgba(99, 102, 241, 0.2)" stroke="var(--primary)" stroke-width="1"/>
                <text x="160" y="26" fill="white" font-size="10" text-anchor="middle">SecurityFilter</text>

                <rect x="245" y="10" width="70" height="24" rx="4" fill="rgba(139, 92, 246, 0.2)" stroke="var(--secondary)" stroke-width="1"/>
                <text x="280" y="26" fill="white" font-size="10" text-anchor="middle">Servlet</text>

                <rect x="365" y="10" width="70" height="24" rx="4" fill="rgba(16, 185, 129, 0.2)" stroke="var(--success)" stroke-width="1"/>
                <text x="400" y="26" fill="white" font-size="10" text-anchor="middle">Base MySQL</text>

                <!-- Flow lines with animated dashes -->
                <!-- 1. Request to Filter -->
                <path d="M 50 70 L 160 70" stroke="var(--accent)" stroke-width="2" fill="none" stroke-dasharray="8,6" class="animated-path"/>
                <polygon points="160,70 152,66 152,74" fill="var(--accent)"/>
                <text x="105" y="62" fill="var(--text-secondary)" font-size="9" text-anchor="middle">1. Requête HTTP</text>

                <!-- 2. Auth Success to Servlet -->
                <path d="M 160 120 L 280 120" stroke="var(--primary)" stroke-width="2" fill="none" stroke-dasharray="8,6" class="animated-path"/>
                <polygon points="280,120 272,116 272,124" fill="var(--primary)"/>
                <text x="220" y="112" fill="var(--text-secondary)" font-size="9" text-anchor="middle">2. Validation Rôle</text>

                <!-- 3. JDBC Query to DB -->
                <path d="M 280 170 L 400 170" stroke="var(--secondary)" stroke-width="2" fill="none" stroke-dasharray="8,6" class="animated-path"/>
                <polygon points="400,170 392,166 392,174" fill="var(--secondary)"/>
                <text x="340" y="162" fill="var(--text-secondary)" font-size="9" text-anchor="middle">3. Requête SQL</text>

                <!-- 4. Result back to Servlet -->
                <path d="M 400 210 L 280 210" stroke="var(--success)" stroke-width="2" fill="none" stroke-dasharray="8,6" class="animated-path-reverse"/>
                <polygon points="280,210 288,206 288,214" fill="var(--success)"/>
                <text x="340" y="202" fill="var(--text-secondary)" font-size="9" text-anchor="middle">4. Données (ResultSet)</text>

                <!-- 5. Render/Response to User -->
                <path d="M 280 250 L 50 250" stroke="var(--accent)" stroke-width="2" fill="none" stroke-dasharray="8,6" class="animated-path-reverse"/>
                <polygon points="50,250 58,246 58,254" fill="var(--accent)"/>
                <text x="165" y="242" fill="var(--text-secondary)" font-size="9" text-anchor="middle">5. Rendu HTML (JSP)</text>
            </svg>
        </div>
    </div>
</div>

<!-- ════════ TAB: DATABASE MCD/MLD SCHEMA ════════ -->
<div id="tab-database" class="tab-content fade-in-delay-2" style="display:none;">
    <div class="card-panel" style="margin-bottom:32px;">
        <h2 style="font-size:18px; font-weight:700; margin-bottom:10px; display:flex; align-items:center; gap:8px;"><i class="fa-solid fa-database" style="color:var(--success);"></i> Schéma Entité-Association (MCD / MLD)</h2>
        <p style="color:var(--text-secondary); font-size:14px; margin-bottom:24px;">Passez la souris sur une table pour mettre en valeur ses relations et activer des effets de flux luminescents.</p>
        
        <div style="width: 100%; overflow-x: auto; background: #05070e; border: 1px solid rgba(255,255,255,0.05); border-radius: 16px; padding: 24px; box-shadow: inset 0 0 30px rgba(0,0,0,0.5);">
            <svg viewBox="0 0 1000 750" style="width: 100%; height: auto;" id="erd-svg">
                <!-- Glowing Filter Definitions -->
                <defs>
                    <filter id="erd-glow" x="-20%" y="-20%" width="140%" height="140%">
                        <feGaussianBlur stdDeviation="6" result="blur" />
                        <feMerge>
                            <feMergeNode in="blur" />
                            <feMergeNode in="SourceGraphic" />
                        </feMerge>
                    </filter>
                </defs>

                <!-- RELATIONSHIPS CONNECTORS PATHS -->
                <!-- 1. departement <-> employe (1:N) -->
                <path d="M 260 117.5 H 320 V 230 H 380" fill="none" stroke="#475569" stroke-width="2" class="rel-path line-dept-emp" id="line-dept-emp" />
                
                <!-- 2. employe <-> contrat_employe (1:N) -->
                <path d="M 600 240 H 680 V 117.5 H 740" fill="none" stroke="#475569" stroke-width="2" class="rel-path line-emp-contrat" id="line-emp-contrat" />
                
                <!-- 3. employe <-> conge (1:N) -->
                <path d="M 600 290 H 680 V 320 H 740" fill="none" stroke="#475569" stroke-width="2" class="rel-path line-emp-conge" id="line-emp-conge" />
                
                <!-- 4. employe <-> fiche_paie (1:N) -->
                <path d="M 600 340 H 680 V 540 H 740" fill="none" stroke="#475569" stroke-width="2" class="rel-path line-emp-fichepaie" id="line-emp-fichepaie" />
                
                <!-- 5. utilisateur <-> employe (1:0..1) -->
                <path d="M 260 467.5 H 320 V 310 H 380" fill="none" stroke="#475569" stroke-width="2" class="rel-path line-user-emp" id="line-user-emp" />
                
                <!-- 6. utilisateur <-> role (N:N) -->
                <path d="M 150 535 V 575" fill="none" stroke="#475569" stroke-width="2" class="rel-path line-user-role" id="line-user-role" />
                
                <!-- 7. notification <-> utilisateur (1:N) -->
                <path d="M 380 565 H 320 V 490 H 260" fill="none" stroke="#475569" stroke-width="2" class="rel-path line-noti-user" id="line-noti-user" />


                <!-- RELATION RELATIONSHIPS TEXT LABELS -->
                <g class="rel-text-group">
                    <rect x="270" y="165" width="100" height="20" rx="4" fill="#0f172a" stroke="#1e293b" class="rel-text-bg line-dept-emp" />
                    <text x="320" y="179" fill="#94a3b8" font-size="10" font-family="Outfit, sans-serif" text-anchor="middle" class="rel-text line-dept-emp">contient (1:N)</text>
                    
                    <rect x="630" y="145" width="100" height="20" rx="4" fill="#0f172a" stroke="#1e293b" class="rel-text-bg line-emp-contrat" />
                    <text x="680" y="159" fill="#94a3b8" font-size="10" font-family="Outfit, sans-serif" text-anchor="middle" class="rel-text line-emp-contrat">possède (1:N)</text>
                    
                    <rect x="630" y="285" width="100" height="20" rx="4" fill="#0f172a" stroke="#1e293b" class="rel-text-bg line-emp-conge" />
                    <text x="680" y="299" fill="#94a3b8" font-size="10" font-family="Outfit, sans-serif" text-anchor="middle" class="rel-text line-emp-conge">demande (1:N)</text>
                    
                    <rect x="630" y="425" width="100" height="20" rx="4" fill="#0f172a" stroke="#1e293b" class="rel-text-bg line-emp-fichepaie" />
                    <text x="680" y="439" fill="#94a3b8" font-size="10" font-family="Outfit, sans-serif" text-anchor="middle" class="rel-text line-emp-fichepaie">génère (1:N)</text>
                    
                    <rect x="270" y="375" width="100" height="20" rx="4" fill="#0f172a" stroke="#1e293b" class="rel-text-bg line-user-emp" />
                    <text x="320" y="389" fill="#94a3b8" font-size="10" font-family="Outfit, sans-serif" text-anchor="middle" class="rel-text line-user-emp">associé à (1:0..1)</text>
                    
                    <rect x="100" y="545" width="100" height="20" rx="4" fill="#0f172a" stroke="#1e293b" class="rel-text-bg line-user-role" />
                    <text x="150" y="559" fill="#94a3b8" font-size="10" font-family="Outfit, sans-serif" text-anchor="middle" class="rel-text line-user-role">a rôle (N:N)</text>
                    
                    <rect x="270" y="505" width="100" height="20" rx="4" fill="#0f172a" stroke="#1e293b" class="rel-text-bg line-noti-user" />
                    <text x="320" y="519" fill="#94a3b8" font-size="10" font-family="Outfit, sans-serif" text-anchor="middle" class="rel-text line-noti-user">concerne (1:N)</text>
                </g>


                <!-- ENTITIES (TABLES NODES) -->
                <!-- Table 1: Departement -->
                <g id="table-departement" class="erd-node" onmouseenter="focusErd('departement')" onmouseleave="blurErd()">
                    <rect x="40" y="60" width="220" height="115" rx="8" fill="#1e293b" stroke="rgba(6, 182, 212, 0.3)" stroke-width="1.5" class="table-box" />
                    <rect x="40" y="60" width="220" height="30" rx="8" fill="rgba(6, 182, 212, 0.15)" />
                    <text x="50" y="79" fill="#ffffff" font-size="12" font-family="Outfit, sans-serif" font-weight="bold">departement</text>
                    <text x="50" y="110" fill="#a5b4fc" font-size="10.5" font-family="Outfit, sans-serif">🔑 id : BIGINT (PK)</text>
                    <text x="50" y="128" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">📝 nom : VARCHAR(100) (UQ)</text>
                    <text x="50" y="146" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">👤 responsable : VARCHAR(100)</text>
                    <text x="50" y="164" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">💰 budget_masse : DECIMAL(14,2)</text>
                </g>

                <!-- Table 2: Employe -->
                <g id="table-employe" class="erd-node" onmouseenter="focusErd('employe')" onmouseleave="blurErd()">
                    <rect x="380" y="200" width="240" height="220" rx="8" fill="#1e293b" stroke="rgba(99, 102, 241, 0.3)" stroke-width="1.5" class="table-box" />
                    <rect x="380" y="200" width="240" height="30" rx="8" fill="rgba(99, 102, 241, 0.15)" />
                    <text x="390" y="219" fill="#ffffff" font-size="12" font-family="Outfit, sans-serif" font-weight="bold">employe</text>
                    <text x="390" y="248" fill="#a5b4fc" font-size="10.5" font-family="Outfit, sans-serif">🔑 id : BIGINT (PK)</text>
                    <text x="390" y="265" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">🔢 matricule : VARCHAR(20) (UQ)</text>
                    <text x="390" y="282" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">👤 nom & prenom : VARCHAR(100)</text>
                    <text x="390" y="299" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">💼 poste : VARCHAR(100)</text>
                    <text x="390" y="316" fill="#a5b4fc" font-size="10.5" font-family="Outfit, sans-serif">🔗 departement_id : BIGINT (FK)</text>
                    <text x="390" y="333" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">📅 date_embauche : DATE</text>
                    <text x="390" y="350" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">💰 salaire_base : DECIMAL(10,2)</text>
                    <text x="390" y="367" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">📧 email : VARCHAR(150) (UQ)</text>
                    <text x="390" y="384" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">🏝️ solde_conges_jours : INT</text>
                </g>

                <!-- Table 3: Contrat Employe -->
                <g id="table-contrat" class="erd-node" onmouseenter="focusErd('contrat')" onmouseleave="blurErd()">
                    <rect x="740" y="40" width="220" height="155" rx="8" fill="#1e293b" stroke="rgba(139, 92, 246, 0.3)" stroke-width="1.5" class="table-box" />
                    <rect x="740" y="40" width="220" height="30" rx="8" fill="rgba(139, 92, 246, 0.15)" />
                    <text x="750" y="59" fill="#ffffff" font-size="12" font-family="Outfit, sans-serif" font-weight="bold">contrat_employe</text>
                    <text x="750" y="90" fill="#a5b4fc" font-size="10.5" font-family="Outfit, sans-serif">🔑 id : BIGINT (PK)</text>
                    <text x="750" y="108" fill="#a5b4fc" font-size="10.5" font-family="Outfit, sans-serif">🔗 employe_id : BIGINT (FK)</text>
                    <text x="750" y="126" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">📄 type_contrat : ENUM</text>
                    <text x="750" y="144" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">📅 debut / fin : DATE</text>
                    <text x="750" y="162" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">💰 salaire : DECIMAL(10,2)</text>
                    <text x="750" y="180" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">🎁 avantages : VARCHAR(300)</text>
                </g>

                <!-- Table 4: Conge -->
                <g id="table-conge" class="erd-node" onmouseenter="focusErd('conge')" onmouseleave="blurErd()">
                    <rect x="740" y="235" width="220" height="170" rx="8" fill="#1e293b" stroke="rgba(245, 158, 11, 0.3)" stroke-width="1.5" class="table-box" />
                    <rect x="740" y="235" width="220" height="30" rx="8" fill="rgba(245, 158, 11, 0.15)" />
                    <text x="750" y="254" fill="#ffffff" font-size="12" font-family="Outfit, sans-serif" font-weight="bold">conge</text>
                    <text x="750" y="285" fill="#a5b4fc" font-size="10.5" font-family="Outfit, sans-serif">🔑 id : BIGINT (PK)</text>
                    <text x="750" y="303" fill="#a5b4fc" font-size="10.5" font-family="Outfit, sans-serif">🔗 employe_id : BIGINT (FK)</text>
                    <text x="750" y="321" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">🏝️ type_conge : ENUM</text>
                    <text x="750" y="339" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">📅 debut / fin : DATE</text>
                    <text x="750" y="357" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">🔢 nb_jours : INT</text>
                    <text x="750" y="375" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">🟢 statut : ENUM</text>
                    <text x="750" y="393" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">👤 approuve_par : VARCHAR</text>
                </g>

                <!-- Table 5: Fiche de Paie -->
                <g id="table-fichepaie" class="erd-node" onmouseenter="focusErd('fichepaie')" onmouseleave="blurErd()">
                    <rect x="740" y="445" width="220" height="190" rx="8" fill="#1e293b" stroke="rgba(16, 185, 129, 0.3)" stroke-width="1.5" class="table-box" />
                    <rect x="740" y="445" width="220" height="30" rx="8" fill="rgba(16, 185, 129, 0.15)" />
                    <text x="750" y="464" fill="#ffffff" font-size="12" font-family="Outfit, sans-serif" font-weight="bold">fiche_paie</text>
                    <text x="750" y="495" fill="#a5b4fc" font-size="10.5" font-family="Outfit, sans-serif">🔑 id : BIGINT (PK)</text>
                    <text x="750" y="513" fill="#a5b4fc" font-size="10.5" font-family="Outfit, sans-serif">🔗 employe_id : BIGINT (FK)</text>
                    <text x="750" y="531" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">📅 mois : VARCHAR(7)</text>
                    <text x="750" y="549" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">💰 salaire_base : DECIMAL</text>
                    <text x="750" y="567" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">💰 heures_sup : DECIMAL</text>
                    <text x="750" y="585" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">💰 primes / retenues : DECIMAL</text>
                    <text x="750" y="603" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">💰 salaire_brut : DECIMAL</text>
                    <text x="750" y="621" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">💰 salaire_net : DECIMAL</text>
                </g>

                <!-- Table 6: Utilisateur -->
                <g id="table-utilisateur" class="erd-node" onmouseenter="focusErd('utilisateur')" onmouseleave="blurErd()">
                    <rect x="40" y="400" width="220" height="135" rx="8" fill="#1e293b" stroke="rgba(239, 68, 68, 0.3)" stroke-width="1.5" class="table-box" />
                    <rect x="40" y="400" width="220" height="30" rx="8" fill="rgba(239, 68, 68, 0.15)" />
                    <text x="50" y="419" fill="#ffffff" font-size="12" font-family="Outfit, sans-serif" font-weight="bold">utilisateur</text>
                    <text x="50" y="450" fill="#a5b4fc" font-size="10.5" font-family="Outfit, sans-serif">🔑 id : BIGINT (PK)</text>
                    <text x="50" y="468" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">📧 email : VARCHAR(150) (UQ)</text>
                    <text x="50" y="486" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">🔒 mot_de_passe : VARCHAR(255)</text>
                    <text x="50" y="504" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">🟢 est_actif : BOOLEAN</text>
                    <text x="50" y="522" fill="#a5b4fc" font-size="10.5" font-family="Outfit, sans-serif">🔗 employe_id : BIGINT (FK, null)</text>
                </g>

                <!-- Table 7: Role -->
                <g id="table-role" class="erd-node" onmouseenter="focusErd('role')" onmouseleave="blurErd()">
                    <rect x="40" y="575" width="220" height="80" rx="8" fill="#1e293b" stroke="rgba(168, 85, 247, 0.3)" stroke-width="1.5" class="table-box" />
                    <rect x="40" y="575" width="220" height="30" rx="8" fill="rgba(168, 85, 247, 0.15)" />
                    <text x="50" y="594" fill="#ffffff" font-size="12" font-family="Outfit, sans-serif" font-weight="bold">role</text>
                    <text x="50" y="625" fill="#a5b4fc" font-size="10.5" font-family="Outfit, sans-serif">🔑 id : BIGINT (PK)</text>
                    <text x="50" y="643" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">📝 nom : VARCHAR(50) (UQ)</text>
                </g>

                <!-- Table 8: Notification -->
                <g id="table-notification" class="erd-node" onmouseenter="focusErd('notification')" onmouseleave="blurErd()">
                    <rect x="380" y="485" width="240" height="160" rx="8" fill="#1e293b" stroke="rgba(16, 185, 129, 0.3)" stroke-width="1.5" class="table-box" />
                    <rect x="380" y="485" width="240" height="30" rx="8" fill="rgba(16, 185, 129, 0.15)" />
                    <text x="390" y="504" fill="#ffffff" font-size="12" font-family="Outfit, sans-serif" font-weight="bold">notification</text>
                    <text x="390" y="535" fill="#a5b4fc" font-size="10.5" font-family="Outfit, sans-serif">🔑 id : BIGINT (PK)</text>
                    <text x="390" y="553" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">📧 expediteur : VARCHAR(150)</text>
                    <text x="390" y="571" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">📧 destinataire : VARCHAR(150)</text>
                    <text x="390" y="589" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">📝 sujet : VARCHAR(255)</text>
                    <text x="390" y="607" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">📅 date_envoi : DATETIME</text>
                    <text x="390" y="625" fill="#e2e8f0" font-size="10.5" font-family="Outfit, sans-serif">🟢 lu : BOOLEAN</text>
                </g>
            </svg>
        </div>
    </div>
</div>

<!-- ════════ TAB: CLASS DIAGRAM ════════ -->
<div id="tab-classes" class="tab-content fade-in-delay-2" style="display:none;">
    <div class="card-panel" style="margin-bottom:32px;">
        <h2 style="font-size:18px; font-weight:700; margin-bottom:20px; display:flex; align-items:center; gap:8px;"><i class="fa-solid fa-sitemap" style="color:var(--primary);"></i> Structure des Classes du Projet (MVC Java)</h2>
        <p style="color:var(--text-secondary); font-size:14px; margin-bottom:24px;">Représentation de l'architecture logicielle Java et de la séparation Controller / DAO / Model.</p>
        
        <div style="display:flex; flex-direction:column; gap:32px;">
            <!-- Controller Layer -->
            <div class="glass-panel" style="padding:20px;">
                <h3 style="font-size:14px; font-weight:800; color:var(--primary); text-transform:uppercase; margin-bottom:16px; letter-spacing:0.5px;">1. Couche Controller (Servlets)</h3>
                <div style="display:grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap:16px;">
                    <div style="padding:12px; background:rgba(255,255,255,0.02); border:1px solid rgba(255,255,255,0.05); border-radius:8px;">
                        <span style="font-weight:700; color:white;">EmployeServlet</span>
                        <p style="font-size:11px; color:var(--text-secondary); margin-top:4px;">Gère la création, modification, suppression et l'affichage des employés.</p>
                    </div>
                    <div style="padding:12px; background:rgba(255,255,255,0.02); border:1px solid rgba(255,255,255,0.05); border-radius:8px;">
                        <span style="font-weight:700; color:white;">CongeServlet</span>
                        <p style="font-size:11px; color:var(--text-secondary); margin-top:4px;">Gère les demandes de congés et le processus d'approbation managérial.</p>
                    </div>
                    <div style="padding:12px; background:rgba(255,255,255,0.02); border:1px solid rgba(255,255,255,0.05); border-radius:8px;">
                        <span style="font-weight:700; color:white;">DashboardServlet</span>
                        <p style="font-size:11px; color:var(--text-secondary); margin-top:4px;">Compile les statistiques analytiques globales pour Chart.js.</p>
                    </div>
                </div>
            </div>

            <!-- DAO Layer -->
            <div class="glass-panel" style="padding:20px;">
                <h3 style="font-size:14px; font-weight:800; color:var(--success); text-transform:uppercase; margin-bottom:16px; letter-spacing:0.5px;">2. Couche DAO (Accès aux Données)</h3>
                <div style="display:grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap:16px;">
                    <div style="padding:12px; background:rgba(255,255,255,0.02); border:1px solid rgba(255,255,255,0.05); border-radius:8px;">
                        <span style="font-weight:700; color:white;">EmployeDAOImpl</span>
                        <p style="font-size:11px; color:var(--text-secondary); margin-top:4px;">Implémente CRUD sur les employés via JDBC classique.</p>
                    </div>
                    <div style="padding:12px; background:rgba(255,255,255,0.02); border:1px solid rgba(255,255,255,0.05); border-radius:8px;">
                        <span style="font-weight:700; color:white;">CongeDAOImpl</span>
                        <p style="font-size:11px; color:var(--text-secondary); margin-top:4px;">Gère la persistance et les soldes de congés.</p>
                    </div>
                    <div style="padding:12px; background:rgba(255,255,255,0.02); border:1px solid rgba(255,255,255,0.05); border-radius:8px;">
                        <span style="font-weight:700; color:white;">UtilisateurDaoImpl</span>
                        <p style="font-size:11px; color:var(--text-secondary); margin-top:4px;">Assure l'authentification et l'inscription sécurisée (BCrypt).</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- ════════ TAB: USE CASES ════════ -->
<div id="tab-usecases" class="tab-content fade-in-delay-2" style="display:none;">
    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:32px; margin-bottom:32px;">
        
        <!-- Interactive Use Case Map -->
        <div class="card-panel">
            <h2 style="font-size:18px; font-weight:700; margin-bottom:20px; display:flex; align-items:center; gap:8px;"><i class="fa-solid fa-circle-dot" style="color:var(--accent);"></i> Cas d'Utilisation Applicatifs</h2>
            <p style="color:var(--text-secondary); font-size:14px; margin-bottom:24px;">Cliquez sur un cas d'utilisation pour lancer une simulation de scan terminal de sa description.</p>
            
            <div style="display:flex; flex-direction:column; gap:12px;">
                <div class="usecase-node glass-panel" onclick="runScan('uc1', 'Permet à un administrateur ou agent RH de recruter de nouveaux employés, définir leur contrat (CDI, CDD, etc.) et leur salaire de base. Un email SendGrid d\'accueil est automatiquement envoyé à la création de leur compte utilisateur lié.')">
                    🎯 UC1: Recrutement & Création Employé
                </div>
                <div class="usecase-node glass-panel" onclick="runScan('uc2', 'Permet à un employé de soumettre une demande de congé. Son manager ou les RH reçoivent une alerte et peuvent accepter ou refuser la demande, déduisant alors les jours demandés du solde global de l\'employé.')">
                    🎯 UC2: Gestion & Validation des Congés
                </div>
                <div class="usecase-node glass-panel" onclick="runScan('uc3', 'Chaque mois, les RH émettent les fiches de paie en intégrant les heures supplémentaires et primes. Le calcul du salaire brut et net est automatisé et un email est envoyé à l\'employé concerné.')">
                    🎯 UC3: Calcul & Émission des Fiches de Paie
                </div>
                <div class="usecase-node glass-panel" onclick="runScan('uc4', 'Vérification en temps réel que les requêtes proviennent d\'utilisateurs connectés et habilités pour la section demandée (SecurityFilter), limitant par exemple la gestion des contrats aux seuls RH et Administrateurs.')">
                    🎯 UC4: Contrôle des Rôles & Sécurité (RBAC)
                </div>
            </div>
        </div>

        <!-- Terminal Output -->
        <div class="card-panel" style="background:#05070e; border:1px solid #1e293b; font-family:monospace; display:flex; flex-direction:column; gap:16px;">
            <div style="display:flex; gap:6px; border-bottom:1px solid #1e293b; padding-bottom:10px; align-items:center;">
                <span style="width:10px; height:10px; border-radius:50%; background:#ef4444;"></span>
                <span style="width:10px; height:10px; border-radius:50%; background:#f59e0b;"></span>
                <span style="width:10px; height:10px; border-radius:50%; background:#10b981;"></span>
                <span style="color:#64748b; font-size:11px; margin-left:10px;">terminal-usecases.sh</span>
            </div>
            
            <div id="terminal-content" style="color:#a5b4fc; font-size:13px; line-height:1.6; min-height:150px; overflow-y:auto;">
                [InterGo Shell] Prêt. Cliquez sur un cas d'utilisation pour afficher sa description détaillée...
            </div>
        </div>
    </div>
</div>

<style>
    /* Tabs styling */
    .active-tab-btn {
        background: rgba(99, 102, 241, 0.15) !important;
        border-color: var(--primary) !important;
        color: white !important;
    }
    
    /* Flow Path Animation */
    .animated-path {
        stroke-dasharray: 8, 6;
        animation: flowDash 2.5s infinite linear;
    }
    .animated-path-reverse {
        stroke-dasharray: 8, 6;
        animation: flowDashReverse 2.5s infinite linear;
    }
    @keyframes flowDash {
        to { stroke-dashoffset: -20; }
    }
    @keyframes flowDashReverse {
        to { stroke-dashoffset: 20; }
    }

    /* SVG ERD highlight styling */
    #erd-svg {
        user-select: none;
    }
    .erd-node {
        transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
        cursor: pointer;
    }
    .erd-node .table-box {
        transition: all 0.35s ease;
    }
    .erd-node:hover .table-box {
        fill: #131d30;
    }
    .rel-path {
        transition: all 0.35s ease;
        stroke-dasharray: 6, 4;
    }
    .rel-text-bg {
        transition: all 0.35s ease;
        opacity: 0.85;
    }
    .rel-text {
        transition: all 0.35s ease;
    }

    /* Active Glowing highlights */
    .erd-node.highlight .table-box {
        stroke: var(--accent) !important;
        stroke-width: 2.2px !important;
        filter: drop-shadow(0 0 10px rgba(6, 182, 212, 0.5));
    }
    .rel-path.highlight {
        stroke: var(--accent) !important;
        stroke-width: 3px !important;
        filter: drop-shadow(0 0 8px rgba(6, 182, 212, 0.6));
        animation: flowRelation 1.5s infinite linear;
    }
    .rel-text-bg.highlight {
        stroke: var(--accent) !important;
        fill: #0c1524 !important;
        filter: drop-shadow(0 0 4px rgba(6, 182, 212, 0.3));
    }
    .rel-text.highlight {
        fill: var(--accent) !important;
        font-weight: 700 !important;
    }

    /* Dimming effects for unrelated items */
    .erd-node.fade-out,
    .rel-path.fade-out,
    .rel-text-bg.fade-out,
    .rel-text.fade-out {
        opacity: 0.15;
    }

    @keyframes flowRelation {
        to { stroke-dashoffset: -20; }
    }

    /* Use Case interactive styling */
    .usecase-node {
        padding: 16px 20px;
        font-weight: 600;
        font-size: 14px;
        cursor: pointer;
        transition: all 0.25s ease;
    }
    .usecase-node:hover {
        background: rgba(6, 182, 212, 0.08);
        border-color: var(--accent);
        transform: translateX(6px);
        color: white;
    }
</style>

<script>
    // Tab switching logic
    const switchTab = (tabId) => {
        // Hide all tabs
        document.querySelectorAll('.tab-content').forEach(tab => {
            tab.style.display = 'none';
        });
        
        // Show target tab
        document.getElementById(tabId).style.display = 'block';
        
        // Reset button states
        document.querySelectorAll('[onclick^="switchTab"]').forEach(btn => {
            btn.classList.remove('active-tab-btn');
        });
        
        // Activate target button
        document.getElementById('btn-' + tabId).classList.add('active-tab-btn');
    };

    // Interactive SVG ERD highlighting
    const focusErd = (tableName) => {
        // Dim everything by default
        document.querySelectorAll('.erd-node').forEach(node => node.classList.add('fade-out'));
        document.querySelectorAll('.rel-path').forEach(path => path.classList.add('fade-out'));
        document.querySelectorAll('.rel-text').forEach(t => t.classList.add('fade-out'));
        document.querySelectorAll('.rel-text-bg').forEach(bg => bg.classList.add('fade-out'));

        // Highlight selected node
        const activeNode = document.getElementById('table-' + tableName);
        if (activeNode) {
            activeNode.classList.remove('fade-out');
            activeNode.classList.add('highlight');
        }

        // Determine related elements based on relationships
        const relationships = {
            'departement': {
                nodes: ['employe'],
                lines: ['line-dept-emp']
            },
            'employe': {
                nodes: ['departement', 'contrat', 'conge', 'fichepaie', 'utilisateur'],
                lines: ['line-dept-emp', 'line-emp-contrat', 'line-emp-conge', 'line-emp-fichepaie', 'line-user-emp']
            },
            'contrat': {
                nodes: ['employe'],
                lines: ['line-emp-contrat']
            },
            'conge': {
                nodes: ['employe'],
                lines: ['line-emp-conge']
            },
            'fichepaie': {
                nodes: ['employe'],
                lines: ['line-emp-fichepaie']
            },
            'utilisateur': {
                nodes: ['employe', 'role', 'notification'],
                lines: ['line-user-emp', 'line-user-role', 'line-noti-user']
            },
            'role': {
                nodes: ['utilisateur'],
                lines: ['line-user-role']
            },
            'notification': {
                nodes: ['utilisateur'],
                lines: ['line-noti-user']
            }
        };

        const rel = relationships[tableName];
        if (rel) {
            rel.nodes.forEach(nodeId => {
                const n = document.getElementById('table-' + nodeId);
                if (n) {
                    n.classList.remove('fade-out');
                    n.classList.add('highlight');
                }
            });
            rel.lines.forEach(lineId => {
                const path = document.getElementById(lineId);
                if (path) {
                    path.classList.remove('fade-out');
                    path.classList.add('highlight');
                }
                // Highlight text labels linked to this path
                document.querySelectorAll('.rel-text.' + lineId).forEach(t => {
                    t.classList.remove('fade-out');
                    t.classList.add('highlight');
                });
                document.querySelectorAll('.rel-text-bg.' + lineId).forEach(bg => {
                    bg.classList.remove('fade-out');
                    bg.classList.add('highlight');
                });
            });
        }
    };

    const blurErd = () => {
        // Reset all elements
        document.querySelectorAll('.erd-node').forEach(node => {
            node.classList.remove('fade-out', 'highlight');
        });
        document.querySelectorAll('.rel-path').forEach(path => {
            path.classList.remove('fade-out', 'highlight');
        });
        document.querySelectorAll('.rel-text').forEach(t => {
            t.classList.remove('fade-out', 'highlight');
        });
        document.querySelectorAll('.rel-text-bg').forEach(bg => {
            bg.classList.remove('fade-out', 'highlight');
        });
    };

    // Terminal scan typewriter simulation
    let typingTimer = null;
    const runScan = (id, text) => {
        const term = document.getElementById('terminal-content');
        if (typingTimer) clearInterval(typingTimer);
        
        term.innerHTML = `<span style="color:var(--accent); font-weight:bold;">$ scan-usecase --id=${id}</span><br>[INFO] Initialisation du scan…<br><br>`;
        
        let index = 0;
        const speed = 15; // characters per millisecond
        
        typingTimer = setInterval(() => {
            if (index < text.length) {
                term.innerHTML += text.charAt(index);
                index++;
            } else {
                term.innerHTML += `<br><br><span style="color:var(--success); font-weight:bold;">[SCAN TERMINE SUCCÈS]</span> <span style="animation: pulse-gear 1s infinite;">_</span>`;
                clearInterval(typingTimer);
            }
        }, speed);
    };
</script>

<jsp:include page="/layout-footer.jsp" />
