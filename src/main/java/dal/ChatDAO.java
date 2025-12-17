package dal;

import entity.ChatMessage;
import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class ChatDAO extends DBContext {

    public void saveMessage(int senderId, String content) {
        String sql = "INSERT INTO chat_message (senderId, messageContent, sentAt) VALUES (?, ?, NOW())";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, senderId);
            ps.setString(2, content);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<ChatMessage> getRecentMessages() {
        List<ChatMessage> list = new ArrayList<>();
        String sql = "SELECT u.displayName, c.messageContent, DATE_FORMAT(c.sentAt, '%H:%i') as sentTime "
                + "FROM chat_message c "
                + "JOIN user u ON c.senderId = u.userId "
                + "ORDER BY c.id DESC LIMIT 50";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new ChatMessage(
                        rs.getString("displayName"),
                        rs.getString("messageContent"),
                        rs.getString("sentTime")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        Collections.reverse(list);
        return list;
    }
}
