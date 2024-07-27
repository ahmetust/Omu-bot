import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class AuthMiddleware extends GetMiddleware {
  final user = Rxn<Map<String, dynamic>>();

  AuthMiddleware() {
    final storage = GetStorage();
    user.value = storage.read('user');
    ever(user, (_) {
      if (user.value == null) {
        Get.toNamed('/login');
      }
    });
  }

  @override
  RouteSettings? redirect(String? route) {
    final storage = GetStorage();
    user.value = storage.read('user');

    if (user.value == null) {
      // Kullanıcı oturum açmamışsa login ve register sayfalarına erişebilir
      if (route == '/login' || route == '/register') {
        return null;
      } else {
        return RouteSettings(name: '/login'); // Giriş yapmamışsa diğer sayfalara erişemez
      }
    } else {
      // Kullanıcı oturum açmışsa login ve register sayfalarına erişemez
      if (route == '/login' || route == '/register') {
        Get.snackbar(
          'Erişim Reddedildi',
          'Zaten oturum açmışsınız.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return RouteSettings(name: Get.currentRoute); // Mevcut sayfada kal
      }

      final role = user.value!['role'];
      if (route == '/admin' && role != 'ADMIN') {
        Get.snackbar(
          'Erişim Reddedildi',
          'Bu sayfaya erişim izniniz yok.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return RouteSettings(name: Get.currentRoute); // Mevcut sayfada kal
      }
      if ((route == '/chat' || route == '/home') && role != 'USER') {
        Get.snackbar(
          'Erişim Reddedildi',
          'Bu sayfaya erişim izniniz yok.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return RouteSettings(name: Get.currentRoute); // Mevcut sayfada kal
      }
    }

    return null;
  }
}
