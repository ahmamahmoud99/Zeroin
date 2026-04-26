import 'package:flutter/material.dart';
import 'package:zorin/Community%20&%20Social/Notifications.dart';
import 'package:zorin/Community%20&%20Social/community_feed_screen.dart';

class MainWrapper extends StatefulWidget {
  final String userName;
  final String userEmail;
  const MainWrapper({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  final int _selectedIndex = 0;

  // الصفحات الآن كل واحدة شايلة الـ Scaffold بتاعها
  final List<Widget> _pages = [
    const NotificationsScreen(),
    const CommunityFeedScreen(),
    const Center(child: Text("Tracks")),
    const Center(child: Text("Settings")),
  ];

  @override
  Widget build(BuildContext context) {
    // هنا الـ MainWrapper بسيط جداً، مجرد بيعرض الصفحة المختارة
    // والـ NavBar موجود جوه كل صفحة منهم عشان نضمن الـ Fit والـ Scaffold
    return _pages[_selectedIndex];
  }
}
