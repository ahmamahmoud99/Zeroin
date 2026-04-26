import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:zorin/widgets/zorin_button.dart';

class MyIntroScreens extends StatefulWidget {
  const MyIntroScreens({super.key});

  @override
  State<MyIntroScreens> createState() => _MyIntroScreensState();
}

class _MyIntroScreensState extends State<MyIntroScreens> {
  final _introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IntroductionScreen(
        key: _introKey,
        rawPages: [
          _buildCustomPage(
            image: "assets/image/intro_one.png",
            title: "Welcome to Zeroin",
            body: "Explore your coding journey",
          ),
          _buildCustomPage(
            image: "assets/image/intro_tow.png",
            title: "Build Your Roadmap",
            body: "Create a custom learning path",
          ),
          _buildCustomPage(
            image: "assets/image/intro_three.PNG",
            title: "Watch Video Lessons",
            body: "Unlock new skills, get XP!",
          ),
          _buildCustomPage(
            image: "assets/image/intro_4.png",
            title: "Join Our Community",
            body: "Connect, learn, share code",
            isLast: true,
          ),
        ],
        showNextButton: false,
        showDoneButton: false,
        dotsDecorator: const DotsDecorator(
          size: Size.square(10.0),
          activeSize: Size(22.0, 10.0),
          activeColor: Color(0xFF7B61FF),
          color: Colors.black12,
          spacing: EdgeInsets.symmetric(horizontal: 4.0, vertical: 105),
        ),
      ),
    );
  }

  Widget _buildCustomPage({
    required String image,
    required String title,
    required String body,
    bool isLast = false,
  }) {
    return Stack(
      children: [
        Positioned(
          top: 50,
          right: 20,
          child: TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            child: const Text(
              "Skip",
              style: TextStyle(
                color: Color(0xFF7B61FF),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(image, height: 280),
                const SizedBox(height: 40),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  body,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 30,
          left: 20,
          right: 20,
          child: ZorinButton(
            text: isLast ? "Get Started" : "Next",
            onPressed: () {
              if (isLast) {
                Navigator.pushReplacementNamed(context, '/login');
              } else {
                _introKey.currentState?.next();
              }
            },
          ),
        ),
      ],
    );
  }
}
