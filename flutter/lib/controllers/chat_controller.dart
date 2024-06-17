import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:omu_bot/services/chat_service.dart';
import 'package:omu_bot/models/chat/chat_massage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';



class ChatController extends GetxController {
  final ChatService _chatService = ChatService();
  var messages = <ChatMessage>[].obs;
  var isLoading = false.obs;

  var isSpeaking = false.obs;
  late TextEditingController chatTextController;
  late ScrollController scrollController;
  late stt.SpeechToText speech;
  late  FlutterTts textToSpeech;

  var isListening = false.obs;

  List<Widget> actions = [IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back))];

  @override
  void onInit() {
    super.onInit();
    chatTextController = TextEditingController();
    scrollController = ScrollController();
    speech = stt.SpeechToText();
    textToSpeech = FlutterTts();
  }

  @override
  void onClose() {
    chatTextController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> sendQuestion(String question) async {
    if(question.isNotEmpty){
      messages.add(ChatMessage(message: question, isSender: true));
      if (speech.isListening) {
        isListening.value = false;
        speech.stop();
      }

    }
    else{
      Get.showSnackbar(const GetSnackBar(
        title: "Mesaj Gönderilemedi",
        message: 'Mesaj kutusu boş',
        duration: const Duration(seconds: 5),
        isDismissible: true,
        backgroundColor: Colors.red,
        dismissDirection: DismissDirection.horizontal, // Bu satırı ekleyin
      ));
    }
    chatTextController.clear();
    isLoading.value = true;

    try {
      Future.delayed(const Duration(milliseconds: 1500));
      final response = await _chatService.sendQuestion(question);
      if(response.isNotEmpty){
        messages.add(ChatMessage(message: response, isSender: false));
      }

    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        message: '$e',
        duration: const Duration(seconds: 3),
        isDismissible: true,
        backgroundColor: Colors.red,
        dismissDirection: DismissDirection.vertical, // Bu satırı ekleyin
      ));
    } finally {
      isLoading.value = false;
    }

    Future.delayed(Duration(milliseconds: 100), () {
      myScrollController();
    });

  }

  void myScrollController() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }


  Future<void> requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
      if (!status.isGranted) {
        throw Exception('Mikrofon izni reddedildi.');
      }
    }
  }
  Future<void> startListening() async {
    requestMicrophonePermission();
    if (!isListening.value) {
      bool available = await speech.initialize();
      if (available) {
        isListening.value = true;
        speech.listen(
          onResult: (val) {
            if (val.hasConfidenceRating && val.confidence > 0) {
              chatTextController.text = val.recognizedWords;
            }
          },
        );
      }
    } else {
      isListening.value = false;
      speech.stop();
      chatTextController.clear();
    }
  }

  Future<void> speakMessage(ChatMessage message) async {
    if (message.isSpeaking.value) {
      await textToSpeech.stop();

      message.isSpeaking.value = false;
    } else {
      await textToSpeech.speak(message.message);
      message.isSpeaking.value = true;
    }

    textToSpeech.setCompletionHandler(() => message.isSpeaking.value = false,);
  }
}
