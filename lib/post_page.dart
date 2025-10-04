// lib/post_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final _captionCtrl = TextEditingController();
  final _picker = ImagePicker();

  XFile? _picked;
  bool _posting = false;

  @override
  void dispose() {
    _captionCtrl.dispose();
    super.dispose();
  }

  bool get _canPost {
    // “画像 or 文字”のどちらかがあれば投稿可能
    return (_picked != null) || _captionCtrl.text.trim().isNotEmpty;
  }

  Future<void> _pickFrom(ImageSource source) async {
    try {
      final x = await _picker.pickImage(source: source, maxWidth: 2000, maxHeight: 2000, imageQuality: 90);
      if (x != null) {
        setState(() => _picked = x);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('画像の取得に失敗しました: $e')),
      );
    }
  }

  void _showPickSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('ライブラリから選択'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickFrom(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('写真を撮る'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickFrom(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit() async {
    if (!_canPost || _posting) return;
    setState(() => _posting = true);

    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() {
      _posting = false;
      _picked = null;
      _captionCtrl.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('投稿しました！')),
    );

    // ナビゲーション戻す場合は下を有効に
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新規投稿'),
        centerTitle: false,
        elevation: 0.5,
      ),
      body: GestureDetector(
        // TextField外タップでキーボード閉じる
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 画像プレビュー（正方形・インスタ風）
              GestureDetector(
                onTap: _showPickSheet,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: _picked == null
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.add_photo_alternate_outlined, size: 40),
                                SizedBox(height: 8),
                                Text('タップして画像を選択'),
                              ],
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(_picked!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // キャプション
              TextField(
                controller: _captionCtrl,
                onChanged: (_) => setState(() {}),
                maxLines: null,
                minLines: 3,
                decoration: InputDecoration(
                  hintText: 'キャプションを書く…',
                  filled: true,
                  fillColor: const Color(0xFFF9F9F9),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 投稿ボタン
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: _canPost && !_posting ? _submit : null,
                  child: _posting
                      ? const SizedBox(
                          width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('投稿する'),
                ),
              ),

              const SizedBox(height: 8),

              // 補助アクション（任意）
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: _showPickSheet,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('画像を変更'),
                  ),
                  if (_picked != null)
                    TextButton.icon(
                      onPressed: () => setState(() => _picked = null),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('画像を削除'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
