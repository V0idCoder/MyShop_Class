import 'package:flutter/material.dart';

import '../architecture/db_service.dart';
import '../models/product.dart';

class ProductsProvider with ChangeNotifier {
  final List<Product> _items = [];

  ProductsProvider(this.dbService);

  final DBService dbService;
  // Product(
  //   id: 'p1',
  //   title: 'Red Shirt',
  //   description: 'A red shirt - it is pretty red!',
  //   price: 29.99,
  //   imageUrl:
  //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  // ),
  // Product(
  //   id: 'p2',
  //   title: 'Trousers',
  //   description: 'A nice pair of trousers.',
  //   price: 59.99,
  //   imageUrl:
  //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  // ),
  // Product(
  //   id: 'p3',
  //   title: 'Yellow Scarf',
  //   description: 'Warm and cozy - exactly what you need for the winter.',
  //   price: 19.99,
  //   imageUrl:
  //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  // ),
  // Product(
  //   id: 'p4',
  //   title: 'A Pan',
  //   description: 'Prepare any meal you want.',
  //   price: 49.99,
  //   imageUrl:
  //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  // ),

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return items.firstWhere(
      (product) => product.id == id,
    );
  }

  Future<void> fetchAndSetProducts() async {
    _items.clear();
    final datas = await dbService.getProduct();
    _items.addAll(datas);
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    //Traiter l'id
    //final newProduct = product.copyWith(id: DateTime.now().toString());
    final newProduct = await dbService.addProduct(product);
    _items.add(newProduct);
    notifyListeners();
  }

  Future<void> updateProduct(Product updatedProduct) async {
    final productIndex =
        _items.indexWhere((product) => product.id == updatedProduct.id);
    if (productIndex >= 0) {
      final newProduct = await dbService.updateProduct(updatedProduct);
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      //Traitement éventuel
    }
  }

  Future<void> deleteProduct(String id) async {
    await dbService.deleteProduct(id);
    _items.removeWhere((product) => product.id == id);
    notifyListeners();
  }

  //Pour l'annulation du delete
  int findIndexById(String id) {
    return _items.indexWhere((product) => product.id == id);
  }

  Future<void> insertProduct(int index, Product product) async {
    final newProduct = await dbService.addProduct(product);
    _items.insert(index, newProduct);
    notifyListeners();
  }
}
