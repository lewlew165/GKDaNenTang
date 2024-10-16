import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addProduct(Product product) {
    return _db.collection('products').doc(product.id).set(product.toMap());
  }

  Future<void> updateProduct(Product product) {
    return _db.collection('products').doc(product.id).update(product.toMap());
  }

  Future<void> deleteProduct(String id) {
    return _db.collection('products').doc(id).delete();
  }

  Stream<List<Product>> getProducts() {
    return _db.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromMap(doc.data(), doc.id)).toList();
    });
  }
}
