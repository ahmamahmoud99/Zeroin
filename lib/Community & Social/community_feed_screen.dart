import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zorin/Community%20&%20Social/create_post_screen.dart';
import 'package:zorin/widgets/postmodel.dart';

class CommunityFeedScreen extends StatefulWidget {
  const CommunityFeedScreen({super.key});

  @override
  State<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends State<CommunityFeedScreen> {
  final ImagePicker _picker = ImagePicker();

  // نفس الداتا بتاعتك بالظبط
  List<PostModel> posts = [
    PostModel(
      id: "1",
      username: "Sara Ahmed",
      studentId: "@student_tech",
      userImageUrl: "assets/image/user_avatar.png",
      content: "Post for a prescript and teaching on in code snippets..",
      codeSnippet:
          "<Code File>\n<sales>\nList connections = new SqlCatenateEnum()",
      likesCount: 15,
      commentsCount: 3,
    ),
    PostModel(
      id: "2",
      username: "Omar Ali",
      studentId: "@dev_omar",
      userImageUrl: "assets/image/user_avatar.png",
      content: "It's truly inspiring to see such a great achievement! 🏆",
      likesCount: 50,
      isLiked: true,
      commentsCount: 10,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // شلنا الـ Scaffold والـ AppBar من هنا عشان ميحصلش تداخل
    // وبدلناهم بـ Stack عشان نحافظ على الـ FloatingActionButton في مكانه
    return Stack(
      children: [
        ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: posts.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) =>
              _buildPostCard(context, posts[index]),
        ),
        // زر الـ Create Post هيفضل في مكانه بالظبط
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton.extended(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreatePostScreen()),
            ),
            label: const Text("Create Post"),
            icon: const Icon(Icons.edit_note_rounded),
            backgroundColor: const Color(0xFF9186C4),
          ),
        ),
      ],
    );
  }

  // --- كل الميثودات دي زي ما هي بالظبط (الديزاين واللوجيك محفوظ) ---
  Widget _buildPostCard(BuildContext context, PostModel post) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserHeader(context, post),
            const SizedBox(height: 16),
            Text(
              post.content,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
            if (post.codeSnippet != null && post.codeSnippet!.isNotEmpty)
              _buildCodeBlock(post.codeSnippet!),
            const SizedBox(height: 20),
            Container(height: 1, color: Colors.grey[200]),
            const SizedBox(height: 10),
            _buildActionButtons(context, post),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context, PostModel post) {
    return InkWell(
      onTap: () => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Profile: ${post.username}"))),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFF9186C4),
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.username,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (post.studentId != null)
                Text(
                  post.studentId!,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.more_horiz_rounded, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildCodeBlock(String code) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        code,
        style: const TextStyle(
          color: Colors.greenAccent,
          fontFamily: 'monospace',
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, PostModel post) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          icon: post.isLiked
              ? Icons.favorite_rounded
              : Icons.favorite_outline_rounded,
          color: post.isLiked ? Colors.red : Colors.grey,
          label: "Like (${post.likesCount})",
          onTap: () => setState(() {
            post.isLiked = !post.isLiked;
            post.isLiked ? post.likesCount++ : post.likesCount--;
          }),
        ),
        _buildActionButton(
          icon: Icons.chat_bubble_outline_rounded,
          color: Colors.grey,
          label: "Comment (${post.commentsCount})",
          onTap: () => _showEnhancedCommentsSheet(context, post),
        ),
        _buildActionButton(
          icon: Icons.share_rounded,
          color: Colors.grey,
          label: "Share",
          onTap: () => Share.share('Check out this post: ${post.content}'),
        ),
      ],
    );
  }

  void _showEnhancedCommentsSheet(BuildContext context, PostModel post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "Comments (${post.commentsCount})",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Divider(),
            Row(
              children: [
                _mediaIcon(
                  Icons.camera_alt_rounded,
                  Colors.pink,
                  "Camera",
                  () async =>
                      await _picker.pickImage(source: ImageSource.camera),
                ),
                _mediaIcon(
                  Icons.image_rounded,
                  Colors.green,
                  "Image",
                  () async =>
                      await _picker.pickImage(source: ImageSource.gallery),
                ),
                _mediaIcon(
                  Icons.videocam_rounded,
                  Colors.red,
                  "Video",
                  () async =>
                      await _picker.pickVideo(source: ImageSource.gallery),
                ),
                _mediaIcon(Icons.code_rounded, Colors.blue, "Code", () {}),
              ],
            ),
            _buildCommentTextField(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _mediaIcon(
    IconData icon,
    Color color,
    String tooltip,
    VoidCallback onTap,
  ) {
    return IconButton(
      icon: Icon(icon, color: color, size: 22),
      onPressed: onTap,
      tooltip: tooltip,
    );
  }

  Widget _buildCommentTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Write a comment...",
          suffixIcon: const Icon(Icons.send_rounded, color: Color(0xFF9186C4)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontSize: 13)),
        ],
      ),
    );
  }
}
