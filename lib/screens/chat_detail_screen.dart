import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatDetailScreen extends StatefulWidget {
  final String userName;
  final String idUser;
  final String idOrder;

  ChatDetailScreen({
    required this.userName,
    required this.idUser,
    required this.idOrder,
  });

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
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
        Uri.parse('http://localhost:8080/api/getMessage/${widget.idOrder}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 401) {
        // Unauthorized
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Token tidak valid. Harap login ulang.')),
        );
        await prefs.remove('token');
        Navigator.of(context).pushReplacementNamed('/login');
        return;
      }

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        setState(() {
          _messages = List<Map<String, dynamic>>.from(responseData['data'])
              .map((message) {
            return {
              'message': message['message'],
              'isSentByUser': message['id_sender'] == widget.idUser,
            };
          }).toList();
          isLoading = false;
        });
      } else {
        // final responseData = jsonDecode(response.body);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //       content: Text('Gagal memuat pesan: ${responseData['message']}')),
        // );
        setState(() {
          isLoading = false;
          _messages = []; // Kosongkan daftar pesan
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Pesan tidak boleh kosong')),
      // );
      return;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Token tidak ditemukan. Harap login ulang.')),
        );
        return;
      }

      final response = await http.post(
        Uri.parse('http://localhost:8080/api/sendMessage'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id_order': widget.idOrder,
          'message': _messageController.text,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        setState(() {
          _messages.insert(0, {
            'message': _messageController.text,
            'isSentByUser': true,
          });
          _messageController.clear();
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
                  'Gagal Mengirim pesan',
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
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            SizedBox(width: 10),
            Text(
              widget.userName,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.black54),
      ),
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? Center(
                        child: Text(
                          "Belum ada pesan",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          final isSentByUser = message['isSentByUser'];
                          return Align(
                            alignment: isSentByUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 12),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 14),
                              decoration: BoxDecoration(
                                color: isSentByUser ? Colors.blue : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                  bottomLeft: isSentByUser
                                      ? Radius.circular(12)
                                      : Radius.circular(0),
                                  bottomRight: isSentByUser
                                      ? Radius.circular(0)
                                      : Radius.circular(12),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Text(
                                message['message'],
                                style: TextStyle(
                                  color: isSentByUser
                                      ? Colors.white
                                      : Colors.black87,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      hintText: "Tulis pesan...",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFF002147),
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
