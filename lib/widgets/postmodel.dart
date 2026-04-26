class PostModel {
  final String id; // معرف فريد لكل بوسط
  final String username;
  final String? studentId; // زي @student
  final String userImageUrl;
  final String content;
  final String? codeSnippet;
  int likesCount; // عدد اللايكات
  bool isLiked; // هل المستخدم الحالي عامل لايك؟
  int commentsCount;

  PostModel({
    required this.id,
    required this.username,
    this.studentId,
    required this.userImageUrl,
    required this.content,
    this.codeSnippet,
    this.likesCount = 0,
    this.isLiked = false,
    this.commentsCount = 0,
  });
}
