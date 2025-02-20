import 'package:http/http.dart' as http;
import 'dart:convert';

class MongoService {
  static const String baseUrl = 'http://10.0.0.11:3000/api';

  Future<void> createTrainee(
      String token, Map<String, dynamic> traineeData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/register'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(traineeData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create trainee: ${response.body}');
    }
  }
}
