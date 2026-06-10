<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/layout-header.jsp">
    <jsp:param name="active" value="conge" />
</jsp:include>

<div class="page-title">
    <h1>Liste des Congés</h1>
    <div class="actions">
        <a href="${pageContext.request.contextPath}/conges/export" class="btn btn-success"><i class="fa-solid fa-file-pdf"></i> Exporter PDF</a>
        <a href="${pageContext.request.contextPath}/conges/new" class="btn btn-primary"><i class="fa-solid fa-plus"></i> Nouvelle Demande</a>
    </div>
</div>

<div class="card-panel table-responsive">
    <table class="custom-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Employé</th>
                <th>Type</th>
                <th>Période</th>
                <th>Jours</th>
                <th>Statut</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="c" items="${listConges}">
                <tr>
                    <td><c:out value="${c.id}" /></td>
                    <td><c:out value="${c.employe.nom} ${c.employe.prenom}" /></td>
                    <td><c:out value="${c.typeConge}" /></td>
                    <td><c:out value="${c.dateDebut}" /> - <c:out value="${c.dateFin}" /></td>
                    <td><c:out value="${c.nbJours}" /> j</td>
                    <td>
                        <c:choose>
                            <c:when test="${c.statut == 'APPROUVE'}">
                                <span class="badge badge-success">APPROUVÉ</span>
                            </c:when>
                            <c:when test="${c.statut == 'REFUSE'}">
                                <span class="badge badge-danger">REFUSÉ</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-warning">EN ATTENTE</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:if test="${c.statut == 'DEMANDE'}">
                            <a href="${pageContext.request.contextPath}/conges/approve?id=${c.id}&statut=APPROUVE" class="btn btn-sm btn-success" title="Approuver"><i class="fa-solid fa-check"></i></a>
                            <a href="${pageContext.request.contextPath}/conges/approve?id=${c.id}&statut=REFUSE" class="btn btn-sm btn-danger" title="Refuser"><i class="fa-solid fa-times"></i></a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/conges/edit?id=${c.id}" class="btn btn-sm btn-primary"><i class="fa-solid fa-pen"></i></a>
                        <a href="${pageContext.request.contextPath}/conges/delete?id=${c.id}" class="btn btn-sm btn-danger" onclick="return confirm('Êtes-vous sûr ?');"><i class="fa-solid fa-trash"></i></a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<jsp:include page="/layout-footer.jsp" />
