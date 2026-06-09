<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>InterGo - RH Dashboard</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <h2><i class="fa-solid fa-layer-group"></i> InterGo</h2>
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
            <div class="user-profile">
                <span>Administrateur</span>
                <i class="fa-solid fa-user-circle fa-2x"></i>
                <!-- a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-danger"><i class="fa-solid fa-sign-out-alt"></i></a -->
            </div>
        </header>

        <!-- Content Area -->
        <div class="content-area">
