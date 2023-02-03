import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'architecture/json_serveur_db_service.dart';
import 'providers/products_provider.dart';
import 'screens/add_edit_product_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/products_overview_screen.dart';
import 'screens/user_products_screen.dart';

void main() {
  runApp(MyShop());
}

class MyShop extends StatelessWidget {
  final JsonServerDBService dbService = JsonServerDBService();

  MyShop({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductsProvider(dbService),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyShop',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                .copyWith(secondary: Colors.deepOrange)),
        routes: {
          '/': (context) => const ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (context) =>
              const ProductDetailScreen(),
          UserProductsScreen.routeName: (context) => const UserProductsScreen(),
          AddEditProductScreen.routeName: (context) =>
              const AddEditProductScreen(),
        },
      ),
    );
  }
}
