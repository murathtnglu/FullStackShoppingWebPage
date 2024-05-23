import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'register_page.dart';
import 'login_page.dart';
import 'shopping_cart_page.dart';
import 'cart_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final int userId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) {
              return HomePage(userId: userId);
            },
          );
        }
        if (settings.name == '/cart') {
          final int userId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) {
              return ShoppingCartPage(userId: userId);
            },
          );
        }
        return null;
      },
    );
  }
}