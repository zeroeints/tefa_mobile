import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContactTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 80.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 300,
              child: WebView(
                initialUrl: 'https://your-location-url.com',
                javascriptMode: JavascriptMode.unrestricted,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 12,
                    offset: Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Your input is invaluable for us to continue to grow and provide the best service. Fill out the form below to express your opinions, criticisms, or suggestions.',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    maxLines: 6,
                    decoration: InputDecoration(
                      labelText: 'Message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      side: BorderSide(color: Theme.of(context).primaryColor),
                      backgroundColor: Colors.transparent,
                      foregroundColor: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    ),
                    child: Text('Send'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
