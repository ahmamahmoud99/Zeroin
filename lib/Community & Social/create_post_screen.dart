import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePostScreen> {
  final TextEditingController _postController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  // 1. دالة اختيار الصور والفيديو
  Future<void> _pickMedia(ImageSource source, {bool isVideo = false}) async {
    try {
      if (isVideo) {
        final XFile? video = await _picker.pickVideo(source: source);
        if (video != null) {
          print("تم اختيار فيديو: ${video.path}");
        }
      } else {
        final XFile? image = await _picker.pickImage(source: source);
        if (image != null) {
          print("تم اختيار صورة: ${image.path}");
        }
      }
    } catch (e) {
      print("خطأ في الوصول للملفات: $e");
    }
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
        leadingWidth: 80,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: () {
                if (_postController.text.isNotEmpty) {
                  Navigator.pop(context, _postController.text);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9186C4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "Post",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // بيانات البروفايل
            Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0xFFF3F3F3),
                  child: Icon(Icons.person, color: Color(0xFF9186C4)),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Software Engineering",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Public",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // مكان الكتابة
            Expanded(
              child: TextField(
                controller: _postController,
                maxLines: null,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  hintText: "What's on your mind?",
                  border: InputBorder.none,
                ),
              ),
            ),
            const Divider(),
            // شريط الأدوات (الصور والفيديو و AI فقط)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  // أيقونة الصور
                  IconButton(
                    icon: const Icon(
                      Icons.image_outlined,
                      color: Color(0xFF9186C4),
                    ),
                    onPressed: () => _pickMedia(ImageSource.gallery),
                  ),
                  // أيقونة الفيديو
                  IconButton(
                    icon: const Icon(
                      Icons.videocam_outlined,
                      color: Color(0xFF9186C4),
                    ),
                    onPressed: () =>
                        _pickMedia(ImageSource.gallery, isVideo: true),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.auto_fix_high,
                    color: Color(0xFF9186C4),
                    size: 20,
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    "AI Assistant",
                    style: TextStyle(color: Color(0xFF9186C4), fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
