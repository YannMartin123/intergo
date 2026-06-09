<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/layout-header.jsp">
    <jsp:param name="active" value="paie" />
</jsp:include>

<div class="page-title">
    <h1>
        <c:if test="${fiche != null}">Modifier Fiche de Paie</c:if>
        <c:if test="${fiche == null}">Nouvelle Fiche de Paie</c:if>
    </h1>
    <a href="${pageContext.request.contextPath}/fiches-paie" class="btn btn-primary"><i class="fa-solid fa-arrow-left"></i> Retour</a>
</div>

<div class="card-panel">
    <form action="${pageContext.request.contextPath}/fiches-paie/${fiche != null ? 'update' : 'insert'}" method="post">
        
        <c:if test="${fiche != null}">
            <input type="hidden" name="id" value="<c:out value='${fiche.id}' />" />
        </c:if>

        <div class="form-grid">
            <div class="form-group">
                <label for="employeId">Employé</label>
                <select id="employeId" name="employeId" class="form-control" required>
                    <c:forEach var="emp" items="${listEmployes}">
                        <option value="${emp.id}" ${fiche != null && fiche.employeId == emp.id ? 'selected' : ''}>
                            <c:out value="${emp.matricule} - ${emp.nom} ${emp.prenom}" />
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="mois">Mois (YYYY-MM)</label>
                <input type="month" id="mois" name="mois" class="form-control" value="<c:out value='${fiche.mois}' />" required>
            </div>

            <div class="form-group">
                <label for="salaireBase">Salaire de Base (€)</label>
                <input type="number" step="0.01" id="salaireBase" name="salaireBase" class="form-control" value="<c:out value='${fiche != null ? fiche.salaireBase : 0}' />" required>
            </div>

            <div class="form-group">
                <label for="heuresSup">Heures Supplémentaires</label>
                <input type="number" step="0.01" id="heuresSup" name="heuresSup" class="form-control" value="<c:out value='${fiche != null ? fiche.heuresSup : 0}' />" required>
            </div>

            <div class="form-group">
                <label for="montantHeuresSup">Montant Heures Sup (€)</label>
                <input type="number" step="0.01" id="montantHeuresSup" name="montantHeuresSup" class="form-control" value="<c:out value='${fiche != null ? fiche.montantHeuresSup : 0}' />" required>
            </div>

            <div class="form-group">
                <label for="primes">Primes / Bonus (€)</label>
                <input type="number" step="0.01" id="primes" name="primes" class="form-control" value="<c:out value='${fiche != null ? fiche.primes : 0}' />" required>
            </div>

            <div class="form-group">
                <label for="retenues">Retenues / Taxes (€)</label>
                <input type="number" step="0.01" id="retenues" name="retenues" class="form-control" value="<c:out value='${fiche != null ? fiche.retenues : 0}' />" required>
            </div>
        </div>

        <div class="form-group" style="margin-top: 15px; padding: 15px; background: rgba(0,0,0,0.2); border-radius: 8px;">
            <p style="color: var(--text-muted); font-size: 14px;">
                <i class="fa-solid fa-info-circle"></i> Le salaire brut et net seront calculés automatiquement : <br>
                <strong>Brut = Base + Montant Heures Sup + Primes</strong><br>
                <strong>Net = Brut - Retenues</strong>
            </p>
        </div>

        <button type="submit" class="btn btn-success" style="margin-top: 20px;">
            <i class="fa-solid fa-save"></i> Enregistrer
        </button>
    </form>
</div>

<jsp:include page="/layout-footer.jsp" />
