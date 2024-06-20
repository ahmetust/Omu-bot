import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/admin/add_question/add_question_request_model.dart';
import '../models/admin/add_question/add_quetion_response_model.dart';
import '../models/admin/category_stats/category_stats_model.dart';
import '../models/admin/list/message_list_request_model.dart';

class AdminService {
  final String baseUrl = 'http://localhost:3300';

  Future<List<MessageListRequestModel>> fetchMessages() async {
    final response = await http.get(Uri.parse('$baseUrl/list-messages'));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((message) => MessageListRequestModel.fromJson(message)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<AddQuestionResponse> addQuestion(AddQuestionRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add-question'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201) {
      return AddQuestionResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add question');
    }
  }

  Future<void> deleteQuestion(int questionId) async {
    final response = await http.delete(Uri.parse('$baseUrl/delete-question/$questionId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete question');
    }
  }

  Future<List<CategoryStatsModel>> getCategoryStats() async {
    final response = await http.get(Uri.parse('$baseUrl/category-stats'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => CategoryStatsModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load category stats');
    }
  }
}
