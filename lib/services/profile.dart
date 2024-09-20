import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:red/models/profile.dart';

Future<Profile> fetchProfile() async {
  final response = await http.get(
    Uri.parse('http://feniceshieldchemical.bwsoft.in/api/api/profile/2/'),
  );

  if (response.statusCode == 200) {
    return Profile.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load profile');
  }
}
