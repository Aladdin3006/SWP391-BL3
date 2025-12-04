package entity;

public class ImportDetail {
    private int importId;
    private int productId;
    private int quantity;

    public ImportDetail() {}

    public ImportDetail(int importId, int productId, int quantity) {
        this.importId = importId;
        this.productId = productId;
        this.quantity = quantity;
    }

    public int getImportId() { return importId; }
    public void setImportId(int importId) { this.importId = importId; }
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}