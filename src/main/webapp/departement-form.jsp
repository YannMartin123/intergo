<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/layout-header.jsp">
    <jsp:param name="active" value="departement" />
</jsp:include>

<div class="page-title fade-in">
    <h1>
        <c:if test="${departement != null}">
            Modifier Département
        </c:if>
        <c:if test="${departement == null}">
            Nouveau Département
        </c:if>
    </h1>
    <a href="${pageContext.request.contextPath}/departements" class="btn btn-primary"><i class="fa-solid fa-arrow-left"></i> Retour</a>
</div>

<div class="card-panel fade-in-delay-1">
    <form action="${pageContext.request.contextPath}/departements/${departement != null ? 'update' : 'insert'}" method="post">
        
        <c:if test="${departement != null}">
            <input type="hidden" name="id" value="<c:out value='${departement.id}' />" />
        </c:if>

        <div class="form-grid">
            <div class="form-group">
                <label for="nom">Nom du Département</label>
                <input type="text" id="nom" name="nom" class="form-control" value="<c:out value='${departement.nom}' />" required>
            </div>
            
            <div class="form-group">
                <label for="responsable">Responsable</label>
                <input type="text" id="responsable" name="responsable" class="form-control" value="<c:out value='${departement.responsable}' />">
            </div>

            <div class="form-group">
                <label for="budgetMasseSalariale">Budget Masse Salariale (FCFA)</label>
                <input type="number" step="0.01" id="budgetMasseSalariale" name="budgetMasseSalariale" class="form-control" value="<c:out value='${departement.budgetMasseSalariale}' />" required>
            </div>
        </div>

        <button type="submit" class="btn btn-success" style="margin-top: 20px;">
            <i class="fa-solid fa-save"></i> Enregistrer
        </button>
    </form>
</div>

<jsp:include page="/layout-footer.jsp" />
