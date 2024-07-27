import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/admin/add_question/add_question_request_model.dart';
import '../models/admin/category_stats/category_stats_model.dart';
import '../models/admin/list/message_list_request_model.dart';
import '../models/admin/edit_question/edit_question_request.dart';
import 'package:get_storage/get_storage.dart';
import '../services/admin_service.dart';

class AdminController extends GetxController {
  var messages = <MessageListRequestModel>[].obs;
  var filteredMessages = <MessageListRequestModel>[].obs; // Filtrelenmiş mesajlar eklendi
  var reportedMessages = <MessageListRequestModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var categoryStats = <CategoryStatsModel>[].obs; // Observable olarak tanımlandı
  var selectedPage = 'manage'.obs;
  var selectedCategory = ''.obs; // Seçilen kategori ismi
  var selectedCategoryId = 0.obs; // Seçilen kategori ID'si

  final AdminService adminService = AdminService();
  final storage = GetStorage();
  late dynamic user;

  @override
  void onInit() {
    super.onInit();
    fetchMessages();
    fetchCategoryStats();
    fetchReportedMessages();
    user = storage.read('user');
  }

  void setSelectedPage(String view) {
    selectedPage.value = view; // Sayfa değiştirme işlemi eklendi
  }

  void fetchReportedMessages() async {
    isLoading.value = true;
    try {
      var fetchedReportedMessages = await adminService.fetchReportedMessages();
      reportedMessages.assignAll(fetchedReportedMessages);

    } catch (e) {
      showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void fetchMessages() async {
    isLoading.value = true;
    try {
      var fetchedMessages = await adminService.fetchMessages();
      messages.assignAll(fetchedMessages);
      filteredMessages.assignAll(fetchedMessages); // Filtrelenmiş mesajları da güncelle
    } catch (e) {
      showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void addQuestion(int userId, String question, String answer, int categoryId) async {
    isLoading.value = true;
    try {
      AddQuestionRequest request = AddQuestionRequest(
        userId: userId,
        question: question,
        answer: answer,
        categoryId: categoryId,
      );
      await adminService.addQuestion(request);
      fetchMessages();
      fetchCategoryStats(); // Kategori istatistiklerini güncelle
    } catch (e) {
      showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void editQuestion(int messageId, String question, String answer, int categoryId) async {
    isLoading.value = true;
    try {
      EditQuestionRequest request = EditQuestionRequest(
        messageId: messageId,
        question: question,
        answer: answer,
        categoryId: categoryId,
      );
      await adminService.editQuestion(request);
      fetchMessages();
      fetchCategoryStats(); // Kategori istatistiklerini güncelle
      fetchReportedMessages();
    } catch (e) {
      showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void deleteQuestion(int questionId) async {
    isLoading.value = true;
    try {
      await adminService.deleteQuestion(questionId);
      fetchMessages();
      fetchCategoryStats(); // Kategori istatistiklerini güncelle
      fetchReportedMessages();
    } catch (e) {
      showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void fetchCategoryStats() async {
    isLoading.value = true;
    try {
      var fetchedStats = await adminService.getCategoryStats();
      categoryStats.assignAll(fetchedStats);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void filterQuestions(String query) {
    if (query.isEmpty) {
      filteredMessages.assignAll(messages);
    } else {
      var filtered = messages.where((message) =>
      message.question.toLowerCase().contains(query.toLowerCase()) ||
          message.answer.toLowerCase().contains(query.toLowerCase())).toList();
      filteredMessages.assignAll(filtered);
    }
  }

  void updateMessageIsReported(int messageId, bool isReported) async {
    isLoading.value = true;
    try {
      await adminService.updateMessageIsReported(messageId);
      fetchReportedMessages(); // Raporlanan mesajları güncelle
    } catch (e) {
      showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  void showErrorSnackbar(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void logout() async {
    try {
      await storage.erase(); // Depolama işlemini kontrol et
      user = null; // Kullanıcı verilerini sıfırla
      Get.offAllNamed('/login'); // Kullanıcıyı login sayfasına yönlendir
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Çıkış yapma işlemi başarısız: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
