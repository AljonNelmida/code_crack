import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class AuthRepository {
  late String baseUrl;

  AuthRepository() {
    initializeBaseUrl();
  }

  Future<void> initializeBaseUrl() async {
    print("getting ip address");
    final ipAddress = await getIpAddress();
    if (ipAddress != null) {
      baseUrl = "http://$ipAddress:3000/api/users"; // Add protocol, port, and path
      print("Got in shared pref $baseUrl");
    } else {
      baseUrl = "http://192.168.68.100:3000/api/users"; // Default fallback
      print("default $baseUrl");
    }
  }

  Future<String?> getIpAddress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("ipaddress");
  }

  Future<Map<String, dynamic>> register({
    required String studentNumber,
    required String username,
    required String email,
    required String password,
  }) async {
    await ensureBaseUrlInitialized();

    print(baseUrl);
    final url = Uri.parse('$baseUrl/register');
    final body = {
      'studentNumber': studentNumber,
      'username': username,
      'email': email,
      'password': password,
    };
    print("registering");
    try {
      print(url);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print(response);
      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'User registered successfully!',
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred during registration.',
      };
    }
  }

  /// Logs in an existing user
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    await ensureBaseUrlInitialized();
    final url = Uri.parse('$baseUrl/login');
    final body = {
      'username': username,
      'password': password,
    };

    print("login");
    try {
      print(url);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print("response");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['user'],
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Login failed.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred during login.',
      };
    }
  }
  Future<void> ensureBaseUrlInitialized() async {
    if (baseUrl.isEmpty) {
      print("Empty");
      await initializeBaseUrl();
    }
  }
}