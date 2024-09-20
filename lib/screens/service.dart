import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:red/models/service.dart';
import 'package:red/screens/book_service.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen>
    with AutomaticKeepAliveClientMixin {
  late Future<List<Service>> _services;
  List<Service> _allServices = [];
  List<Service> _filteredServices = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterServices);
    _services = fetchServices().then((services) {
      setState(() {
        _allServices = services;
        _filteredServices = services;
      });
      return services;
    });
  }

  Future<List<Service>> fetchServices() async {
    final response = await http.get(
      Uri.parse('http://feniceshieldchemical.bwsoft.in/api/api/services/'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Service.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

  void _filterServices() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredServices = _allServices.where((service) {
        return service.name.toLowerCase().contains(query) ||
            service.description.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Services',
          style: TextStyle(
              color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
              child: TextField(
                cursorColor: const Color.fromARGB(255, 49, 121, 46),
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: "Search the service",
                  border: InputBorder.none,
                  suffixIcon: Icon(
                    Icons.search,
                    size: 25,
                    color: Color.fromARGB(255, 49, 121, 46),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: FutureBuilder<List<Service>>(
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
                    return const Center(child: Text('No services found.'));
                  } else {
                    final services = snapshot.data!;
                    final items = _searchController.text.isNotEmpty
                        ? _filteredServices
                        : services;
                    return ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 15.0),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final service = items[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 5, left: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 191, 230, 188),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BookService(
                                            serviceId: service.id,
                                            serviceName: service.name,
                                          ))),
                              title: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  service.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              subtitle: Text(service.description),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
