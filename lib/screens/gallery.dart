import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:red/screens/image.dart';
import 'package:red/widgets/heading_text.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen>
    with AutomaticKeepAliveClientMixin {
  late Future<List<Map<String, dynamic>>> _services;

  @override
  void initState() {
    super.initState();
    _services = fetchServices();
  }

  Future<List<Map<String, dynamic>>> fetchServices() async {
    final response = await http.get(Uri.parse(
        'http://feniceshieldchemical.bwsoft.in/api/api/gallery-images/'));

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> services = [];

        // Iterate over the map entries
        data.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            final String serviceName = value['service_name'] as String;
            final List<dynamic>? images = value['images'] as List<dynamic>?;

            if (images != null) {
              List<String> imageUrls = images
                  .where((item) =>
                      item is Map<String, dynamic> && item.containsKey('image'))
                  .map((item) => item['image'] as String)
                  .toList();

              services.add({
                'serviceName': serviceName,
                'imageUrls': imageUrls,
              });
            }
          }
        });

        return services;
      } catch (e) {
        throw Exception('Failed to parse JSON: $e');
      }
    } else {
      throw Exception('Failed to load services');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const HeadingText(text: 'Gallery'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _services,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Color.fromARGB(255, 49, 121, 46),
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No services found'));
          } else {
            final services = snapshot.data!;
            return ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                final serviceName = service['serviceName'] as String;
                final imageUrls = service['imageUrls'] as List<String>;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serviceName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: imageUrls.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Container(
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade200,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PictureScreen(
                                                      imageUrl:
                                                          imageUrls[index])));
                                    },
                                    child: Image.network(
                                      imageUrls[index],
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Center(
                                            child:
                                                Text('Failed to load image'));
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
