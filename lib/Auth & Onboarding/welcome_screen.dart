import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _handleSplashTransition();
  }

  void _handleSplashTransition() async {
    // استني 3 ثواني عشان الدكتور يلحق يشوف اللوجو والجملة اللي تعبتي فيهم
    await Future.delayed(const Duration(seconds: 3));

    // شيل السبلاش دلوقتي واظهر محتوى الـ Welcome
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // محتوى صفحة الـ Welcome بتاعتك (اللوجو وزرار البداية)
            Image.asset('assets/image/intro_one.png', width: 612),
            const SizedBox(height: 24),
            const Text("Welcome to Zorin", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300)),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/intro'),
              child: const Text("Get Started"),
            ),
          ],
        ),
      ),
    );
  }
}