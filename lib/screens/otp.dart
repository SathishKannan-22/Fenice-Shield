// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:red/screens/login.dart';
import 'package:red/widgets/side_button.dart';
import 'package:red/widgets/heading_text.dart';
import 'package:http/http.dart' as http;

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final int _otpLength = 6;
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());

  Future<void> verifyOTP() async {
    String otp = _controllers.map((controller) => controller.text).join();

    final response = await http.post(
      Uri.parse('http://feniceshieldchemical.bwsoft.in/api/api/verify-otp/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'otp': otp,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (kDebugMode) {
        print('$data');
      }
      _showError('');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP')),
      );
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        title: const Center(child: HeadingText(text: 'Verification success')),
        content: Image.asset(
          'assets/images/otpverify.png',
          height: 250,
          width: 250,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Enter OTP sent to your mobile number',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ],
            ),
          ),
          Positioned(
            top: -40,
            right: -40,
            child: Image.asset(
              'assets/images/Group 7.png',
              width: 300,
              height: 300,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/otp.png',
                      height: 300,
                      width: 300,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            HeadingText(text: 'Enter OTP'),
                            Text(
                              'Enter OTP to sign up',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(_otpLength, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 5, left: 5),
                          child: SizedBox(
                            width: 40,
                            height: 50,
                            child: Material(
                              borderRadius: BorderRadius.circular(10),
                              elevation: 4.0,
                              child: TextField(
                                cursorColor:
                                    const Color.fromARGB(255, 49, 121, 46),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                controller: _controllers[index],
                                maxLength: 1,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  counterText: '',
                                  fillColor: Colors.transparent,
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty &&
                                      index < _otpLength - 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                  if (value.isEmpty && index > 0) {
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SideButton(
                          text: 'Verify',
                          onPressed: () {
                            verifyOTP();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -40,
            right: -40,
            child: Image.asset(
              'assets/images/Group 7.png',
              width: 300,
              height: 300,
            ),
          ),
          Positioned(
              top: 20,
              left: 20,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.grey,
                    size: 42,
                  ))),
        ],
      ),
    );
  }
}
