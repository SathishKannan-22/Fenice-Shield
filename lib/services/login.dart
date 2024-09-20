import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  static const String _loginUrl =
      'http://feniceshieldchemical.bwsoft.in/api/api/login/';

  Future<Map<String, dynamic>?> login(String mobile, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'mobile': mobile,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}
