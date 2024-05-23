package com.example.databasehomework2;

import java.math.BigDecimal;

public class Product {
    private Long productId;
    private String productName;
    private BigDecimal productPrice;
    private String productCategory;
    private String productImage;
    private int popularity;

    // Getters and Setters
    public Long getProductId() {
        return productId;
    }

    public void setProductId(Long productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public BigDecimal getProductPrice() {
        return productPrice;
    }

    public void setProductPrice(BigDecimal productPrice) {
        this.productPrice = productPrice;
    }

    public String getProductCategory() {
        return productCategory;
    }

    public void setProductCategory(String productCategory) {
        this.productCategory = productCategory;
    }

    public String getProductImage() {
        return productImage;
    }

    public void setProductImage(String productImage) {
        this.productImage = productImage;
    }

    public int getPopularity(){
        return popularity;
    }

    public void setPopularity(int popularity){
        this.popularity = popularity;
    }
}
