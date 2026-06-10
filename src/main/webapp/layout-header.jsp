<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>InterGo - RH Dashboard</title>
    <!-- Google Fonts -->
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

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <h2 style="display:flex; align-items:center; gap:8px;"><i class="fa-solid fa-compass navbar-brand-icon" style="font-size:24px; animation: rotate-compass 12s infinite linear; background: linear-gradient(135deg, var(--accent) 0%, var(--primary) 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;"></i> Inter<span style="color:var(--primary);">Go</span></h2>
        </div>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/dashboard" class="${param.active == 'dashboard' ? 'active' : ''}"><i class="fa-solid fa-chart-pie"></i> Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/departements" class="${param.active == 'departement' ? 'active' : ''}"><i class="fa-solid fa-building"></i> Départements</a></li>
            <li><a href="${pageContext.request.contextPath}/employes" class="${param.active == 'employe' ? 'active' : ''}"><i class="fa-solid fa-users"></i> Employés</a></li>
            <li><a href="${pageContext.request.contextPath}/contrats" class="${param.active == 'contrat' ? 'active' : ''}"><i class="fa-solid fa-file-signature"></i> Contrats</a></li>
            <li><a href="${pageContext.request.contextPath}/conges" class="${param.active == 'conge' ? 'active' : ''}"><i class="fa-solid fa-calendar-alt"></i> Congés</a></li>
            <li><a href="${pageContext.request.contextPath}/fiches-paie" class="${param.active == 'paie' ? 'active' : ''}"><i class="fa-solid fa-file-invoice-dollar"></i> Fiches de Paie</a></li>
        </ul>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <!-- Header -->
        <header class="top-header">
            <div class="search-bar">
                <!-- Placeholder for search if needed -->
            </div>
            <div class="user-profile" style="display:flex; align-items:center; gap:16px;">
                <div style="display:flex; flex-direction:column; align-items:flex-end;">
                    <span style="font-weight:700; color:var(--text-main);">${not empty sessionScope.userEmail ? sessionScope.userEmail : 'Administrateur'}</span>
                    <span style="font-size:11px; color:var(--text-muted); text-transform:uppercase; font-weight:600; letter-spacing:0.5px;">Accès Dashboard</span>
                </div>
                <div style="width:40px; height:40px; border-radius:50%; background:rgba(99, 102, 241, 0.15); border:1px solid var(--border-glow-active); display:flex; align-items:center; justify-content:center; color:var(--primary);">
                    <i class="fa-solid fa-user" style="font-size:16px;"></i>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-danger" style="padding: 8px 12px;" title="Se déconnecter"><i class="fa-solid fa-right-from-bracket"></i></a>
            </div>
        </header>

        <!-- Content Area -->
        <div class="content-area">
