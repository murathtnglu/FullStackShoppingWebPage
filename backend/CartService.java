package com.example.databasehomework2;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Service
public class CartService {

    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public CartService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<CartItem> getCartItems(Long userId) {
        String sql = "SELECT c.cartid, c.userid, c.productid, c.quantity, p.productname, p.productprice, p.product_image " +
                "FROM shopping_cart c " +
                "JOIN product p ON c.productid = p.productid " +
                "WHERE c.userid = ?";
        return jdbcTemplate.query(sql, new Object[]{userId}, (rs, rowNum) -> mapRowToCartItem(rs));
    }

    public void addCartItem(CartItem cartItem) {
        String sql = "INSERT INTO shopping_cart (userid, productid, quantity) VALUES (?, ?, ?)";
        jdbcTemplate.update(sql, cartItem.getUserId(), cartItem.getProductId(), cartItem.getQuantity());
    }

    public void updateCartItem(CartItem cartItem) {
        String sql = "UPDATE shopping_cart SET quantity = ? WHERE cartid = ?";
        jdbcTemplate.update(sql, cartItem.getQuantity(), cartItem.getCartId());
    }

    public void removeCartItem(Long cartId) {
        String sql = "DELETE FROM shopping_cart WHERE cartid = ?";
        jdbcTemplate.update(sql, cartId);
    }

    private CartItem mapRowToCartItem(ResultSet rs) throws SQLException {
        CartItem cartItem = new CartItem();
        cartItem.setCartId(rs.getLong("cartid"));
        cartItem.setUserId(rs.getLong("userid"));
        cartItem.setProductId(rs.getLong("productid"));
        cartItem.setQuantity(rs.getInt("quantity"));
        cartItem.setProductName(rs.getString("productname"));
        cartItem.setProductPrice(rs.getDouble("productprice"));
        cartItem.setProductImage(rs.getString("product_image"));
        return cartItem;
    }
}