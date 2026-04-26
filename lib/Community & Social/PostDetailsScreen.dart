import 'package:flutter/material.dart';
import 'package:zorin/widgets/postmodel.dart';

class PostDetailsScreen extends StatefulWidget {
  final PostModel post;
  const PostDetailsScreen({super.key, required this.post});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  bool isLiked = false;
  late int currentLikes;
  late int currentComments;
  final TextEditingController _commentController = TextEditingController();

  String? replyingToUser;
  int? replyingToIndex;

  // هيكل البيانات مع تأمين القيم الابتدائية
  final List<Map<String, dynamic>> _comments = [
    {
      "name": "Ahmed Ali",
      "text": "Great work! Keep going 🚀",
      "likes": 5,
      "isLiked": false,
      "replies": [], // لستة فاضية عشان ميعملش نل
    },
  ];

  @override
  void initState() {
    super.initState();
    // تأمين القيم اللي جاية من الموديل
    currentLikes = widget.post.likesCount ?? 0;

    // حساب العداد الإجمالي بأمان
    int initialCount = _comments.length;
    for (var c in _comments) {
      var replies = c["replies"] as List?;
      initialCount += (replies?.length ?? 0);
    }
    currentComments = initialCount;
  }

  void _submitAction() {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      if (replyingToIndex != null) {
        // إضافة رد وتأمين وجود اللستة
        if (_comments[replyingToIndex!]["replies"] == null) {
          _comments[replyingToIndex!]["replies"] = [];
        }
        _comments[replyingToIndex!]["replies"].add({
          "name": "Me",
          "text": _commentController.text,
        });
      } else {
        // إضافة تعليق أساسي
        _comments.add({
          "name": "Me",
          "text": _commentController.text,
          "likes": 0,
          "isLiked": false,
          "replies": [],
        });
      }
      currentComments++;
      _commentController.clear();
      replyingToUser = null;
      replyingToIndex = null;
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF9186C4);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F0FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: primaryPurple,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Post Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildPostContent(primaryPurple),
            ),
            const Divider(thickness: 1, color: Colors.black12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Comments",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _comments.length,
              itemBuilder: (context, index) =>
                  _buildAdvancedComment(index, primaryPurple),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildInteractiveInput(primaryPurple),
    );
  }

  Widget _buildAdvancedComment(int index, Color color) {
    var comment = _comments[index];
    // تأمين كل المتغيرات داخل الكومنت
    int cLikes = comment["likes"] ?? 0;
    bool cIsLiked = comment["isLiked"] ?? false;
    List cReplies = comment["replies"] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const CircleAvatar(
            radius: 16,
            child: Icon(Icons.person, size: 18),
          ),
          title: Text(
            comment["name"] ?? "User",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(comment["text"] ?? ""),
              const SizedBox(height: 5),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() {
                      comment["isLiked"] = !cIsLiked;
                      comment["isLiked"]
                          ? comment["likes"] = cLikes + 1
                          : comment["likes"] = cLikes - 1;
                    }),
                    child: Text(
                      "Like ${cLikes > 0 ? cLikes : ""}",
                      style: TextStyle(
                        color: cIsLiked ? Colors.red : Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => setState(() {
                      replyingToUser = comment["name"];
                      replyingToIndex = index;
                    }),
                    child: Text(
                      "Reply",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (cReplies.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 60),
            child: Column(
              children: cReplies
                  .map(
                    (reply) => ListTile(
                      dense: true,
                      leading: const CircleAvatar(
                        radius: 12,
                        child: Icon(Icons.person, size: 14),
                      ),
                      title: Text(
                        reply["name"] ?? "User",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      subtitle: Text(
                        reply["text"] ?? "",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildInteractiveInput(Color color) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[200]!)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (replyingToUser != null)
              Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                child: Row(
                  children: [
                    Text(
                      "Replying to ",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      replyingToUser!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () => setState(() => replyingToUser = null),
                    ),
                  ],
                ),
              ),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: replyingToUser != null
                    ? "Write a reply..."
                    : "Write a comment...",
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(Icons.send_rounded, color: color),
                  onPressed: _submitAction,
                ),
                contentPadding: const EdgeInsets.all(15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostContent(Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: color,
                child: const Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.post.username ?? "User",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.post.studentId ?? "@id",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(widget.post.content ?? ""),
          const SizedBox(height: 15),
          Row(
            children: [
              _actionIcon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                "$currentLikes",
                isLiked ? Colors.red : Colors.grey,
                () {
                  setState(() {
                    isLiked = !isLiked;
                    isLiked ? currentLikes++ : currentLikes--;
                  });
                },
              ),
              const SizedBox(width: 20),
              _actionIcon(
                Icons.comment_outlined,
                "$currentComments",
                Colors.blue,
                () {},
              ),
              const SizedBox(width: 20),
              _actionIcon(Icons.share_outlined, "Share", Colors.green, () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Link copied!")));
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionIcon(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 5),
          Text(label),
        ],
      ),
    );
  }
}
