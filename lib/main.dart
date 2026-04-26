import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// اتأكدي إن المسارات دي صحيحة حسب ترتيب الفولدرات عندك
import 'Auth & Onboarding/AIOrientationScreen.dart';
import 'Auth & Onboarding/intro_screens.dart';
import 'Auth & Onboarding/login_screen.dart';
import 'Auth & Onboarding/welcome_screen.dart';
import 'Community & Social/community_feed_screen.dart';
import 'Learning & Roadmap/lessons_screen.dart';
import 'Learning & Roadmap/levels_screen.dart';
import 'Learning & Roadmap/tracks_screen.dart';
import 'Learning & Roadmap/video_player_screen.dart';
import 'Quizzes/quiz_main_screen.dart';
import 'firebase_options.dart';

// 1. إضافة كلاس الـ AppProvider هنا عشان الـ main تشوفه
class AppProvider extends ChangeNotifier {
  ThemeMode _themeMode;
  Locale _locale;

  AppProvider(bool isDark, String lang)
    : _themeMode = isDark ? ThemeMode.dark : ThemeMode.light,
      _locale = Locale(lang);

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  void toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', isDark);
    notifyListeners();
  }

  void changeLanguage(String langCode) async {
    _locale = Locale(langCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', langCode);
    notifyListeners();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final bool isDark = prefs.getBool('isDark') ?? false;
  final String lang = prefs.getString('languageCode') ?? 'ar';

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(isDark, lang),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: appProvider.locale,
          themeMode: appProvider.themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: const Color(0xFF787BB3),
            fontFamily: 'Cairo', // اتأكدي إن الخط متضاي في الـ pubspec
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: const Color(0xFF787BB3),
            fontFamily: 'Cairo',
            useMaterial3: true,
          ),
          initialRoute: '/intro',
          routes: {
            '/intro': (context) => const MyIntroScreens(),
            '/welcome': (context) => const WelcomeScreen(),
            '/login': (context) => const LoginScreen(),
            '/ai_orientation': (context) => const AIOrientationScreen(),
            // 2. تعديل هنا: نبعت userName للـ TracksScreen
            '/tracks': (context) => const TracksScreen(userName: "Rahma"),
            '/levels': (context) => const LevelsScreen(),
            '/lessons': (context) => const LessonsScreen(),
            '/video_player': (context) => const VideoPlayerScreen(),
            '/quiz': (context) => const QuizMainScreen(),
            '/quiz': (context) => const QuizMainScreen(),
            '/community': (context) => const CommunityFeedScreen(),
          },
        );
      },
    );
  }
}
