import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_model.dart';
import 'top_bar.dart';

class ProductInfoPage extends StatelessWidget {
  final int productId;
  final String productName;
  final double productPrice;
  final String productCategory;
  final String productImage;
  final int userId;

  ProductInfoPage({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productCategory,
    required this.productImage,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopBar(userId: userId, onSearch: (query) {
        
      }),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                productImage,
                height: 300, 
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Text(
              productName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '\$${productPrice.toString()}',
              style: TextStyle(fontSize: 20, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  var cartItem = CartItem(
                    cartId: 0,
                    userId: userId,
                    productId: productId,
                    productName: productName,
                    productPrice: productPrice,
                    productImage: productImage,
                  );
                  Provider.of<CartModel>(context, listen: false).addItem(cartItem);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$productName added to cart')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: Text(
                  'Add to Cart',
                  style: TextStyle(color: Colors.white), 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
