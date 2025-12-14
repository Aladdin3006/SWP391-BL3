package controller.auth;

import dal.UserDAO;
import entity.User;
import util.EmailUtility;
import java.io.IOException;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name="ForgotPasswordController", urlPatterns={"/forgot-password"})
public class ForgotPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/auth/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        UserDAO db = new UserDAO();
        User user = db.getUserByEmail(email);

        if (user == null) {
            request.setAttribute("error", "This email address is not registered in our system.");
            request.setAttribute("enteredEmail", email);
        } else {
            String token = UUID.randomUUID().toString();
            db.updateToken(email, token);

            String baseUrl = getBaseUrl(request);

            new Thread(() -> {
                EmailUtility.sendReset(email, token, baseUrl);
            }).start();

            request.setAttribute("message", "A reset link has been sent to " + email + ". Please check your inbox.");
        }
        request.getRequestDispatcher("/view/auth/forgot-password.jsp").forward(request, response);
    }

    private String getBaseUrl(HttpServletRequest request) {
        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        String contextPath = request.getContextPath();

        StringBuilder url = new StringBuilder();
        url.append(scheme).append("://").append(serverName);

        if ((serverPort != 80) && (serverPort != 443)) {
            url.append(":").append(serverPort);
        }

        url.append(contextPath);
        return url.toString();
    }
}