import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omu_bot/controllers/chat_controller.dart';
import 'package:omu_bot/widgets/app_bar.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:omu_bot/widgets/clickable_text.dart';
import '../../models/chat/chat_massage.dart';
import '../../widgets/progress_indicator.dart'; // TypingIndicator yerine kullanılan ilgili bileşeni ekleyin

class ChatPage extends GetView<ChatController> {
  ChatPage({super.key});

  List<Color> senderColors = [
    const Color(0xFCE62808),
    const Color(0xFF740411),
  ];

  List<Color> responseColors = [
    const Color(0xC41436DF),
    const Color(0xFF092B9B),
  ];

  List<Color> gradientBoxColors = [
    const Color(0xC4EF3A1F),
    const Color(0xFF7D96E6),
  ];

  List<Color> textfieldColors = [
    const Color(0xFFF69170),
    const Color(0xFF7D96E6),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(
        title: "OmuBOT",
        actions: [],
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/omu_logo.png"),
                  fit: BoxFit.contain,
                  colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.1), BlendMode.dstATop),
                ),
              ),
            ),
          ),
          Obx(() => ListView.builder(
            itemCount: controller.messages.length + 1,
            controller: controller.scrollController,
            padding: const EdgeInsets.only(top: 10, bottom: 70),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              if (index == controller.messages.length) {
                // Show loading indicator with bot logo at the bottom
                return Obx(() {
                  return controller.isLoading.value
                      ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/chat_bot_logo_2.png',
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(width: 8.0),
                        const TypingIndicator(), // Buraya uygun bileşeni ekleyin
                      ],
                    ),
                  )
                      : const SizedBox.shrink();
                });
              } else {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: controller.messages[index].isSender
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: controller.messages[index].isSender
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (!controller.messages[index].isSender)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Image.asset(
                                'assets/images/chat_bot_logo_2.png',
                                width: 50,
                                height: 50,
                              ),
                            ),
                          IntrinsicWidth(
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.7,
                              ),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: controller.messages[index].isSender
                                      ? senderColors
                                      : responseColors,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        controller.speakMessage(controller.messages[index]),
                                    child: Obx(() => Icon(
                                      controller.messages[index].isSpeaking.value
                                          ? Icons.volume_off
                                          : Icons.volume_up,
                                      color: Colors.white,
                                    )),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                      child: ClickableText(text: controller.messages[index].message)
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (controller.messages[index].isSender)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Image.asset(
                                'assets/images/user_logo_2.png',
                                width: 40,
                                height: 40,
                              ),
                            ),
                        ],
                      ),
                      if (!controller.messages[index].isSender)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, left: 50.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: () {
                                _showReportDialog(context, controller.messages[index]);
                              },
                              icon: Icon(Icons.report, color: Colors.red),
                              label: Text('Rapor Et', style: TextStyle(color: Colors.red)),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }
            },
          )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: GradientBoxBorder(
                          gradient: buildLinearGradient(textfieldColors),
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: "Bir mesaj yazın",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8.0),
                          ),
                          keyboardType: TextInputType.text,
                          controller: controller.chatTextController,
                          onEditingComplete: () async =>
                          await controller.sendQuestion(
                              controller.chatTextController.value.text),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  IconButton(
                    icon: Obx(() =>
                        Icon(controller.isListening.value ? Icons.mic : Icons.mic_none)),
                    onPressed: controller.startListening,
                  ),
                  MaterialButton(
                    onPressed: () async =>
                    await controller.sendQuestion(controller.chatTextController.value.text),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    padding: const EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: buildLinearGradient(gradientBoxColors),
                        borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                      ),
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
                        alignment: Alignment.center,
                        child: const Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient buildLinearGradient(List<Color> colors) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );
  }

  void _showReportDialog(BuildContext context, ChatMessage message) {
    final TextEditingController _reportController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 8,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Mesajı Rapor Et',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.redAccent,
                  ),
                ),
                SizedBox(height: 20),
                _buildInputLabel('Rapor Mesajı'),
                _buildReportTextField(_reportController),
                SizedBox(height: 20),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.grey,
                        ),
                        child: const Text('Vazgeç', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          final reportMessage = _reportController.text;
                          if (message.messageId != null) {
                            controller.reportMessage(message.messageId!, reportMessage);
                          } else {
                            // Handle the case when messageId is null
                            // Show an error message or handle it accordingly
                            print("Message ID is null");
                          }
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.redAccent,
                        ),
                        child: const Text('Rapor Et', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.black,
      ),
    );
  }

  Widget _buildReportTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      maxLines: 3,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Geri bildiriminizi yazın',
      ),
    );
  }
}

