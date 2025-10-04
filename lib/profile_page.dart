import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ダミー画像URL（1:1）
    final posts = List.generate(
      21,
      (i) => 'https://picsum.photos/id/${100 + i}/800/800',
    );
    final saved = List.generate(
      12,
      (i) => 'https://picsum.photos/id/${200 + i}/800/800',
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: Colors.white,
          title: const Text('よこやま'),
          centerTitle: false,
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.more_horiz),
            )
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(child: _ProfileHeader()),
            SliverToBoxAdapter(child: _Highlights()),
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.black,
                  tabs: const [
                    Tab(icon: Icon(Icons.grid_on)),
                    Tab(icon: Icon(Icons.bookmark_border)),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            children: [
              _PostsGrid(urls: posts),
              _PostsGrid(urls: saved),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // アバター + 統計
          Row(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage('https://i.pravatar.cc/200?img=8'),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    _StatItem(label: '投稿', value: '21'),
                    _StatItem(label: 'フォロワー', value: '1,248'),
                    _StatItem(label: 'フォロー中', value: '312'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 名前 / 自己紹介
          const Text('よこやま', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text(
            'Flutter / 起業 / テック💻\nミニSNS開発中。',
            style: TextStyle(height: 1.3),
          ),
          const SizedBox(height: 12),
          // ボタン群（編集・シェア）
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('プロフィールを編集'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('プロフィールをシェア'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Highlights extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ストーリーズハイライト風
    return SizedBox(
      height: 104, // パディング含め安全な高さ
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: 8,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 72,
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
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 26,
                      backgroundImage:
                          NetworkImage('https://i.pravatar.cc/150?img=${index + 20}'),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 16,
                  child: Text(
                    'Highlight $index',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, height: 1.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PostsGrid extends StatelessWidget {
  final List<String> urls;
  const _PostsGrid({required this.urls});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      itemCount: urls.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3列
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
        childAspectRatio: 1, // 正方形
      ),
      itemBuilder: (context, index) {
        return CachedNetworkImage(
          imageUrl: urls[index],
          fit: BoxFit.cover,
          placeholder: (c, _) => const Center(
            child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          errorWidget: (c, _, __) => const Center(child: Icon(Icons.broken_image)),
          fadeInDuration: const Duration(milliseconds: 180),
          fadeOutDuration: const Duration(milliseconds: 120),
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}

/// TabBarをSliverにピン留めするためのDelegate
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _TabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // Containerは「decoration」に色＋ボーダーをまとめる（colorプロパティは使わない）
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0x14000000), width: 0.5),
          bottom: BorderSide(color: Color(0x14000000), width: 0.5),
        ),
      ),
      child: Material(
        color: Colors.transparent, // Inkエフェクト用
        child: _tabBar,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}
