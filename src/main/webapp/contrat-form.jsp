<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/layout-header.jsp">
    <jsp:param name="active" value="contrat" />
</jsp:include>

<div class="page-title">
    <h1>
        <c:if test="${contrat != null}">Modifier Contrat</c:if>
        <c:if test="${contrat == null}">Nouveau Contrat</c:if>
    </h1>
    <a href="${pageContext.request.contextPath}/contrats" class="btn btn-primary"><i class="fa-solid fa-arrow-left"></i> Retour</a>
</div>

<div class="card-panel">
    <form action="${pageContext.request.contextPath}/contrats/${contrat != null ? 'update' : 'insert'}" method="post">
        
        <c:if test="${contrat != null}">
            <input type="hidden" name="id" value="<c:out value='${contrat.id}' />" />
        </c:if>

        <div class="form-grid">
            <div class="form-group">
                <label for="employeId">Employé</label>
                <select id="employeId" name="employeId" class="form-control" required>
                    <c:forEach var="emp" items="${listEmployes}">
                        <option value="${emp.id}" ${contrat != null && contrat.employeId == emp.id ? 'selected' : ''}>
                            <c:out value="${emp.matricule} - ${emp.nom} ${emp.prenom}" />
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="typeContrat">Type de Contrat</label>
                <select id="typeContrat" name="typeContrat" class="form-control" required>
                    <option value="CDI" ${contrat != null && contrat.typeContrat == 'CDI' ? 'selected' : ''}>CDI</option>
                    <option value="CDD" ${contrat != null && contrat.typeContrat == 'CDD' ? 'selected' : ''}>CDD</option>
                    <option value="STAGE" ${contrat != null && contrat.typeContrat == 'STAGE' ? 'selected' : ''}>STAGE</option>
                    <option value="CONSULTANT" ${contrat != null && contrat.typeContrat == 'CONSULTANT' ? 'selected' : ''}>CONSULTANT</option>
                </select>
            </div>

            <div class="form-group">
                <label for="dateDebut">Date de Début</label>
                <input type="date" id="dateDebut" name="dateDebut" class="form-control" value="<c:out value='${contrat.dateDebut}' />" required>
            </div>

            <div class="form-group">
                <label for="dateFin">Date de Fin</label>
                <input type="date" id="dateFin" name="dateFin" class="form-control" value="<c:out value='${contrat.dateFin}' />">
                <small style="color:var(--text-muted);">Laisser vide si CDI</small>
            </div>

            <div class="form-group">
                <label for="salaire">Salaire (€)</label>
                <input type="number" step="0.01" id="salaire" name="salaire" class="form-control" value="<c:out value='${contrat.salaire}' />" required>
            </div>

            <div class="form-group">
                <label for="avantages">Avantages</label>
                <input type="text" id="avantages" name="avantages" class="form-control" value="<c:out value='${contrat.avantages}' />" placeholder="ex: Voiture de fonction, Tickets resto...">
            </div>
        </div>

        <button type="submit" class="btn btn-success" style="margin-top: 20px;">
            <i class="fa-solid fa-save"></i> Enregistrer
        </button>
    </form>
</div>

<jsp:include page="/layout-footer.jsp" />
