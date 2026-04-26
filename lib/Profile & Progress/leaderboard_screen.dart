import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const primaryColor = Color(0xFF7B61FF);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Leaderboard", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 1. الجزء العلوي (Top 3 Players)
          Container(
            height: size.height * 0.3,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildTopPlayer(size, "Ali Ahmed", "2nd", 60, Colors.grey[300]!),
                _buildTopPlayer(size, "Rahma", "1st", 85, const Color(0xFFFFD700)), // Gold for you!
                _buildTopPlayer(size, "Mona", "3rd", 55, Colors.orange[300]!),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 2. قائمة باقي المتصدرين (Scrollable List)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8F7FF),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: 10, // عدد الطلبة
                itemBuilder: (context, index) {
                  return _buildLeaderboardTile(index + 4, "Student Name", "1250 XP");
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget للمراكز التلاتة الأولى
  Widget _buildTopPlayer(Size size, String name, String rank, double radius, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(rank, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7B61FF))),
        const Icon(Icons.arrow_drop_up, color: Colors.green),
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: CircleAvatar(
            radius: radius / 2,
            backgroundColor: Colors.white,
            child: const Icon(Icons.person, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
      ],
    );
  }

  // Widget لشكل الصف في القائمة
  Widget _buildLeaderboardTile(int rank, String name, String points) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Text("#$rank", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(width: 15),
          const CircleAvatar(radius: 20, backgroundColor: Color(0xFFF0EEFF), child: Icon(Icons.person, size: 20)),
          const SizedBox(width: 15),
          Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(points, style: const TextStyle(color: Color(0xFF7B61FF), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}