import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  final List<String> imagePaths = [
    "assets/images/WhatsApp Image 2025-01-24 at 09.27.00.jpeg",
    "assets/images/WhatsApp Image 2025-01-24 at 09.27.35.jpeg",
    "assets/images/WhatsApp Image 2025-01-24 at 09.28.29.jpeg",
  ];

  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendFeedback(BuildContext context) async {
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
        Uri.parse('http://localhost:8080/api/feedback'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'message': _messageController.text}),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  'Pesan Terkirim',
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
        _messageController.clear();
      } else {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${responseData['message']}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send feedback')),
      );
    } finally {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/Logo JTI 1.png', // Path gambar lokal
                  width: 40, // Ukuran gambar
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          automaticallyImplyLeading: false,
          bottom: TabBar(
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Kontak'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // Existing Content
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              // Main Title
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  children: [
                                    TextSpan(
                                        text:
                                            "Solusi Software yang Tepat untuk"),
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: Image.asset(
                                        "assets/images/Untitled_design__2_-removebg-preview-min.webp",
                                        width: 60,
                                        height: 60,
                                      ),
                                    ),
                                    TextSpan(text: "Bisnis Anda"),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Subtitle
                              Text(
                                "Agensi berdedikasi yang menghadirkan solusi perangkat lunak inovatif untuk hasil berdampak.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Portfolio Section
                  const SizedBox(height: 50),
                  // Text(
                  //   "Portfolio",
                  //   style: TextStyle(
                  //     fontSize: 28,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.black87,
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 250.0,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      pauseAutoPlayOnTouch: false,
                      viewportFraction: 1.0,
                      enlargeCenterPage: true,
                    ),
                    items: imagePaths.map((path) {
                      return Builder(
                        builder: (BuildContext context) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                             child: Image.asset(
                              path,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 50),
                  // About Us Section
                  Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          "assets/images/Untitled design (3)-min.webp",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 60.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tentang Kami",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Tefa adalah pusat inovasi dalam pembuatan perangkat lunak yang menghubungkan pendidikan dengan industri.",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Kami menciptakan perangkat lunak kreatif yang menarik dan mengutamakan kepuasan pelanggan.",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  // Why Us Section
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 36.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Title Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              Text(
                                "Mengapa Kami",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Kami menggabungkan keahlian para ahli dengan semangat mahasiswa berbakat untuk memberikan hasil terbaik yang memenuhi kebutuhan Anda.",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black54),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 36),
                        // Feature Cards
                        Column(
                          children: [
                            FeatureCard(
                              title: "Harga",
                              description:
                                  "Layanan berkualitas tinggi dengan biaya lebih terjangkau dibandingkan layanan komersial lainnya.",
                            ),
                            FeatureCard(
                              title: "Teknologi",
                              description:
                                  "Kami menggunakan alat dan metode modern untuk menghadirkan perangkat lunak yang efisien dan dapat diandalkan.",
                            ),
                            FeatureCard(
                              title: "Kualitas",
                              description:
                                  "Kami menggabungkan keahlian para ahli berpengalaman dan kreativitas mahasiswa berbakat untuk memberikan hasil terbaik yang sesuai dengan kebutuhan bisnis Anda.",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // const SizedBox(height: 36),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 5, right: 5), // Margin-top: 5em
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 40.0), // Padding: py-5
                      child: Column(
                        children: [
                          // Header Section
                          Column(
                            children: [
                              Text(
                                "Layanan Kami",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.color,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Apa yang bisa kami lakukan",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          SizedBox(height: 40),

                          // Service Items
                          ..._buildServiceItems(context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Column(
                  children: [
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
                            'Kontak',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Masukan Anda sangat berharga bagi kami untuk terus berkembang dan memberikan layanan terbaik. Isilah formulir di bawah ini untuk menyampaikan opini, kritik, atau saran Anda.',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _messageController,
                            maxLines: 6,
                            decoration: InputDecoration(
                              labelText: 'Pesan',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () => _sendFeedback(context),
                            style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              side: BorderSide(
                                  color: Colors
                                      .blue.shade900), // Ubah warna border
                              backgroundColor: Color(0xFF002147),
                              foregroundColor:
                                  Colors.white, // Warna teks tombol
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                            ),
                            child: _isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text('Send'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Widget> _buildServiceItems(BuildContext context) {
  final services = [
    {
      "title": "Website",
      "description":
          "Kami menciptakan situs web untuk bisnis Anda yang pastinya terpercaya dan terjamin kualitasnya.",
      "image": "assets/images/WhatsApp Image 2025-01-24 at 09.29.45.jpeg",
    },
    {
      "title": "Mobile Apps",
      "description":
          "Kami menciptakan aplikasi mobile untuk bisnis Anda yang pastinya terpercaya dan terjamin kualitasnya.",
      "image": "assets/images/WhatsApp Image 2025-01-24 at 09.29.56.jpeg",
    },
    {
      "title": "Desktop Apps",
      "description":
          "Kami menciptakan aplikasi desktop untuk bisnis Anda yang pastinya terpercaya dan terjamin kualitasnya.",
      "image": "assets/images/WhatsApp Image 2025-01-24 at 09.30.09.jpeg",
    },
  ];

  return services.map((service) {
    final isImageFirst = service["title"] != "Mobile Apps";

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gambar di sisi kiri jika bukan "Mobile Apps"
            if (isImageFirst) _buildImage(service["image"]!),

            // Teks
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

            // Gambar di sisi kanan jika "Mobile Apps"
            if (!isImageFirst) _buildImage(service["image"]!),
          ],
        ),
        SizedBox(height: 40),
      ],
    );
  }).toList();
}

// Fungsi untuk membangun widget gambar dari lokal
Widget _buildImage(String imagePath) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8.0),
    child: Image.asset(
      imagePath,
      fit: BoxFit.cover,
      width: 150,  // Sesuaikan ukuran gambar
      height: 150,
    ),
  );
}



class FeatureCard extends StatelessWidget {
  final String title;
  final String description;

  const FeatureCard({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 16), // Margin
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
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

class ProjectCard extends StatelessWidget {
  final String imageUrl;
  final String badgeText;
  final String title;
  final String description;

  const ProjectCard({
    Key? key,
    required this.imageUrl,
    required this.badgeText,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width > 600
          ? (MediaQuery.of(context).size.width - 48) / 2
          : double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.network(
              imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Description
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
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
