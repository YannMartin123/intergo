<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/layout-header.jsp">
    <jsp:param name="active" value="departement" />
</jsp:include>

<div class="page-title">
    <h1>Liste des Départements</h1>
    <div class="actions">
        <a href="${pageContext.request.contextPath}/departements/export" class="btn btn-success"><i class="fa-solid fa-file-pdf"></i> Exporter PDF</a>
        <a href="${pageContext.request.contextPath}/departements/new" class="btn btn-primary"><i class="fa-solid fa-plus"></i> Nouveau Département</a>
    </div>
</div>

<div class="card-panel table-responsive">
    <table class="custom-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Nom</th>
                <th>Responsable</th>
                <th>Budget (Masse Salariale)</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="dept" items="${listDepartement}">
                <tr>
                    <td><c:out value="${dept.id}" /></td>
                    <td><c:out value="${dept.nom}" /></td>
                    <td><c:out value="${dept.responsable}" /></td>
                    <td><c:out value="${dept.budgetMasseSalariale}" /> €</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/departements/edit?id=${dept.id}" class="btn btn-sm btn-primary"><i class="fa-solid fa-pen"></i></a>
                        <a href="${pageContext.request.contextPath}/departements/delete?id=${dept.id}" class="btn btn-sm btn-danger" onclick="return confirm('Êtes-vous sûr ?');"><i class="fa-solid fa-trash"></i></a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<jsp:include page="/layout-footer.jsp" />
