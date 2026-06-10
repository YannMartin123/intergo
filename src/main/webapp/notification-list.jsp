<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<jsp:include page="/layout-header.jsp">
    <jsp:param name="active" value="notifications" />
</jsp:include>

<style>
    /* Tab Navigation */
    .tabs-nav {
        display: flex;
        gap: 12px;
        margin-bottom: 24px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        padding-bottom: 1px;
    }
    .tab-btn {
        background: transparent;
        border: none;
        color: var(--text-muted);
        font-family: 'Outfit', sans-serif;
        font-size: 15px;
        font-weight: 600;
        padding: 12px 20px;
        cursor: pointer;
        transition: all 0.3s ease;
        position: relative;
        display: flex;
        align-items: center;
        gap: 8px;
    }
    .tab-btn:hover {
        color: var(--text-main);
    }
    .tab-btn.active {
        color: var(--primary);
    }
    .tab-btn.active::after {
        content: '';
        position: absolute;
        bottom: -1px;
        left: 0;
        right: 0;
        height: 2px;
        background: linear-gradient(90deg, var(--primary), var(--accent));
        box-shadow: 0 0 10px rgba(99, 102, 241, 0.5);
    }
    
    /* Notification Cards */
    .noti-list {
        display: flex;
        flex-direction: column;
        gap: 16px;
    }
    .noti-card {
        background: rgba(255, 255, 255, 0.02);
        border: 1px solid rgba(255, 255, 255, 0.05);
        border-radius: 12px;
        padding: 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        cursor: pointer;
        position: relative;
        overflow: hidden;
    }
    .noti-card:hover {
        background: rgba(255, 255, 255, 0.04);
        border-color: rgba(99, 102, 241, 0.2);
        transform: translateY(-2px);
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
    }
    .noti-card.unread {
        background: rgba(99, 102, 241, 0.04);
        border-color: rgba(99, 102, 241, 0.15);
    }
    .noti-card.unread::before {
        content: '';
        position: absolute;
        left: 0;
        top: 0;
        bottom: 0;
        width: 4px;
        background: var(--primary);
        box-shadow: 0 0 10px var(--primary);
    }
    .noti-left {
        display: flex;
        gap: 16px;
        align-items: center;
        flex: 1;
    }
    .noti-avatar {
        width: 44px;
        height: 44px;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.03);
        border: 1px solid rgba(255, 255, 255, 0.05);
        display: flex;
        align-items: center;
        justify-content: center;
        color: var(--primary);
        font-size: 16px;
        transition: all 0.3s ease;
    }
    .noti-card.unread .noti-avatar {
        background: rgba(99, 102, 241, 0.1);
        border-color: rgba(99, 102, 241, 0.3);
        color: var(--accent);
        box-shadow: 0 0 10px rgba(6, 182, 212, 0.2);
    }
    .noti-content {
        flex: 1;
    }
    .noti-meta {
        display: flex;
        gap: 12px;
        align-items: center;
        font-size: 12px;
        color: var(--text-muted);
        margin-bottom: 4px;
    }
    .noti-title {
        font-size: 15px;
        font-weight: 700;
        color: var(--text-main);
        margin-bottom: 4px;
    }
    .noti-snippet {
        font-size: 13px;
        color: var(--text-secondary);
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        max-width: 600px;
    }
    .noti-right {
        display: flex;
        align-items: center;
        gap: 16px;
    }
    .noti-date {
        font-size: 11px;
        color: var(--text-muted);
        text-align: right;
    }
    
    /* Glowing Badges */
    .glow-badge {
        background: linear-gradient(135deg, var(--primary), var(--accent));
        color: #ffffff;
        font-size: 11px;
        font-weight: 800;
        padding: 2px 8px;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(99, 102, 241, 0.4);
    }
    .status-dot {
        width: 8px;
        height: 8px;
        border-radius: 50%;
        background: var(--text-muted);
    }
    .unread .status-dot {
        background: var(--accent);
        box-shadow: 0 0 8px var(--accent);
        animation: pulse-dot 1.5s infinite;
    }
    
    /* Empty State */
    .empty-state {
        text-align: center;
        padding: 60px 20px;
        background: rgba(255, 255, 255, 0.01);
        border: 1px dashed rgba(255, 255, 255, 0.05);
        border-radius: 16px;
    }
    .empty-icon {
        font-size: 48px;
        color: var(--text-muted);
        margin-bottom: 16px;
        opacity: 0.5;
    }
    
    /* Modal Backdrop */
    .modal-backdrop {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0, 0, 0, 0.6);
        backdrop-filter: blur(8px);
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 1000;
        opacity: 0;
        pointer-events: none;
        transition: opacity 0.3s ease;
    }
    .modal-backdrop.open {
        opacity: 1;
        pointer-events: auto;
    }
    .modal-dialog {
        background: rgba(18, 24, 38, 0.95);
        border: 1px solid rgba(255, 255, 255, 0.08);
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5), 0 0 20px rgba(99, 102, 241, 0.1);
        border-radius: 16px;
        width: 100%;
        max-width: 600px;
        padding: 32px;
        transform: translateY(20px);
        transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
    }
    .modal-backdrop.open .modal-dialog {
        transform: translateY(0);
    }
    .modal-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 24px;
    }
    .modal-header h2 {
        font-size: 20px;
        font-weight: 700;
        margin: 0;
    }
    .modal-close-btn {
        background: rgba(255, 255, 255, 0.03);
        border: 1px solid rgba(255, 255, 255, 0.05);
        width: 32px;
        height: 32px;
        border-radius: 50%;
        color: var(--text-main);
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        transition: all 0.2s ease;
    }
    .modal-close-btn:hover {
        background: rgba(239, 68, 68, 0.1);
        border-color: rgba(239, 68, 68, 0.2);
        color: var(--danger);
    }
    
    @keyframes pulse-dot {
        0% { transform: scale(1); opacity: 1; }
        50% { transform: scale(1.3); opacity: 0.6; }
        100% { transform: scale(1); opacity: 1; }
    }
</style>

<div class="page-title fade-in">
    <div>
        <h1 class="text-gradient">Centre de Notifications</h1>
        <p style="color:var(--text-secondary); font-size:14px; margin-top:4px;">Envoyez des messages internes et gérez vos alertes d'entreprise.</p>
    </div>
    <div class="actions">
        <button onclick="openComposeModal()" class="btn btn-primary"><i class="fa-solid fa-paper-plane"></i> Nouveau Message</button>
    </div>
</div>

<!-- Tabs selector -->
<div class="tabs-nav fade-in-delay-1">
    <button class="tab-btn active" onclick="switchTab('inbox')">
        <i class="fa-solid fa-inbox"></i> Boîte de réception
        <c:if test="${unreadCount > 0}">
            <span class="glow-badge" id="inbox-count">${unreadCount}</span>
        </c:if>
    </button>
    <button class="tab-btn" onclick="switchTab('sentbox')">
        <i class="fa-solid fa-paper-plane"></i> Messages envoyés
    </button>
</div>

<!-- Tab: Inbox Container -->
<div id="tab-inbox" class="tab-content fade-in-delay-2">
    <div class="noti-list">
        <c:choose>
            <c:when test="${empty listReceived}">
                <div class="empty-state">
                    <div class="empty-icon"><i class="fa-solid fa-envelope-open"></i></div>
                    <h3 style="color:var(--text-main); font-weight:600; margin-bottom:8px;">Boîte de réception vide</h3>
                    <p style="color:var(--text-muted); font-size:14px;">Vous n'avez reçu aucune notification pour le moment.</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="n" items="${listReceived}">
                    <div class="noti-card ${n.lu ? '' : 'unread'}" id="noti-${n.id}" 
                         onclick="openDetailModal(${n.id}, '${fn:escapeXml(n.expediteur)}', '${fn:escapeXml(n.destinataire)}', '${fn:escapeXml(n.sujet)}', '${fn:escapeXml(n.message)}', '${n.dateEnvoi}', ${n.lu})">
                        <div class="noti-left">
                            <div class="noti-avatar">
                                <i class="fa-solid fa-envelope"></i>
                            </div>
                            <div class="noti-content">
                                <div class="noti-meta">
                                    <span>De : <strong style="color:var(--text-main);"><c:out value="${n.expediteur}" /></strong></span>
                                    <span style="opacity:0.3;">|</span>
                                    <div class="status-dot"></div>
                                </div>
                                <div class="noti-title"><c:out value="${n.sujet}" /></div>
                                <div class="noti-snippet"><c:out value="${n.message}" /></div>
                            </div>
                        </div>
                        <div class="noti-right">
                            <div class="noti-date">${n.dateEnvoi.toLocalDate()}</div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Tab: Sentbox Container -->
<div id="tab-sentbox" class="tab-content fade-in-delay-2" style="display:none;">
    <div class="noti-list">
        <c:choose>
            <c:when test="${empty listSent}">
                <div class="empty-state">
                    <div class="empty-icon"><i class="fa-solid fa-paper-plane"></i></div>
                    <h3 style="color:var(--text-main); font-weight:600; margin-bottom:8px;">Aucun message envoyé</h3>
                    <p style="color:var(--text-muted); font-size:14px;">Vous n'avez envoyé aucune notification pour le moment.</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="n" items="${listSent}">
                    <div class="noti-card" 
                         onclick="openDetailModal(${n.id}, '${fn:escapeXml(n.expediteur)}', '${fn:escapeXml(n.destinataire)}', '${fn:escapeXml(n.sujet)}', '${fn:escapeXml(n.message)}', '${n.dateEnvoi}', true)">
                        <div class="noti-left">
                            <div class="noti-avatar" style="color:var(--accent);">
                                <i class="fa-solid fa-paper-plane"></i>
                            </div>
                            <div class="noti-content">
                                <div class="noti-meta">
                                    <span>À : <strong style="color:var(--text-main);"><c:out value="${n.destinataire}" /></strong></span>
                                </div>
                                <div class="noti-title"><c:out value="${n.sujet}" /></div>
                                <div class="noti-snippet"><c:out value="${n.message}" /></div>
                            </div>
                        </div>
                        <div class="noti-right">
                            <div class="noti-date">${n.dateEnvoi.toLocalDate()}</div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- ══ COMPOSE MODAL ══ -->
<div class="modal-backdrop" id="compose-modal">
    <div class="modal-dialog">
        <div class="modal-header">
            <h2>Nouveau Message Interne</h2>
            <button onclick="closeComposeModal()" class="modal-close-btn"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <form action="${pageContext.request.contextPath}/notifications/insert" method="post">
            <div class="form-group" style="margin-bottom: 16px;">
                <label for="destinataire">Destinataire (Collaborateur)</label>
                <select id="destinataire" name="destinataire" class="form-control" required style="width:100%;">
                    <option value="" disabled selected>Choisir un destinataire...</option>
                    <c:forEach var="emp" items="${listEmployes}">
                        <c:if test="${emp.email != sessionScope.utilisateurConnecte.email}">
                            <option value="${emp.email}">
                                <c:out value="${emp.nom} ${emp.prenom} (${emp.email})" />
                            </option>
                        </c:if>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group" style="margin-bottom: 16px;">
                <label for="sujet">Sujet du Message</label>
                <input type="text" id="sujet" name="sujet" class="form-control" required placeholder="ex: Validation de congés / Fiche de paie">
            </div>
            <div class="form-group" style="margin-bottom: 24px;">
                <label for="message">Message</label>
                <textarea id="message" name="message" class="form-control" rows="6" required placeholder="Saisissez votre message ici..."></textarea>
            </div>
            <div style="display:flex; justify-content:flex-end; gap:12px;">
                <button type="button" onclick="closeComposeModal()" class="btn btn-outline">Annuler</button>
                <button type="submit" class="btn btn-success"><i class="fa-solid fa-paper-plane"></i> Envoyer</button>
            </div>
        </form>
    </div>
</div>

<!-- ══ DETAIL MODAL ══ -->
<div class="modal-backdrop" id="detail-modal">
    <div class="modal-dialog">
        <div class="modal-header">
            <h2 id="det-sujet">Sujet de la notification</h2>
            <button onclick="closeDetailModal()" class="modal-close-btn"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <div style="margin-bottom: 20px; padding: 12px; background: rgba(255,255,255,0.02); border-radius: 8px; border: 1px solid rgba(255,255,255,0.04);">
            <div style="font-size:13px; color:var(--text-secondary); display:flex; justify-content:space-between;">
                <div>De : <strong id="det-expediteur" style="color:var(--text-main);">sender@email.com</strong></div>
                <div id="det-date" style="color:var(--text-muted);">Date</div>
            </div>
            <div style="font-size:13px; color:var(--text-secondary); margin-top:4px;">À : <span id="det-destinataire">receiver@email.com</span></div>
        </div>
        <div style="margin-bottom: 24px; min-height: 150px; background: rgba(0,0,0,0.15); padding: 16px; border-radius: 8px; font-size: 14px; line-height: 1.6; color: var(--text-main); white-space: pre-wrap;" id="det-message">
            Message complet...
        </div>
        <div style="display:flex; justify-content:flex-end;">
            <button onclick="closeDetailModal()" class="btn btn-primary">Fermer</button>
        </div>
    </div>
</div>

<script>
    // Tab switching
    function switchTab(tabId) {
        document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
        document.querySelectorAll('.tab-content').forEach(c => c.style.display = 'none');
        
        if (tabId === 'inbox') {
            document.querySelector('.tab-btn:nth-child(1)').classList.add('active');
            document.getElementById('tab-inbox').style.display = 'block';
        } else {
            document.querySelector('.tab-btn:nth-child(2)').classList.add('active');
            document.getElementById('tab-sentbox').style.display = 'block';
        }
    }
    
    // Compose Modal functions
    function openComposeModal() {
        const modal = document.getElementById('compose-modal');
        modal.classList.add('open');
    }
    function closeComposeModal() {
        const modal = document.getElementById('compose-modal');
        modal.classList.remove('open');
    }
    
    // Detail Modal functions
    function openDetailModal(id, exp, dest, sujet, msg, date, isLu) {
        document.getElementById('det-sujet').innerText = sujet;
        document.getElementById('det-expediteur').innerText = exp;
        document.getElementById('det-destinataire').innerText = dest;
        document.getElementById('det-date').innerText = date.replace('T', ' ').substring(0, 16);
        document.getElementById('det-message').innerText = msg;
        
        const modal = document.getElementById('detail-modal');
        modal.classList.add('open');
        
        // If the message is unread, hit the servlet to mark as read
        if (!isLu) {
            markNotificationAsRead(id);
        }
    }
    
    function closeDetailModal() {
        const modal = document.getElementById('detail-modal');
        modal.classList.remove('open');
    }
    
    function markNotificationAsRead(id) {
        const url = '${pageContext.request.contextPath}/notifications/read';
        const params = new URLSearchParams();
        params.append('id', id);
        
        fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: params
        })
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                const card = document.getElementById('noti-' + id);
                if (card && card.classList.contains('unread')) {
                    card.classList.remove('unread');
                    
                    // Update unread count badge in UI
                    const badge = document.getElementById('inbox-count');
                    if (badge) {
                        let count = parseInt(badge.innerText);
                        count--;
                        if (count <= 0) {
                            badge.remove();
                        } else {
                            badge.innerText = count;
                        }
                    }
                }
            }
        })
        .catch(err => console.error('Error marking message as read:', err));
    }
</script>

<jsp:include page="/layout-footer.jsp" />
