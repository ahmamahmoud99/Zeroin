import 'package:flutter/material.dart';
import 'package:zorin/Community%20&%20Social/PostDetailsScreen.dart';
import 'package:zorin/widgets/custom_bottom_nav.dart';
import 'package:zorin/widgets/notification_model.dart';
import 'package:zorin/widgets/postmodel.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedTab = "All";
  int _unreadCount = 3;
  int _currentIndex = 0;

  final List<NotificationModel> _allNotifications = [
    NotificationModel(
      id: "1",
      username: "Ahmed Hassan",
      userAvatar: "https://i.pravatar.cc/150?u=a",
      content: "replied to your comment",
      subContent: "This is really helpful! 👍",
      time: "5 min ago",
      postId: "post_123",
      type: NotificationType.reply,
    ),
    NotificationModel(
      id: "2",
      username: "Reem",
      userAvatar: "https://i.pravatar.cc/150?u=r",
      content: "mentioned you in a comment",
      subContent: "Great point, @Sara Ahmed!",
      time: "20 min ago",
      postId: "post_456",
      type: NotificationType.comment,
    ),
  ];

  List<NotificationModel> get _filteredNotifications {
    if (_selectedTab == "All") return _allNotifications;
    if (_selectedTab == "Mentions") {
      return _allNotifications
          .where(
            (n) =>
                n.type == NotificationType.comment ||
                n.type == NotificationType.reply,
          )
          .toList();
    }
    if (_selectedTab == "Messages") {
      return [];
    }
    return _allNotifications;
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF9186C4);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F0FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: primaryPurple,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          _buildNotificationBadge(primaryPurple),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          _buildTabs(),
          Expanded(
            child: _filteredNotifications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _filteredNotifications.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) =>
                        _buildNotificationItem(_filteredNotifications[index]),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          "All",
          "Mentions",
          "Messages",
        ].map((title) => _tabItem(title)).toList(),
      ),
    );
  }

  Widget _tabItem(String title) {
    bool isActive = _selectedTab == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF9186C4) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isActive
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(NotificationModel item) {
    return GestureDetector(
      onTap: () {
        // تم تصحيح اللوجيك هنا وحذف التكرار اللي كان مسبب المشكلة
        PostModel postToDisplay = PostModel(
          id: item.postId,
          username: item.username,
          studentId: "@user_id",
          content:
              "This is the content of the post you clicked on from notifications!",
          likesCount: 15,
          commentsCount: 5,
          userImageUrl: item.userAvatar,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailsScreen(post: postToDisplay),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(item.userAvatar),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                      children: [
                        TextSpan(
                          text: "${item.username} ",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: item.content),
                      ],
                    ),
                  ),
                  if (item.subContent != null)
                    Text(
                      item.subContent!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    item.time,
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
            ),
            Icon(item.getIcon(), color: item.getIconColor(), size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 10),
          Text(
            "No $_selectedTab yet",
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "We'll let you know when something arrives!",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationBadge(Color color) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: Color(0xFF9186C4),
            size: 28,
          ),
          onPressed: () => setState(() => _unreadCount = 0),
        ),
        if (_unreadCount > 0)
          Positioned(
            right: 8,
            top: 10,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Text(
                "$_unreadCount",
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
      ],
    );
  }
}
