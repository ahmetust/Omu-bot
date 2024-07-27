import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../controllers/admin_controller.dart';
import '../../models/admin/category_stats/category_stats_model.dart';

class ReportedMessagesPage extends GetView<AdminController> {
  const ReportedMessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    final user = storage.read('user');
    final TextEditingController _searchController = TextEditingController();
    var size = MediaQuery.of(context).size;

    void _showEditQuestionDialog({bool isEdit = false, String? reportMessage, int? messageId, String? initialQuestion, String? initialAnswer, String? initialCategory}) {
      final TextEditingController _questionController = TextEditingController(text: initialQuestion);
      final TextEditingController _answerController = TextEditingController(text: initialAnswer);
      String selectedCategory = initialCategory ?? '';
      int selectedCategoryId = controller.categoryStats.firstWhere((cat) => cat.categoryName == initialCategory, orElse: () => CategoryStatsModel(categoryName: '', categoryId: 0, questionCount: 0)).categoryId;

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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Düzenle',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blueAccent,
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.3,
                          child: DropdownButtonFormField<String>(
                            value: selectedCategory.isEmpty ? null : selectedCategory,
                            items: controller.categoryStats.map((category) {
                              return DropdownMenuItem<String>(
                                value: category.categoryName,
                                child: Text(category.categoryName),
                              );
                            }).toList(),
                            hint: Text('Kategori Seç'),
                            onChanged: (value) {
                              if (value != null) {
                                selectedCategory = value;
                                selectedCategoryId = controller.categoryStats.firstWhere((cat) => cat.categoryName == value).categoryId;
                              }
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    _buildInputLabel('Rapor Mesajı'),
                    Text(reportMessage ?? '', style: TextStyle(fontWeight: FontWeight.w300, color: Colors.grey)),
                    SizedBox(height: 20),
                    _buildInputLabel('Soru'),
                    _buildQuestionTextField(_questionController),
                    SizedBox(height: 10),
                    _buildInputLabel('Cevap'),
                    _buildQuestionTextField(_answerController),
                    SizedBox(height: 20),
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: size.width * 0.3,
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
                          width: size.width * 0.3,
                          child: ElevatedButton(
                            onPressed: () {
                              final int userId = user['id'];
                              final question = _questionController.text;
                              final answer = _answerController.text;
                              final categoryId = selectedCategoryId;
                              if (messageId != null) {
                                controller.editQuestion(messageId, question, answer, categoryId);
                              }
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.blueAccent,
                            ),
                            child: const Text('Güncelle', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            if (controller.errorMessage.isNotEmpty) {
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                Get.snackbar('Error', controller.errorMessage.value, snackPosition: SnackPosition.BOTTOM);
              });
            }
            return Expanded(
              child: ListView.builder(
                itemCount: controller.reportedMessages.length,
                itemBuilder: (context, index) {
                  final message = controller.reportedMessages[index];
                  return Dismissible(
                    key: Key(message.messageId.toString()),
                    onDismissed: (direction) {
                      controller.updateMessageIsReported(message.messageId, false);
                      controller.reportedMessages.removeAt(index);
                    },
                    background: Container(color: Colors.red),
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(() => Checkbox(
                              value: message.isChecked.value,
                              onChanged: (bool? value) {
                                message.isChecked.value = value!;
                              },
                            )),
                            IconButton(
                              icon: Icon(Icons.edit_rounded, color: Colors.redAccent),
                              onPressed: () {
                                _showEditQuestionDialog(
                                  isEdit: true,
                                  messageId: message.messageId,
                                  initialQuestion: message.question,
                                  initialAnswer: message.answer,
                                  initialCategory: message.category,
                                  reportMessage: message.reportMessage,
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_rounded, color: Colors.redAccent),
                              onPressed: () {
                                int messageId = message.messageId;
                                controller.deleteQuestion(messageId);
                              },
                            ),
                          ],
                        ),
                        title: Text(message.question, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Cevap: ${message.answer}'),
                              Text('Kategori: ${message.category}'),
                              Text('User ID: ${message.userId}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String labelText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        labelText,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, [TextInputType keyboardType = TextInputType.text]) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildQuestionTextField(TextEditingController controller, [TextInputType keyboardType = TextInputType.text]) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
      ),
      minLines: 3,
      maxLines: null,
    );
  }

  Widget _buildSearchField(TextEditingController controller, void Function(String) onChanged) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: 'Soru Ara',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(Icons.search),
        suffixIcon: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            controller.clear();
            onChanged('');
          },
        ),
      ),
    );
  }
}
