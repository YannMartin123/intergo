<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/layout-header.jsp">
    <jsp:param name="active" value="employe" />
</jsp:include>

<div class="page-title fade-in">
    <h1>
        <c:if test="${employe != null}">Modifier Employé</c:if>
        <c:if test="${employe == null}">Nouvel Employé</c:if>
    </h1>
    <a href="${pageContext.request.contextPath}/employes" class="btn btn-primary"><i class="fa-solid fa-arrow-left"></i> Retour</a>
</div>

<div class="card-panel fade-in-delay-1">
    <form action="${pageContext.request.contextPath}/employes/${employe != null ? 'update' : 'insert'}" method="post">
        
        <c:if test="${employe != null}">
            <input type="hidden" name="id" value="<c:out value='${employe.id}' />" />
        </c:if>

        <div class="form-grid">
            <div class="form-group">
                <label for="matricule">Matricule</label>
                <input type="text" id="matricule" name="matricule" class="form-control" value="<c:out value='${employe.matricule}' />" required>
            </div>
            
            <div class="form-group">
                <label for="nom">Nom</label>
                <input type="text" id="nom" name="nom" class="form-control" value="<c:out value='${employe.nom}' />" required>
            </div>

            <div class="form-group">
                <label for="prenom">Prénom</label>
                <input type="text" id="prenom" name="prenom" class="form-control" value="<c:out value='${employe.prenom}' />" required>
            </div>

            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" class="form-control" value="<c:out value='${employe.email}' />" required>
            </div>

            <div class="form-group">
                <label for="telephone">Téléphone</label>
                <input type="text" id="telephone" name="telephone" class="form-control" value="<c:out value='${employe.telephone}' />">
            </div>

            <div class="form-group">
                <label for="poste">Poste</label>
                <input type="text" id="poste" name="poste" class="form-control" value="<c:out value='${employe.poste}' />" required>
            </div>

            <div class="form-group">
                <label for="departementId">Département</label>
                <select id="departementId" name="departementId" class="form-control" required>
                    <c:forEach var="dept" items="${listDepartements}">
                        <option value="${dept.id}" ${employe != null && employe.departementId == dept.id ? 'selected' : ''}>
                            <c:out value="${dept.nom}" />
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="typeContrat">Type de Contrat</label>
                <select id="typeContrat" name="typeContrat" class="form-control" required>
                    <option value="CDI" ${employe != null && employe.typeContrat == 'CDI' ? 'selected' : ''}>CDI</option>
                    <option value="CDD" ${employe != null && employe.typeContrat == 'CDD' ? 'selected' : ''}>CDD</option>
                    <option value="STAGE" ${employe != null && employe.typeContrat == 'STAGE' ? 'selected' : ''}>STAGE</option>
                    <option value="CONSULTANT" ${employe != null && employe.typeContrat == 'CONSULTANT' ? 'selected' : ''}>CONSULTANT</option>
                </select>
            </div>

            <div class="form-group">
                <label for="dateEmbauche">Date d'embauche</label>
                <input type="date" id="dateEmbauche" name="dateEmbauche" class="form-control" value="<c:out value='${employe.dateEmbauche}' />" required>
            </div>

            <div class="form-group">
                <label for="salaireBase">Salaire de Base</label>
                <input type="number" step="0.01" id="salaireBase" name="salaireBase" class="form-control" value="<c:out value='${employe.salaireBase}' />" required>
            </div>

            <div class="form-group">
                <label for="soldeCongesJours">Solde Congés (Jours)</label>
                <input type="number" id="soldeCongesJours" name="soldeCongesJours" class="form-control" value="<c:out value='${employe != null ? employe.soldeCongesJours : 0}' />" required>
            </div>
        </div>

        <button type="submit" class="btn btn-success" style="margin-top: 20px;">
            <i class="fa-solid fa-save"></i> Enregistrer
        </button>
    </form>
</div>

<jsp:include page="/layout-footer.jsp" />
