package entity;

public class Inventory {
    private int id;
    private int productId;
    private int changeId;

    public Inventory() {}

    public Inventory(int id, int productId, int changeId) {
        this.id = id;
        this.productId = productId;
        this.changeId = changeId;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public int getChangeId() { return changeId; }
    public void setChangeId(int changeId) { this.changeId = changeId; }
}