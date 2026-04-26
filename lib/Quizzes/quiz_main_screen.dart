import 'package:flutter/material.dart';

class QuizMainScreen extends StatefulWidget {
  const QuizMainScreen({super.key});
  @override
  State<QuizMainScreen> createState() => _QuizMainScreenState();
}

class _QuizMainScreenState extends State<QuizMainScreen> {
  Map<int, int?> selectedAnswers = {
    0: null,
    1: null,
    2: null,
    3: null,
    4: null,
  };
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'ما هي لغة البرمجة المستخدمة في فلاتر؟',
      'options': ['Java', 'Dart', 'Python', 'Swift'],
      'correct': 1,
    },
    {
      'question': 'أي ويدجيت نستخدمه لعمل سكرول؟',
      'options': ['Column', 'Row', 'ListView', 'Container'],
      'correct': 2,
    },
    {
      'question': 'ما هو الأمر المستخدم لتحميل الباكدجات؟',
      'options': [
        'flutter run',
        'flutter build',
        'flutter pub get',
        'flutter doctor',
      ],
      'correct': 2,
    },
    {
      'question': 'ما هي وظيفة الـ State في فلاتر؟',
      'options': [
        'تغيير شكل الشاشة',
        'حفظ البيانات',
        'تحديث الواجهة',
        'كل ما سبق',
      ],
      'correct': 3,
    },
    {
      'question': 'من هو مطور إطار عمل فلاتر؟',
      'options': ['Facebook', 'Apple', 'Google', 'Microsoft'],
      'correct': 2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F0FF),
      appBar: AppBar(
        title: const Text(
          "ZORIN Quiz",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: questions.length,
        itemBuilder: (context, index) => _buildQuestionCard(index),
      ),
      bottomNavigationBar: _buildSubmitButton(),
    );
  }

  Widget _buildQuestionCard(int qIndex) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "سؤال ${qIndex + 1}: ${questions[qIndex]['question']}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          ...List.generate(4, (optIdx) {
            bool isSelected = selectedAnswers[qIndex] == optIdx;
            return GestureDetector(
              onTap: () => setState(() => selectedAnswers[qIndex] = optIdx),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF7654F9)
                      : const Color(0xFFF7F6FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.check_circle : Icons.circle_outlined,
                      color: isSelected ? Colors.white : Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      questions[qIndex]['options'][optIdx],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    bool isAllAnswered = !selectedAnswers.containsValue(null);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7654F9),
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: isAllAnswered
            ? () => Navigator.pushNamed(context, '/quiz_result')
            : null,
        child: const Text(
          "تسليم الإجابات 🚀",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
