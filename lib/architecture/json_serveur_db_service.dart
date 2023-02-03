import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;

import 'db_service.dart';
import '../models/product.dart';

class JsonServerDBService implements DBService {
  /// URL du Json-Server (Attention : pour les serveur qui est simulé)
  final String url = 'http://10.0.2.2:3000';

  @override
  Future<List<Product>> getProduct() async {
    // await Future.delayed(const Duration(seconds: 2));

    final products = <Product>[];

    final response = await http.get(Uri.parse('$url/products'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data != null) {
        for (Map<String, dynamic> v in data) {
          products.add(Product.fromJson(v).copyWith(id: v['id']));
        }
        return products;
      }
    } else {
      developer.log(response.body);
    }
    return [];
  }

  @override
  Future<Product> addProduct(Product product) async {
    // await Future.delayed(const Duration(seconds: 2));

    final response = await http.post(
      Uri.parse('$url/products'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        product.toJson(),
      ),
    );

    return product.copyWith(id: jsonDecode(response.body)['id']);
  }

  @override
  Future<Product> updateProduct(Product updatedProduct) async {
    // await Future.delayed(const Duration(seconds: 2));

    await http.patch(
      Uri.parse('$url/products/${updatedProduct.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        updatedProduct.toJson(),
      ),
    );
    return updatedProduct;
  }

  @override
  Future<void> deleteProduct(String id) async {
    await http.delete(Uri.parse('$url/products/$id'));
  }
}
