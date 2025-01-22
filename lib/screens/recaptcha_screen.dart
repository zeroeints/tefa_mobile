// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class RecaptchaScreen extends StatelessWidget {
//   final String siteKey;
//   final Function(String) onVerified;

//   RecaptchaScreen({required this.siteKey, required this.onVerified});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('reCAPTCHA')),
//       body: WebView(
//         initialUrl: 'https://www.google.com/recaptcha/api/fallback?k=$siteKey',
//         javascriptMode: JavascriptMode.unrestricted,
//         onPageFinished: (url) {
//           if (url.contains('success')) {
//             // Simulasi token berhasil
//             onVerified('mocked-token'); // Ganti dengan token sebenarnya jika didukung.
//             Navigator.pop(context);
//           }
//         },
//       ),
//     );
//   }
// }
