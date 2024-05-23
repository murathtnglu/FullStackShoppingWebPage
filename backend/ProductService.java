package com.example.databasehomework2;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Service
public class ProductService {

    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public ProductService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<Product> getAllProducts() {
        String sql = "SELECT * FROM product";
        return jdbcTemplate.query(sql, (rs, rowNum) -> mapRowToProduct(rs));
    }

    public List<Product> getPopularProduct() {
        String sql = "SELECT * FROM top_5_popular_products";
        return jdbcTemplate.query(sql, (rs, rowNum) -> mapRowToProduct(rs));
    }
    private Product mapRowToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setProductId(rs.getLong("productid"));
        product.setProductName(rs.getString("productname"));
        product.setProductPrice(rs.getBigDecimal("productprice"));
        product.setProductCategory(rs.getString("productcategory"));
        product.setProductImage(rs.getString("product_image"));
        product.setPopularity(rs.getInt("popularity"));
        return product;
    }
}
