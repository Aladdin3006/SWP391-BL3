package entity;

public class Product {

    private int id;
    private String productCode;
    private String name;
    private String brand;
    private String company;
    private int categoryId;   // đổi từ categoryName -> categoryId
    private int unit;
    private int supplierId;
    private String status;
    private String url;
    private String categoryName;

    public Product(int id, String productCode, String name, String brand, String company, int categoryId, int unit, int supplierId, String status, String url, String categoryName) {
        this.id = id;
        this.productCode = productCode;
        this.name = name;
        this.brand = brand;
        this.company = company;
        this.categoryId = categoryId;
        this.unit = unit;
        this.supplierId = supplierId;
        this.status = status;
        this.url = url;
        this.categoryName = categoryName;
    }

    public Product() {}



    public Product(int id, String productCode, String name, String brand, String company,
                   int categoryId, int unit, int supplierId, String status, String url) {
        this.id = id;
        this.productCode = productCode;
        this.name = name;
        this.brand = brand;
        this.company = company;
        this.categoryId = categoryId;
        this.unit = unit;
        this.supplierId = supplierId;
        this.status = status;
        this.url = url;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getProductCode() { return productCode; }
    public void setProductCode(String productCode) { this.productCode = productCode; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }

    public String getCompany() { return company; }
    public void setCompany(String company) { this.company = company; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public int getUnit() { return unit; }
    public void setUnit(int unit) { this.unit = unit; }

    public int getSupplierId() { return supplierId; }
    public void setSupplierId(int supplierId) { this.supplierId = supplierId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getUrl() { return url; }
    public void setUrl(String url) { this.url = url; }
    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }
}
