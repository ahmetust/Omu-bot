import 'package:get/get.dart';
import 'package:omu_bot/controllers/admin_controller.dart';

class AdminBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminController>(() => AdminController());
  }
}
