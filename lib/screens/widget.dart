import 'package:flutter/material.dart';
class ServicesSection extends StatelessWidget {
  List<Widget> _buildServiceItems(BuildContext context) {
    final services = [
      {
        "title": "Website",
        "description":
            "We create a website for your business. which is certainly trusted and guaranteed quality",
        "image": "https://www.korsa.io/images/service-3.png",
      },
      {
        "title": "Mobile Apps",
        "description":
            "We create mobile apps for your business. which of course is trusted and guaranteed quality",
        "image": "https://www.korsa.io/images/service-1.png",
      },
      {
        "title": "Desktop Apps",
        "description":
            "We create desktop apps for your business. which of course is trusted and guaranteed quality",
        "image": "https://www.korsa.io/images/service-3.png",
      },
    ];

    return services.map((service) {
      final isImageFirst = service["title"] != "Mobile Apps";

      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image
              if (isImageFirst)
                _buildImage(service["image"]!),

              // Text
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service["title"]!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        service["description"]!,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),

              // Image (if it's the second column)
              if (!isImageFirst)
                _buildImage(service["image"]!),
            ],
          ),
          SizedBox(height: 40),
        ],
      );
    }).toList();
  }

  Widget _buildImage(String imageUrl) {
    return Flexible(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: 200,
          height: 200,
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    
    throw UnimplementedError();
  }
}