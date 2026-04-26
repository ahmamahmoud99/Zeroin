class UserModel {
  final String uid;
  final String name;
  final String email;
  final String major; // القسم (تكنولوجيا تعليم)
  final String role; // طالب / محاضر

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.major,
    this.role = 'student',
  });

  // تحويل لـ Map عشان Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'major': major,
      'role': role,
      'createdAt': DateTime.now(),
    };
  }
}
