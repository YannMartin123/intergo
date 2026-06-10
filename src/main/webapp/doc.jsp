<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
        <p style="color:var(--text-secondary); font-size:14px; margin-bottom:32px;">Passez la souris sur une table pour mettre en valeur ses liaisons de clés étrangères.</p>
        
        <div style="display:grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap:24px;" id="db-erd-container">
            <!-- Table 1: Departement -->
            <div class="erd-table glass-panel" id="table-departement" onmouseenter="highlightErd('departement')" onmouseleave="resetErd()">
                <div class="erd-table-header" style="background:rgba(6,182,212,0.1); border-bottom:1px solid var(--border-glow); padding:10px 16px; font-weight:700; display:flex; justify-content:between; align-items:center;">
                    <span>departement</span>
                    <span style="font-size:10px; padding:2px 6px; border-radius:4px; background:var(--accent); color:white;">PK</span>
                </div>
                <div style="padding:12px 16px; font-size:12px; display:flex; flex-direction:column; gap:6px;">
                    <div>🔑 <strong>id</strong> : BIGINT <span style="color:var(--text-muted);">(auto_inc)</span></div>
                    <div>📝 <strong>nom</strong> : VARCHAR(100) <span style="color:var(--text-muted);">(unique)</span></div>
                    <div>👤 <strong>responsable</strong> : VARCHAR(100)</div>
                    <div>💰 <strong>budget_masse_salariale</strong> : DECIMAL(14,2)</div>
                </div>
            </div>

            <!-- Table 2: Employe -->
            <div class="erd-table glass-panel" id="table-employe" onmouseenter="highlightErd('employe')" onmouseleave="resetErd()">
                <div class="erd-table-header" style="background:rgba(99,102,241,0.1); border-bottom:1px solid var(--border-glow); padding:10px 16px; font-weight:700; display:flex; justify-content:between; align-items:center;">
                    <span>employe</span>
                    <span style="font-size:10px; padding:2px 6px; border-radius:4px; background:var(--primary); color:white;">FK</span>
                </div>
                <div style="padding:12px 16px; font-size:12px; display:flex; flex-direction:column; gap:6px;">
                    <div>🔑 <strong>id</strong> : BIGINT <span style="color:var(--text-muted);">(auto_inc)</span></div>
                    <div>🔢 <strong>matricule</strong> : VARCHAR(20) <span style="color:var(--text-muted);">(unique)</span></div>
                    <div>👤 <strong>nom</strong> : VARCHAR(100)</div>
                    <div>👤 <strong>prenom</strong> : VARCHAR(100)</div>
                    <div>💼 <strong>poste</strong> : VARCHAR(100)</div>
                    <div style="color:var(--accent); font-weight:600;">🔗 <strong>departement_id</strong> : BIGINT</div>
                    <div>📅 <strong>date_embauche</strong> : DATE</div>
                    <div>💰 <strong>salaire_base</strong> : DECIMAL(10,2)</div>
                    <div>📄 <strong>type_contrat</strong> : ENUM</div>
                    <div>📧 <strong>email</strong> : VARCHAR(150)</div>
                    <div>🏝️ <strong>solde_conges_jours</strong> : INT</div>
                </div>
            </div>

            <!-- Table 3: Contrat Employe -->
            <div class="erd-table glass-panel" id="table-contrat" onmouseenter="highlightErd('contrat')" onmouseleave="resetErd()">
                <div class="erd-table-header" style="background:rgba(139,92,246,0.1); border-bottom:1px solid var(--border-glow); padding:10px 16px; font-weight:700; display:flex; justify-content:between; align-items:center;">
                    <span>contrat_employe</span>
                    <span style="font-size:10px; padding:2px 6px; border-radius:4px; background:var(--secondary); color:white;">FK</span>
                </div>
                <div style="padding:12px 16px; font-size:12px; display:flex; flex-direction:column; gap:6px;">
                    <div>🔑 <strong>id</strong> : BIGINT <span style="color:var(--text-muted);">(auto_inc)</span></div>
                    <div style="color:var(--primary); font-weight:600;">🔗 <strong>employe_id</strong> : BIGINT</div>
                    <div>📄 <strong>type_contrat</strong> : ENUM</div>
                    <div>📅 <strong>date_debut</strong> : DATE</div>
                    <div>📅 <strong>date_fin</strong> : DATE</div>
                    <div>💰 <strong>salaire</strong> : DECIMAL(10,2)</div>
                    <div>🎁 <strong>avantages</strong> : VARCHAR(300)</div>
                </div>
            </div>

            <!-- Table 4: Conge -->
            <div class="erd-table glass-panel" id="table-conge" onmouseenter="highlightErd('conge')" onmouseleave="resetErd()">
                <div class="erd-table-header" style="background:rgba(245,158,11,0.1); border-bottom:1px solid var(--border-glow); padding:10px 16px; font-weight:700; display:flex; justify-content:between; align-items:center;">
                    <span>conge</span>
                    <span style="font-size:10px; padding:2px 6px; border-radius:4px; background:var(--warning); color:white;">FK</span>
                </div>
                <div style="padding:12px 16px; font-size:12px; display:flex; flex-direction:column; gap:6px;">
                    <div>🔑 <strong>id</strong> : BIGINT <span style="color:var(--text-muted);">(auto_inc)</span></div>
                    <div style="color:var(--primary); font-weight:600;">🔗 <strong>employe_id</strong> : BIGINT</div>
                    <div>🏝️ <strong>type_conge</strong> : ENUM</div>
                    <div>📅 <strong>date_debut</strong> : DATE</div>
                    <div>📅 <strong>date_fin</strong> : DATE</div>
                    <div>🔢 <strong>nb_jours</strong> : INT</div>
                    <div>📝 <strong>motif</strong> : VARCHAR(300)</div>
                    <div>🟢 <strong>statut</strong> : ENUM</div>
                </div>
            </div>

            <!-- Table 5: Fiche de Paie -->
            <div class="erd-table glass-panel" id="table-fichepaie" onmouseenter="highlightErd('fichepaie')" onmouseleave="resetErd()">
                <div class="erd-table-header" style="background:rgba(16,185,129,0.1); border-bottom:1px solid var(--border-glow); padding:10px 16px; font-weight:700; display:flex; justify-content:between; align-items:center;">
                    <span>fiche_paie</span>
                    <span style="font-size:10px; padding:2px 6px; border-radius:4px; background:var(--success); color:white;">FK</span>
                </div>
                <div style="padding:12px 16px; font-size:12px; display:flex; flex-direction:column; gap:6px;">
                    <div>🔑 <strong>id</strong> : BIGINT <span style="color:var(--text-muted);">(auto_inc)</span></div>
                    <div style="color:var(--primary); font-weight:600;">🔗 <strong>employe_id</strong> : BIGINT</div>
                    <div>📅 <strong>mois</strong> : VARCHAR(7)</div>
                    <div>💰 <strong>salaire_base</strong> : DECIMAL(10,2)</div>
                    <div>💰 <strong>heures_sup</strong> : DECIMAL(6,2)</div>
                    <div>💰 <strong>primes</strong> : DECIMAL(10,2)</div>
                    <div>💰 <strong>retenues</strong> : DECIMAL(10,2)</div>
                    <div>💰 <strong>salaire_net</strong> : DECIMAL(10,2)</div>
                </div>
            </div>

            <!-- Table 6: Utilisateur -->
            <div class="erd-table glass-panel" id="table-utilisateur" onmouseenter="highlightErd('utilisateur')" onmouseleave="resetErd()">
                <div class="erd-table-header" style="background:rgba(239,68,68,0.1); border-bottom:1px solid var(--border-glow); padding:10px 16px; font-weight:700; display:flex; justify-content:between; align-items:center;">
                    <span>utilisateur</span>
                    <span style="font-size:10px; padding:2px 6px; border-radius:4px; background:var(--danger); color:white;">FK</span>
                </div>
                <div style="padding:12px 16px; font-size:12px; display:flex; flex-direction:column; gap:6px;">
                    <div>🔑 <strong>id</strong> : BIGINT <span style="color:var(--text-muted);">(auto_inc)</span></div>
                    <div>📧 <strong>email</strong> : VARCHAR(150)</div>
                    <div>🔒 <strong>mot_de_passe</strong> : VARCHAR(255)</div>
                    <div>🟢 <strong>est_actif</strong> : BOOLEAN</div>
                    <div style="color:var(--primary); font-weight:600;">🔗 <strong>employe_id</strong> : BIGINT <span style="color:var(--text-muted);">(nullable)</span></div>
                </div>
            </div>
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

    /* ERD highlight styling */
    .erd-table {
        transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        cursor: pointer;
    }
    .erd-table:hover {
        transform: translateY(-4px) scale(1.02);
        box-shadow: 0 12px 30px rgba(99, 102, 241, 0.15);
    }
    .erd-table.fade-out-erd {
        opacity: 0.25;
        transform: scale(0.98);
        filter: blur(1px);
    }
    .erd-table.highlight-erd {
        border-color: var(--accent) !important;
        box-shadow: 0 0 20px rgba(6, 182, 212, 0.4) !important;
        opacity: 1 !important;
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

    // ERD Hover highlighting
    const highlightErd = (activeTable) => {
        document.querySelectorAll('.erd-table').forEach(table => {
            table.classList.add('fade-out-erd');
        });
        
        // Highlight selected table
        const activeNode = document.getElementById('table-' + activeTable);
        if (activeNode) {
            activeNode.classList.remove('fade-out-erd');
            activeNode.classList.add('highlight-erd');
        }

        // Highlight related tables depending on keys
        if (activeTable === 'employe') {
            document.getElementById('table-departement').classList.remove('fade-out-erd');
            document.getElementById('table-departement').classList.add('highlight-erd');
        } else if (activeTable === 'contrat' || activeTable === 'conge' || activeTable === 'fichepaie' || activeTable === 'utilisateur') {
            document.getElementById('table-employe').classList.remove('fade-out-erd');
            document.getElementById('table-employe').classList.add('highlight-erd');
        } else if (activeTable === 'departement') {
            document.getElementById('table-employe').classList.remove('fade-out-erd');
            document.getElementById('table-employe').classList.add('highlight-erd');
        }
    };

    const resetErd = () => {
        document.querySelectorAll('.erd-table').forEach(table => {
            table.classList.remove('fade-out-erd', 'highlight-erd');
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
