package com.example.databasehomework2;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/cart")
public class CartController {

    private final CartService cartService;

    @Autowired
    public CartController(CartService cartService) {
        this.cartService = cartService;
    }

    @GetMapping("/{userId}")
    public List<CartItem> getCartItems(@PathVariable Long userId) {
        return cartService.getCartItems(userId);
    }

    @PostMapping
    public ResponseEntity<String> addCartItem(@RequestBody CartItem cartItem) {
        cartService.addCartItem(cartItem);
        return ResponseEntity.ok("Item added to cart");
    }

    @PutMapping("/{cartId}")
    public ResponseEntity<String> updateCartItem(@PathVariable Long cartId, @RequestBody CartItem cartItem) {
        cartItem.setCartId(cartId);
        cartService.updateCartItem(cartItem);
        return ResponseEntity.ok("Item updated in cart");
    }

    @DeleteMapping("/{cartId}")
    public ResponseEntity<String> removeCartItem(@PathVariable Long cartId) {
        cartService.removeCartItem(cartId);
        return ResponseEntity.ok("Item removed from cart");
    }
}
