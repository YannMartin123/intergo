<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<jsp:include page="/layout-header.jsp">
    <jsp:param name="active" value="chat" />
</jsp:include>

<style>
    .chat-container {
        display: grid;
        grid-template-columns: 340px 1fr;
        height: calc(100vh - 140px);
        background: rgba(18, 24, 38, 0.6);
        backdrop-filter: blur(12px);
        border: 1px solid rgba(255, 255, 255, 0.05);
        border-radius: 16px;
        overflow: hidden;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
        position: relative;
    }

    /* Left Sidebar: Contacts */
    .chat-sidebar {
        border-right: 1px solid rgba(255, 255, 255, 0.05);
        display: flex;
        flex-direction: column;
        background: rgba(10, 15, 26, 0.4);
    }
    .sidebar-search {
        padding: 16px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.02);
    }
    .search-input {
        width: 100%;
        background: rgba(255, 255, 255, 0.03);
        border: 1px solid rgba(255, 255, 255, 0.08);
        border-radius: 8px;
        padding: 10px 14px;
        color: white;
        font-family: 'Inter', sans-serif;
        font-size: 13px;
        outline: none;
        transition: all 0.3s ease;
    }
    .search-input:focus {
        border-color: var(--primary);
        box-shadow: 0 0 10px rgba(99, 102, 241, 0.2);
    }

    /* Filters (WhatsApp Style) */
    .sidebar-filters {
        display: flex;
        gap: 8px;
        padding: 0 16px 12px 16px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.05);
    }
    .filter-btn {
        background: rgba(255, 255, 255, 0.03);
        border: 1px solid rgba(255, 255, 255, 0.08);
        border-radius: 20px;
        padding: 6px 14px;
        color: var(--text-secondary);
        font-size: 12px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.2s ease;
        outline: none;
    }
    .filter-btn:hover {
        background: rgba(255, 255, 255, 0.08);
        color: white;
        border-color: rgba(255, 255, 255, 0.15);
    }
    .filter-btn.active {
        background: rgba(99, 102, 241, 0.2);
        border-color: var(--primary);
        color: white;
        box-shadow: 0 0 10px rgba(99, 102, 241, 0.3);
    }

    .contacts-list {
        flex: 1;
        overflow-y: auto;
        padding: 12px;
        display: flex;
        flex-direction: column;
        gap: 6px;
    }
    .contact-item {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 12px;
        border-radius: 10px;
        cursor: pointer;
        transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
        position: relative;
    }
    .contact-item:hover {
        background: rgba(255, 255, 255, 0.03);
    }
    .contact-item.active {
        background: rgba(99, 102, 241, 0.12);
        border: 1px solid rgba(99, 102, 241, 0.2);
    }
    .contact-avatar {
        width: 42px;
        height: 42px;
        border-radius: 50%;
        background: rgba(99, 102, 241, 0.15);
        border: 1px solid rgba(99, 102, 241, 0.3);
        display: flex;
        align-items: center;
        justify-content: center;
        color: var(--primary);
        font-weight: 700;
        font-size: 14px;
        position: relative;
        flex-shrink: 0;
    }
    .status-dot {
        width: 10px;
        height: 10px;
        border-radius: 50%;
        background: #64748b;
        position: absolute;
        bottom: 0;
        right: 0;
        border: 2px solid #0d131f;
        transition: background 0.3s ease;
    }
    .status-dot.online {
        background: #10b981;
        box-shadow: 0 0 8px #10b981;
    }
    .contact-info {
        flex: 1;
        min-width: 0;
    }
    .contact-name {
        font-weight: 700;
        font-size: 14px;
        color: var(--text-main);
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .contact-email {
        font-size: 11px;
        color: var(--text-muted);
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        margin-top: 2px;
    }
    .unread-badge {
        background: var(--danger);
        color: white;
        font-size: 10px;
        font-weight: 800;
        padding: 2px 6px;
        border-radius: 10px;
        box-shadow: 0 0 8px rgba(239, 68, 68, 0.5);
    }

    /* Right Panel: Chat Area */
    .chat-main {
        display: flex;
        flex-direction: column;
        background: rgba(13, 19, 31, 0.2);
        position: relative;
    }
    .chat-header {
        padding: 16px 24px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: rgba(18, 24, 38, 0.4);
        z-index: 10;
    }
    .chat-header-info {
        display: flex;
        align-items: center;
        gap: 12px;
    }

    /* Guidelines / Rules Panel */
    .rules-banner {
        background: rgba(245, 158, 11, 0.08);
        border: 1px dashed rgba(245, 158, 11, 0.25);
        border-radius: 8px;
        padding: 10px 16px;
        margin: 16px 24px 0 24px;
        display: flex;
        align-items: center;
        gap: 12px;
        font-size: 12.5px;
        color: #fbd38d;
        z-index: 5;
    }
    .rules-banner i {
        font-size: 18px;
        color: var(--warning);
    }

    /* Messages Board (WhatsApp Wallpaper Style) */
    .chat-messages {
        flex: 1;
        overflow-y: auto;
        padding: 24px;
        display: flex;
        flex-direction: column;
        gap: 16px;
        background-color: rgba(11, 20, 26, 0.45);
        background-image: radial-gradient(rgba(99, 102, 241, 0.04) 1px, transparent 0);
        background-size: 24px 24px;
    }
    .msg-group {
        display: flex;
        flex-direction: column;
        max-width: 65%;
    }
    .msg-group.outgoing {
        align-self: flex-end;
        align-items: flex-end;
    }
    .msg-group.incoming {
        align-self: flex-start;
        align-items: flex-start;
    }
    .msg-bubble {
        padding: 10px 14px;
        border-radius: 12px;
        font-size: 13.5px;
        line-height: 1.5;
        white-space: pre-wrap;
        word-break: break-word;
        position: relative;
    }
    .outgoing .msg-bubble {
        background: rgba(5, 97, 98, 0.45);
        border: 1px solid rgba(5, 97, 98, 0.6);
        color: #e9edef;
        border-bottom-right-radius: 4px;
        box-shadow: 0 4px 15px rgba(5, 97, 98, 0.15);
    }
    .incoming .msg-bubble {
        background: rgba(32, 44, 51, 0.45);
        border: 1px solid rgba(32, 44, 51, 0.6);
        color: #e9edef;
        border-bottom-left-radius: 4px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
    }
    .msg-meta-row {
        display: flex;
        align-items: center;
        justify-content: flex-end;
        gap: 4px;
        font-size: 10px;
        color: rgba(255, 255, 255, 0.4);
        margin-top: 4px;
    }

    /* Attachments rendering */
    .msg-attachment {
        margin-top: 8px;
        background: rgba(0, 0, 0, 0.2);
        border: 1px solid rgba(255, 255, 255, 0.06);
        border-radius: 8px;
        padding: 8px 12px;
        display: flex;
        align-items: center;
        gap: 10px;
        text-decoration: none;
        color: var(--text-main);
        transition: background 0.2s ease;
    }
    .msg-attachment:hover {
        background: rgba(255, 255, 255, 0.04);
        border-color: var(--primary);
    }
    .msg-attachment i {
        font-size: 20px;
        color: var(--accent);
    }
    .attachment-img {
        max-width: 260px;
        max-height: 180px;
        border-radius: 6px;
        margin-top: 8px;
        border: 1px solid rgba(255, 255, 255, 0.1);
        cursor: pointer;
        transition: transform 0.2s ease;
        display: block;
    }
    .attachment-img:hover {
        transform: scale(1.02);
    }

    /* Bottom Input Bar */
    .chat-input-area {
        padding: 16px 24px;
        background: rgba(18, 24, 38, 0.4);
        border-top: 1px solid rgba(255, 255, 255, 0.05);
        display: flex;
        flex-direction: column;
        gap: 10px;
        position: relative;
    }
    .attachment-preview-panel {
        display: flex;
        align-items: center;
        gap: 10px;
        background: rgba(99, 102, 241, 0.08);
        border: 1px solid rgba(99, 102, 241, 0.2);
        padding: 8px 12px;
        border-radius: 8px;
    }
    .attachment-preview-panel span {
        font-size: 12px;
        color: var(--text-main);
        flex: 1;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .remove-attachment-btn {
        background: transparent;
        border: none;
        color: var(--danger);
        cursor: pointer;
        outline: none;
    }
    .input-row {
        display: flex;
        gap: 12px;
        align-items: center;
    }
    .chat-input {
        flex: 1;
        background: rgba(255, 255, 255, 0.02);
        border: 1px solid rgba(255, 255, 255, 0.06);
        border-radius: 10px;
        padding: 12px 16px;
        color: white;
        font-family: 'Inter', sans-serif;
        font-size: 13.5px;
        outline: none;
        transition: border-color 0.3s ease;
    }
    .chat-input:focus {
        border-color: var(--primary);
    }
    .action-btn {
        background: rgba(255, 255, 255, 0.03);
        border: 1px solid rgba(255, 255, 255, 0.06);
        color: var(--text-secondary);
        width: 44px;
        height: 44px;
        border-radius: 10px;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.2s ease;
        outline: none;
    }
    .action-btn:hover {
        background: rgba(255, 255, 255, 0.06);
        color: white;
        border-color: rgba(255, 255, 255, 0.15);
    }
    .send-btn {
        background: var(--primary);
        border: none;
        color: white;
        width: 44px;
        height: 44px;
        border-radius: 10px;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.25s ease;
        outline: none;
    }
    .send-btn:hover {
        background: var(--secondary);
        transform: scale(1.03);
        box-shadow: 0 0 12px rgba(99, 102, 241, 0.4);
    }

    /* Emoji Picker style */
    .emoji-picker {
        position: absolute;
        bottom: 74px;
        left: 24px;
        background: rgba(18, 24, 38, 0.95);
        border: 1px solid rgba(255, 255, 255, 0.08);
        border-radius: 12px;
        padding: 12px;
        display: grid;
        grid-template-columns: repeat(6, 1fr);
        gap: 8px;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.5);
        z-index: 1000;
        backdrop-filter: blur(12px);
        width: 240px;
    }
    .emoji-picker span {
        font-size: 20px;
        cursor: pointer;
        transition: transform 0.15s ease;
        text-align: center;
        user-select: none;
    }
    .emoji-picker span:hover {
        transform: scale(1.25);
    }

    /* Voice Recording style overlay */
    .recording-overlay {
        display: flex;
        align-items: center;
        gap: 12px;
        flex: 1;
        background: rgba(239, 68, 68, 0.08);
        border: 1px solid rgba(239, 68, 68, 0.25);
        border-radius: 10px;
        padding: 0 16px;
        height: 44px;
        color: #ef4444;
    }
    
    @keyframes pulse {
        0%, 100% { opacity: 1; }
        50% { opacity: 0.4; }
    }
    .rec-blink {
        width: 10px;
        height: 10px;
        background-color: #ef4444;
        border-radius: 50%;
        animation: pulse 1s infinite;
    }

    /* Empty state */
    .chat-empty-state {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 100%;
        color: var(--text-muted);
        text-align: center;
        padding: 40px;
        background-color: rgba(11, 20, 26, 0.15);
    }
    .chat-empty-state i {
        font-size: 60px;
        margin-bottom: 20px;
        opacity: 0.2;
    }

    /* Toast style */
    .toast-alert {
        position: fixed;
        bottom: 24px;
        right: 24px;
        background: rgba(18, 24, 38, 0.95);
        border: 1px solid rgba(99, 102, 241, 0.3);
        border-radius: 8px;
        padding: 16px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.4);
        display: flex;
        align-items: center;
        gap: 12px;
        transform: translateY(100px);
        opacity: 0;
        transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        z-index: 9999;
    }
    .toast-alert.show {
        transform: translateY(0);
        opacity: 1;
    }
</style>

<div class="page-title fade-in">
    <div>
        <h1 class="text-gradient">Messagerie Interne</h1>
        <p style="color:var(--text-secondary); font-size:14px; margin-top:4px;">Discutez en temps réel avec vos collègues et partagez vos documents professionnels.</p>
    </div>
</div>

<div class="chat-container fade-in-delay-1">
    <!-- Contacts Sidebar -->
    <div class="chat-sidebar">
        <div class="sidebar-search">
            <input type="text" id="contact-search" class="search-input" placeholder="Rechercher un collègue..." onkeyup="filterContacts()">
        </div>
        
        <!-- Filters (WhatsApp Style) -->
        <div class="sidebar-filters">
            <button class="filter-btn active" onclick="setFilter('all')">Tous</button>
            <button class="filter-btn" onclick="setFilter('online')">En ligne</button>
            <button class="filter-btn" onclick="setFilter('unread')">Non lus</button>
        </div>

        <div class="contacts-list" id="contacts-container">
            <c:forEach var="contact" items="${listContacts}">
                <c:if test="${contact.email != sessionScope.utilisateurConnecte.email}">
                    <div class="contact-item" id="contact-${fn:replace(contact.email, '@', '_at_')}" onclick="selectContact('${contact.email}', '${fn:escapeXml(contact.prenom)} ${fn:escapeXml(contact.nom)}')">
                        <div class="contact-avatar">
                            ${fn:substring(contact.prenom, 0, 1)}${fn:substring(contact.nom, 0, 1)}
                            <div class="status-dot" id="status-${fn:replace(contact.email, '@', '_at_')}"></div>
                        </div>
                        <div class="contact-info">
                            <div class="contact-name"><c:out value="${contact.prenom} ${contact.nom}" /></div>
                            <div class="contact-email"><c:out value="${contact.email}" /></div>
                        </div>
                        <div class="unread-badge" id="badge-${fn:replace(contact.email, '@', '_at_')}" 
                             style="${contact.unreadCount > 0 ? '' : 'display:none;'}">${contact.unreadCount}</div>
                    </div>
                </c:if>
            </c:forEach>
        </div>
    </div>

    <!-- Active Chat Panel -->
    <div class="chat-main" id="chat-panel">
        <!-- Empty State (No Chat Selected) -->
        <div class="chat-empty-state" id="empty-state">
            <i class="fa-solid fa-comments"></i>
            <h3 style="color:var(--text-main); font-weight:600; margin-bottom:8px;">Vos conversations</h3>
            <p style="font-size:13px; max-width:320px;">Sélectionnez un collaborateur dans la barre latérale pour démarrer une discussion sécurisée.</p>
        </div>

        <!-- Chat Panel (Hidden by default) -->
        <div id="active-chat-container" style="display:none; flex-direction:column; height:100%;">
            <!-- Header -->
            <div class="chat-header">
                <div class="chat-header-info">
                    <div class="contact-avatar" id="active-avatar" style="width:36px; height:36px; font-size:12px;">X</div>
                    <div>
                        <div class="contact-name" id="active-name">Collaborateur</div>
                        <div class="contact-email" id="active-email">email@entreprise.com</div>
                        <!-- Typing Indicator -->
                        <div class="typing-indicator" id="active-typing" style="display:none; color:#10b981; font-size:11.5px; font-weight:600; margin-top:2px;">
                            <i class="fa-solid fa-circle-notch fa-spin" style="margin-right:4px;"></i> en train d'écrire...
                        </div>
                    </div>
                </div>
            </div>

            <!-- Guidelines Banner -->
            <div class="rules-banner">
                <i class="fa-solid fa-circle-info"></i>
                <div>
                    <strong>Charte de communication :</strong> Les échanges doivent rester strictement professionnels. 
                    Formats autorisés : PDF, PNG, JPG, JPEG, DOCX, XLSX, PPTX, TXT et Audio (WEBM, WAV, MP3). Max 5 Mo.
                </div>
            </div>

            <!-- Messages Board -->
            <div class="chat-messages" id="messages-container">
                <!-- Loaded dynamically -->
            </div>

            <!-- Attachment Preview Area -->
            <div class="chat-input-area">
                <!-- Emoji Picker Panel -->
                <div id="emoji-picker" class="emoji-picker" style="display: none;">
                    <span onclick="insertEmoji('😊')">😊</span>
                    <span onclick="insertEmoji('👍')">👍</span>
                    <span onclick="insertEmoji('🤝')">🤝</span>
                    <span onclick="insertEmoji('👏')">👏</span>
                    <span onclick="insertEmoji('🚀')">🚀</span>
                    <span onclick="insertEmoji('💡')">💡</span>
                    <span onclick="insertEmoji('✅')">✅</span>
                    <span onclick="insertEmoji('❌')">❌</span>
                    <span onclick="insertEmoji('📝')">📝</span>
                    <span onclick="insertEmoji('📁')">📁</span>
                    <span onclick="insertEmoji('💬')">💬</span>
                    <span onclick="insertEmoji('🔥')">🔥</span>
                    <span onclick="insertEmoji('⭐')">⭐</span>
                    <span onclick="insertEmoji('👋')">👋</span>
                    <span onclick="insertEmoji('🎉')">🎉</span>
                    <span onclick="insertEmoji('⚠️')">⚠️</span>
                    <span onclick="insertEmoji('📞')">📞</span>
                    <span onclick="insertEmoji('📌')">📌</span>
                </div>

                <div class="attachment-preview-panel" id="attachment-preview" style="display:none;">
                    <i class="fa-solid fa-file-arrow-up" style="color:var(--accent); font-size:16px;"></i>
                    <span id="attachment-name">Fichier.pdf</span>
                    <button class="remove-attachment-btn" onclick="clearAttachment()"><i class="fa-solid fa-circle-xmark"></i></button>
                </div>

                <!-- Input area -->
                <div class="input-row">
                    <!-- File Trigger Button -->
                    <button class="action-btn" id="paperclip-btn" onclick="triggerFileInput()" title="Ajouter un fichier de travail"><i class="fa-solid fa-paperclip"></i></button>
                    <input type="file" id="chat-file-input" style="display:none;" onchange="handleFileUpload(event)">

                    <!-- Emoji Trigger Button -->
                    <button class="action-btn" id="emoji-btn" onclick="toggleEmojiPicker()" title="Ajouter un émoji"><i class="fa-regular fa-face-smile"></i></button>

                    <!-- Recording overlay when active -->
                    <div id="recording-overlay" class="recording-overlay" style="display:none;">
                        <div class="rec-blink"></div>
                        <span style="font-size:13px; font-weight:600; flex:1;">Vocal... <span id="record-timer">00:00</span></span>
                        <button class="remove-attachment-btn" onclick="cancelRecording()" style="color:#ef4444; font-size:16px; padding: 0 8px;" title="Annuler"><i class="fa-solid fa-trash-can"></i></button>
                    </div>

                    <!-- Text Input -->
                    <input type="text" id="chat-message-input" class="chat-input" placeholder="Saisissez votre message professionnel..." oninput="handleMessageInput()" onkeydown="handleKeyPress(event)">

                    <!-- Audio Record Button -->
                    <button class="action-btn" id="record-btn" onclick="toggleAudioRecording()" title="Enregistrer un message vocal"><i class="fa-solid fa-microphone"></i></button>

                    <!-- Send Button -->
                    <button class="send-btn" onclick="sendMessage()"><i class="fa-solid fa-paper-plane"></i></button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Floating Notification Alert -->
<div class="toast-alert" id="chat-toast">
    <i class="fa-solid fa-bell" style="color:var(--accent); font-size:20px;"></i>
    <div>
        <div style="font-weight:700; color:white; font-size:13px;" id="toast-title">Nouveau message</div>
        <div style="color:var(--text-secondary); font-size:12px;" id="toast-body">Contenu du message...</div>
    </div>
</div>

<!-- Audio for notification -->
<audio id="notif-sound" src="https://assets.mixkit.co/active_storage/sfx/2869/2869-84.wav" preload="auto"></audio>

<script>
    const currentUserEmail = "${sessionScope.utilisateurConnecte.email}";
    const contextPath = "${pageContext.request.contextPath}";
    let activeContactEmail = null;
    let socket = null;
    let currentAttachment = null; // { url, fileName, fileType }
    let currentFilter = 'all';

    // Typing State Debounce variables
    let typingTimeout = null;
    let isCurrentlyTyping = false;

    // MediaRecorder variables
    let mediaRecorder = null;
    let audioChunks = [];
    let recordInterval = null;
    let recordSeconds = 0;
    let isRecording = false;

    // Initialize WebSockets
    function initWebSocket() {
        const protocol = window.location.protocol === 'https:' ? 'wss://' : 'ws://';
        const wsUrl = protocol + window.location.host + contextPath + '/chatws?email=' + encodeURIComponent(currentUserEmail);

        console.log("[Chat] Connecting to WebSocket: " + wsUrl);
        socket = new WebSocket(wsUrl);

        socket.onopen = function() {
            console.log("[Chat] WebSocket connection open.");
        };

        socket.onmessage = function(event) {
            const data = JSON.parse(event.data);

            if (data.type === "STATUS_UPDATE") {
                updateOnlineStatus(data.onlineUsers);
            } else if (data.type === "TYPING") {
                handleTypingEvent(data);
            } else if (data.type === "READ_RECEIPT") {
                handleReadReceipt(data);
            } else {
                // CHAT Message
                handleIncomingMessage(data);
            }
        };

        socket.onclose = function() {
            console.log("[Chat] WebSocket connection closed. Reconnecting in 5 seconds...");
            setTimeout(initWebSocket, 5000);
        };

        socket.onerror = function(err) {
            console.error("[Chat] WebSocket error: ", err);
        };
    }

    // Update the visual status dots for online users
    function updateOnlineStatus(onlineUsers) {
        // Reset all statuses to offline
        document.querySelectorAll('.status-dot').forEach(dot => {
            dot.classList.remove('online');
        });

        // Set online status for active users
        onlineUsers.forEach(email => {
            if (email !== currentUserEmail) {
                const elementId = 'status-' + email.replace(/@/g, '_at_');
                const dot = document.getElementById(elementId);
                if (dot) {
                    dot.classList.add('online');
                }
            }
        });
        applyFilters();
    }

    // Handle typing events in real-time
    function handleTypingEvent(data) {
        if (data.senderEmail === activeContactEmail) {
            const typingDiv = document.getElementById('active-typing');
            if (typingDiv) {
                typingDiv.style.display = data.typing ? 'block' : 'none';
            }
        }
    }

    // Handle read receipts to turn ticks blue
    function handleReadReceipt(data) {
        if (data.receiverEmail === activeContactEmail) {
            // Turn ticks blue for all outgoing messages in currently open chat
            document.querySelectorAll('.msg-group.outgoing .fa-check-double').forEach(icon => {
                icon.style.color = '#53bdeb';
            });
        }
    }

    // Handle receiving a message
    function handleIncomingMessage(msg) {
        const isFromActiveContact = (msg.senderEmail === activeContactEmail);
        const isFromSelf = (msg.senderEmail === currentUserEmail);

        if (isFromActiveContact || isFromSelf) {
            appendMessage(msg);
            scrollChatToBottom();

            // If we received an unread message from the active contact, send read receipt immediately
            if (isFromActiveContact) {
                sendReadReceipt(msg.senderEmail);
            }
        } else {
            // Update sidebar unread badge
            incrementUnreadBadge(msg.senderEmail);
            playNotifSound();
            showToast("Nouveau message de " + msg.senderEmail, msg.message);
        }
    }

    // Send read receipt
    function sendReadReceipt(senderEmail) {
        if (socket && socket.readyState === WebSocket.OPEN) {
            socket.send(JSON.stringify({
                type: "READ_RECEIPT",
                senderEmail: senderEmail
            }));
        }
    }

    // Robust Date parsing helper
    function parseDate(ts) {
        if (!ts) return new Date();
        if (typeof ts === 'string') {
            return new Date(ts);
        }
        if (Array.isArray(ts)) {
            const year = ts[0] || 2026;
            const month = (ts[1] !== undefined) ? (ts[1] - 1) : 0;
            const day = ts[2] || 1;
            const hour = ts[3] || 0;
            const minute = ts[4] || 0;
            const second = ts[5] || 0;
            return new Date(year, month, day, hour, minute, second);
        }
        if (typeof ts === 'object') {
            const year = ts.year || 2026;
            const month = (ts.monthValue !== undefined) ? (ts.monthValue - 1) : 0;
            const day = ts.dayOfMonth || 1;
            const hour = ts.hour || 0;
            const minute = ts.minute || 0;
            const second = ts.second || 0;
            return new Date(year, month, day, hour, minute, second);
        }
        return new Date(ts);
    }

    // Append message to HTML board
    function appendMessage(msg) {
        const container = document.getElementById('messages-container');
        const isSelf = (msg.senderEmail === currentUserEmail);

        const groupDiv = document.createElement('div');
        groupDiv.className = "msg-group " + (isSelf ? "outgoing" : "incoming");

        const bubbleDiv = document.createElement('div');
        bubbleDiv.className = "msg-bubble";
        
        // Render text if present
        if (msg.message && msg.message.trim() !== "") {
            const textSpan = document.createElement('span');
            textSpan.textContent = msg.message;
            bubbleDiv.appendChild(textSpan);
        }

        // Render file attachment if present
        if (msg.fileUrl) {
            const isImage = msg.fileType && msg.fileType.startsWith('image/');
            const isAudio = (msg.fileType && msg.fileType.startsWith('audio/')) || 
                            (msg.fileName && (msg.fileName.endsWith('.webm') || msg.fileName.endsWith('.wav') || msg.fileName.endsWith('.mp3') || msg.fileName.endsWith('.ogg') || msg.fileName.endsWith('.m4a')));

            if (isImage) {
                const img = document.createElement('img');
                img.className = "attachment-img";
                img.src = msg.fileUrl;
                img.alt = msg.fileName;
                img.onclick = () => window.open(msg.fileUrl, '_blank');
                bubbleDiv.appendChild(img);
            } else if (isAudio) {
                const audioContainer = document.createElement('div');
                audioContainer.style.marginTop = msg.message ? '8px' : '0px';
                audioContainer.style.display = 'flex';
                audioContainer.style.alignItems = 'center';
                audioContainer.style.gap = '8px';
                
                const micIcon = document.createElement('i');
                micIcon.className = "fa-solid fa-microphone";
                micIcon.style.color = isSelf ? "rgba(255,255,255,0.7)" : "var(--primary)";
                micIcon.style.fontSize = "16px";

                const audioEl = document.createElement('audio');
                audioEl.src = msg.fileUrl;
                audioEl.controls = true;
                audioEl.style.maxHeight = '32px';
                audioEl.style.outline = 'none';

                audioContainer.appendChild(micIcon);
                audioContainer.appendChild(audioEl);
                bubbleDiv.appendChild(audioContainer);
            } else {
                const attachLink = document.createElement('a');
                attachLink.className = "msg-attachment";
                attachLink.href = msg.fileUrl;
                attachLink.target = "_blank";
                attachLink.title = "Ouvrir la pièce jointe";

                let fileIcon = "fa-solid fa-file";
                if (msg.fileType && msg.fileType.includes('pdf')) fileIcon = "fa-solid fa-file-pdf";
                else if (msg.fileName.endsWith('.docx') || msg.fileName.endsWith('.doc')) fileIcon = "fa-solid fa-file-word";
                else if (msg.fileName.endsWith('.xlsx') || msg.fileName.endsWith('.xls')) fileIcon = "fa-solid fa-file-excel";
                else if (msg.fileName.endsWith('.pptx') || msg.fileName.endsWith('.ppt')) fileIcon = "fa-solid fa-file-powerpoint";

                attachLink.innerHTML = `<i class="${fileIcon}"></i> <span>${msg.fileName}</span>`;
                bubbleDiv.appendChild(attachLink);
            }
        }

        // Meta Row (Time + Ticks)
        const metaDiv = document.createElement('div');
        metaDiv.className = "msg-meta-row";
        const date = parseDate(msg.timestamp);
        let dateStr = "00:00";
        try {
            dateStr = date.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
        } catch (e) {
            console.error("Error formatting date: ", e);
        }
        metaDiv.innerHTML = `<span>${dateStr}</span>`;

        if (isSelf) {
            // Render ticks
            if (msg.lu) {
                metaDiv.innerHTML += `<i class="fa-solid fa-check-double" style="color: #53bdeb; font-size: 11px;" title="Lu"></i>`;
            } else if (msg.delivered) {
                metaDiv.innerHTML += `<i class="fa-solid fa-check-double" style="color: rgba(255,255,255,0.4); font-size: 11px;" title="Distribué"></i>`;
            } else {
                metaDiv.innerHTML += `<i class="fa-solid fa-check" style="color: rgba(255,255,255,0.4); font-size: 11px;" title="Envoyé"></i>`;
            }
        }

        groupDiv.appendChild(bubbleDiv);
        groupDiv.appendChild(metaDiv);
        container.appendChild(groupDiv);
    }

    // Scroll chat window to bottom
    function scrollChatToBottom() {
        const container = document.getElementById('messages-container');
        container.scrollTop = container.scrollHeight;
    }

    // Increment sidebar unread badge
    function incrementUnreadBadge(email) {
        const badgeId = 'badge-' + email.replace(/@/g, '_at_');
        const badge = document.getElementById(badgeId);
        if (badge) {
            let count = parseInt(badge.textContent) || 0;
            count++;
            badge.textContent = count;
            badge.style.display = 'block';
        }
        applyFilters();
    }

    // Clear unread badge
    function clearUnreadBadge(email) {
        const badgeId = 'badge-' + email.replace(/@/g, '_at_');
        const badge = document.getElementById(badgeId);
        if (badge) {
            badge.textContent = '0';
            badge.style.display = 'none';
        }
        applyFilters();
    }

    // Toast alerts
    function showToast(title, body) {
        const toast = document.getElementById('chat-toast');
        document.getElementById('toast-title').textContent = title;
        document.getElementById('toast-body').textContent = body.length > 60 ? body.substring(0, 60) + '...' : body;
        
        toast.classList.add('show');
        setTimeout(() => {
            toast.classList.remove('show');
        }, 4000);
    }

    function playNotifSound() {
        const audio = document.getElementById('notif-sound');
        if (audio) {
            audio.play().catch(e => console.log("Sound play prevented: " + e.message));
        }
    }

    // Select a contact and load history
    function selectContact(email, fullName) {
        activeContactEmail = email;

        // Highlight sidebar item
        document.querySelectorAll('.contact-item').forEach(item => {
            item.classList.remove('active');
        });
        const elementId = 'contact-' + email.replace(/@/g, '_at_');
        document.getElementById(elementId).classList.add('active');

        // Clear unread badge and send read receipt
        clearUnreadBadge(email);
        sendReadReceipt(email);

        // Update header details
        document.getElementById('active-name').textContent = fullName;
        document.getElementById('active-email').textContent = email;
        document.getElementById('active-avatar').textContent = fullName.split(' ').map(n => n[0]).join('');
        document.getElementById('active-typing').style.display = 'none';

        // Switch panels
        document.getElementById('empty-state').style.display = 'none';
        document.getElementById('active-chat-container').style.display = 'flex';

        // Load History
        const messagesContainer = document.getElementById('messages-container');
        messagesContainer.innerHTML = '<div style="text-align:center; padding: 20px; color:var(--text-muted);"><i class="fa-solid fa-spinner fa-spin" style="font-size:24px; margin-bottom:10px;"></i><br>Chargement de l\'historique…</div>';

        fetch(contextPath + '/chat/history?contact=' + encodeURIComponent(email))
            .then(res => res.json())
            .then(messages => {
                messagesContainer.innerHTML = '';
                if (messages.length === 0) {
                    messagesContainer.innerHTML = '<div style="text-align:center; padding: 40px 20px; color:var(--text-muted); font-size:13px; font-style:italic;">Début de la conversation sécurisée. Restez courtois et professionnel.</div>';
                } else {
                    messages.forEach(msg => {
                        // Mark all historical unread messages as delivered visually for outgoing
                        if (!msg.lu) {
                            msg.delivered = true;
                        }
                        appendMessage(msg);
                    });
                }
                scrollChatToBottom();
                document.getElementById('chat-message-input').focus();
            })
            .catch(err => {
                messagesContainer.innerHTML = '<div style="text-align:center; padding: 20px; color:var(--danger);">Erreur lors du chargement de l\'historique.</div>';
                console.error(err);
            });
    }

    // Trigger local file selection
    function triggerFileInput() {
        document.getElementById('chat-file-input').click();
    }

    // Handle local file selection and AJAX upload
    function handleFileUpload(event) {
        const file = event.target.files[0];
        if (!file) return;

        // Validate client side
        const maxLimit = 5 * 1024 * 1024; // 5MB
        if (file.size > maxLimit) {
            alert("Le fichier dépasse la limite autorisée de 5 Mo.");
            event.target.value = '';
            return;
        }

        const allowedExts = ["pdf", "png", "jpg", "jpeg", "docx", "xlsx", "pptx", "txt"];
        const ext = file.name.substring(file.name.lastIndexOf(".") + 1).toLowerCase();
        if (!allowedExts.includes(ext)) {
            alert("Format non autorisé. Formats acceptés : PDF, PNG, JPG, JPEG, DOCX, XLSX, PPTX, TXT");
            event.target.value = '';
            return;
        }

        // Send to Upload Servlet
        const formData = new FormData();
        formData.append("file", file);

        document.getElementById('attachment-preview').style.display = 'flex';
        document.getElementById('attachment-name').textContent = "Téléversement de : " + file.name + "...";

        fetch(contextPath + '/chat/upload', {
            method: 'POST',
            body: formData
        })
        .then(res => {
            if (!res.ok) {
                return res.json().then(json => { throw new Error(json.error || "Erreur de téléversement"); });
            }
            return res.json();
        })
        .then(data => {
            currentAttachment = data; // contains { url, fileName, fileType }
            document.getElementById('attachment-name').textContent = file.name;
        })
        .catch(err => {
            alert(err.message);
            clearAttachment();
        });
    }

    // Clear attachment from state
    function clearAttachment() {
        currentAttachment = null;
        document.getElementById('chat-file-input').value = '';
        document.getElementById('attachment-preview').style.display = 'none';
    }

    // Typing state handler on keypress/input
    function handleMessageInput() {
        if (!activeContactEmail) return;
        if (!isCurrentlyTyping) {
            isCurrentlyTyping = true;
            sendTypingState(true);
        }
        clearTimeout(typingTimeout);
        typingTimeout = setTimeout(() => {
            isCurrentlyTyping = false;
            sendTypingState(false);
        }, 2000);
    }

    function sendTypingState(typing) {
        if (socket && socket.readyState === WebSocket.OPEN && activeContactEmail) {
            socket.send(JSON.stringify({
                type: "TYPING",
                receiverEmail: activeContactEmail,
                typing: typing
            }));
        }
    }

    // Emoji picker handlers
    function toggleEmojiPicker() {
        const picker = document.getElementById('emoji-picker');
        picker.style.display = picker.style.display === 'none' ? 'grid' : 'none';
    }

    function insertEmoji(emoji) {
        const input = document.getElementById('chat-message-input');
        input.value += emoji;
        input.focus();
        handleMessageInput();
        document.getElementById('emoji-picker').style.display = 'none';
    }

    // Close emoji picker when clicking outside
    document.addEventListener('click', function(e) {
        const picker = document.getElementById('emoji-picker');
        const btn = document.getElementById('emoji-btn');
        if (picker && picker.style.display !== 'none' && !picker.contains(e.target) && e.target !== btn && !btn.contains(e.target)) {
            picker.style.display = 'none';
        }
    });

    // MediaRecorder / Audio Voice Message Recording logic
    function toggleAudioRecording() {
        if (isRecording) {
            stopAndSendRecording();
        } else {
            startRecording();
        }
    }

    function startRecording() {
        if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
            alert("L'enregistrement audio n'est pas pris en charge par votre navigateur.");
            return;
        }

        navigator.mediaDevices.getUserMedia({ audio: true })
            .then(stream => {
                isRecording = true;
                audioChunks = [];
                mediaRecorder = new MediaRecorder(stream);
                mediaRecorder.ondataavailable = event => {
                    audioChunks.push(event.data);
                };

                mediaRecorder.onstop = () => {
                    stream.getTracks().forEach(track => track.stop());
                    if (audioChunks.length === 0) return;

                    const audioBlob = new Blob(audioChunks, { type: 'audio/webm' });
                    uploadAudioBlob(audioBlob);
                };

                mediaRecorder.start();

                // UI Changes
                document.getElementById('recording-overlay').style.display = 'flex';
                document.getElementById('chat-message-input').style.display = 'none';
                document.getElementById('paperclip-btn').style.display = 'none';
                document.getElementById('emoji-btn').style.display = 'none';
                document.getElementById('record-btn').innerHTML = '<i class="fa-solid fa-square" style="color:#ef4444;"></i>';
                document.getElementById('record-btn').title = "Arrêter et envoyer";
                document.getElementById('record-timer').textContent = "00:00";
                
                recordSeconds = 0;
                recordInterval = setInterval(() => {
                    recordSeconds++;
                    const mins = Math.floor(recordSeconds / 60).toString().padStart(2, '0');
                    const secs = (recordSeconds % 60).toString().padStart(2, '0');
                    document.getElementById('record-timer').textContent = mins + ":" + secs;
                }, 1000);
            })
            .catch(err => {
                console.error("Microphone access error:", err);
                alert("Impossible d'accéder au micro. Veuillez autoriser l'accès.");
            });
    }

    function stopAndSendRecording() {
        if (!isRecording) return;
        clearInterval(recordInterval);
        mediaRecorder.stop();
        resetRecordingUI();
    }

    function cancelRecording() {
        if (!isRecording) return;
        clearInterval(recordInterval);
        audioChunks = []; // Clear chunks so onstop won't upload
        mediaRecorder.stop();
        resetRecordingUI();
    }

    function resetRecordingUI() {
        isRecording = false;
        document.getElementById('recording-overlay').style.display = 'none';
        document.getElementById('chat-message-input').style.display = 'block';
        document.getElementById('paperclip-btn').style.display = 'flex';
        document.getElementById('emoji-btn').style.display = 'flex';
        document.getElementById('record-btn').innerHTML = '<i class="fa-solid fa-microphone"></i>';
        document.getElementById('record-btn').title = "Enregistrer un message vocal";
        document.getElementById('chat-message-input').focus();
    }

    function uploadAudioBlob(blob) {
        const formData = new FormData();
        const timestamp = new Date().getTime();
        const filename = "vocal_" + timestamp + ".webm";
        formData.append("file", blob, filename);

        document.getElementById('attachment-preview').style.display = 'flex';
        document.getElementById('attachment-name').textContent = "Téléversement du message vocal...";

        fetch(contextPath + '/chat/upload', {
            method: 'POST',
            body: formData
        })
        .then(res => {
            if (!res.ok) {
                return res.json().then(json => { throw new Error(json.error || "Erreur de téléversement"); });
            }
            return res.json();
        })
        .then(data => {
            currentAttachment = data; // contains { url, fileName, fileType }
            document.getElementById('attachment-name').textContent = "🎙️ Message vocal prêt";
            // Auto-send the audio message
            sendMessage();
        })
        .catch(err => {
            alert("Erreur lors de l'enregistrement de l'audio: " + err.message);
            clearAttachment();
        });
    }

    // Key press handler
    function handleKeyPress(e) {
        if (e.key === 'Enter') {
            sendMessage();
            e.preventDefault();
        }
    }

    // Send chat message
    function sendMessage() {
        const input = document.getElementById('chat-message-input');
        const text = input.value.trim();

        if (text === "" && !currentAttachment) return;
        if (!activeContactEmail) return;

        // Cancel any pending typing timeouts and declare typing stopped
        clearTimeout(typingTimeout);
        if (isCurrentlyTyping) {
            isCurrentlyTyping = false;
            sendTypingState(false);
        }

        const payload = {
            receiverEmail: activeContactEmail,
            message: text,
            fileName: currentAttachment ? currentAttachment.fileName : null,
            fileType: currentAttachment ? currentAttachment.fileType : null,
            fileUrl: currentAttachment ? currentAttachment.url : null
        };

        if (socket && socket.readyState === WebSocket.OPEN) {
            socket.send(JSON.stringify(payload));
            input.value = "";
            clearAttachment();
        } else {
            alert("Erreur de connexion. Veuillez patienter pendant la reconconnexion.");
        }
    }

    // Set contact filtering tab/mode
    function setFilter(filterType) {
        currentFilter = filterType;
        document.querySelectorAll('.filter-btn').forEach(btn => btn.classList.remove('active'));
        event.currentTarget.classList.add('active');
        applyFilters();
    }

    // Apply combined text search and tab filter
    function applyFilters() {
        const q = document.getElementById('contact-search').value.toLowerCase();
        document.querySelectorAll('.contact-item').forEach(item => {
            const name = item.querySelector('.contact-name').textContent.toLowerCase();
            const email = item.querySelector('.contact-email').textContent.toLowerCase();
            
            const matchesText = name.includes(q) || email.includes(q);
            
            let matchesFilter = true;
            if (currentFilter === 'online') {
                const dot = item.querySelector('.status-dot');
                matchesFilter = dot && dot.classList.contains('online');
            } else if (currentFilter === 'unread') {
                const badge = item.querySelector('.unread-badge');
                const count = parseInt(badge.textContent) || 0;
                matchesFilter = count > 0;
            }
            
            if (matchesText && matchesFilter) {
                item.style.display = 'flex';
            } else {
                item.style.display = 'none';
            }
        });
    }

    function filterContacts() {
        applyFilters();
    }

    // Start Websockets
    window.onload = function() {
        initWebSocket();
    };
</script>

<jsp:include page="/layout-footer.jsp" />
