import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:red/widgets/arrow.dart';
import 'package:red/widgets/heading_text.dart';

class HistoryService extends StatefulWidget {
  const HistoryService({super.key});

  @override
  State<HistoryService> createState() => _HistoryServiceState();
}

class _HistoryServiceState extends State<HistoryService> {
  List<dynamic> serviceHistory = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchServiceHistory();
  }

  Future<void> fetchServiceHistory() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? refreshToken = prefs.getString('refresh_token');

      if (refreshToken == null) {
        setState(() {
          isLoading = false;
          errorMessage = 'No refresh token found. Please login again.';
        });
        return;
      }
      final accessToken = await refreshAccessToken(refreshToken);

      if (accessToken == null) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to refresh access token.';
        });
        return;
      }

      await getServiceHistory(accessToken);
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error occurred: $e';
      });
      if (kDebugMode) {
        print('Error occurred: $e');
      }
    }
  }

  Future<String?> refreshAccessToken(String refreshToken) async {
    final url = Uri.parse(
        'http://feniceshieldchemical.bwsoft.in/api/api/token/refresh/');
    final response = await http.post(
      url,
      body: {
        'refresh': refreshToken,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newAccessToken = data['access'];
      return newAccessToken;
    } else {
      return null;
    }
  }

  Future<void> getServiceHistory(String accessToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? id = prefs.getInt('id');
    final url = Uri.parse(
        'http://feniceshieldchemical.bwsoft.in/api/api/booking-history/$id/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (kDebugMode) {
        print('Full data received: $data');
      }

      setState(() {
        if (data is List) {
          serviceHistory = data;
        } else {
          serviceHistory = [];
        }
        if (kDebugMode) {
          print('Service History Length: ${serviceHistory.length}');
        }
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to fetch service history.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const PositionedBackButton(),
        title: const Text(
          'Service History',
          style: TextStyle(
              color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Loading and Error States
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 49, 121, 46),
                ),
              )
            else if (errorMessage.isNotEmpty)
              Center(
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else if (serviceHistory.isEmpty)
              const Center(
                child: Text('No service history available.'),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: serviceHistory.length,
                  itemBuilder: (context, index) {
                    final service = serviceHistory[index];
                    final serviceName = (service['service'] != null &&
                            service['service'] is Map &&
                            service['service']['name'] != null &&
                            service['service']['name'] is String)
                        ? service['service']['name']
                        : 'No Title';
                    final status =
                        service['status'] != null && service['status'] is String
                            ? service['status']
                            : 'No Status Available';

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                          title: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              serviceName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          // subtitle: Text(status),
                          trailing: Text(status),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
