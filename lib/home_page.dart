import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = [
      {
        'user': 'alice',
        'name': 'Alice',
        'text': 'Flutter最高！🔥',
        'image': 'https://picsum.photos/id/1015/1080/1080',
        'likes': 124,
        'time': '2時間前',
      },
      {
        'user': 'bob',
        'name': 'Bob',
        'text': '新しいSNSアプリ開発中💻',
        'image': 'https://picsum.photos/id/1025/1080/1080',
        'likes': 89,
        'time': '5時間前',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: false,
        title: Text(
          'Link',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            letterSpacing: -0.5,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.add_box_outlined, size: 26),
          ),
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.send_outlined, size: 24),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // --- Stories（オーバーフロー完全対策） ---
          SliverToBoxAdapter(
            child: SizedBox(
              height: 88, // 子に与える高さ: 88 - (padding.vert=8) = 80
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), // 8→4
                itemCount: 12,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 68,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFF58529), Color(0xFFDD2A7B), Color(0xFF8134AF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 26, // 28→26（外周）
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 24, // 26→24（内側）
                              backgroundImage:
                                  NetworkImage('https://i.pravatar.cc/150?img=${index + 3}'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2), // 6→2
                        SizedBox(
                          height: 14, // 固定高さで安定
                          child: Text(
                            'user$index',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10, // 11→10
                              height: 1.0,  // 余白を詰める
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: Divider(height: 1)),

          // --- Feed ---
          SliverList.separated(
            itemCount: posts.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final p = posts[index];
              return _PostTile(
                username: p['user'] as String,
                displayName: p['name'] as String,
                imageUrl: p['image'] as String,
                caption: p['text'] as String,
                likes: p['likes'] as int,
                timeLabel: p['time'] as String,
                avatarUrl: 'https://i.pravatar.cc/150?img=${index + 10}',
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PostTile extends StatefulWidget {
  final String username;
  final String displayName;
  final String imageUrl;
  final String caption;
  final int likes;
  final String timeLabel;
  final String avatarUrl;

  const _PostTile({
    required this.username,
    required this.displayName,
    required this.imageUrl,
    required this.caption,
    required this.likes,
    required this.timeLabel,
    required this.avatarUrl,
  });

  @override
  State<_PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<_PostTile> {
  bool liked = false;
  bool showBigHeart = false;
  late int likeCount;

  @override
  void initState() {
    super.initState();
    likeCount = widget.likes;
  }

  void _toggleLike({bool fromDoubleTap = false}) {
    setState(() {
      liked = !liked;
      likeCount += liked ? 1 : -1;

      if (fromDoubleTap && liked) {
        showBigHeart = true;
        Future.delayed(const Duration(milliseconds: 700), () {
          if (mounted) setState(() => showBigHeart = false);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- Header row ---
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          leading: CircleAvatar(backgroundImage: NetworkImage(widget.avatarUrl)),
          title: Text(widget.displayName, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text('@${widget.username}',
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          trailing: const Icon(Icons.more_horiz),
        ),

        // --- Image (edge-to-edge, 1:1) + double tap like ---
        GestureDetector(
          onDoubleTap: () => _toggleLike(fromDoubleTap: true),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (c, _) =>
                      const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  errorWidget: (c, _, __) =>
                      const Center(child: Icon(Icons.broken_image, size: 48)),
                  fadeInDuration: const Duration(milliseconds: 180),
                  fadeOutDuration: const Duration(milliseconds: 120),
                ),
              ),
              AnimatedOpacity(
                opacity: showBigHeart ? 1 : 0,
                duration: const Duration(milliseconds: 150),
                child: const Icon(Icons.favorite, size: 120),
              ),
            ],
          ),
        ),

        // --- Action bar ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            children: [
              IconButton(
                onPressed: _toggleLike,
                icon: Icon(liked ? Icons.favorite : Icons.favorite_border),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.mode_comment_outlined),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.send_outlined),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.bookmark_border),
              ),
            ],
          ),
        ),

        // --- Likes count ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('いいね $likeCount 件',
              style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 6),

        // --- Caption (username + text) ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 14, height: 1.4),
              children: [
                TextSpan(
                    text: widget.displayName,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                const TextSpan(text: '  '),
                TextSpan(text: widget.caption),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),

        // --- View comments / time ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {},
                child: const Text('コメントを見る', style: TextStyle(color: Colors.grey)),
              ),
              const SizedBox(height: 4),
              Text(widget.timeLabel, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
