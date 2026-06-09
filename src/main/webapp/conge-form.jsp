<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/layout-header.jsp">
    <jsp:param name="active" value="conge" />
</jsp:include>

<div class="page-title">
    <h1>
        <c:if test="${conge != null}">Modifier Demande Congé</c:if>
        <c:if test="${conge == null}">Nouvelle Demande Congé</c:if>
    </h1>
    <a href="${pageContext.request.contextPath}/conges" class="btn btn-primary"><i class="fa-solid fa-arrow-left"></i> Retour</a>
</div>

<div class="card-panel">
    <form action="${pageContext.request.contextPath}/conges/${conge != null ? 'update' : 'insert'}" method="post">
        
        <c:if test="${conge != null}">
            <input type="hidden" name="id" value="<c:out value='${conge.id}' />" />
            <input type="hidden" name="statut" value="<c:out value='${conge.statut}' />" />
            <input type="hidden" name="approuvePar" value="<c:out value='${conge.approuvePar}' />" />
        </c:if>

        <div class="form-grid">
            <div class="form-group">
                <label for="employeId">Employé</label>
                <select id="employeId" name="employeId" class="form-control" required>
                    <c:forEach var="emp" items="${listEmployes}">
                        <option value="${emp.id}" ${conge != null && conge.employeId == emp.id ? 'selected' : ''}>
                            <c:out value="${emp.matricule} - ${emp.nom} ${emp.prenom} (Solde: ${emp.soldeCongesJours} j)" />
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="typeConge">Type de Congé</label>
                <select id="typeConge" name="typeConge" class="form-control" required>
                    <option value="ANNUEL" ${conge != null && conge.typeConge == 'ANNUEL' ? 'selected' : ''}>ANNUEL</option>
                    <option value="MALADIE" ${conge != null && conge.typeConge == 'MALADIE' ? 'selected' : ''}>MALADIE</option>
                    <option value="MATERNITE" ${conge != null && conge.typeConge == 'MATERNITE' ? 'selected' : ''}>MATERNITE</option>
                    <option value="PATERNITE" ${conge != null && conge.typeConge == 'PATERNITE' ? 'selected' : ''}>PATERNITE</option>
                    <option value="EXCEPTIONNEL" ${conge != null && conge.typeConge == 'EXCEPTIONNEL' ? 'selected' : ''}>EXCEPTIONNEL</option>
                </select>
            </div>

            <div class="form-group">
                <label for="dateDebut">Date de Début</label>
                <input type="date" id="dateDebut" name="dateDebut" class="form-control" value="<c:out value='${conge.dateDebut}' />" required>
            </div>

            <div class="form-group">
                <label for="dateFin">Date de Fin</label>
                <input type="date" id="dateFin" name="dateFin" class="form-control" value="<c:out value='${conge.dateFin}' />" required>
            </div>

            <div class="form-group" style="grid-column: 1 / -1;">
                <label for="motif">Motif</label>
                <input type="text" id="motif" name="motif" class="form-control" value="<c:out value='${conge.motif}' />">
            </div>
        </div>

        <button type="submit" class="btn btn-success" style="margin-top: 20px;">
            <i class="fa-solid fa-save"></i> Enregistrer
        </button>
    </form>
</div>

<jsp:include page="/layout-footer.jsp" />
