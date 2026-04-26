import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String levelName = args['levelName'] ?? "Lesson";
    final String trackId = args['trackId'] ?? "";
    final String levelId = args['levelId'] ?? "";
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFF),
      body: Stack(
        children: [
          _buildCreativeHeader(context, screenHeight, screenWidth, levelName),
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.22),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tracks')
                  .doc(trackId)
                  .collection('levels')
                  .doc(levelId)
                  .collection('lessons')
                  .orderBy('order')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());
                var lessons = snapshot.data!.docs;
                if (lessons.isEmpty)
                  return const Center(child: Text("No lessons yet!"));

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08,
                    vertical: 20,
                  ),
                  itemCount: lessons.length,
                  itemBuilder: (context, index) {
                    var lessonData =
                        lessons[index].data() as Map<String, dynamic>;
                    Map<String, dynamic> step = {
                      'title': lessonData['title'],
                      'id': lessonData['videoUrl'],
                    };
                    return _buildModernStep(
                      context,
                      step,
                      index,
                      lessons.length,
                      screenWidth,
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

  Widget _buildCreativeHeader(
    BuildContext context,
    double h,
    double w,
    String name,
  ) {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        height: h * 0.3,
        width: w,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7654F9), Color(0xFF9D84FF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 22,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 10,
                ),
                child: Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: w * 0.065,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernStep(
    BuildContext context,
    Map step,
    int index,
    int total,
    double w,
  ) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
              if (index != total - 1)
                Expanded(
                  child: Container(
                    width: 2,
                    color: const Color(0xFF7654F9).withOpacity(0.2),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(
                context,
                '/video_player',
                arguments: {'title': step['title'], 'id': step['id']},
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 25),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: w * 0.038,
                            ),
                          ),
                          const Text(
                            "Video Lesson",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 60);
    var cp1 = Offset(size.width / 4, size.height);
    var ep1 = Offset(size.width / 2, size.height - 30);
    path.quadraticBezierTo(cp1.dx, cp1.dy, ep1.dx, ep1.dy);
    var cp2 = Offset(size.width - (size.width / 4), size.height - 80);
    var ep2 = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(cp2.dx, cp2.dy, ep2.dx, ep2.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
