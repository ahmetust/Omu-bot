import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../controllers/admin_controller.dart';
import '../../models/admin/category_stats/category_stats_model.dart';

class ManageQuestionsPage extends GetView<AdminController> {
  const ManageQuestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();
    var size = MediaQuery.of(context).size;

    void _showAddQuestionDialog() {
      final TextEditingController _questionController = TextEditingController();
      final TextEditingController _answerController = TextEditingController();
      final TextEditingController _userIdController = TextEditingController();

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
                          'Soru ekle',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blueAccent,
                          ),
                        ), // Spacer between 'Kategori Ekle' and 'Soru Ekle'
                        SizedBox(
                          width: size.width * 0.4, // Adjust the width as needed
                          child: DropdownButtonFormField<String>(
                            items: controller.categoryStats.map((category) {
                              return DropdownMenuItem<String>(
                                value: category.categoryName,
                                child: Text(category.categoryName),
                              );
                            }).toList(),
                            hint: Text('Kategori Seç'),
                            onChanged: (value) {
                              // Ensure value is not null
                              if (value != null) {
                                controller.selectedCategory.value = value;
                                controller.selectedCategoryId.value = controller.categoryStats.firstWhere((cat) => cat.categoryName == value).categoryId;
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

                   /* SizedBox(height: 10),
                    _buildInputLabel('User ID'),
                    _buildTextField(_userIdController, TextInputType.number),
                    SizedBox(height: 10),*/
                    _buildInputLabel('Soru'),
                    _buildQuestionTextField(_questionController),
                    SizedBox(height: 10),
                    _buildInputLabel('Cevap'),
                    _buildQuestionTextField(_answerController),
                    SizedBox(height: 20),
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceBetween, // Align buttons to the right
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
                        ), // Spacer between buttons
                        SizedBox(
                          width: size.width * 0.3,
                          child: ElevatedButton(
                            onPressed: () {
                              final userId = int.tryParse(_userIdController.text) ?? 0;
                              final question = _questionController.text;
                              final answer = _answerController.text;
                              final categoryId = controller.selectedCategoryId.value;
                              controller.addQuestion(userId, question, answer, categoryId);
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.blueAccent,
                            ),
                            child: const Text('Oluştur', style: TextStyle(color: Colors.white)),
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width * 0.6,
                  child: _buildSearchField(_searchController),
                ),
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: _showAddQuestionDialog,
                    child: Text(
                      'Soru Ekle',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
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
              return ListView.builder(
                shrinkWrap: true,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit_rounded, color: Colors.redAccent),
                            onPressed: () {
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
                  );
                },
              );
            }),
          ],
        ),
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

  Widget _buildSearchField(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Soru Ara',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}
