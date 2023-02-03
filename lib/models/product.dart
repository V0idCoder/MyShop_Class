class Product {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl});

  ///base() --> objet vide pour l'usage du formulaire
  factory Product.base() {
    return Product(
      id: null,
      title: '',
      description: '',
      price: 0.0,
      imageUrl: '',
    );
  }

  Product copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  String toString() {
    return "{\n\tid: $id\n\ttitle: $title\n\tdescription: $description\n\tprice: $price\n\timageUrl: $imageUrl}";
  }
}
