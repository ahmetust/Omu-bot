import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../controllers/admin_controller.dart';
import '../../models/admin/category_stats/category_stats_model.dart';

class StatsPage extends GetView<AdminController> {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isNarrow = size.width < 500;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: TextStyle(color: Colors.red),
            ),
          );
        } else {
          return isNarrow
              ? Column(
            children: [
              Expanded(
                flex: 2,
                child: PieChart(
                  PieChartData(
                    sections: _buildPieChartSections(controller.categoryStats),
                    centerSpaceRadius: 40,
                    startDegreeOffset: -90,
                    sectionsSpace: 0,
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, PieTouchResponse? response) {
                        // Handle touch event here if needed
                      },
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildLegend(controller.categoryStats),
              ),
            ],
          )
              : Row(
            children: [
              Expanded(
                flex: 2,
                child: PieChart(
                  PieChartData(
                    sections: _buildPieChartSections(controller.categoryStats),
                    centerSpaceRadius: 40,
                    startDegreeOffset: -90,
                    sectionsSpace: 0,
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, PieTouchResponse? response) {
                        // Handle touch event here if needed
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _buildLegend(controller.categoryStats),
                  ),
                ),
              ),
            ],
          );
        }
      }),
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
    ]; // Sample color list, add more colors as needed

    return List.generate(
      categoryStats.length,
          (index) {
        final categoryStat = categoryStats[index];
        final Color color = colors[index % colors.length]; // Cycle through colors

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

  List<Widget> _buildLegend(List<CategoryStatsModel> categoryStats) {
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
    ]; // Sample color list, match with colors used in PieChart

    return categoryStats.asMap().entries.map((entry) {
      int index = entry.key;
      CategoryStatsModel categoryStat = entry.value;
      Color color = colors[index % colors.length];

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 8),
            Text(
              '${categoryStat.categoryName} (${categoryStat.questionCount} Soru)',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      );
    }).toList();
  }
}
