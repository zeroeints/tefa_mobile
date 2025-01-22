import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../screens/home_screen.dart';
import '../screens/order_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/profile_screen.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    OrderScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
       
        child: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            SalomonBottomBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
              selectedColor: Colors.blue.shade500,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.shopping_bag),
              title: Text("Order"),
              selectedColor: Colors.blue.shade700,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.question_answer),
              title: Text("Chat"),
              selectedColor: Colors.blue.shade900,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.person),
              title: Text("Profile"),
              selectedColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
