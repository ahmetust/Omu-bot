import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatService {
  final String apiUrl = 'http://34.89.5.66:5000/soru';

  Future<String> sendQuestion(String question) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'soru': question,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['cevap'];
    } else {
      throw Exception('Failed to send question');
    }
  }
}
