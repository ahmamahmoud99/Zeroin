import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart'; // مكتبة جوجل

class ZeroinAssistant extends StatefulWidget {
  const ZeroinAssistant({super.key});

  @override
  State<ZeroinAssistant> createState() => _ZeroinAssistantState();
}

class _ZeroinAssistantState extends State<ZeroinAssistant> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {
      "sender": "bot",
      "text":
          "اهلا بكِ في Zorin! أنا مدعوم بذكاء Gemini، اسأليني أي شيء عن التعليم أو البرمجة.",
    },
  ];

  // حطي الـ API Key بتاعك هنا (مهم جداً)
  final String _apiKey = "AIzaSyBNgwiBFhXVUTGaR9WVfmGY8G2a0SARDFI";
  late GenerativeModel _model;
  bool _isLoading = false; // عشان نبين ان البوت بيفكر

  @override
  void initState() {
    super.initState();
    // تهيئة موديل Gemini
    _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    String userText = _messageController.text;
    setState(() {
      _messages.add({"sender": "user", "text": userText});
      _isLoading = true; // ابدأي التحميل
      _messageController.clear();
    });

    try {
      // إرسال الرسالة لـ Gemini فعلياً
      final content = [Content.text(userText)];
      final response = await _model.generateContent(content);

      setState(() {
        _messages.add({
          "sender": "bot",
          "text": response.text ?? "عذراً، لم أستطع فهم ذلك.",
        });
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add({
          "sender": "bot",
          "text": "حصلت مشكلة في الاتصال، اتأكدي من الـ API Key والإنترنت.",
        });
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF9186C4);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F0FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Zorin AI Assistant",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                bool isUser = _messages[index]["sender"] == "user";
                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? primaryPurple : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Text(
                      _messages[index]["text"]!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const LinearProgressIndicator(
              color: primaryPurple,
              backgroundColor: Colors.transparent,
            ),
          _buildInputArea(primaryPurple),
        ],
      ),
    );
  }

  Widget _buildInputArea(Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "اسألي Gemini Zorin...",
                filled: true,
                fillColor: const Color(0xFFF3F0FF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _sendMessage(), // الإرسال عند الضغط على Enter
            ),
          ),
          IconButton(
            icon: Icon(Icons.send_rounded, color: color),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
