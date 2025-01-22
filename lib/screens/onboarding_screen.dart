// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class OnboardingScreen extends StatefulWidget {
//   @override
//   _OnboardingScreenState createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;

//   final List<Map<String, String>> _onboardingData = [
//     {
//       "image": "assets/images/onboarding1.png",
//       "title": "Welcome to Our App",
//       "subtitle": "Discover creative solutions for your business needs."
//     },
//     {
//       "image": "assets/images/onboarding2.png",
//       "title": "Collaborate Easily",
//       "subtitle": "Work with teams seamlessly anywhere, anytime."
//     },
//     {
//       "image": "assets/images/onboarding3.png",
//       "title": "Achieve Your Goals",
//       "subtitle": "Turn your ideas into reality with our app."
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           PageView.builder(
//             controller: _pageController,
//             onPageChanged: (index) {
//               setState(() {
//                 _currentPage = index;
//               });
//             },
//             itemCount: _onboardingData.length,
//             itemBuilder: (context, index) {
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     _onboardingData[index]["image"]!,
//                     height: 300,
//                   ),
//                   SizedBox(height: 40),
//                   Text(
//                     _onboardingData[index]["title"]!,
//                     textAlign: TextAlign.center,
//                     style: GoogleFonts.poppins(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                     child: Text(
//                       _onboardingData[index]["subtitle"]!,
//                       textAlign: TextAlign.center,
//                       style: GoogleFonts.poppins(
//                         fontSize: 16,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//           Positioned(
//             bottom: 80,
//             left: 0,
//             right: 0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(
//                 _onboardingData.length,
//                 (index) => buildDot(index, context),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 40,
//             left: 20,
//             right: 20,
//             child: ElevatedButton(
//               onPressed: () {
//                 if (_currentPage == _onboardingData.length - 1) {
//                   // Navigate to Login Screen
//                   Navigator.pushReplacementNamed(context, "/login");
//                 } else {
//                   _pageController.nextPage(
//                     duration: Duration(milliseconds: 300),
//                     curve: Curves.easeInOut,
//                   );
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.blue,
//                 padding: EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: Text(
//                 _currentPage == _onboardingData.length - 1
//                     ? "Get Started"
//                     : "Next",
//                 style: GoogleFonts.poppins(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildDot(int index, BuildContext context) {
//     return AnimatedContainer(
//       duration: Duration(milliseconds: 300),
//       margin: EdgeInsets.symmetric(horizontal: 4),
//       height: 8,
//       width: _currentPage == index ? 24 : 8,
//       decoration: BoxDecoration(
//         color: _currentPage == index ? Colors.blue : Colors.grey,
//         borderRadius: BorderRadius.circular(12),
//       ),
//     );
//   }
// }
