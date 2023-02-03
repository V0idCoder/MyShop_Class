import '../models/product.dart';

abstract class DBService {
  Future<List<Product>> getProduct();
  Future<Product> addProduct(Product product);
  Future<Product> updateProduct(Product updatedProduct);
  Future<void> deleteProduct(String id);
}
