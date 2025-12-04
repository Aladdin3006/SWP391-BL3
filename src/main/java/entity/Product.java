package entity;

public class Product {
    private int id;
    private String productCode;
    private String name;
    private String brand;
    private String company;
    private String categoryName;
    private int unit;

    public Product() {}

    public Product(int id, String productCode, String name, String brand, String company, String categoryName, int unit) {
        this.id = id;
        this.productCode = productCode;
        this.name = name;
        this.brand = brand;
        this.company = company;
        this.categoryName = categoryName;
        this.unit = unit;
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
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
    public int getUnit() { return unit; }
    public void setUnit(int unit) { this.unit = unit; }
}