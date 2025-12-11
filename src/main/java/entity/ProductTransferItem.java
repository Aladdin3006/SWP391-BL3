package entity;

import java.sql.Timestamp;

public class ProductTransferItem {
    private int id;
    private int ticketId;
    private String ticketType; // request or actual
    private int productId;
    private int quantity;
    private Timestamp createdAt;
    
    // For display purposes
    private Product product;

    public ProductTransferItem() {}

    public ProductTransferItem(int id, int ticketId, String ticketType, int productId, 
                              int quantity, Timestamp createdAt) {
        this.id = id;
        this.ticketId = ticketId;
        this.ticketType = ticketType;
        this.productId = productId;
        this.quantity = quantity;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getTicketId() { return ticketId; }
    public void setTicketId(int ticketId) { this.ticketId = ticketId; }

    public String getTicketType() { return ticketType; }
    public void setTicketType(String ticketType) { this.ticketType = ticketType; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }
}

