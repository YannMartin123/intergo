<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<jsp:include page="/layout-header.jsp">
    <jsp:param name="active" value="dashboard" />
</jsp:include>

<!-- Chart.js Library -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<div class="page-title fade-in">
    <div>
        <h1 class="text-gradient">Tableau de Bord</h1>
        <p style="color:var(--text-secondary); font-size:14px; margin-top:4px;">Indicateurs clés de performance et analyses détaillées de vos ressources humaines.</p>
    </div>
</div>

<!-- ══ KPI STATS GRID ══ -->
<div class="stats-grid fade-in-delay-1" style="display:grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap:24px; margin-bottom:32px;">
    <!-- Metric 1: Total Employees -->
    <div class="stat-card" style="position:relative; overflow:hidden;">
        <div class="stat-icon blue">
            <i class="fa-solid fa-users"></i>
        </div>
        <div class="stat-info">
            <h3 id="stat-employees" style="font-size:28px; font-weight:800;">0</h3>
            <p>Employés Actifs</p>
        </div>
    </div>

    <!-- Metric 2: Pending Leaves -->
    <div class="stat-card ${congesAttente > 0 ? 'neon-border-green' : ''}" style="position:relative; overflow:hidden;">
        <div class="stat-icon orange" style="${congesAttente > 0 ? 'animation: pulse-gear 1.5s infinite;' : ''}">
            <i class="fa-solid fa-clock"></i>
        </div>
        <div class="stat-info">
            <h3 id="stat-leaves" style="font-size:28px; font-weight:800;">0</h3>
            <p>Congés en attente</p>
        </div>
    </div>

    <!-- Metric 3: Total Payroll -->
    <div class="stat-card" style="position:relative; overflow:hidden;">
        <div class="stat-icon green">
            <i class="fa-solid fa-money-bill-wave"></i>
        </div>
        <div class="stat-info">
            <h3 id="stat-payroll" style="font-size:28px; font-weight:800;">0</h3>
            <p>Masse Salariale Net</p>
        </div>
    </div>

    <!-- Metric 4: Average Salary -->
    <div class="stat-card" style="position:relative; overflow:hidden;">
        <div class="stat-icon violet">
            <i class="fa-solid fa-scale-balanced"></i>
        </div>
        <div class="stat-info">
            <h3 id="stat-avg-salary" style="font-size:28px; font-weight:800;">0</h3>
            <p>Salaire de Base Moyen</p>
        </div>
    </div>
</div>

<!-- ══ CHARTS GRID ══ -->
<div class="charts-container fade-in-delay-2" style="display:grid; grid-template-columns: repeat(auto-fit, minmax(450px, 1fr)); gap:32px; margin-bottom:32px;">
    
    <!-- Chart 1: Hires Trend (Line Area) -->
    <div class="card-panel" style="padding:24px;">
        <h2 style="font-size:16px; font-weight:700; margin-bottom:20px; display:flex; align-items:center; gap:8px;"><i class="fa-solid fa-chart-area" style="color:var(--accent);"></i> Évolution des Recrutements</h2>
        <div style="height:250px; position:relative;">
            <canvas id="chartHires"></canvas>
        </div>
    </div>

    <!-- Chart 2: Departments Distribution (Bar) -->
    <div class="card-panel" style="padding:24px;">
        <h2 style="font-size:16px; font-weight:700; margin-bottom:20px; display:flex; align-items:center; gap:8px;"><i class="fa-solid fa-chart-bar" style="color:var(--primary);"></i> Répartition des Effectifs</h2>
        <div style="height:250px; position:relative;">
            <canvas id="chartDepts"></canvas>
        </div>
    </div>

    <!-- Chart 3: Contract Types (Pie) -->
    <div class="card-panel" style="padding:24px;">
        <h2 style="font-size:16px; font-weight:700; margin-bottom:20px; display:flex; align-items:center; gap:8px;"><i class="fa-solid fa-chart-pie" style="color:var(--secondary);"></i> Types de Contrat</h2>
        <div style="height:250px; position:relative;">
            <canvas id="chartContracts"></canvas>
        </div>
    </div>

    <!-- Chart 4: Leave Statuses (Doughnut) -->
    <div class="card-panel" style="padding:24px;">
        <h2 style="font-size:16px; font-weight:700; margin-bottom:20px; display:flex; align-items:center; gap:8px;"><i class="fa-solid fa-circle-notch" style="color:var(--success);"></i> Statut des Demandes de Congé</h2>
        <div style="height:250px; position:relative;">
            <canvas id="chartConges"></canvas>
        </div>
    </div>

    <!-- Chart 5: Salary Ranges (Horizontal Bar) -->
    <div class="card-panel" style="padding:24px;">
        <h2 style="font-size:16px; font-weight:700; margin-bottom:20px; display:flex; align-items:center; gap:8px;"><i class="fa-solid fa-wallet" style="color:var(--warning);"></i> Répartition des Tranches de Salaire</h2>
        <div style="height:250px; position:relative;">
            <canvas id="chartSalaries"></canvas>
        </div>
    </div>

    <!-- Chart 6: Budget vs Actuals (Grouped Bar) -->
    <div class="card-panel" style="padding:24px;">
        <h2 style="font-size:16px; font-weight:700; margin-bottom:20px; display:flex; align-items:center; gap:8px;"><i class="fa-solid fa-scale-unbalanced" style="color:var(--accent);"></i> Masse Salariale : Budget vs Réel</h2>
        <div style="height:250px; position:relative;">
            <canvas id="chartBudgetVsSalaries"></canvas>
        </div>
    </div>

    <!-- Chart 7: Leave Types Distribution (Polar Area) -->
    <div class="card-panel" style="padding:24px;">
        <h2 style="font-size:16px; font-weight:700; margin-bottom:20px; display:flex; align-items:center; gap:8px;"><i class="fa-solid fa-umbrella-beach" style="color:var(--secondary);"></i> Motifs de Demandes de Congés</h2>
        <div style="height:250px; position:relative;">
            <canvas id="chartCongeTypes"></canvas>
        </div>
    </div>

    <!-- Chart 8: Company Salary Structure (Radar) -->
    <div class="card-panel" style="padding:24px;">
        <h2 style="font-size:16px; font-weight:700; margin-bottom:20px; display:flex; align-items:center; gap:8px;"><i class="fa-solid fa-receipt" style="color:var(--success);"></i> Structure Global des Coûts Salariaux</h2>
        <div style="height:250px; position:relative;">
            <canvas id="chartSalaryStructure"></canvas>
        </div>
    </div>

    <!-- Interactive Quick Actions & Simulated Logs -->
    <div class="card-panel" style="display:flex; flex-direction:column; gap:20px; padding:24px; grid-column: span 2;">
        <h2 style="font-size:18px; font-weight:700; margin-bottom:10px; display:flex; align-items:center; gap:8px;"><i class="fa-solid fa-bolt" style="color:var(--accent);"></i> Actions Rapides</h2>
        
        <div style="display:grid; grid-template-columns:repeat(auto-fit, minmax(200px, 1fr)); gap:12px;">
            <a href="${pageContext.request.contextPath}/employes/new" class="btn btn-outline" style="font-size:13px; padding:12px;"><i class="fa-solid fa-user-plus" style="color:var(--primary);"></i> Recruter Employé</a>
            <a href="${pageContext.request.contextPath}/conges/new" class="btn btn-outline" style="font-size:13px; padding:12px;"><i class="fa-solid fa-calendar-plus" style="color:var(--warning);"></i> Demander un Congé</a>
            <a href="${pageContext.request.contextPath}/contrats/new" class="btn btn-outline" style="font-size:13px; padding:12px;"><i class="fa-solid fa-file-contract" style="color:var(--secondary);"></i> Éditer un Contrat</a>
            <a href="${pageContext.request.contextPath}/fiches-paie/new" class="btn btn-outline" style="font-size:13px; padding:12px;"><i class="fa-solid fa-receipt" style="color:var(--success);"></i> Émettre une Fiche</a>
        </div>

        <div style="border-top:1px solid rgba(255, 255, 255, 0.05); padding-top:16px; flex:1; display:flex; flex-direction:column;">
            <h3 style="font-size:13px; font-weight:600; text-transform:uppercase; color:var(--text-muted); margin-bottom:12px; letter-spacing:0.5px;">Flux d'Activité Récente</h3>
            <div id="activity-feed" style="display:flex; flex-direction:column; gap:10px; font-size:12px; color:var(--text-secondary); max-height:120px; overflow-y:auto; flex:1;">
                <div style="display:flex; gap:8px; align-items:center;"><span style="width:6px; height:6px; border-radius:50%; background:var(--primary);"></span> Connexion sécurisée de l'administrateur</div>
                <div style="display:flex; gap:8px; align-items:center;"><span style="width:6px; height:6px; border-radius:50%; background:var(--success);"></span> Base de données synchronisée et chargée avec succès</div>
            </div>
        </div>
    </div>
</div>

<script>
    // ── KPI COUNT-UP ANIMATION ──
    const animateCounter = (id, target, suffix = '', decimals = 0) => {
        const el = document.getElementById(id);
        if (!el) return;
        const duration = 1200; // 1.2 seconds
        const steps = 40;
        const increment = target / steps;
        let current = 0;
        let step = 0;
        const timer = setInterval(() => {
            current += increment;
            step++;
            if (step >= steps) {
                el.innerText = target.toFixed(decimals).replace(/\B(?=(\d{3})+(?!\d))/g, " ") + suffix;
                clearInterval(timer);
            } else {
                el.innerText = current.toFixed(decimals).replace(/\B(?=(\d{3})+(?!\d))/g, " ") + suffix;
            }
        }, duration / steps);
    };

    // Trigger metrics animations
    animateCounter('stat-employees', ${totalEmployes});
    animateCounter('stat-leaves', ${congesAttente});
    animateCounter('stat-payroll', ${masseSalariale}, ' FCFA', 2);
    animateCounter('stat-avg-salary', ${avgSalary}, ' FCFA', 2);

    // ── CHARTS INITIALIZATION ──
    const getCssVar = (name) => getComputedStyle(document.documentElement).getPropertyValue(name).trim();
    
    const primaryColor = getCssVar('--primary') || '#6366f1';
    const secondaryColor = getCssVar('--secondary') || '#8b5cf6';
    const accentColor = getCssVar('--accent') || '#06b6d4';
    const successColor = getCssVar('--success') || '#10b981';
    const warningColor = getCssVar('--warning') || '#f59e0b';
    const dangerColor = getCssVar('--danger') || '#ef4444';
    
    // Global chart theme config
    const chartDefaults = {
        responsive: true,
        maintainAspectRatio: false,
        animation: {
            duration: 1200,
            easing: 'easeOutQuart'
        },
        plugins: {
            legend: {
                labels: {
                    color: '#94a3b8',
                    font: { family: 'Outfit, Inter, sans-serif', size: 11 }
                }
            }
        },
        scales: {
            r: { grid: { color: 'rgba(255,255,255,0.05)' }, angleLines: { color: 'rgba(255,255,255,0.05)' } },
            x: { ticks: { color: '#94a3b8', font: { family: 'Outfit, Inter, sans-serif' } }, grid: { color: 'rgba(255,255,255,0.03)' } },
            y: { ticks: { color: '#94a3b8', font: { family: 'Outfit, Inter, sans-serif' } }, grid: { color: 'rgba(255,255,255,0.03)' } }
        }
    };

    // Parse data feeds
    const hireData = ${hireJson};
    const deptData = ${deptJson};
    const contractData = ${contractJson};
    const congeData = ${congeJson};
    const salaryData = ${salaryJson};
    const budgetVsActualData = ${budgetVsActualJson};
    const congeTypeData = ${congeTypeJson};
    const structureData = ${structureJson};

    // Chart 1: Recrutements Trend (Line Area)
    new Chart(document.getElementById('chartHires'), {
        type: 'line',
        data: {
            labels: Object.keys(hireData),
            datasets: [{
                label: 'Nouveaux Recrutements',
                data: Object.values(hireData),
                borderColor: accentColor,
                backgroundColor: 'rgba(6, 182, 212, 0.15)',
                borderWidth: 3,
                fill: true,
                tension: 0.4
            }]
        },
        options: chartDefaults
    });

    // Chart 2: Departments Distribution (Bar)
    new Chart(document.getElementById('chartDepts'), {
        type: 'bar',
        data: {
            labels: Object.keys(deptData),
            datasets: [{
                label: 'Nombre de collaborateurs',
                data: Object.values(deptData),
                backgroundColor: [primaryColor, secondaryColor, accentColor, successColor, warningColor],
                borderRadius: 6
            }]
        },
        options: chartDefaults
    });

    // Chart 3: Contract Types (Pie)
    new Chart(document.getElementById('chartContracts'), {
        type: 'pie',
        data: {
            labels: Object.keys(contractData),
            datasets: [{
                data: Object.values(contractData),
                backgroundColor: [primaryColor, secondaryColor, successColor, warningColor],
                borderColor: 'rgba(11, 15, 25, 0.9)',
                borderWidth: 2
            }]
        },
        options: {
            ...chartDefaults,
            scales: {} // Pie charts don't have axis scales
        }
    });

    // Chart 4: Leave Statuses (Doughnut)
    new Chart(document.getElementById('chartConges'), {
        type: 'doughnut',
        data: {
            labels: Object.keys(congeData),
            datasets: [{
                data: Object.values(congeData),
                backgroundColor: [successColor, dangerColor, warningColor],
                borderColor: 'rgba(11, 15, 25, 0.9)',
                borderWidth: 2
            }]
        },
        options: {
            ...chartDefaults,
            cutout: '68%',
            scales: {}
        }
    });

    // Chart 5: Salary Ranges (Horizontal Bar)
    new Chart(document.getElementById('chartSalaries'), {
        type: 'bar',
        data: {
            labels: Object.keys(salaryData),
            datasets: [{
                label: 'Collaborateurs par tranche',
                data: Object.values(salaryData),
                backgroundColor: secondaryColor,
                borderRadius: 6
            }]
        },
        options: {
            ...chartDefaults,
            indexAxis: 'y'
        }
    });

    // Chart 6: Budget vs Actuals (Grouped Bar)
    const deptLabels = Object.keys(budgetVsActualData);
    const budgetAllocated = deptLabels.map(k => budgetVsActualData[k].allocated);
    const salarySpent = deptLabels.map(k => budgetVsActualData[k].spent);

    new Chart(document.getElementById('chartBudgetVsSalaries'), {
        type: 'bar',
        data: {
            labels: deptLabels,
            datasets: [
                {
                    label: 'Budget Masse Salariale Alloué',
                    data: budgetAllocated,
                    backgroundColor: 'rgba(99, 102, 241, 0.65)',
                    borderColor: primaryColor,
                    borderWidth: 1,
                    borderRadius: 4
                },
                {
                    label: 'Masse Salariale Réelle',
                    data: salarySpent,
                    backgroundColor: 'rgba(16, 185, 129, 0.65)',
                    borderColor: successColor,
                    borderWidth: 1,
                    borderRadius: 4
                }
            ]
        },
        options: chartDefaults
    });

    // Chart 7: Leave Types Distribution (Polar Area)
    new Chart(document.getElementById('chartCongeTypes'), {
        type: 'polarArea',
        data: {
            labels: Object.keys(congeTypeData),
            datasets: [{
                data: Object.values(congeTypeData),
                backgroundColor: [primaryColor, secondaryColor, accentColor, successColor, warningColor],
                borderColor: 'rgba(11, 15, 25, 0.9)',
                borderWidth: 2
            }]
        },
        options: {
            ...chartDefaults,
            scales: {
                r: {
                    grid: { color: 'rgba(255,255,255,0.05)' },
                    angleLines: { color: 'rgba(255,255,255,0.05)' },
                    ticks: { color: '#94a3b8', backdropColor: 'transparent' }
                }
            }
        }
    });

    // Chart 8: Company Salary Structure (Radar)
    new Chart(document.getElementById('chartSalaryStructure'), {
        type: 'radar',
        data: {
            labels: Object.keys(structureData),
            datasets: [{
                label: 'Montant Total Cumulé (FCFA)',
                data: Object.values(structureData),
                backgroundColor: 'rgba(6, 182, 212, 0.15)',
                borderColor: accentColor,
                pointBackgroundColor: accentColor,
                pointBorderColor: '#fff',
                borderWidth: 2
            }]
        },
        options: {
            ...chartDefaults,
            scales: {
                r: {
                    grid: { color: 'rgba(255,255,255,0.05)' },
                    angleLines: { color: 'rgba(255,255,255,0.05)' },
                    pointLabels: { color: '#94a3b8', font: { family: 'Outfit, Inter, sans-serif' } },
                    ticks: { display: false }
                }
            }
        }
    });

    // ── SIMULATED ACTIVITY FEED ──
    const feed = document.getElementById('activity-feed');
    const actions = [
        { text: 'Contrat CDI signé pour Sophie Martin', color: accentColor },
        { text: 'Fiche de paie émise pour Lucas Petit', color: successColor },
        { text: 'Demande de congé ANNUEL soumise par Arthur Moreau', color: warningColor },
        { text: 'Département Finance mis à jour par l\'admin', color: primaryColor },
        { text: 'Contrat CDD créé pour Maxime Fontaine', color: secondaryColor },
        { text: 'Congé validé pour Camille Roux', color: successColor }
    ];

    setInterval(() => {
        const act = actions[Math.floor(Math.random() * actions.length)];
        const div = document.createElement('div');
        div.style.cssText = 'display:flex; gap:8px; align-items:center; opacity:0; transform:translateY(-10px); transition:all 0.5s ease;';
        div.innerHTML = `<span style="width:6px; height:6px; border-radius:50%; background:${act.color};"></span> ${act.text}`;
        
        feed.insertBefore(div, feed.firstChild);
        setTimeout(() => {
            div.style.opacity = '1';
            div.style.transform = 'translateY(0)';
        }, 50);

        if (feed.children.length > 5) {
            feed.removeChild(feed.lastChild);
        }
    }, 4000);
</script>

<jsp:include page="/layout-footer.jsp" />
