// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:red/screens/otp.dart';
import 'package:red/widgets/side_button.dart';
import 'package:red/widgets/heading_text.dart';
import 'package:red/widgets/text_field.dart';
import 'package:red/utils/icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  void _register() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _mobileController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill all the fields");
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      Fluttertoast.showToast(msg: "Passwords do not match");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url =
        Uri.parse('http://feniceshieldchemical.bwsoft.in/api/api/register/');
    final response = await http.post(
      url,
      body: {
        'username': _nameController.text,
        'email': _emailController.text,
        'mobile': _mobileController.text,
        'address': _addressController.text,
        'password': _passwordController.text,
        'password2': _confirmPasswordController.text,
      },
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201) {
      Fluttertoast.showToast(msg: "Registration successful");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const OTPScreen()));
    } else {
      Fluttertoast.showToast(msg: "Registration failed");
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
                  'Already have a account',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Sign in',
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
                    const SizedBox(height: 100),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        HeadingText(text: 'Create Account'),
                      ],
                    ),
                    TextFieldWidget(
                      labelText: 'Full name',
                      hintText: 'Full name',
                      iconData: SvgIcons.personIcon,
                      obscureText: false,
                      controller: _nameController,
                      keyboardtype: TextInputType.name,
                    ),
                    const SizedBox(height: 15),
                    TextFieldWidget(
                      labelText: 'Email',
                      hintText: 'Email',
                      iconData: SvgIcons.mailIcon,
                      obscureText: false,
                      controller: _emailController,
                      keyboardtype: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),
                    TextFieldWidget(
                      labelText: 'mobile',
                      hintText: 'mobile',
                      iconData: SvgIcons.phoneIcon,
                      obscureText: false,
                      controller: _mobileController,
                      keyboardtype: TextInputType.number,
                    ),
                    const SizedBox(height: 15),
                    TextFieldWidget(
                      labelText: 'Address',
                      hintText: 'Address',
                      iconData: SvgIcons.homeIcon,
                      obscureText: false,
                      controller: _addressController,
                      keyboardtype: TextInputType.streetAddress,
                    ),
                    const SizedBox(height: 15),
                    TextFieldWidget(
                      labelText: 'Password',
                      hintText: 'Password',
                      iconData: SvgIcons.lockIcon,
                      obscureText: false,
                      controller: _passwordController,
                      keyboardtype: TextInputType.visiblePassword,
                    ),
                    const SizedBox(height: 15),
                    TextFieldWidget(
                      labelText: 'Confirm password',
                      hintText: 'Confirm password',
                      iconData: SvgIcons.keyIcon,
                      obscureText: false,
                      controller: _confirmPasswordController,
                      keyboardtype: TextInputType.visiblePassword,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _isLoading
                            ? const CircularProgressIndicator(
                                color: Color.fromARGB(255, 49, 121, 46),
                              )
                            : SideButton(
                                text: 'Sign up',
                                onPressed: _register,
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
