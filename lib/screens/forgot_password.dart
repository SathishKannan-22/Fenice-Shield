// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:red/screens/forgot_otp.dart';
import 'package:red/screens/sign_up.dart';
import 'package:red/widgets/side_button.dart';
import 'package:red/widgets/heading_text.dart';
import 'package:red/widgets/text_field.dart';
import 'package:red/utils/icons.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendOtp() async {
    final String email = _emailController.text;

    if (email.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your email");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse(
          'http://feniceshieldchemical.bwsoft.in/api/api/password-reset/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );
    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "OTP sent to your email");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const ForgotOTP()));
    } else {
      Fluttertoast.showToast(msg: "Failed to send OTP");
    }
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
              children: [
                const Text(
                  'Don’t have an account ?',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()));
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                )
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
          Positioned(
              top: 50,
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
          Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Forgot password.png',
                      height: 250,
                      width: 250,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            HeadingText(text: 'Change Password'),
                            Text(
                              'Enter your mail to send otp',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    TextFieldWidget(
                      labelText: 'Email',
                      hintText: 'Email',
                      iconData: SvgIcons.mailIcon,
                      obscureText: false,
                      controller: _emailController,
                      keyboardtype: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _isLoading
                            ? const CircularProgressIndicator(
                                color: Color.fromARGB(255, 49, 121, 46),
                              )
                            : SideButton(
                                text: 'Send OTP',
                                onPressed: _sendOtp,
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
