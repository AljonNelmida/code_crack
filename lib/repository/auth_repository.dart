import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class AuthRepository {
  final String baseUrl = "http://192.168.68.104:3000/api/users";

  Future<Map<String, dynamic>> register({
    required String studentNumber,
    required String username,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/register');
    final body = {
      'studentNumber': studentNumber,
      'username': username,
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

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
    final url = Uri.parse('$baseUrl/login');
    final body = {
      'username': username,
      'password': password,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

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
}