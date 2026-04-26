import 'package:flutter/material.dart';

// بنعمل Enum عشان نحدد نوع التنبيه بسهولة في اللوجيك
enum NotificationType { like, comment, follow, share, reply }

class NotificationModel {
  final String id; // معرف التنبيه نفسه
  final String username; // اسم الشخص اللي عمل الأكشن
  final String userAvatar; // صورته
  final String content; // نص التنبيه (مثلاً: "علق على منشورك")
  final String?
  subContent; // لو فيه جزء من التعليق يظهر (زي الصورة اللي بعتيها)
  final String time; // وقت التنبيه
  final String postId; // الـ ID بتاع البوست عشان لما نضغط عليه يفتح
  final NotificationType type; // نوع التنبيه
  final bool isRead; // هل المستخدم شاف التنبيه ولا لاء

  NotificationModel({
    required this.id,
    required this.username,
    required this.userAvatar,
    required this.content,
    this.subContent,
    required this.time,
    required this.postId,
    required this.type,
    this.isRead = false,
  });

  // ميثود مساعدة بتجيب الأيقونة المناسبة بناءً على النوع
  IconData getIcon() {
    switch (type) {
      case NotificationType.like:
        return Icons.favorite_rounded;
      case NotificationType.comment:
      case NotificationType.reply:
        return Icons.chat_bubble_rounded;
      case NotificationType.follow:
        return Icons.person_add_rounded;
      case NotificationType.share:
        return Icons.share_rounded;
    }
  }

  // ميثود بتجيب اللون المناسب للأيقونة
  Color getIconColor() {
    switch (type) {
      case NotificationType.like:
        return Colors.redAccent;
      case NotificationType.comment:
      case NotificationType.reply:
        return const Color(0xFF9186C4); // البنفسجي بتاعنا
      case NotificationType.follow:
        return Colors.blue;
      case NotificationType.share:
        return Colors.green;
    }
  }
}
