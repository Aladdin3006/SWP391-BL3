package entity;

public class ExportDetail {
    private int exportId;
    private int productId;
    private int quantity;

    public ExportDetail() {}

    public ExportDetail(int exportId, int productId, int quantity) {
        this.exportId = exportId;
        this.productId = productId;
        this.quantity = quantity;
    }

    public int getExportId() { return exportId; }
    public void setExportId(int exportId) { this.exportId = exportId; }
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}