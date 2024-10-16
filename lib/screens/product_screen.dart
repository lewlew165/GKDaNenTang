import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/firestore_service.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  List<Product> _products = [];
  String? _editingProductId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Tên Sản Phẩm')),
            TextField(controller: _categoryController, decoration: InputDecoration(labelText: 'Loại sản phẩm')),
            TextField(controller: _priceController, decoration: InputDecoration(labelText: 'Giá sản phẩm'), keyboardType: TextInputType.number),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addOrUpdateProduct,
              child: Text(_editingProductId == null ? 'Thêm sản phẩm' : 'Cập nhật sản phẩm'),
            ),
            SizedBox(height: 20), 
            Text(
              'Danh sách sản phẩm',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: StreamBuilder<List<Product>>(
                stream: _firestoreService.getProducts(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                  _products = snapshot.data!;
                  return ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tên SP: ${_products[index].name}'),
                                  Text('Loại SP: ${_products[index].category}'),
                                  Text('Giá SP: \$${_products[index].price}'),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => _editProduct(_products[index]),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => _deleteProduct(_products[index].id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addOrUpdateProduct() {
    if (_nameController.text.isNotEmpty && _categoryController.text.isNotEmpty && _priceController.text.isNotEmpty) {
      if (_editingProductId == null) {
        // Thêm sản phẩm mới
        Product newProduct = Product(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: _nameController.text,
          category: _categoryController.text,
          price: double.parse(_priceController.text),
        );
        _firestoreService.addProduct(newProduct);
      } else {
        // Cập nhật sản phẩm
        Product updatedProduct = Product(
          id: _editingProductId!,
          name: _nameController.text,
          category: _categoryController.text,
          price: double.parse(_priceController.text),
        );
        _firestoreService.updateProduct(updatedProduct);
        _editingProductId = null; // Reset sau khi cập nhật
      }
      _clearInputs();
      setState(() {}); // Cập nhật giao diện
    }
  }

  void _clearInputs() {
    _nameController.clear();
    _categoryController.clear();
    _priceController.clear();
  }

  void _editProduct(Product product) {
    _editingProductId = product.id;
    _nameController.text = product.name;
    _categoryController.text = product.category;
    _priceController.text = product.price.toString();
    setState(() {}); // Cập nhật giao diện nếu cần
  }

  void _deleteProduct(String productId) {
    _firestoreService.deleteProduct(productId);
  }
}
