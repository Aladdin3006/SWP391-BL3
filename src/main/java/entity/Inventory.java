package entity;

public class Inventory {
    private int id;
    private int productId;
    private int workspaceId;
    private int quantity;

    public Inventory() {}

    public Inventory(int id, int productId, int workspaceId, int quantity) {
        this.id = id;
        this.productId = productId;
        this.workspaceId = workspaceId;
        this.quantity = quantity;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public int getWorkspaceId() { return workspaceId; }
    public void setWorkspaceId(int workspaceId) { this.workspaceId = workspaceId; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}