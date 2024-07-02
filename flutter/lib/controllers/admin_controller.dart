import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omu_bot/controllers/auth_controller.dart';
import '../models/admin/add_question/add_question_request_model.dart';
import '../models/admin/category_stats/category_stats_model.dart';
import '../models/admin/list/message_list_request_model.dart';
import '../models/user/user.dart';
import '../services/admin_service.dart';

class AdminController extends GetxController {
  var messages = <MessageListRequestModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var categoryStats = <CategoryStatsModel>[].obs;
  var selectedPage = 'manage'.obs;
  final AdminService adminService = AdminService();
  var selectedCategory = ''.obs; // Selected category name
  var selectedCategoryId = 0.obs; // Selected category ID


  @override
  void onInit() {
    super.onInit();
    fetchMessages();
    fetchCategoryStats();

  }

  void setSelectedPage(String view) {
    selectedPage.value = view;
  }

  void fetchMessages() async {
    isLoading.value = true;
    try {
      var fetchedMessages = await adminService.fetchMessages();
      messages.assignAll(fetchedMessages);
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



  void showErrorSnackbar(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
