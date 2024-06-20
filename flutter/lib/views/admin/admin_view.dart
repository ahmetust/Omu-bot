import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_controller.dart';
import 'stats_view.dart'; // Yeni import
import 'manage_questions_view.dart'; // Yeni import

class AdminView extends StatelessWidget {
  final AdminController adminController = Get.put(AdminController());

  AdminView({super.key});

  final Map<String, Widget Function()> pages = {
    'stats': () => buildStatsPage(),
    'manage': () => buildManageQuestionsPage(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Paneli'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Admin Paneli',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('İstatistikler'),
              onTap: () {
                adminController.setSelectedPage('stats');
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Soru Ekle/Sil'),
              onTap: () {
                adminController.setSelectedPage('manage');
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      body: Obx(() {
        return pages[adminController.selectedPage.value]!();
      }),
    );
  }
}
