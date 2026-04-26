import 'package:flutter/material.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FF),
      appBar: AppBar(
        title: const Text("My Achievements", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        // عرض عمودين في الشاشة عشان المقاس يظبط على الـ Infinix
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 0.85, // تظبيط طول الكارت بالنسبة لعرضه
        ),
        itemCount: 8, // عدد الإنجازات
        itemBuilder: (context, index) {
          // مثال: أول 3 إنجازات "مفتوحة" والباقي "مقفول"
          bool isUnlocked = index < 3;
          return _buildAchievementCard(
              "Course Starter",
              "Finish your first lesson",
              isUnlocked
          );
        },
      ),
    );
  }

  Widget _buildAchievementCard(String title, String desc, bool isUnlocked) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // الأيقونة: لو مقفولة تبقا باهتة (Grey) ولو مفتوحة لافندر
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isUnlocked ? const Color(0xFFF0EEFF) : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              isUnlocked ? Icons.emoji_events : Icons.lock_outline,
              size: 40,
              color: isUnlocked ? const Color(0xFF7B61FF) : Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isUnlocked ? Colors.black : Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              desc,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}