import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const primaryColor = Color(0xFF7B61FF); // لافندر الفيجما

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. الجزء العلوي (Header + Profile Picture)
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // الكيرف البنفسجي اللي فوق
                Container(
                  height: size.height * 0.25,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                ),
                // صورة البروفايل (فوق الكيرف)
                Positioned(
                  top: size.height * 0.15,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: CircleAvatar(
                      radius: size.height * 0.07,
                      backgroundImage: const AssetImage('assets/image/user_profile.png'), // صورتك هنا
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: size.height * 0.1),

            // 2. الاسم والوظيفة
            const Text(
              "Ali Ahmed",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Flutter Developer",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),

            SizedBox(height: size.height * 0.03),

            // 3. قسم الإحصائيات (Stats Row) - زي الفيجما بالظبط
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem("12", "Courses"),
                  _buildStatItem("45h", "Learning"),
                  _buildStatItem("8", "Certificates"),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(20),
              child: Divider(thickness: 1, color: Color(0xFFF0F0F0)),
            ),

            // 4. قائمة الإعدادات (Settings List)
            _buildSettingsItem(Icons.person_outline, "Edit Profile"),
            _buildSettingsItem(Icons.notifications_none, "Notifications"),
            _buildSettingsItem(Icons.security, "Security"),
            _buildSettingsItem(Icons.help_outline, "Help Center"),
            _buildSettingsItem(Icons.logout, "Logout", isLogout: true),

            SizedBox(height: size.height * 0.05),
          ],
        ),
      ),
    );
  }

  // Widget فرعي للإحصائيات
  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF7B61FF))),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      ],
    );
  }

  // Widget فرعي لقائمة الإعدادات
  Widget _buildSettingsItem(IconData icon, String title, {bool isLogout = false}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isLogout ? Colors.red[50] : const Color(0xFFF8F7FF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: isLogout ? Colors.red : const Color(0xFF7B61FF)),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: isLogout ? Colors.red : Colors.black87)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {},
    );
  }
}