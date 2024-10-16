class Product {
  String id;
  String name;
  String category;
  double price;

  Product({required this.id, required this.name, required this.category, required this.price});

  factory Product.fromMap(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'price': price,
    };
  }
}
