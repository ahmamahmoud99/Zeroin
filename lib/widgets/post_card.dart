import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart'; // مكتبة الشير (اختياري)

class PostCard extends StatefulWidget {
  final String username;
  final String content;

  const PostCard({super.key, required this.username, required this.content});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked = false; // حالة الإعجاب

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // هيدر البوست
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFF3F3F3),
                  child: Icon(Icons.person, color: Color(0xFF9186C4)),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                const Icon(Icons.more_horiz, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 12),
            Text(widget.content, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 10),
            const Divider(),

            // سطر التفاعل (Like, Comment, Share) - التصميم الأصلي
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // زرار اللايك (بيغير لونه لما تدوسي)
                InkWell(
                  onTap: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        size: 20,
                        color: isLiked ? Colors.red : Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      const Text("Like"),
                    ],
                  ),
                ),
                // زرار الكومنت
                InkWell(
                  onTap: () {},
                  child: const Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 20,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 5),
                      Text("Comment"),
                    ],
                  ),
                ),
                // زرار الشير (مفعل)
                InkWell(
                  onTap: () {
                    // بياخد محتوى البوست ويبعته لأي تطبيق تاني
                    Share.share(
                      widget.content,
                      subject: 'Check this post from Zorin!',
                    );
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.share_outlined, size: 20, color: Colors.grey),
                      SizedBox(width: 5),
                      Text("Share"),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // منطقة الكومنت مع أيقونات الصور والفيديو (اللي طلبتيها)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Write a comment...",
                      hintStyle: const TextStyle(fontSize: 14),
                      filled: true,
                      fillColor: const Color(0xFFF3F3F3),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.image_outlined,
                              color: Color(0xFF9186C4),
                              size: 20,
                            ),
                            onPressed: () {}, // هنا تفتحي الجاليري للكومنت
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.videocam_outlined,
                              color: Color(0xFF9186C4),
                              size: 20,
                            ),
                            onPressed: () {}, // هنا تفتحي الفيديو للكومنت
                          ),
                        ],
                      ),
                    ),
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
