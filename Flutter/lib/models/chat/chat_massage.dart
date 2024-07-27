import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

class ChatMessage {
  final String message;
  final bool isSender;
  int? _messageId; // Opsiyonel olarak tanımlandı, başlangıçta null

  RxBool isSpeaking;
  bool isReported;
  String reportMessage;

  ChatMessage({
    required this.message,
    required this.isSender,
    bool isSpeaking = false,
    this.isReported = false,
    this.reportMessage = '',
  }) : isSpeaking = isSpeaking.obs;

  // Getter for _messageId
  int? get messageId => _messageId;

  // Setter for _messageId
  set messageId(int? id) {
    _messageId = id;
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    ChatMessage chatMessage = ChatMessage(
      message: json['message'],
      isSender: json['isSender'],
      isReported: (json['isReported'] == 1),
      reportMessage: json['report'] ?? '',
    );
    chatMessage._messageId = json['message_id']; // JSON anahtarının doğru olduğundan emin olun
    return chatMessage;
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'isSender': isSender,
      'message_id': _messageId,
      'isReported': isReported ? 1 : 0,
      'report_message': reportMessage,
    };
  }
}