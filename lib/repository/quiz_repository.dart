import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class QuizRepository {
  String baseUrl ="";

  QuizRepository() {
    initializeBaseUrl();
  }

  Future<void> initializeBaseUrl() async {
    final ipAddress = await getIpAddress();
    if (ipAddress != null) {
      baseUrl = "http://$ipAddress:3000/api/quizzes"; // Add protocol, port, and path
    } else {
      baseUrl = "http://192.168.68.100:3000/api/quizzes"; // Default fallback
    }
  }

  Future<String?> getIpAddress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("ipaddress");
  }


  Future<List<dynamic>> fetchQuizzes() async {
    await ensureBaseUrlInitialized();
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body); // Decodes the JSON response into a List
      } else {
        throw Exception("Failed to load quizzes. Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching quizzes: $e");
    }
  }

  // Fetch quizzes by tags
  Future<List<dynamic>> fetchQuizzesByTags(List<String> tags) async {
    await ensureBaseUrlInitialized();
    try {
      final url = "$baseUrl/tags"; // Endpoint for quizzes by tags
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'tags': tags}), // Sending tags as JSON payload
      );

      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body); // Decodes the JSON response into a List
      } else if (response.statusCode == 404) {
        print("No quizzes found for the given tags.");
        return []; // Return an empty list if no quizzes are found
      } else {
        throw Exception("Failed to fetch quizzes by tags. Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching quizzes by tags: $e");
    }
  }

  Future<void> ensureBaseUrlInitialized() async {
    if (baseUrl.isEmpty) {
      await initializeBaseUrl();
    }
  }
}
