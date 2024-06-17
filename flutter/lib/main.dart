import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:omu_bot/views/chat/backup_view.dart';
import 'package:omu_bot/views/chat/chat_page.dart';
import 'package:omu_bot/views/login/login_view.dart';
import 'package:omu_bot/views/login/register_view.dart';
import 'package:omu_bot/views/home/home_page.dart';
void main() async{
  await GetStorage.init();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OmuBOT',
      initialRoute: '/home',
      getPages: [
        GetPage(name: '/login', page: () => LoginView()),
        GetPage(name: '/register', page: () => RegisterView()),
        GetPage(name: '/home', page: () => HomeView()),
        GetPage(name: '/chat', page: () => ChatPage()),
        GetPage(name: '/backup', page: () => ChatPageBackup())
        //GetPage(name: '/admin', page: () => AdminView()),
      ],
    );
  }
}
