<jsp:include page="/layout-header.jsp">
    <jsp:param name="active" value="dashboard" />
</jsp:include>

<div class="page-title">
    <h1>Tableau de Bord</h1>
</div>

<div class="stats-grid">
    <div class="stat-card">
        <div class="stat-icon blue">
            <i class="fa-solid fa-users"></i>
        </div>
        <div class="stat-info">
            <h3>${totalEmployes}</h3>
            <p>Employés Actifs</p>
        </div>
    </div>
    <div class="stat-card">
        <div class="stat-icon orange">
            <i class="fa-solid fa-clock"></i>
        </div>
        <div class="stat-info">
            <h3>${congesAttente}</h3>
            <p>Congés en attente</p>
        </div>
    </div>
    <div class="stat-card">
        <div class="stat-icon green">
            <i class="fa-solid fa-money-bill-wave"></i>
        </div>
        <div class="stat-info">
            <h3>${masseSalariale} €</h3>
            <p>Masse Salariale Totale</p>
        </div>
    </div>
</div>

<div class="card-panel">
    <h2>Bienvenue sur InterGo</h2>
    <p style="margin-top: 15px; color: var(--text-muted);">
        Sélectionnez une option dans le menu de gauche pour gérer les départements, les employés, ou générer des rapports.
    </p>
</div>

<jsp:include page="/layout-footer.jsp" />
