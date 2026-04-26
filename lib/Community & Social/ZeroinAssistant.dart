import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// 1. استيراد مكتبة جوجل
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ZeroinAssistant extends StatefulWidget {
  const ZeroinAssistant({super.key});
  @override
  State<ZeroinAssistant> createState() => _ZeroinAssistantState();
}

class _ZeroinAssistantState extends State<ZeroinAssistant> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _msgs = [];

  // 2. تعريف موديل Gemini
  late GenerativeModel _model;
  final String _apiKey =
      "AIzaSyCKUTunROwL9igV8BMKDslFeVRxLiGx4ds"; // المفتاح بتاعك

  @override
  void initState() {
    super.initState();
    // 3. تهيئة الموديل عند فتح الشاشة
    _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('chat_history');
    setState(() {
      _msgs = data != null
          ? List<Map<String, dynamic>>.from(json.decode(data))
          : [
              {
                "t":
                    "اهلا بيكِ في Zorin! انا المساعد الذكي، اقدر اساعدك في ايه؟",
                "m": false,
              },
            ];
    });
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('chat_history', json.encode(_msgs));
  }

  // 4. ميثود الإرسال والرد الحقيقي
  Future<void> _send() async {
    if (_controller.text.trim().isEmpty) return;

    String userText = _controller.text;
    setState(() {
      _msgs.add({"t": userText, "m": true});
    });
    _controller.clear();
    _save();

    try {
      // إرسال لـ Gemini
      final content = [Content.text(userText)];
      final response = await _model.generateContent(content);

      setState(() {
        _msgs.add({
          "t": response.text ?? "معلش يا هندسة، جربي تاني.",
          "m": false,
        });
      });
      _save();
    } catch (e) {
      setState(() {
        _msgs.add({
          "t": "حصلت مشكلة في الاتصال، اتأكدي من الإنترنت.",
          "m": false,
        });
      });
    }
  }

  Future<void> _attach() async {
    FilePickerResult? result = await FilePicker.pickFiles();
    if (result != null) {
      setState(
        () =>
            _msgs.add({"t": "📎 File: ${result.files.first.name}", "m": true}),
      );
      _save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F0F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFF8E83BC),
              child: Icon(Icons.groups, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Zeroin Assistant",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Online",
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: _msgs.length,
              itemBuilder: (context, i) =>
                  _bubble(_msgs[i]['t'], _msgs[i]['m']),
            ),
          ),
          _inputArea(),
        ],
      ),
    );
  }

  Widget _bubble(String txt, bool isMe) => Align(
    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isMe ? null : const Color(0xFFC7B1D9),
        gradient: isMe
            ? const LinearGradient(
                colors: [Color(0xFF4DB6AC), Color(0xFFB2DFDB)],
              )
            : null,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(isMe ? 20 : 0),
          bottomRight: Radius.circular(isMe ? 0 : 20),
        ),
      ),
      child: Text(txt, style: const TextStyle(fontWeight: FontWeight.bold)),
    ),
  );

  Widget _inputArea() => Container(
    padding: const EdgeInsets.all(15),
    decoration: const BoxDecoration(
      color: Color(0xFFC7B8D9),
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    child: Row(
      children: [
        IconButton(
          icon: const Icon(Icons.attach_file, size: 28),
          onPressed: _attach,
        ),
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "Type a message",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: _send,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF4DB6AC), Color(0xFF80CBC4)],
              ),
            ),
            child: const Icon(Icons.send, color: Colors.white, size: 20),
          ),
        ),
      ],
    ),
  );
}
