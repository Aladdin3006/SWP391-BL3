package util;

import entity.User;
import java.util.Properties;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailUtility {

    private static final String HOST = "smtp.gmail.com";
    private static final String PORT = "587";
    private static final String USER = "wms.fpt@gmail.com";
    private static final String PASS = "dszq pleh cbki wjlt ";

    public static void sendPost(User user, String baseUrl) {
        Properties props = new Properties();
        props.put("mail.smtp.host", HOST);
        props.put("mail.smtp.port", PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(USER, PASS);
            }
        };

        Session session = Session.getInstance(props, auth);

        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(USER));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(user.getEmail()));
            msg.setSubject("WMS Account Verification");

            String verifyLink = baseUrl + "/verify?code=" + user.getVerificationCode();

            String content = "<h3>Hello " + user.getDisplayName() + ",</h3>"
                    + "<p>Please click the link below to verify your account:</p>"
                    + "<a href='" + verifyLink + "'>VERIFY ACCOUNT</a>"
                    + "<br><br><p>Ignore this email if you did not request it.</p>";

            msg.setContent(content, "text/html; charset=utf-8");

            Transport.send(msg);
            System.out.println("Email sent successfully to " + user.getEmail());

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    public static void sendReset(String email, String token, String baseUrl) {
        Properties props = new Properties();
        props.put("mail.smtp.host", HOST);
        props.put("mail.smtp.port", PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(USER, PASS);
            }
        };

        Session session = Session.getInstance(props, auth);

        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(USER));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
            msg.setSubject("WMS Password Reset Request");

            String resetLink = baseUrl + "/reset-password?token=" + token;

            String content = "<h3>Password Reset</h3>"
                    + "<p>Someone requested a password reset for your WMS account.</p>"
                    + "<p>Click the link below to reset your password:</p>"
                    + "<a href='" + resetLink + "'>RESET PASSWORD</a>"
                    + "<br><br><p>If this was not you, you can safely ignore this email.</p>";

            msg.setContent(content, "text/html; charset=utf-8");

            Transport.send(msg);
            System.out.println("Reset email sent successfully to " + email);

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}