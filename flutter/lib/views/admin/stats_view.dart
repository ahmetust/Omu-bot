// admin_view_stats_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../controllers/admin_controller.dart';
import '../../models/admin/category_stats/category_stats_model.dart';

Widget buildStatsPage() {
  final AdminController adminController = Get.find();
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 2,
          child: Obx(() {
            if (adminController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            } else if (adminController.errorMessage.isNotEmpty) {
              return Center(
                child: Text(
                  adminController.errorMessage.value,
                  style: TextStyle(color: Colors.red),
                ),
              );
            } else {
              return PieChart(
                PieChartData(
                  sections: _buildPieChartSections(adminController.categoryStats),
                  centerSpaceRadius: 40,
                  startDegreeOffset: -90,
                  sectionsSpace: 0,
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, PieTouchResponse? response) {
                      // Handle touch event here if needed
                    },
                  ),
                ),
              );
            }
          }),
        ),
      ],
    ),
  );
}

List<PieChartSectionData> _buildPieChartSections(List<CategoryStatsModel> categoryStats) {
  List<Color> colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.red,
    Colors.teal,
    Colors.pink,
    Colors.deepOrange,
    Colors.indigo,
  ]; // Örnek renk listesi, istediğiniz kadar renk ekleyebilirsiniz.

  return List.generate(
    categoryStats.length,
        (index) {
      final categoryStat = categoryStats[index];
      final Color color = colors[index % colors.length]; // Renklerin döngüsel olarak atanması

      return PieChartSectionData(
        color: color,
        value: categoryStat.questionCount.toDouble(),
        title: '${categoryStat.categoryName}\n${categoryStat.questionCount} Soru',
        radius: 100,
        titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      );
    },
  );
}
