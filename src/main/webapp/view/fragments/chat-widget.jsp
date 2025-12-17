<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>

<style>
    .chat-widget-btn {
        position: fixed;
        bottom: 20px;
        right: 20px;
        width: 55px;
        height: 55px;
        z-index: 2000;
        cursor: pointer;
        transition: all 0.2s;
        border: none;
    }
    .chat-widget-btn:hover {
        transform: scale(1.1);
    }
    .chat-window {
        position: fixed;
        width: 320px;
        height: 420px;
        bottom: 90px;
        right: 20px;
        z-index: 2000;
        display: none;
        box-shadow: 0 0 20px rgba(0,0,0,0.2);
    }
    .chat-window.show {
        display: flex !important;
    }
    .chat-header {
        padding: 10px 15px;
        background-color: #0d6efd;
        color: white;
        border-radius: 0.375rem 0.375rem 0 0;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .chat-body {
        flex: 1;
        overflow-y: auto;
        padding: 10px;
        background-color: #f8f9fa;
    }
    .chat-footer {
        padding: 10px;
        background-color: white;
        border-top: 1px solid #dee2e6;
        border-radius: 0 0 0.375rem 0.375rem;
    }
    .msg-bubble {
        max-width: 80%;
        padding: 8px 12px;
        margin-bottom: 8px;
        border-radius: 12px;
        font-size: 0.9rem;
        word-wrap: break-word;
    }
    .msg-bubble.me {
        background-color: #0d6efd;
        color: white;
        margin-left: auto;
    }
    .msg-bubble.other {
        background-color: white;
        border: 1px solid #dee2e6;
        color: #212529;
    }
    .msg-container {
        display: flex;
        flex-direction: column;
        margin-bottom: 8px;
    }
    .msg-container.me {
        align-items: flex-end;
    }
    .msg-container.other {
        align-items: flex-start;
    }
    .msg-sender {
        font-size: 0.7rem;
        color: #6c757d;
        margin-bottom: 2px;
        padding: 0 5px;
    }
    .msg-time {
        font-size: 0.65rem;
        opacity: 0.8;
        text-align: right;
        margin-top: 2px;
    }
    .chat-body::-webkit-scrollbar {
        width: 6px;
    }
    .chat-body::-webkit-scrollbar-thumb {
        background-color: #adb5bd;
        border-radius: 4px;
    }
    .system-message {
        text-align: center;
        margin: 10px 0;
    }
    .system-badge {
        background-color: #6c757d;
        color: white;
        padding: 2px 8px;
        border-radius: 10px;
        font-size: 0.7rem;
        opacity: 0.5;
    }
</style>

<div class="chat-widget-btn bg-primary text-white rounded-circle d-flex align-items-center justify-content-center shadow" 
     onclick="toggleChat()">
    <i class="fas fa-comment-dots fa-lg"></i>
</div>

<div class="card border-0 chat-window" id="chatWindow">
    <div class="chat-header">
        <span class="fw-bold"><i class="fas fa-users me-2"></i>Warehouse Chat</span>
        <button type="button" class="btn-close btn-close-white" onclick="toggleChat()" style="padding: 0; width: 20px; height: 20px;"></button>
    </div>

    <div class="chat-body" id="messageList">
        <!-- Messages will be inserted here -->
    </div>

    <div class="chat-footer">
        <div class="input-group input-group-sm">
            <input type="text" id="chatInput" class="form-control" placeholder="Type a message..." onkeypress="handleEnter(event)" autocomplete="off">
            <button class="btn btn-primary" type="button" onclick="sendMessage()">
                <i class="fas fa-paper-plane"></i>
            </button>
        </div>
    </div>
</div>

<script>
    var websocket = null;
    var myName = "${sessionScope.user.displayName}";
    var isConnecting = false;

    function getWsUrl() {
        var host = window.location.host;
        var path = "${pageContext.request.contextPath}";
        if (path === "/" || path === "") {
            path = "";
        }
        var protocol = window.location.protocol === 'https:' ? 'wss://' : 'ws://';
        return protocol + host + path + "/chat";
    }

    function initWebSocket() {
        if (isConnecting) {
            console.log("Already connecting...");
            return;
        }

        if (websocket && websocket.readyState === WebSocket.OPEN) {
            console.log("Already connected");
            return;
        }

        if (websocket && websocket.readyState === WebSocket.CONNECTING) {
            console.log("Connection in progress...");
            return;
        }

        isConnecting = true;

        try {
            websocket = new WebSocket(getWsUrl());

            websocket.onopen = function () {
                isConnecting = false;
                addSystemMessage("Connected");
                scrollToBottom();
                console.log("WebSocket connected successfully");
            };

            websocket.onmessage = function (event) {
                try {
                    var msg = JSON.parse(event.data);
                    var isHist = (msg.type === 'HISTORY');
                    displayMessage(msg.senderName, msg.content, msg.timestamp, isHist);
                } catch (e) {
                    console.error("Error parsing message:", e);
                }
            };

            websocket.onerror = function (error) {
                console.error("WebSocket error:", error);
                isConnecting = false;
                addSystemMessage("Connection error");
            };

            websocket.onclose = function (event) {
                isConnecting = false;
                console.log("WebSocket closed. Code:", event.code, "Reason:", event.reason);
                addSystemMessage("Disconnected");

                setTimeout(function () {
                    var chatWindow = document.getElementById("chatWindow");
                    if (chatWindow && chatWindow.classList.contains('show')) {
                        console.log("Attempting to reconnect...");
                        addSystemMessage("Reconnecting...");
                        initWebSocket();
                    }
                }, 3000);
            };
        } catch (error) {
            console.error("Failed to create WebSocket:", error);
            isConnecting = false;
            addSystemMessage("Failed to connect");
        }
    }

    function displayMessage(sender, content, time, isHistory) {
        var list = document.getElementById("messageList");
        if (!list)
            return;

        var isMe = (sender === myName);

        var container = document.createElement("div");
        container.className = "msg-container " + (isMe ? "me" : "other");

        if (!isMe) {
            var senderSpan = document.createElement("div");
            senderSpan.className = "msg-sender";
            senderSpan.textContent = sender;
            container.appendChild(senderSpan);
        }

        var bubble = document.createElement("div");
        bubble.className = "msg-bubble " + (isMe ? "me" : "other");

        var contentDiv = document.createElement("div");
        contentDiv.textContent = content;
        bubble.appendChild(contentDiv);

        var timeDiv = document.createElement("div");
        timeDiv.className = "msg-time";
        timeDiv.textContent = time;
        bubble.appendChild(timeDiv);

        container.appendChild(bubble);
        list.appendChild(container);

        if (!isHistory) {
            scrollToBottom();
        }
    }

    function addSystemMessage(text) {
        var list = document.getElementById("messageList");
        if (!list)
            return;

        var systemMsg = document.createElement("div");
        systemMsg.className = "system-message";
        systemMsg.innerHTML = '<span class="system-badge">' + escapeHtml(text) + '</span>';
        list.appendChild(systemMsg);
        scrollToBottom();
    }

    function scrollToBottom() {
        var list = document.getElementById("messageList");
        if (list) {
            list.scrollTop = list.scrollHeight;
        }
    }

    function sendMessage() {
        var input = document.getElementById("chatInput");
        if (!input)
            return;

        var text = input.value.trim();
        if (!text)
            return;

        if (!websocket) {
            console.log("WebSocket not initialized");
            addSystemMessage("Connecting...");
            initWebSocket();
            return;
        }

        if (websocket.readyState === WebSocket.CONNECTING) {
            console.log("WebSocket still connecting, please wait...");
            addSystemMessage("Connecting...");
            return;
        }

        if (websocket.readyState === WebSocket.OPEN) {
            try {
                websocket.send(text);
                input.value = "";
                input.focus();
            } catch (error) {
                console.error("Error sending message:", error);
                addSystemMessage("Failed to send message");
            }
        } else {
            console.log("WebSocket not connected. State:", websocket.readyState);
            addSystemMessage("Reconnecting...");
            initWebSocket();
        }
    }

    function handleEnter(e) {
        if (e.key === "Enter" || e.keyCode === 13) {
            e.preventDefault();
            sendMessage();
        }
    }

    function toggleChat() {
        var chatWindow = document.getElementById("chatWindow");
        if (!chatWindow) {
            console.error("Chat window element not found!");
            return;
        }

        var isVisible = chatWindow.classList.contains('show');

        if (isVisible) {
            chatWindow.classList.remove('show');
            console.log("Chat closed");
        } else {
            chatWindow.classList.add('show');
            console.log("Chat opened");

            initWebSocket();

            setTimeout(function () {
                var input = document.getElementById("chatInput");
                if (input) {
                    input.focus();
                }
            }, 200);
        }
    }

    function escapeHtml(text) {
        var map = {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#039;'
        };
        return String(text).replace(/[&<>"']/g, function (m) {
            return map[m];
        });
    }

    window.addEventListener('beforeunload', function () {
        if (websocket && websocket.readyState === WebSocket.OPEN) {
            websocket.close();
        }
    });

</script>
