<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/layout-header.jsp">
    <jsp:param name="active" value="employe" />
</jsp:include>

<div class="page-title">
    <h1>Liste des Employés</h1>
    <div class="actions">
        <a href="${pageContext.request.contextPath}/employes/export" class="btn btn-success"><i class="fa-solid fa-file-pdf"></i> Exporter PDF</a>
        <a href="${pageContext.request.contextPath}/employes/new" class="btn btn-primary"><i class="fa-solid fa-plus"></i> Nouvel Employé</a>
    </div>
</div>

<div class="card-panel table-responsive">
    <table class="custom-table">
        <thead>
            <tr>
                <th>Matricule</th>
                <th>Nom & Prénom</th>
                <th>Poste</th>
                <th>Département</th>
                <th>Type Contrat</th>
                <th>Solde Congés</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="emp" items="${listEmployes}">
                <tr>
                    <td><c:out value="${emp.matricule}" /></td>
                    <td><c:out value="${emp.nom} ${emp.prenom}" /></td>
                    <td><c:out value="${emp.poste}" /></td>
                    <td><c:out value="${emp.departement.nom}" /></td>
                    <td>
                        <span style="padding: 4px 8px; border-radius: 4px; background-color: var(--secondary-color); font-size: 12px;">
                            <c:out value="${emp.typeContrat}" />
                        </span>
                    </td>
                    <td><c:out value="${emp.soldeCongesJours}" /> j</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/employes/edit?id=${emp.id}" class="btn btn-sm btn-primary"><i class="fa-solid fa-pen"></i></a>
                        <a href="${pageContext.request.contextPath}/employes/delete?id=${emp.id}" class="btn btn-sm btn-danger" onclick="return confirm('Êtes-vous sûr ?');"><i class="fa-solid fa-trash"></i></a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<jsp:include page="/layout-footer.jsp" />
