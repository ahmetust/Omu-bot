import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:omu_bot/bindings/admin_binding.dart';
import 'package:omu_bot/bindings/auth_binding.dart';
import 'package:omu_bot/bindings/chat_binding.dart';
import 'package:omu_bot/views/admin/admin_view.dart';
import 'package:omu_bot/views/chat/chat_page.dart';
import 'package:omu_bot/views/login/login_view.dart';
import 'package:omu_bot/views/login/register_view.dart';
import 'package:omu_bot/views/home/home_page.dart';
import 'package:omu_bot/middlewares/auth_middleware.dart';

String initRoute = '/login';

void main() async {
  await GetStorage.init();
  final storage = GetStorage();
  final userData = storage.read('user');
  if (userData != null) {
    initRoute = '/home';
  }

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
      initialBinding: AuthBinding(),
      initialRoute: initRoute,
      getPages: [
        GetPage(name: '/login', page: () => LoginView(), binding: AuthBinding(), middlewares: [
          AuthMiddleware()
        ]),
        GetPage(name: '/register', page: () => RegisterView(), binding: AuthBinding(), middlewares: [
          AuthMiddleware()
        ]),
        GetPage(name: '/home', page: () => const HomeView(), binding: AuthBinding(), middlewares: [
          AuthMiddleware()
        ]),
        GetPage(name: '/chat', page: () => ChatPage(), binding: ChatBinding(), middlewares: [
          AuthMiddleware()
        ]),
        GetPage(name: '/admin', page: () => AdminView(), binding: AdminBinding(), middlewares: [
          AuthMiddleware()
        ]),
      ],
    );
  }
}