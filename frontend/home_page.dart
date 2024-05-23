import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product_info_page.dart';
import 'cart_model.dart';
import 'package:provider/provider.dart';
import 'top_bar.dart';

class HomePage extends StatefulWidget {
  final int userId;

  HomePage({required this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/products'));
    if (response.statusCode == 200) {
      List<dynamic> productList = json.decode(response.body);
      setState(() {
        products = productList.map((data) => Product.fromJson(data)).toList();
        filteredProducts = products;
      });
    } else {
     
    }
  }

  void fetchTopSellers() async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/popularity'));
    if (response.statusCode == 200) {
      List<dynamic> productList = json.decode(response.body);
      setState(() {
        filteredProducts = productList.map((data) => Product.fromJson(data)).toList();
      });
    } else {
     
    }
  }

  void filterProducts(String category) {
    setState(() {
      selectedCategory = category;
      if (category == 'All') {
        filteredProducts = products;
      } else {
        filteredProducts = products.where((product) => product.productCategory == category).toList();
      }
    });
  }

  void searchProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = products;
      } else {
        filteredProducts = products.where((product) => product.productName.toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider(
      create: (context) => CartModel(userId: widget.userId),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: TopBar(userId: widget.userId, onSearch: searchProducts),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purpleAccent, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCategoryButton('All'),
                      _buildCategoryButton('Horror'),
                      _buildCategoryButton('Science'),
                      _buildCategoryButton('Science Fiction'),
                      _buildCategoryButton('Fantasy'),
                      _buildCategoryButton('Crime'),
                      _buildCategoryButton('Comics'),
                      _buildCategoryButton('Figures'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ElevatedButton(
                          onPressed: () => fetchTopSellers(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          child: Text(
                            "Top Sellers",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: screenWidth > 600 ? 4 : 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductInfoPage(
                              productId: filteredProducts[index].productId,
                              productName: filteredProducts[index].productName,
                              productPrice: filteredProducts[index].productPrice,
                              productCategory: filteredProducts[index].productCategory,
                              productImage: filteredProducts[index].productImage,
                              userId: widget.userId,
                            ),
                          ),
                        );
                      },
                      child: ProductCard(product: filteredProducts[index]),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () => filterProducts(category),
        style: ElevatedButton.styleFrom(
          primary: selectedCategory == category ? Colors.deepPurple : Colors.white,
          onPrimary: selectedCategory == category ? Colors.white : Colors.purple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        child: Text(
          category,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class Product {
  final int productId;
  final String productName;
  final double productPrice;
  final String productCategory;
  final String productImage;
  final int popularity;

  Product({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productCategory,
    required this.productImage,
    required this.popularity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'],
      productName: json['productName'],
      productPrice: json['productPrice'],
      productCategory: json['productCategory'],
      productImage: json['productImage'],
      popularity: json['popularity'],
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center( 
              child: Image.network(
                product.productImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.productName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '\$${product.productPrice.toString()}',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
