import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
class ChatMessage {
  final String message;
  final bool isSender;

  RxBool isSpeaking;



  ChatMessage({required this.message, required this.isSender, bool isSpeaking = false}) : isSpeaking = isSpeaking.obs;
}