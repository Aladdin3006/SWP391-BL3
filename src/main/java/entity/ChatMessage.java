package entity;

public class ChatMessage {
    private String senderName;
    private String content;
    private String timestamp;

    public ChatMessage(String senderName, String content, String timestamp) {
        this.senderName = senderName;
        this.content = content;
        this.timestamp = timestamp;
    }

    public String getSenderName() { return senderName; }
    public String getContent() { return content; }
    public String getTimestamp() { return timestamp; }
}