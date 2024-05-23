import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_model.dart';
import 'top_bar.dart';

class ShoppingCartPage extends StatelessWidget {
  final int userId;

  ShoppingCartPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    var cart = Provider.of<CartModel>(context);
    cart.fetchCartItems(userId); 
    double totalPrice = cart.totalPrice;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopBar(userId: userId, onSearch: (query) {
        
      }),
      body: Column(
        children: [
          Container(
            height: 4, 
            color: Colors.purpleAccent, 
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Shopping Cart",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        return CartItemWidget(
                          cartItem: cart.items[index],
                          onQuantityChanged: (newQuantity) {
                            cart.updateQuantity(cart.items[index], newQuantity);
                          },
                          onRemove: () {
                            cart.removeItem(cart.items[index]);
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "\$${totalPrice.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                      
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.purple,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Checkout'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  CartItemWidget({
    required this.cartItem,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            cartItem.productImage,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.productName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  '\$${cartItem.productPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        if (cartItem.quantity > 1) {
                          onQuantityChanged(cartItem.quantity - 1);
                        }
                      },
                    ),
                    Text(
                      cartItem.quantity.toString(),
                      style: TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: () {
                        onQuantityChanged(cartItem.quantity + 1);
                      },
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: onRemove,
                      child: Text(
                        'Remove',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
