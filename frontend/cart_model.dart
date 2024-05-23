import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartItem {
  final int cartId;
  final int userId;
  final int productId;
  final String productName;
  final double productPrice;
  final String productImage;
  int quantity;

  CartItem({
    required this.cartId,
    required this.userId,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    this.quantity = 1,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartId: json['cartId'],
      userId: json['userId'],
      productId: json['productId'],
      productName: json['productName'],
      productPrice: json['productPrice'],
      productImage: json['productImage'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartId': cartId,
      'userId': userId,
      'productId': productId,
      'productName': productName,
      'productPrice': productPrice,
      'productImage': productImage,
      'quantity': quantity,
    };
  }
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];
  int? userId;

  CartModel({this.userId});

  List<CartItem> get items => _items;

  double get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.productPrice * item.quantity);

  Future<void> addItem(CartItem newItem) async {

    CartItem? existingItem = _items.firstWhere(
          (item) => item.productId == newItem.productId,
      orElse: () => CartItem(cartId: 0, userId: 0, productId: 0, productName: '', productPrice: 0, productImage: ''),
    );

    if (existingItem.productId != 0) {
   
      existingItem.quantity += newItem.quantity;
      await updateCartItem(existingItem);
    } else {
    
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/cart'),
        body: json.encode(newItem.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        await fetchCartItems(newItem.userId); 
      }
    }
    _sortItems();
    notifyListeners();
  }

  Future<void> updateQuantity(CartItem item, int quantity) async {
    item.quantity = quantity;
    await updateCartItem(item);
    _sortItems();
    notifyListeners();
  }

  Future<void> updateCartItem(CartItem item) async {
    final response = await http.put(
      Uri.parse('http://localhost:8080/api/cart/${item.cartId}'),
      body: json.encode({
        'cartId': item.cartId,
        'quantity': item.quantity,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      
    }
  }

  Future<void> removeItem(CartItem item) async {
    final response = await http.delete(
      Uri.parse('http://localhost:8080/api/cart/${item.cartId}'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      await fetchCartItems(item.userId); 
    }
    _sortItems();
    notifyListeners();
  }

  Future<void> fetchCartItems(int userId) async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/cart/$userId'),
    );

    if (response.statusCode == 200) {
      List<dynamic> cartList = json.decode(response.body);
      _items.clear();
      _items.addAll(cartList.map((data) => CartItem.fromJson(data)).toList());
      _sortItems();
      notifyListeners();
    }
  }

  void _sortItems() {
    _items.sort((a, b) => a.productName.compareTo(b.productName));
  }
}
