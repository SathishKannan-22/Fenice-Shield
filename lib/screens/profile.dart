// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:red/screens/complaints.dart';
import 'package:red/screens/history_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:red/screens/forgot_password.dart';
import 'package:red/screens/login.dart';
import 'package:red/screens/profile_edit.dart';
import 'package:red/widgets/list_tile.dart';
import 'package:red/widgets/heading_text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  Map<String, dynamic>? profileData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? id = prefs.getInt('id');

      if (id == null) {
        throw Exception("ID or access token is missing");
      }

      final response = await http.get(
        Uri.parse('http://feniceshieldchemical.bwsoft.in/api/api/profile/$id/'),
      );

      if (response.statusCode == 200) {
        setState(() {
          profileData = json.decode(response.body);
          isLoading = false;
        });
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized access. Please log in again.");
      } else if (response.statusCode == 404) {
        throw Exception("Profile not found.");
      } else {
        throw Exception("Failed to load profile data.");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        title: const Center(child: HeadingText(text: 'Logout')),
        content: Image.asset(
          'assets/images/logout.png',
          height: 250,
          width: 250,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(
                        color: Color.fromARGB(255, 49, 121, 46),
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.remove('id');
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(
                        color: Color.fromARGB(255, 49, 121, 46),
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const HeadingText(text: 'Profile'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Color.fromARGB(255, 49, 121, 46),
            ))
          : errorMessage != null
              ? Center(
                  child: Text(errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 18)))
              : profileData != null
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Material(
                              elevation: 15,
                              shape: const CircleBorder(),
                              child: CircleAvatar(
                                radius: 90,
                                backgroundColor:
                                    const Color.fromARGB(255, 191, 230, 188),
                                child: Text(
                                  profileData!['username']![0].toUpperCase(),
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 49, 121, 46),
                                    fontSize: 100,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(5, 5),
                                        blurRadius: 10,
                                        color:
                                            Color.fromARGB(115, 100, 100, 100),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text('${profileData!['username']}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Text(
                              '${profileData!['address']}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            CustomListTile(
                              text: 'Edit profile',
                              icon: Icons.mode_edit_outlined,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const EditProfile()));
                              },
                            ),
                            CustomListTile(
                              text: 'Change password',
                              icon: Icons.mode_edit_outlined,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotPassword()));
                              },
                            ),
                            CustomListTile(
                              text: 'Service history',
                              icon: Icons.mode_edit_outlined,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HistoryService()));
                              },
                            ),
                            CustomListTile(
                              text: 'Complaints & Quaries',
                              icon: Icons.mode_edit_outlined,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Complaints()));
                              },
                            ),
                            CustomListTile(
                              text: 'Logout',
                              icon: Icons.mode_edit_outlined,
                              onTap: () {
                                _showError('');
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  : const Center(child: Text('Profile data not found')),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
