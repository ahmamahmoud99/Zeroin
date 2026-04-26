import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'postmodel.dart';

class creatpost extends StatefulWidget {
  const creatpost({super.key});

  @override
  _creatpostState createState() => _creatpostState();
}

class _creatpostState extends State<creatpost> {
  // الكنترولرز لسحب البيانات
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  // --- دوال التفاعل مع الأزرار ---

  Future<void> _openCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      print("Picked from Camera: ${photo.path}");
    }
  }

  Future<void> _openGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print("Picked from Gallery: ${image.path}");
    }
  }

  void _showLinkDialog() {
    TextEditingController linkController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Link"),
        content: TextField(
          controller: linkController,
          decoration: const InputDecoration(hintText: "https://example.com"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (linkController.text.isNotEmpty) {
                setState(() {
                  _contentController.text += "\n${linkController.text}";
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E8F3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'New Post',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              if (_contentController.text.isNotEmpty) {
                PostModel newPost = PostModel(
                  username: "User Name",
                  content: _contentController.text,
                  // هنا بناخد الكود اللي المستخدم كتبه فعلاً
                  codeSnippet: _codeController.text,
                  id: '',
                  userImageUrl: '',
                );
                Navigator.pop(context, newPost);
              }
            },
            child: const Text(
              'Post',
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // حقل العنوان
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: const TextStyle(fontSize: 22, color: Colors.black54),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // حقل محتوى البوست
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Write your post...',
                contentPadding: const EdgeInsets.all(20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // --- التعديل المطلوب: مربع الكود الذكي ---
            TextField(
              controller: _codeController,
              maxLines: 6,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                color: Colors.blueGrey,
              ),
              decoration: InputDecoration(
                // هنا الكود اللي كان ثابت حطيناه كـ Hint عشان يتمسح أول ما المستخدم يكتب
                hintText:
                    "<CleanSharpCode>\nvar connections = new DatabaseCatenate()\n{\n  loadMainConnections();\n  return connections;\n}\n</CleanSharpCode>",
                hintStyle: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.grey,
                ),
                hintMaxLines: 6,
                alignLabelWithHint: true,
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
              ),
            ),

            const SizedBox(height: 200),

            // صف الأزرار التفاعلية
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  Icons.camera_alt_outlined,
                  "Camera",
                  _openCamera,
                ),
                _buildActionButton(Icons.image_outlined, "Image", _openGallery),
                _buildActionButton(Icons.link, "Link", _showLinkDialog),
                _buildActionButton(Icons.code, "Code", () {
                  // لما يدوس على كود ينزل تحت ويفتح الكيبورد عند مربع الكود
                  FocusScope.of(context).requestFocus(FocusNode());
                }),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ويدجت بناء الأزرار لجعلها قابلة للضغط (Interactive)
  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, size: 30),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
