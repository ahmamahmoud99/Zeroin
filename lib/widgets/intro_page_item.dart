import 'package:flutter/material.dart';

class IntroPageItem extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon; // أو String imagePath لو هتستخدمي صور

  const IntroPageItem({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 120, color: const Color(0xFFB19CD9)), // اللافندر الموحد
        const SizedBox(height: 40),
        Text(
          title,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFFB19CD9)),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
          ),
        ),
      ],
    );
  }
}