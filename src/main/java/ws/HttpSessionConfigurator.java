package ws;

import jakarta.servlet.http.HttpSession;
import jakarta.websocket.HandshakeResponse;
import jakarta.websocket.server.HandshakeRequest;
import jakarta.websocket.server.ServerEndpointConfig;

public class HttpSessionConfigurator extends ServerEndpointConfig.Configurator {

    @Override
    public void modifyHandshake(ServerEndpointConfig config,
            HandshakeRequest request,
            HandshakeResponse response) {
        Object sessionObj = request.getHttpSession();
        if (sessionObj instanceof HttpSession) {
            HttpSession httpSession = (HttpSession) sessionObj;
            config.getUserProperties().put("httpSession", httpSession);
        } else {
            System.out.println("Configurator: HttpSession was null or invalid during handshake.");
        }
    }
}
