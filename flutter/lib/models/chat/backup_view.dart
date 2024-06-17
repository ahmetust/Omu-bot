import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:omu_bot/controllers/chat_controller.dart';
import 'package:get/get.dart';
import 'package:omu_bot/widgets/app_bar.dart';
import '../../widgets/progress_indicator.dart';

class ChatPageBackup extends StatefulWidget {
  const ChatPageBackup({super.key});

  @override
  State<ChatPageBackup> createState() => _ChatPageBackupState();
}

class _ChatPageBackupState extends State<ChatPageBackup> {
  final ChatController _controller = Get.put(ChatController());

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(
        title: "OmuBOT",
        actions: [],
      ),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height - 110,
            child: Obx(() => ListView.builder(
              itemCount: _controller.messages.length + 1,
              shrinkWrap: false,
              controller: _controller.scrollController,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                if (index == _controller.messages.length) {
                  // Show loading indicator with bot logo at the bottom
                  return Obx(() {
                    return _controller.isLoading.value
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
                          TypingIndicator(),
                        ],
                      ),
                    )
                        : SizedBox.shrink();
                  });
                } else {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: (_controller.messages[index].isSender
                          ? Alignment.topRight
                          : Alignment.topLeft),
                      child: Row(
                        mainAxisAlignment:
                        _controller.messages[index].isSender
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (!_controller.messages[index].isSender)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Image.asset(
                                'assets/images/chat_bot_logo_2.png',
                                width: 50,
                                height: 50,
                              ),
                            ),
                          Flexible(
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                MediaQuery.of(context).size.width * 0.7,
                              ),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.9),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                gradient: buildLinearGradient(
                                    _controller.messages[index].isSender
                                        ? senderColors
                                        : responseColors),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => _controller.speakMessage(
                                        _controller.messages[index]),
                                    child: Obx(() => Icon(
                                      _controller
                                          .messages[index]
                                          .isSpeaking
                                          .value
                                          ? Icons.volume_off
                                          : Icons.volume_up,
                                      color: Colors.white,
                                    )),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: Text(
                                      _controller.messages[index].message,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_controller.messages[index].isSender)
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
                    ),
                  );
                }
              },
            )),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.width / 2,
              child: Image.asset(
                "assets/images/omu_logo.png",
                fit: BoxFit.contain,
                opacity: const AlwaysStoppedAnimation(.1),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: GradientBoxBorder(
                          gradient: buildLinearGradient([
                            const Color(0xFFF69170),
                            const Color(0xFF7D96E6),
                          ]),
                        ),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(50.0)),
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
                          controller: _controller.chatTextController,
                          onEditingComplete: () async => await _controller
                              .sendQuestion(
                              _controller.chatTextController.value.text),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 4.0,
                  ),
                  IconButton(
                    icon: Obx(() => Icon(_controller.isListening.value
                        ? Icons.mic
                        : Icons.mic_none)),
                    onPressed: _controller.startListening,
                  ),
                  MaterialButton(
                    onPressed: () async => await _controller.sendQuestion(
                        _controller.chatTextController.value.text),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    padding: const EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: buildLinearGradient(gradientBoxColors),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(50.0)),
                      ),
                      child: Container(
                        constraints: const BoxConstraints(
                            minWidth: 88.0,
                            minHeight: 36.0), // min sizes for Material buttons
                        alignment: Alignment.center,
                        child: const Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  )
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
        begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors);
  }
}
