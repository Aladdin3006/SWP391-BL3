package ws;

import com.google.gson.Gson;
import dal.ChatDAO;
import entity.ChatMessage;
import entity.User;
import jakarta.servlet.http.HttpSession;
import jakarta.websocket.CloseReason;
import jakarta.websocket.EndpointConfig;
import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint(value = "/chat", configurator = HttpSessionConfigurator.class)
public class ChatServer {

    private static final Set<Session> sessions = ConcurrentHashMap.newKeySet();
    private static final Gson gson = new Gson();
    private final ChatDAO chatDAO = new ChatDAO();

    @OnOpen
    public void onOpen(Session session, EndpointConfig config) {
        try {
            HttpSession httpSession = (HttpSession) config.getUserProperties().get("httpSession");

            if (httpSession == null || httpSession.getAttribute("user") == null) {
                System.out.println("ChatServer: Rejecting connection (Not logged in)");
                session.close(new CloseReason(CloseReason.CloseCodes.VIOLATED_POLICY, "Not Logged In"));
                return;
            }

            User user = (User) httpSession.getAttribute("user");

            String r = "";
            if (user.getRole() != null) {
                r = user.getRole().getRoleName().toLowerCase();
            }

            if (!"employee".equals(r) && !"storekeeper".equals(r)) {
                System.out.println("ChatServer: Rejecting connection for role: " + r);
                session.close(new CloseReason(CloseReason.CloseCodes.VIOLATED_POLICY, "Unauthorized Role"));
                return;
            }

            session.getUserProperties().put("user", user);
            sessions.add(session);
            System.out.println("ChatServer: " + user.getDisplayName() + " joined.");

            List<ChatMessage> history = chatDAO.getRecentMessages();
            for (ChatMessage pastMsg : history) {
                session.getBasicRemote().sendText(gson.toJson(pastMsg));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @OnMessage
    public void onMessage(String content, Session session) {
        try {
            User sender = (User) session.getUserProperties().get("user");
            if (sender == null) {
                return;
            }

            String time = LocalTime.now().format(DateTimeFormatter.ofPattern("HH:mm"));
            chatDAO.saveMessage(sender.getUserId(), content);

            ChatMessage msg = new ChatMessage(sender.getDisplayName(), content, time);
            String json = gson.toJson(msg);

            for (Session s : sessions) {
                if (s.isOpen()) {
                    s.getAsyncRemote().sendText(json);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @OnClose
    public void onClose(Session session) {
        sessions.remove(session);
    }

    @OnError
    public void onError(Session session, Throwable t) {
        t.printStackTrace();
    }
}
