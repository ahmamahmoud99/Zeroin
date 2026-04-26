import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/zorin_drawer.dart';

class LevelsScreen extends StatelessWidget {
  const LevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String trackTitle = args['title'] ?? 'No Title';
    final String trackId = args['trackId'] ?? '';
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FF),
      drawer: const ZorinDrawer(),
      body: Column(
        children: [
          _buildCreativeHeader(context, screenWidth, trackTitle),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tracks')
                  .doc(trackId)
                  .collection('levels')
                  .orderBy('order')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());
                var levels = snapshot.data!.docs;
                if (levels.isEmpty)
                  return const Center(child: Text("No levels added yet!"));

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: 20,
                  ),
                  itemCount: levels.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    var levelData =
                        levels[index].data() as Map<String, dynamic>;
                    return _buildLevelCard(
                      context,
                      screenWidth,
                      index: index,
                      title: levelData['title'] ?? 'Level',
                      subtitle: "Explore ${levelData['title']}",
                      isOpen: true,
                      trackId: trackId,
                      levelId: levels[index].id,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreativeHeader(BuildContext context, double w, String name) {
    return ClipPath(
      clipper: LevelWaveClipper(),
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6265AC), Color(0xFF7654F9)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: w * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelCard(
    BuildContext context,
    double screenWidth, {
    required int index,
    required String title,
    required String subtitle,
    required bool isOpen,
    required String trackId,
    required String levelId,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/lessons',
          arguments: {
            'levelName': title,
            'trackId': trackId,
            'levelId': levelId,
          },
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(screenWidth * 0.07),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: const LinearGradient(
            colors: [Color(0xFF7654F9), Color(0xFF9186C4)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -screenWidth * 0.05,
              bottom: -screenWidth * 0.05,
              child: Icon(
                Icons.auto_awesome,
                size: screenWidth * 0.35,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: screenWidth * 0.07,
                  ),
                ),
                SizedBox(height: screenWidth * 0.05),
                Text(
                  "Level ${index + 1}",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: screenWidth * 0.035,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.065,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: screenWidth * 0.032,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LevelWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 40);
    var cp1 = Offset(size.width / 4, size.height);
    var ep1 = Offset(size.width / 2, size.height - 20);
    path.quadraticBezierTo(cp1.dx, cp1.dy, ep1.dx, ep1.dy);
    var cp2 = Offset(size.width - (size.width / 4), size.height - 60);
    var ep2 = Offset(size.width, size.height - 20);
    path.quadraticBezierTo(cp2.dx, cp2.dy, ep2.dx, ep2.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
