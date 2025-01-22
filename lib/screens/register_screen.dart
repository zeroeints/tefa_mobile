import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    const String apiUrl = 'http://localhost:8080/api/register';

    final Map<String, dynamic> requestData = {
      'username': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'password': _passwordController.text.trim(),
      'telp': _telpController.text.trim(),
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      setState(() {
        _isLoading = false;
      });

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registrasi berhasil! Silakan cek email Anda.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ?? 'Gagal melakukan registrasi'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan. Periksa koneksi Anda.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/Logo JTI 1.png',
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 20),
                Text(
                  "Buat Akun Baru",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  controller: _nameController,
                  hintText: 'Masukkan nama lengkap Anda',
                  icon: Icons.person,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  controller: _emailController,
                  hintText: 'Masukkan email Anda',
                  icon: Icons.email,
                  isEmail: true,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  controller: _telpController,
                  hintText: 'Masukkan nomor telepon',
                  icon: Icons.phone,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  controller: _passwordController,
                  hintText: 'Masukkan password Anda',
                  icon: Icons.lock,
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text(
                          "Daftar",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Sudah punya akun? Masuk",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool isEmail = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Field ini tidak boleh kosong';
        }
        if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Masukkan email yang valid';
        }
        return null;
      },
    );
  }
}
