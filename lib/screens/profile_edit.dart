import 'package:flutter/material.dart';
import 'package:red/widgets/button.dart';
import 'package:red/widgets/heading_text.dart';
import 'package:red/widgets/text_field.dart';
import 'package:red/utils/icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  Map<String, dynamic>? profileData;
  bool isLoading = true; // For data fetching
  bool isUpdating = false; // For profile updating
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  /// Fetches the profile data from the API and populates the text fields.
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
          _nameController.text = profileData?['username'] ?? '';
          _mobileController.text = profileData?['additional_number'] ?? '';
          _addressController.text = profileData?['address'] ?? '';
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
      Fluttertoast.showToast(
        msg: "Error: $errorMessage",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  /// Updates the profile by sending a PUT request to the API.
  Future<void> _updateProfile() async {
    setState(() {
      isUpdating = true;
    });

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? id = prefs.getInt('id');
      if (id == null) {
        throw Exception("ID is missing");
      }

      final response = await http.put(
        Uri.parse('http://feniceshieldchemical.bwsoft.in/api/api/profile/$id/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': _nameController.text,
          'additional_number': _mobileController.text,
          'address': _addressController.text,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          profileData = json.decode(response.body);
          isUpdating = false;
        });
        Fluttertoast.showToast(
          msg: "Profile updated successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        throw Exception("Failed to update profile.");
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isUpdating = false;
      });
      Fluttertoast.showToast(
        msg: "Error: $errorMessage",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 49, 121, 46),
                    ),
                  )
                : LayoutBuilder(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const HeadingText(text: 'Edit Profile'),
                                        Image.asset(
                                          'assets/images/profile.png',
                                          height: 250,
                                          width: 250,
                                        ),
                                        const SizedBox(height: 20),
                                        TextFieldWidget(
                                          labelText: 'Full name',
                                          hintText: 'Full name',
                                          iconData: SvgIcons.personIcon,
                                          obscureText: false,
                                          controller: _nameController,
                                          keyboardtype: TextInputType.name,
                                        ),
                                        const SizedBox(height: 30),
                                        TextFieldWidget(
                                          labelText: 'Additional mobile',
                                          hintText: 'Additional mobile',
                                          iconData: SvgIcons.phoneIcon,
                                          obscureText: false,
                                          controller: _mobileController,
                                          keyboardtype: TextInputType.number,
                                          // keyboardType: TextInputType.phone,
                                        ),
                                        const SizedBox(height: 30),
                                        TextFieldWidget(
                                          labelText: 'Address',
                                          hintText: 'Address',
                                          iconData: SvgIcons.homeIcon,
                                          obscureText: false,
                                          controller: _addressController,
                                          keyboardtype:
                                              TextInputType.streetAddress,
                                        ),
                                        const SizedBox(height: 40),
                                        CustomElevatedButton(
                                          isLoading: isUpdating,
                                          onPressed: _updateProfile,
                                          text: 'Update',
                                        ),
                                        if (errorMessage != null)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0),
                                            child: Text(
                                              errorMessage!,
                                              style: const TextStyle(
                                                  color: Colors.red),
                                            ),
                                          ),
                                      ],
                                    ),
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
          // Optional: Overlay loading indicator during updating
          if (isUpdating)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 49, 121, 46),
                ),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
