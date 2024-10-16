import 'package:admin_app/screens/login_screen.dart';
import 'package:admin_app/screens/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ProductScreen(),
    );
  }
}
