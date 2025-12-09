package entity;

public class ProductTransferItem {
    private int id;
    private int productId;
    private int quantity;
    private String productCode;
    private String productName;

    public ProductTransferItem() {}

    public ProductTransferItem(int id, int productId, int quantity, String productCode, String productName) {
        this.id = id;
        this.productId = productId;
        this.quantity = quantity;
        this.productCode = productCode;
        this.productName = productName;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public String getProductCode() { return productCode; }
    public void setProductCode(String productCode) { this.productCode = productCode; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
}