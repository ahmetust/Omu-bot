import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:omu_bot/models/user/user.dart';
import 'package:omu_bot/services/auth_service.dart';

class AuthController extends GetxController {
  var user = Rxn<User>();
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    ever(user, handleAuthChanged);
    loadUser();
  }

  void loadUser() {
    final userData = storage.read('user');
    if (userData != null) {
      user.value = User.fromJson(userData);
    }
  }

  void handleAuthChanged(User? user) {
    if (user == null) {
      Get.offAllNamed('/login');
    } else if (user.role == 'ADMIN') {
      Get.offAllNamed('/admin');
    } else {
      Get.offAllNamed('/home');
    }
  }

  Future<void> login(String email, String password) async {
    final authService = AuthService();
    final response = await authService.login(email, password);
    if (response != null) {
      final userData = User(id: response.id, email: email, role: response.role);
      storage.write('user', userData.toJson());
      user.value = userData;
    }
  }

  Future<void> register(String email, String password) async {
    final authService = AuthService();
    final response = await authService.register(email, password);
    if (response != null) {
      final userData = User(id: response.id, email: email, role: 'USER');
      storage.write('user', userData.toJson());
      user.value = userData;
    }
  }

  void logout() {
    storage.erase();
    user.value = null;
  }
}
