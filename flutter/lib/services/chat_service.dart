import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/chat/chat_massage.dart';
import '../models/chat/report_message/report_message_request.dart';
import '../models/chat/report_message/report_message_response.dart';


class ChatService {
  final String baseUrl = 'http://34.89.5.66:5000';

  Future<ChatMessage> sendQuestion(String question, int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/soru'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'soru': question,
        'user_id': userId,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ChatMessage.fromJson({
        'message': jsonResponse['cevap'],
        'isSender': false,
        'message_id': jsonResponse['message_id'], // Server'dan dönen id'yi burada alıyoruz
        'isReported': false,
        'report': '',
      });
    } else {
      throw Exception('Failed to send question');
    }
  }

  Future<void> reportMessage(int messageId, String reportMessage) async {
    ReportMessageRequest requestModel = ReportMessageRequest(
      messageId: messageId,
      reportMessage: reportMessage,
    );

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/report'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestModel.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to report message');
      }

      ReportMessageResponse responseModel =
      ReportMessageResponse.fromJson(jsonDecode(response.body));

      if (responseModel.error != null) {
        throw Exception('Failed to report message: ${responseModel.error}');
      }

      print(responseModel.message);
    } catch (error) {
      print('Error reporting message: $error');
      throw Exception('Failed to report message: $error');
    }
  }


}
