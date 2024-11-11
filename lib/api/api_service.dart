
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://131.159.223.70:8080';

  Future<List<dynamic>> getTasks(int userId) async {
    final response = await http.get(Uri.parse('$_baseUrl/tasks?user_id=$userId'));
    return jsonDecode(response.body);
  }

  Future<List<dynamic>> getEvents(int userId) async {
    final response = await http.get(Uri.parse('$_baseUrl/events?user_id=$userId'));
    return jsonDecode(response.body);
  }

  Future<void> createTask(int userId, String title, String dueDate) async {
    await http.post(
      Uri.parse('$_baseUrl/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'title': title,
        'due_date': dueDate,
        'completed': false,
      }),
    );
  }

  Future<void> createEvent(int userId, String title, String startTime, String endTime) async {
    await http.post(
      Uri.parse('$_baseUrl/events'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'title': title,
        'start_time': startTime,
        'end_time': endTime,
      }),
    );
  }
}
