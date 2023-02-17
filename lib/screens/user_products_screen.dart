import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
//import 'add_edit_product_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user_products';

  const UserProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductsProvider>(context);

    void deleteProduct(String id) {
      //Mémoriser le produit ET son index
      final existingProduct = provider.findById(id);
      final existingProductIndex = provider.findIndexById(id);
      provider.deleteProduct(id);
      //Préparer la SnackBar et l'afficher
      final snackBar = SnackBar(
        content: const Text('Deleting product...'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            provider.insertProduct(existingProductIndex, existingProduct);
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        centerTitle: true,
        actions: [
          IconButton(
            //Ajout de produit
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddEditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: provider.items.length,
          itemBuilder: (_, index) => Column(
            children: [
              UserProductItem(
                id: provider.items[index].id ?? '',
                title: provider.items[index].title,
                imageUrl: provider.items[index].imageUrl,
                deleteMethod: deleteProduct,
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
