// admin_view_manage_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_controller.dart';

Widget buildManageQuestionsPage() {
  final AdminController adminController = Get.find();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  final TextEditingController _categoryIdController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _deleteQuestionIdController = TextEditingController();

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _userIdController,
            decoration: InputDecoration(labelText: 'User ID'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _questionController,
            decoration: InputDecoration(labelText: 'Soru'),
          ),
          TextField(
            controller: _answerController,
            decoration: InputDecoration(labelText: 'Cevap'),
          ),
          TextField(
            controller: _categoryIdController,
            decoration: InputDecoration(labelText: 'Kategori ID'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final userId = int.tryParse(_userIdController.text) ?? 0;
              final question = _questionController.text;
              final answer = _answerController.text;
              final categoryId = int.tryParse(_categoryIdController.text) ?? 0;
              adminController.addQuestion(userId, question, answer, categoryId);
            },
            child: Text('Soru Ekle'),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _deleteQuestionIdController,
            decoration: InputDecoration(labelText: 'Soru ID (Silme için)'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final questionId = int.tryParse(_deleteQuestionIdController.text) ?? 0;
              adminController.deleteQuestion(questionId);
            },
            child: Text('Soru Sil'),
          ),
          SizedBox(height: 20),
          Obx(() {
            if (adminController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            if (adminController.errorMessage.isNotEmpty) {
              Get.snackbar('Error', adminController.errorMessage.value,
                  snackPosition: SnackPosition.BOTTOM);
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: adminController.messages.length,
              itemBuilder: (context, index) {
                final message = adminController.messages[index];
                return ListTile(
                  title: Text(message.question),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cevap: ${message.answer}'),
                      Text('Kategori: ${message.category}'),
                      Text('User ID: ${message.userId}'),
                    ],
                  ),
                );
              },
            );
          }),
        ],
      ),
    ),
  );
}
