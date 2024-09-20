// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:red/screens/forgot_password.dart';
import 'package:red/screens/home.dart';
import 'package:red/screens/sign_up.dart';
import 'package:red/widgets/rain.dart';
import 'package:red/widgets/side_button.dart';
import 'package:red/widgets/heading_text.dart';
import 'package:red/widgets/text_field.dart';
import 'package:red/utils/icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:red/services/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    final String mobile = _mobileController.text.trim();
    final String password = _passwordController.text.trim();

    if (mobile.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill in both fields");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final LoginService authService = LoginService();
      final data = await authService.login(mobile, password);

      setState(() {
        _isLoading = false;
      });

      if (data != null && data['id'] != null) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('refresh_token', data['refresh_token']);
        await prefs.setInt('id', data['id']);
        await prefs.setString('access_token', data['access_token']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        Fluttertoast.showToast(
            msg: "Login failed. Please check your credentials.");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: "An error occurred. Please try again later.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // resizeToAvoidBottomInset: false, // Prevents content from being resized
      body: Stack(
        children: [
          Positioned(
            top: -40,
            right: -40,
            child: Image.asset(
              'assets/images/Group 7.png',
              width: 300,
              height: 300,
            ),
          ),
          const RainAnimation(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/amico.png',
                                    height: 200,
                                    width: 190,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          HeadingText(text: 'Login'),
                                          Text(
                                            'please sign in to continue',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  TextFieldWidget(
                                    labelText: 'mobile',
                                    hintText: 'mobile',
                                    iconData: SvgIcons.mailIcon,
                                    obscureText: false,
                                    controller: _mobileController,
                                    keyboardtype: TextInputType.number,
                                  ),
                                  const SizedBox(height: 30),
                                  TextFieldWidget(
                                    labelText: 'password',
                                    hintText: 'password',
                                    iconData: SvgIcons.lockIcon,
                                    obscureText: true,
                                    controller: _passwordController,
                                    keyboardtype: TextInputType.visiblePassword,
                                  ),
                                  const SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ForgotPassword()));
                                          },
                                          child: const Text(
                                            'Forgot ?',
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17),
                                          )),
                                      _isLoading
                                          ? const CircularProgressIndicator(
                                              color: Color.fromARGB(
                                                  255, 49, 121, 46),
                                            )
                                          : SideButton(
                                              text: 'Login',
                                              onPressed: _login,
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
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
                                            builder: (context) =>
                                                const SignUpScreen()));
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
                        ],
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
  }
}
