import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F0FF), // خلفية لافندر الهوية
      body: Stack( // استخدمنا Stack عشان نحط ووتر مارك خفيفة في الخلفية
        children: [
          // 1. الووتر مارك باسم الأبلكيشن
          Positioned(
            top: 100,
            left: -20,
            child: Opacity(
              opacity: 0.03,
              child: Text("ZORIN", style: TextStyle(fontSize: 120, fontWeight: FontWeight.w900, color: Color(0xFF7654F9))),
            ),
          ),

          // 2. المحتوى الأساسي
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // أيقونة الهاكر المبرمج فوق خالص
                const Icon(Icons.psychology, size: 80, color: Color(0xFF7654F9)),
                const SizedBox(height: 10),
                const Text("MISSION ACCOMPLISHED", style: TextStyle(letterSpacing: 2, fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),

                const SizedBox(height: 20),

                // اسمك منور الشاشة
                const Text(
                  "RAHMA",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w900, color: Color(0xFF7654F9)),
                ),

                // الوردة المتحركة (الروح الحقيقية) 🌸
                // تأكدي إن ملف الـ JSON موجود في الـ assets
                SizedBox(
                  height: 250,
                  child: Lottie.asset(
                    'assets/flower.json',
                    repeat: false, // تفتح وتثبت على جمالها
                  ),
                ),

                const Text(
                  "Score: 100%",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                ),

                const SizedBox(height: 30),

                // الكلمة التحفيزية في كادر شيك
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFF7654F9).withOpacity(0.2)),
                    ),
                    child: const Text(
                      "\"The only way to learn a new programming language is by writing programs in it.\"",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // زرار العودة للتراكس
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7654F9),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                  icon: const Icon(Icons.home_filled),
                  label: const Text("Go to Dashboard", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}