<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/layout-header.jsp">
    <jsp:param name="active" value="contrat" />
</jsp:include>

<div class="page-title fade-in">
    <h1>Liste des Contrats</h1>
    <div class="actions">
        <a href="${pageContext.request.contextPath}/contrats/export" class="btn btn-success"><i class="fa-solid fa-file-pdf"></i> Exporter PDF</a>
        <a href="${pageContext.request.contextPath}/contrats/new" class="btn btn-primary"><i class="fa-solid fa-plus"></i> Nouveau Contrat</a>
    </div>
</div>

<div class="card-panel table-responsive fade-in-delay-1">
    <table class="custom-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Employé</th>
                <th>Type</th>
                <th>Date Début</th>
                <th>Date Fin</th>
                <th>Salaire</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="c" items="${listContrats}">
                <tr>
                    <td><c:out value="${c.id}" /></td>
                    <td><c:out value="${c.employe.matricule} - ${c.employe.nom} ${c.employe.prenom}" /></td>
                    <td><c:out value="${c.typeContrat}" /></td>
                    <td><c:out value="${c.dateDebut}" /></td>
                    <td><c:out value="${c.dateFin != null ? c.dateFin : 'N/A'}" /></td>
                    <td><c:out value="${c.salaire}" /> FCFA</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/contrats/edit?id=${c.id}" class="btn btn-sm btn-primary"><i class="fa-solid fa-pen"></i></a>
                        <a href="${pageContext.request.contextPath}/contrats/delete?id=${c.id}" class="btn btn-sm btn-danger" onclick="return confirm('Êtes-vous sûr ?');"><i class="fa-solid fa-trash"></i></a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<jsp:include page="/layout-footer.jsp" />
