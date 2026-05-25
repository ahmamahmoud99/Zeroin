import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../services/user_service.dart';
import '../../widgets/zorin_drawer.dart';

class TracksScreen extends StatefulWidget {
  const TracksScreen({super.key});

  @override
  State<TracksScreen> createState() => _TracksScreenState();
}

class _TracksScreenState extends State<TracksScreen> {
  final UserService _userService = UserService();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  bool showAllTracks = false;

  final List<List<Color>> trackColors = [
    [const Color(0xFF6C63FF), const Color(0xFF8E7BFF)],
    [const Color(0xFF11998E), const Color(0xFF38EF7D)],
    [const Color(0xFFFF9966), const Color(0xFFFF5E62)],
  ];

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text("User not logged in")));
    }

    final String uid = currentUser.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F5FB),

      drawer: const ZorinDrawer(),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,

        type: BottomNavigationBarType.fixed,

        selectedItemColor: const Color(0xFF7654F9),

        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,

        onTap: (index) {
          if (index == 0) return;

          if (index == 1) {
            Navigator.pushNamed(context, '/community');
          }

          if (index == 2) {
            Navigator.pushNamed(context, '/notifications');
          }

          if (index == 3) {
            Navigator.pushNamed(context, '/profile');
          }

          if (index == 4) {
            Navigator.pushNamed(context, '/settings');
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Tracks",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.groups_rounded),
            label: "Community",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none_rounded),
            label: "Notifications",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: "Profile",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: "Settings",
          ),
        ],
      ),

      body: StreamBuilder(
        stream: _userService.getUserData(uid),

        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF7654F9)),
            );
          }

          final user = userSnapshot.data!;

          final completedLessons = List<String>.from(
            user.completedLessons ?? [],
          );

          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),

              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  /// HEADER
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              "Hello, ${user.name} 👋",

                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              "Ready to learn something new?",

                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/notifications');
                        },

                        child: Container(
                          padding: const EdgeInsets.all(10),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),

                          child: const Icon(Icons.notifications_none_rounded),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  /// SEARCH
                  Container(
                    height: 55,

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(16),

                      border: Border.all(color: Colors.grey.shade200),
                    ),

                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,

                        hintText: "Search for courses, tracks...",

                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),

                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF8B80F8),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  /// CONTINUE LEARNING
                  /// CONTINUE LEARNING
                  Builder(
                    builder: (context) {
                      double continueProgress = 0;

                      if (completedLessons.isNotEmpty) {
                        continueProgress = completedLessons.length / 20;
                      }

                      if (continueProgress > 1) {
                        continueProgress = 1;
                      }

                      return Container(
                        width: double.infinity,

                        padding: const EdgeInsets.all(18),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),

                          gradient: const LinearGradient(
                            colors: [Color(0xFF8B80F8), Color(0xFF6C63FF)],
                          ),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Continue Learning",

                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),

                                const Spacer(),

                                Text(
                                  "${(continueProgress * 100).toInt()}%",

                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            Text(
                              (user.lastLessonTitle ?? "").isEmpty
                                  ? "Start Learning Now 🚀"
                                  : user.lastLessonTitle,

                              maxLines: 1,

                              overflow: TextOverflow.ellipsis,

                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),

                            const SizedBox(height: 18),

                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),

                              child: LinearProgressIndicator(
                                value: continueProgress,

                                minHeight: 7,

                                backgroundColor: Colors.white24,

                                valueColor: const AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            Align(
                              alignment: Alignment.centerRight,

                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),

                                decoration: BoxDecoration(
                                  color: Colors.white,

                                  borderRadius: BorderRadius.circular(12),
                                ),

                                child: const Text(
                                  "Continue",

                                  style: TextStyle(
                                    color: Color(0xFF6C63FF),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  /// TRACKS TITLE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      const Text(
                        "My Tracks",

                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showAllTracks = !showAllTracks;
                          });
                        },

                        child: Text(
                          showAllTracks ? "Show Less" : "View All",

                          style: TextStyle(
                            color: Colors.deepPurple.shade300,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  /// TRACKS
                  StreamBuilder<QuerySnapshot>(
                    stream: _db.collection('track1').snapshots(),

                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 40),

                            child: Text("No Tracks Found Yet"),
                          ),
                        );
                      }

                      return ListView.separated(
                        itemCount: showAllTracks
                            ? snapshot.data!.docs.length
                            : snapshot.data!.docs.length > 3
                            ? 3
                            : snapshot.data!.docs.length,

                        shrinkWrap: true,

                        physics: const NeverScrollableScrollPhysics(),

                        separatorBuilder: (_, __) => const SizedBox(height: 14),

                        itemBuilder: (context, index) {
                          final doc = snapshot.data!.docs[index];

                          final data = doc.data() as Map<String, dynamic>;

                          final int totalLessons = data['totalLessons'] ?? 1;

                          final int completedCount = completedLessons.where((
                            lessonId,
                          ) {
                            return lessonId.startsWith(doc.id);
                          }).length;

                          final double progress = completedCount / totalLessons;

                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/levels',

                                arguments: {
                                  'title': data['title'],
                                  'trackId': doc.id,
                                },
                              );
                            },

                            child: Container(
                              padding: const EdgeInsets.all(14),

                              decoration: BoxDecoration(
                                color: Colors.white,

                                borderRadius: BorderRadius.circular(18),

                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(.03),

                                    blurRadius: 10,

                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),

                              child: Row(
                                children: [
                                  Container(
                                    width: 55,
                                    height: 55,

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),

                                      gradient: LinearGradient(
                                        colors:
                                            trackColors[index %
                                                trackColors.length],
                                      ),
                                    ),

                                    child: const Icon(
                                      Icons.code_rounded,
                                      color: Colors.white,
                                    ),
                                  ),

                                  const SizedBox(width: 14),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        Text(
                                          data['title'] ?? "",

                                          maxLines: 1,

                                          overflow: TextOverflow.ellipsis,

                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,

                                            fontSize: 14,
                                          ),
                                        ),

                                        const SizedBox(height: 8),

                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),

                                          child: LinearProgressIndicator(
                                            value: progress,

                                            minHeight: 6,

                                            backgroundColor:
                                                Colors.grey.shade200,

                                            valueColor:
                                                const AlwaysStoppedAnimation(
                                                  Color(0xFF8B80F8),
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Text(
                                    "${(progress * 100).toInt()}%",

                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,

                                      color: Color(0xFF6C63FF),

                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  /// CATEGORIES
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      const Text(
                        "Categories",

                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "View All",

                        style: TextStyle(
                          color: Colors.deepPurple.shade300,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,

                    physics: const BouncingScrollPhysics(),

                    child: const Row(
                      children: [
                        _CategoryItem(
                          icon: Icons.design_services_outlined,
                          title: "Design",
                        ),

                        SizedBox(width: 14),

                        _CategoryItem(
                          icon: Icons.code_rounded,
                          title: "Development",
                        ),

                        SizedBox(width: 14),

                        _CategoryItem(
                          icon: Icons.campaign_outlined,
                          title: "Marketing",
                        ),

                        SizedBox(width: 14),

                        _CategoryItem(
                          icon: Icons.business_center_outlined,
                          title: "Business",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// RECOMMENDED
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      const Text(
                        "Recommended for you",

                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "View All",

                        style: TextStyle(
                          color: Colors.deepPurple.shade300,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Container(
                    padding: const EdgeInsets.all(14),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(18),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.03),

                          blurRadius: 10,

                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: Row(
                      children: [
                        Container(
                          width: 65,
                          height: 65,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),

                            gradient: const LinearGradient(
                              colors: [Color(0xFF8B80F8), Color(0xFF6C63FF)],
                            ),
                          ),

                          child: const Icon(
                            Icons.bolt_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                user.lastLessonTitle ??
                                    "Introduction to Flutter",

                                maxLines: 1,

                                overflow: TextOverflow.ellipsis,

                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                "by Zorin Team",

                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: Colors.orange,
                                    size: 18,
                                  ),

                                  const SizedBox(width: 4),

                                  const Text("4.8"),

                                  const SizedBox(width: 6),

                                  Text(
                                    "(230)",

                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const Icon(Icons.bookmark_border_rounded),
                      ],
                    ),
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const _CategoryItem({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 65,
          height: 65,

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(18),

            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(.03), blurRadius: 8),
            ],
          ),

          child: Icon(icon, color: const Color(0xFF8B80F8)),
        ),

        const SizedBox(height: 10),

        Text(
          title,

          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
