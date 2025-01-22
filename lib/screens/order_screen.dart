import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedTypeId;
  List<Map<String, dynamic>> _projectTypes = [];

  @override
  void initState() {
    super.initState();
    _fetchProjectTypes();
  }

  Future<void> _fetchProjectTypes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return;

      final response = await http.get(
        Uri.parse('http://localhost:8080/api/type'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        setState(() {
          _projectTypes = List<Map<String, dynamic>>.from(data['data']);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _submitOrder() async {
    if (_formKey.currentState!.validate() && _selectedTypeId != null) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return;

      final response = await http.post(
        Uri.parse('http://localhost:8080/api/order'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'judul': _projectNameController.text.trim(),
          'description': _descriptionController.text.trim(),
          'type': [_selectedTypeId],
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  'Order Berhasil',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.all(16),
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Tutup',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  'Gagal Membuat Order',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.all(16),
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Tutup',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        // elevation: 4,
        title: Row(
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/Logo JTI 1.png',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Buat Order',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF002147),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                  _projectNameController, 'Nama Proyek', Icons.work_outline),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: const Color.fromARGB(0, 0, 0, 0)),
                  ),
                ),
                items: _projectTypes.map((type) {
                  return DropdownMenuItem(
                    value: type['id_type'].toString(),
                    child: Text(type['type']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedTypeId = value);
                },
                hint: Text("Pilih tipe proyek"),
              ),
              SizedBox(height: 12),
              _buildTextField(_descriptionController, 'Deskripsi',
                  Icons.description_outlined,
                  maxLines: 4),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _submitOrder,
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    side: BorderSide(
                        color: Colors.blue.shade900), // Ubah warna border
                    backgroundColor: Color(0xFF002147),
                    foregroundColor: Colors.white, // Warna teks tombol
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                  ),
                  child: Text("Kirim",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hint, IconData icon,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(255, 255, 255, 255),
        prefixIcon: Icon(icon, color: Color.fromARGB(255, 10, 0, 40)),
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color.fromARGB(0, 0, 0, 0)),
        ),
      ),
      validator: (value) => value!.isEmpty ? "$hint tidak boleh kosong" : null,
    );
  }
}
