import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omu_bot/controllers/auth_controller.dart';
import 'package:omu_bot/widgets/app_bar.dart';

class RegisterView extends StatelessWidget {

  RegisterView({super.key});
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Register",),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const  InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                authController.register(emailController.text, passwordController.text);
              },
              child: Text('Register'),
            ),
            TextButton(
              onPressed: () {
                Get.toNamed('/login');
              },
              child: Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
