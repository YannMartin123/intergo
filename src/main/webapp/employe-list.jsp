<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/layout-header.jsp">
    <jsp:param name="active" value="employe" />
</jsp:include>

<div class="page-title fade-in">
    <h1>Liste des Employés</h1>
    <div class="actions">
        <a href="${pageContext.request.contextPath}/employes/export" class="btn btn-success"><i class="fa-solid fa-file-pdf"></i> Exporter PDF</a>
        <a href="${pageContext.request.contextPath}/employes/new" class="btn btn-primary"><i class="fa-solid fa-plus"></i> Nouvel Employé</a>
    </div>
</div>

<div class="card-panel table-responsive fade-in-delay-1">
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
                        <span class="badge" style="background: rgba(139, 92, 246, 0.15); color: #c084fc; border: 1px solid rgba(139, 92, 246, 0.2);">
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
