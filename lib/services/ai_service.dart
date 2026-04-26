import 'package:google_generative_ai/google_generative_ai.dart';

class ZorinAIService {
  // حطي الـ API Key بتاعك هنا
  static const String _apiKey = "AIzaSyBHxmrvP3nv7HW7O5uUqru7Ke0Lni6JziE";

  final GenerativeModel _model;
  ChatSession? _chat;

  ZorinAIService()
    : _model = GenerativeModel(
        model: 'gemini-3-flash-preview',
        apiKey: _apiKey,
      );

  Future<String> startChat() async {
    _chat = _model.startChat(
      history: [
        Content.text(
          "أنت مساعد ذكي لتطبيق Zorin. وظيفتك توجيه الطلاب بأسلوب تفاعلي يشبه دولينجو. "
          "ابدأ بسؤالهم عن كليتهم. ثم اسأل عن خلفيتهم البرمجية. "
          "المسارات المتاحة عندنا: Flutter, Web, Cybersecurity. "
          "إذا سألوا عن شيء غير متاح مثل Data Analysis، اشرحه بذكاء ثم وضح أنه سيتوفر قريباً واقترح مصادر خارجية.",
        ),
      ],
    );

    final response = await _chat!.sendMessage(
      Content.text("ابدأ بترحيب وسؤال عن الكلية"),
    );
    return response.text ?? "أهلاً بك في زورين! ما هي كليتك؟";
  }

  Future<String> getResponse(String message) async {
    if (_chat == null) await startChat();
    final response = await _chat!.sendMessage(Content.text(message));
    return response.text ?? "حدث خطأ في السيرفر، حاول ثانية.";
  }
}
