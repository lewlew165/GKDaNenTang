import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'product_screen.dart'; // Import màn hình quản lý sản phẩm

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Tạo instance FirebaseAuth
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  Future<void> _login() async {
    try {
      // Đăng nhập với Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        // Nếu đăng nhập thành công, chuyển đến màn hình quản lý sản phẩm
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ProductScreen()),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString(); // Ghi nhận lỗi nếu có
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đăng Nhập')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Mật khẩu'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login, // Gọi hàm đăng nhập
              child: Text('Đăng Nhập'),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
