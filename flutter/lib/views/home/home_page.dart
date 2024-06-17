import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omu_bot/controllers/auth_controller.dart';
import 'package:omu_bot/widgets/app_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    //final AuthController authController = Get.find();

    List<Widget> actions = [
      IconButton(
        icon: const Icon(Icons.logout, color: Colors.white),
        onPressed: () {
          //authController.logout();
        },
      ),
    ];

    return Scaffold(
      appBar: CommonAppBar(title: "OmuBOT", actions: actions),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/chat_bot_logo.png', // Örnek bir robot ikonu
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),
            Text(
              'Hoş geldiniz!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Yapay zekâ destekli chatbot ile konuşmaya başlamak için aşağıdaki butona dokunun.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/chat');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,// Butonun arka plan rengi
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Butonun kenar yuvarlaklığı
                ),
                elevation: 5, // Butonun gölge yüksekliği
                 // Buton metni rengi
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.chat_bubble, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Yeni bir konuşma başlat",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
