import 'package:flutter/material.dart';

import '../services/ai_service.dart';
import '../widgets/zorin_drawer.dart';

class AIOrientationScreen extends StatefulWidget {
  const AIOrientationScreen({super.key});

  @override
  _AIOrientationScreenState createState() => _AIOrientationScreenState();
}

class _AIOrientationScreenState extends State<AIOrientationScreen> {
  final ZorinAIService _aiService = ZorinAIService();
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  // اللوجيك بتاعك: عداد الأسئلة (عشان نوقف عند 3)
  int _questionCount = 0;
  final int _maxQuestions = 3;

  @override
  void initState() {
    super.initState();
    _loadInitialMessage();
  }

  void _loadInitialMessage() async {
    setState(() => _isLoading = true);
    String msg = await _aiService.startChat();
    setState(() {
      _messages.add({"role": "ai", "text": msg});
      _isLoading = false;
    });
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty || _isLoading) return;
    String userMsg = _controller.text;

    setState(() {
      _messages.add({"role": "user", "text": userMsg});
      _controller.clear();
      _isLoading = true;
    });

    try {
      String aiResponse = await _aiService.getResponse(userMsg);

      setState(() {
        _messages.add({"role": "ai", "text": aiResponse});
        _questionCount++;
      });

      // لو وصلنا لـ 3 أسئلة، يبدأ الـ AI يحلل النتيجة النهائية
      if (_questionCount >= _maxQuestions) {
        _finishOrientation();
      }
    } catch (e) {
      setState(() {
        _messages.add({
          "role": "ai",
          "text": "حدث خطأ في الاتصال، حاول مرة أخرى.",
        });
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _finishOrientation() async {
    setState(() => _isLoading = true);

    // الـ AI بياخد القرار النهائي هنا بناءً على الشات
    String finalDecision = await _aiService.getResponse(
      "بناءً على إجاباتي، حدد لي تراك (Mobile/Web) ومستوى (Level 1/2/3). رد بكلمتين فقط.",
    );

    String targetTrack = finalDecision.toLowerCase().contains("web")
        ? "Web Development"
        : "Mobile Development";
    String level = finalDecision.contains("2")
        ? "Level 2"
        : (finalDecision.contains("3") ? "Level 3" : "Level 1");

    setState(() {
      _messages.add({
        "role": "ai",
        "text":
            "تحليل رائع! ستبدأ مسار $targetTrack من $level. جاري التحويل...",
      });
    });

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      // الانتقال السلس لصفحة التراكات مع تمرير النتيجة
      Navigator.pushReplacementNamed(
        context,
        '/tracks',
        arguments: {'track': targetTrack, 'level': level},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F0FF),
      drawer: const ZorinDrawer(),
      appBar: AppBar(
        title: const Text(
          "مساعد زورين الذكي ✨",
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                bool isAI = _messages[index]["role"] == "ai";
                return _buildBubble(isAI, _messages[index]["text"]!);
              },
            ),
          ),
          if (_isLoading)
            const LinearProgressIndicator(color: Color(0xFF787BB3)),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildBubble(bool isAI, String text) {
    return Align(
      alignment: isAI ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isAI ? const Color(0xFF6265AC) : Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isAI ? Colors.white : Colors.black87,
            fontFamily: 'Cairo',
          ),
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: "اسأل زورين...",
                hintStyle: const TextStyle(fontFamily: 'Cairo'),
                filled: true,
                fillColor: const Color(0xFFF0F2F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFF787BB3)),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
