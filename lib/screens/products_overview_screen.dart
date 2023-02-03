import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/product_item.dart';

class ProductsOverviewScreen extends StatelessWidget {
  const ProductsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loadedProducts = Provider.of<ProductsProvider>(context).items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: loadedProducts.length,
        itemBuilder: (context, index) => ProductItem(
          id: loadedProducts[index].id!, //on est sûr qu'il y aura un id : !
          title: loadedProducts[index].title,
          imageUrl: loadedProducts[index].imageUrl,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }
}
