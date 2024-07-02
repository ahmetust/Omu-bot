import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_controller.dart';
import '../../widgets/app_bar.dart';
import 'stats_view.dart';
import 'manage_questions_view.dart';

class AdminView extends GetView<AdminController> {
  final Map<String, Widget Function()> pages = {
    'stats': () => StatsPage(),
    'manage': () => ManageQuestionsPage(),
  };

  AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [
      IconButton(
        icon: const Icon(Icons.logout, color: Colors.white),
        onPressed: () {
          controller.logout(); // GetView sayesinde controller doğrudan kullanılabilir
        },
      ),
    ];

    return Scaffold(
      appBar:  CommonAppBar( // CommonAppBar'ı kullanarak appBar'ı güncelliyoruz
        title: 'Admin Paneli',
        actions: actions,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight, // Başlangıç yönü
                  end: Alignment.bottomRight, // Bitiş yönü
                  colors: [
                    Color(0xFCC53C26),
                    Color(0xFF0D40E5),
                  ],
                ),
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
                controller.setSelectedPage('stats');
                Navigator.pop(context); // Drawer'ı kapat
              },
            ),
            ListTile(
              title: Text('Soru Ekle/Sil'),
              onTap: () {
                controller.setSelectedPage('manage');
                Navigator.pop(context); // Drawer'ı kapat
              },
            ),
          ],
        ),
      ),
      body: Obx(() {
        return pages[controller.selectedPage.value]!();
      }),
    );
  }
}
