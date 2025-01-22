import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  
  List<dynamic> chatData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChatData();
  }

  Future<void> fetchChatData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Token tidak ditemukan. Harap login ulang.')),
        );
        return;
      }

      final response = await http.get(
        Uri.parse('http://localhost:8080/api/order'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        setState(() {
          chatData = responseData['data'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load chat data');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
       ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  'Gagal Membuat chat',
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

  Future<void> fetchChatDetail(String idOrder) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Token tidak ditemukan. Harap login ulang.')),
        );
        return;
      }

      final response = await http.get(
        Uri.parse('http://localhost:8080/api/order/$idOrder'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        showDetailModal(responseData['data']); // Tampilkan modal
      } else {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Gagal mendapatkan detail: ${responseData['message']}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching details: $error')),
      );
    }
  }

  void showDetailModal(Map<String, dynamic> details) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detail Pesanan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text('ID Order: ${details['id_order']}'),
              Text('Title: ${details['title']}'),
              Text('Status: ${details['status']}'),
              Text('Types: ${details['types']}'),
              Text('Description: ${details['description']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup modal
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void showDeleteConfirmation(String idOrder) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus order ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                deleteChat(idOrder); // Hapus chat
              },
              child: Text(
                'Hapus',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteChat(String idOrder) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Token tidak ditemukan. Harap login ulang.')),
        );
        return;
      }

      final response = await http.delete(
        Uri.parse('http://localhost:8080/api/order'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'id_order': idOrder}),
      );

      if (response.statusCode == 201) {
        setState(() {
          chatData.removeWhere((chat) => chat['id_order'] == idOrder);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  'berhasil menghapus order',
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
      } else {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  'Gagal Menghapus order',
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
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting chat: $error')),
      );
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
              'chat',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF002147),
              ),
            ),
          ],
        ),
        
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black54),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Fitur pencarian belum tersedia")),
              );
            },
          ),
        ],
        iconTheme: IconThemeData(color: Colors.black54),
      ),
      backgroundColor: Colors.grey.shade100,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : chatData.isEmpty
              ? Center(child: Text("Tidak ada pesanan"))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 8.0),
                  itemCount: chatData.length,
                  itemBuilder: (context, index) {
                    final chat = chatData[index];
                    return _buildChatItem(
                      context,
                      idOrder: chat['id_order'],
                      idUser: chat['id_user'],
                      name: chat['title'],
                      lastMessage:
                          "Status: ${chat['status']} - Types: ${chat['types']}",
                      status: chat['status'],
                    );
                  },
                ),
    );
  }

  Widget _buildChatItem(
    BuildContext context, {
    required String idOrder,
    required String idUser,
    required String name,
    required String lastMessage,
    required String status,
  }) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        lastMessage,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: PopupMenuButton(
        onSelected: (value) {
          if (value == 'detail') {
            fetchChatDetail(idOrder);
          } else if (value == 'delete') {
            showDeleteConfirmation(idOrder);
          }
        },
        itemBuilder: (context) {
          final items = <PopupMenuEntry<String>>[
            PopupMenuItem(
              value: 'detail',
              child: Text('Detail'),
            ),
          ];
          if (status == "Pending") {
            items.add(PopupMenuItem(
              value: 'delete',
              child: Text('Hapus'),
            ));
          }
          return items;
        },
      ),
      onTap: () {
        if (status == "Pending") {
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  'Order masih pending',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            backgroundColor: Colors.orange,
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetailScreen(
                userName: name,
                idUser: idUser,
                idOrder: idOrder,
              ),
            ),
          );
        }
      },
    );
  }
}
