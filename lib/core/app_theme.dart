import 'package:flutter/material.dart';

class ZorinColors {
  static const Color primaryLavender = Color(0xFFB19CD9); // اللافندر الأساسي
  static const Color accentCyan = Color(0xFFAFEEEE);     // السيان للتنبيهات
  static const Color softGrey = Color(0xFFF3F4F6);       // خلفية الشاشات
  static const Color cardBackground = Color(0xFFFFFFFF);
}

class ZorinTheme {
  static ThemeData get lightTheme => ThemeData(
    primaryColor: ZorinColors.primaryLavender,
    scaffoldBackgroundColor: ZorinColors.softGrey,
    // تصغير حجم الأيقونات الافتراضي ليكون Minimalist
    iconTheme: const IconThemeData(size: 20, color: Colors.black54),
  );
}