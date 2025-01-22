import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'EditProfileScreen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _username = '';
  String _email = '';
  String _photoUrl = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token =
          prefs.getString('token'); // Mendapatkan token dari SharedPreferences

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Token tidak ditemukan. Harap login ulang.')),
        );
        return;
      }

      final response = await http.get(
        Uri.parse(
            'http://localhost:8080/api/user'), // URL API untuk mendapatkan data pengguna
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', 
        },
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body); // Decode data JSON dari API
       setState(() {
          _username = data['data']['username'] ?? 'Username tidak tersedia';
          _email = data['data']['email'] ?? 'Email tidak tersedia';
          _photoUrl = 'https://res.cloudinary.com/dnppmhczy/image/upload/v1734949243/${data['data']['photo']}';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  'Gagal Memuat penguna',
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching data: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Profil
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF002147),
                        const Color.fromARGB(255, 0, 0, 0)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                Positioned(
                  top: 150,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 15,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: _photoUrl.isNotEmpty
                              ? NetworkImage(_photoUrl)
                              : AssetImage('assets/images/user-1.jpg')
                                  as ImageProvider,
                        ),
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        _username.isNotEmpty ? _username : "Nama Pengguna",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        _email.isNotEmpty ? _email : "user@example.com",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 80), // Jarak agar avatar tidak terlalu atas

            // List Menu Profil
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.person,
                    title: "Edit Profil",
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfileScreen()),
                      );

                      if (result == true) {
                        _fetchUserData(); 
                      }
                    },
                  ),
                  // Divider(),
                  // _buildMenuItem(
                  //   icon: Icons.settings,
                  //   title: "Pengaturan",
                  //   onTap: () {
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       SnackBar(content: Text("Navigasi ke Pengaturan")),
                  //     );
                  //   },
                  // ),
                  Divider(),
                  _buildMenuItem(
                    icon: Icons.logout,
                    title: "Logout",
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi Menu Item
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Color.fromARGB(255, 0, 34, 72), size: 28),
      title: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
      onTap: onTap,
    );
  }

  // Fungsi Logout
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Konfirmasi Logout"),
        content: Text("Apakah Anda yakin ingin logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await _logout(context); // Logout pengguna
            },
            child: Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pop(context);
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
   ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  'Anda telah keluar',
                  style: TextStyle(
                    fontSize: 12,
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
  }
}
