import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_bottom_nav.dart';
import '../widgets/zorin_drawer.dart';

class TracksScreen extends StatelessWidget {
  final String userName;
  const TracksScreen({super.key, this.userName = "Sara Ahmed"});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {},
      ),
      drawer: const ZorinDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildCreativeHeader(context)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: size.height * 0.05),
              child: Column(
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Learning Student",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatItem(
                        label: "POINTS",
                        value: "120",
                        icon: Icons.star_rounded,
                      ),
                      _StatItem(
                        label: "WORLD RANK",
                        value: "#45",
                        icon: Icons.emoji_events_rounded,
                      ),
                      _StatItem(
                        label: "LOCAL RANK",
                        value: "#12",
                        icon: Icons.location_on_rounded,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 25, top: 30, bottom: 10),
              child: Text(
                "My Tracks",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('tracks').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  var doc = snapshot.data!.docs[index];
                  var data = doc.data() as Map<String, dynamic>;
                  return _itemCard(context, data, doc.id);
                }, childCount: snapshot.data!.docs.length),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _itemCard(
    BuildContext context,
    Map<String, dynamic> item,
    String docId,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [Color(0xFF363761), Color(0xFF478ED1)],
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: const CircleAvatar(
          backgroundColor: Colors.white24,
          child: Icon(Icons.rocket_launch, color: Colors.white),
        ),
        title: Text(
          item['title'] ?? '',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "View All",
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.white, size: 10),
            ],
          ),
        ),
        onTap: () => Navigator.pushNamed(
          context,
          '/levels',
          arguments: {'title': item['title'], 'trackId': docId},
        ),
      ),
    );
  }

  Widget _buildCreativeHeader(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: size.height * 0.2,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8486BA), Color(0xFF7654F9)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),
        Positioned(
          bottom: -40,
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 46,
              backgroundColor: const Color(0xFFF0EDFF),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.star_rate_rounded,
                    size: 80,
                    color: const Color(0xFF7654F9).withOpacity(0.1),
                  ),
                  const Icon(Icons.person, size: 40, color: Color(0xFF8486BA)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF7654F9)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
