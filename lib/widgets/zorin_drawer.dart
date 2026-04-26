import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart'; // تأكدي إن المسار صح لملف الـ main

class ZorinDrawer extends StatelessWidget {
  const ZorinDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // السطر ده هو اللي كان ناقص عشان يحل الـ Error
    final appProvider = Provider.of<AppProvider>(context);

    // ربط الحالات بالـ Provider بدل القيم الثابتة
    bool isDark = appProvider.themeMode == ThemeMode.dark;
    bool isArabic = appProvider.locale.languageCode == 'ar';

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : const Color(0xFF787BB3),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 45, color: Color(0xFF787BB3)),
            ),
            accountName: const Text(
              "Rahma",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: const Text("Educational Technology"),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                _drawerTile(
                  Icons.groups_outlined,
                  isArabic ? "المجتمع" : "Community",
                  () {},
                ),
                _drawerTile(
                  Icons.notifications_none_rounded,
                  isArabic ? "التنبيهات" : "Notifications",
                  () {},
                ),
                _drawerTile(
                  Icons.quiz_outlined,
                  isArabic ? "الاختبارات" : "Quizzes",
                  () {},
                ),
                _drawerTile(
                  Icons.chat_bubble_outline_rounded,
                  isArabic ? "مساعد ذكي" : "AI Chat",
                  () {},
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          _actionTile(
            isDark ? Icons.light_mode : Icons.dark_mode,
            isArabic
                ? (isDark ? "الوضع الفاتح" : "الوضع المظلم")
                : (isDark ? "Light Mode" : "Dark Mode"),
            Switch(
              activeColor: const Color(0xFF787BB3),
              value: isDark,
              onChanged: (value) {
                appProvider.toggleTheme(value);
              },
            ),
          ),
          _actionTile(
            Icons.translate_rounded,
            isArabic ? "English" : "اللغة العربية",
            IconButton(
              icon: const Icon(Icons.swap_horiz, color: Color(0xFF787BB3)),
              onPressed: () {
                String newLang = isArabic ? 'en' : 'ar';
                appProvider.changeLanguage(newLang);
              },
            ),
          ),
          _drawerTile(
            Icons.settings_outlined,
            isArabic ? "الإعدادات" : "Settings",
            () {},
          ),
          _drawerTile(
            Icons.logout_rounded,
            isArabic ? "خروج" : "Logout",
            () {},
            color: Colors.redAccent,
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _drawerTile(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.blueGrey, size: 28),
      title: Text(title, style: TextStyle(fontSize: 16, color: color)),
      onTap: onTap,
      dense: true,
    );
  }

  Widget _actionTile(IconData icon, String title, Widget trailing) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey, size: 28),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: trailing,
      dense: true,
    );
  }
}
