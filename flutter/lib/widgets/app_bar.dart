import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;

  const CommonAppBar({super.key, required this.title, this.actions = const []});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: actions,
      iconTheme: const IconThemeData(color: Colors.white,),
      centerTitle: true,
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight, // Başlangıç yönü
            end: Alignment.bottomRight, // Bitiş yönü
            colors: [
              Color(0xFCC53C26),
              Color(0xFF0D40E5),
            ],
          ),
        ),
      ),

    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize; // AppBar'ın boyutunu almak için kullanılır
}
