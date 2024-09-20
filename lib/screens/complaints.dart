import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:red/widgets/arrow.dart';
import 'package:red/widgets/button.dart';
import 'package:red/widgets/heading_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Complaints extends StatefulWidget {
  const Complaints({super.key});

  @override
  State<Complaints> createState() => _ComplaintsState();
}

class _ComplaintsState extends State<Complaints> {
  bool isUpdating = false; // For complaint submission state
  final TextEditingController _commentsController = TextEditingController();

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  Future<void> _submitComplaint() async {
    if (_commentsController.text.isEmpty) {
      // Show error if the complaint text is empty
      Fluttertoast.showToast(msg: "Please enter your comments!");
      return;
    }

    setState(() {
      isUpdating = true;
    });

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? id = prefs.getInt('id');
      final response = await http.post(
        Uri.parse(
            'http://feniceshieldchemical.bwsoft.in/api/api/queries-feedback/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"user": id, "description": _commentsController.text}),
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Response body: ${response.body}');
      }
      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            title: const Center(child: HeadingText(text: 'Submitted')),
            content: Image.asset(
              'assets/images/complaint done.png',
              height: 250,
              width: 250,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
              ),
            ],
          ),
        );
        _commentsController.clear();
      } else {
        Fluttertoast.showToast(
            msg: "Failed to submit complaint: ${response.body}");
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
      Fluttertoast.showToast(msg: "An error occurred. Please try again.");
    } finally {
      setState(() {
        isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Center(
                          child: HeadingText(text: 'Complaints & Queries')),
                      const SizedBox(height: 10),
                      Image.asset(
                        'assets/images/complaints.png',
                        height: 250,
                        width: 250,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Enter your complaints & queries to improve our service!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(12),
                        child: TextFormField(
                          controller: _commentsController,
                          cursorColor: const Color.fromARGB(255, 49, 121, 46),
                          maxLines: 5,
                          style:
                              const TextStyle(fontSize: 18, color: Colors.grey),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(16),
                            hintText: 'Enter Your comments!',
                            hintStyle: const TextStyle(
                                fontSize: 18, color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 49, 121, 46),
                                  width: 2),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomElevatedButton(
                        isLoading: isUpdating,
                        onPressed: _submitComplaint,
                        text: 'Send',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const PositionedBackButton(),
          ],
        ),
      ),
    );
  }
}
