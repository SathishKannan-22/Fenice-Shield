import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:red/widgets/arrow.dart';
import 'package:red/widgets/side_button.dart';
import 'package:red/widgets/heading_text.dart';
import 'package:red/utils/icons.dart';
import 'package:red/widgets/text_field.dart';

class ForgotOTP extends StatefulWidget {
  const ForgotOTP({super.key});

  @override
  State<ForgotOTP> createState() => _ForgotOTPState();
}

class _ForgotOTPState extends State<ForgotOTP> {
  final int _otpLength = 6;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  bool _isLoading = false;

  Future<void> _verifyOtp() async {
    final String otp = _controllers.map((controller) => controller.text).join();
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    if (otp.length != _otpLength) {
      Fluttertoast.showToast(msg: "An error occurred. Please try again later.");
      return;
    }

    if (password.isEmpty || confirmPassword.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter both password fields");
      return;
    }

    if (password != confirmPassword) {
      Fluttertoast.showToast(msg: "Passwords do not match");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse(
          'http://feniceshieldchemical.bwsoft.in/api/api/password-reset-confirm/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'otp': otp,
        'new_password': password,
        'confirm_password': confirmPassword,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      _showDialogue('success');
    } else {
      Fluttertoast.showToast(msg: "Failed to verify OTP");
    }
  }

  void _showDialogue(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        title: const Center(child: HeadingText(text: 'success')),
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
                  'Enter OTP sent to your mail id',
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
                            HeadingText(text: 'Change password'),
                            Text(
                              'Enter OTP to change password',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
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
                    const SizedBox(height: 30),
                    TextFieldWidget(
                      labelText: 'Password',
                      hintText: 'Password',
                      iconData: SvgIcons.lockIcon,
                      obscureText: true,
                      controller: _passwordController,
                      keyboardtype: TextInputType.visiblePassword,
                    ),
                    const SizedBox(height: 30),
                    TextFieldWidget(
                      labelText: 'Confirm Password',
                      hintText: 'Confirm Password',
                      iconData: SvgIcons.lockIcon,
                      obscureText: true,
                      controller: _confirmPasswordController,
                      keyboardtype: TextInputType.visiblePassword,
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _isLoading
                            ? const CircularProgressIndicator(
                                color: Color.fromARGB(255, 49, 121, 46),
                              )
                            : SideButton(
                                text: 'Verify',
                                onPressed: _verifyOtp,
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const PositionedBackButton()
        ],
      ),
    );
  }
}
