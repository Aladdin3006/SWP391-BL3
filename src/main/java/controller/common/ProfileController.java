package controller.common;

import dal.UserDAO;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Properties;
import java.util.UUID;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

@WebServlet(name = "ProfileController", urlPatterns = {"/profile"})
public class ProfileController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserDAO db = new UserDAO();
        HttpSession session = request.getSession();
        User sessionUser = (User) session.getAttribute("user");

        if (sessionUser != null) {
            User user = db.getUserById(sessionUser.getUserId());
            request.setAttribute("profileUser", user);
            request.getRequestDispatcher("/view/fragments/profile.jsp").forward(request, response);
        } else {
            response.sendRedirect("login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        UserDAO db = new UserDAO();
        HttpSession session = request.getSession();

        if ("update".equals(action)) {
            User sessionUser = (User) session.getAttribute("user");
            if (sessionUser == null) {
                response.sendRedirect("login");
                return;
            }

            int userId = sessionUser.getUserId();
            String displayName = request.getParameter("displayName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            User currentUser = db.getUserById(userId);
            if (currentUser != null) {
                String currentEmail = currentUser.getEmail();
                boolean emailChanged = !currentEmail.equals(email);

                if (emailChanged) {
                    User existingUserWithEmail = db.getUserByEmail(email);
                    if (existingUserWithEmail != null && existingUserWithEmail.getUserId() != userId) {
                        request.setAttribute("error", "Email already exists.");
                        request.setAttribute("profileUser", currentUser);
                        request.getRequestDispatcher("/view/fragments/profile.jsp").forward(request, response);
                        return;
                    }

                    String verificationCode = UUID.randomUUID().toString();

                    String baseUrl = getBaseUrl(request);
                    String verifyLink = baseUrl + "/verify-email-change?token=" + verificationCode +
                            "&email=" + email + "&userId=" + userId;

                    new Thread(() -> {
                        sendEmailChangeVerification(displayName, email, verifyLink);
                    }).start();

                    currentUser.setDisplayName(displayName);
                    currentUser.setPhone(phone);
                    currentUser.setVerificationCode(verificationCode);

                    boolean success = db.updateUserWithVerification(currentUser);
                    if (success) {
                        User updatedUser = db.getUserById(userId);
                        session.setAttribute("user", updatedUser);
                        request.setAttribute("emailChangeMessage", "Email change requested. Please check your NEW email for verification link. Your current email remains active until verification.");
                        request.setAttribute("message", "Profile updated! Email change requires verification.");
                    } else {
                        request.setAttribute("error", "Failed to update profile.");
                    }
                } else {
                    currentUser.setDisplayName(displayName);
                    currentUser.setEmail(email);
                    currentUser.setPhone(phone);

                    boolean success = db.updateUser(currentUser);
                    if (success) {
                        User updatedUser = db.getUserById(userId);
                        session.setAttribute("user", updatedUser);
                        request.setAttribute("message", "Profile updated successfully!");
                    } else {
                        request.setAttribute("error", "Failed to update profile.");
                    }
                }

                request.setAttribute("profileUser", db.getUserById(userId));
                request.getRequestDispatcher("/view/fragments/profile.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("profile");
        }
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

    private void sendEmailChangeVerification(String displayName, String newEmail, String verifyLink) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication("wms.fpt@gmail.com", "dszq pleh cbki wjlt ");
            }
        };

        Session session = Session.getInstance(props, auth);

        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress("wms.fpt@gmail.com"));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(newEmail));
            msg.setSubject("WMS Email Change Verification");

            String content = "<h3>Hello " + displayName + ",</h3>"
                    + "<p>You requested to change your email address.</p>"
                    + "<p>Please click the link below to verify your new email:</p>"
                    + "<a href='" + verifyLink + "'>VERIFY EMAIL CHANGE</a>"
                    + "<br><br><p>If you did not request this change, please ignore this email.</p>";

            msg.setContent(content, "text/html; charset=utf-8");
            Transport.send(msg);

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}