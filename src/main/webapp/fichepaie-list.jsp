<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/layout-header.jsp">
    <jsp:param name="active" value="paie" />
</jsp:include>

<div class="page-title">
    <h1>Fiches de Paie</h1>
    <div class="actions">
        <a href="${pageContext.request.contextPath}/fiches-paie/export" class="btn btn-success"><i class="fa-solid fa-file-pdf"></i> Exporter PDF</a>
        <a href="${pageContext.request.contextPath}/fiches-paie/new" class="btn btn-primary"><i class="fa-solid fa-plus"></i> Nouvelle Fiche</a>
    </div>
</div>

<div class="card-panel table-responsive">
    <table class="custom-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Employé</th>
                <th>Mois</th>
                <th>Salaire Base</th>
                <th>Primes</th>
                <th>Retenues</th>
                <th>Salaire Net</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="f" items="${listFiches}">
                <tr>
                    <td><c:out value="${f.id}" /></td>
                    <td><c:out value="${f.employe.nom} ${f.employe.prenom}" /></td>
                    <td><c:out value="${f.mois}" /></td>
                    <td><c:out value="${f.salaireBase}" /> €</td>
                    <td><c:out value="${f.primes}" /> €</td>
                    <td><c:out value="${f.retenues}" /> €</td>
                    <td style="font-weight:bold; color:var(--success-color);"><c:out value="${f.salaireNet}" /> €</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/fiches-paie/edit?id=${f.id}" class="btn btn-sm btn-primary"><i class="fa-solid fa-pen"></i></a>
                        <a href="${pageContext.request.contextPath}/fiches-paie/delete?id=${f.id}" class="btn btn-sm btn-danger" onclick="return confirm('Êtes-vous sûr ?');"><i class="fa-solid fa-trash"></i></a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<jsp:include page="/layout-footer.jsp" />
