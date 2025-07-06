import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:provider/provider.dart'; // Import Provider
import 'mock_data.dart';
import 'create_post.dart'; // Import CreatePost
import 'post_card.dart';
import 'qna_card.dart';
import 'reels_viewer.dart';
import 'post_view_model.dart'; // Import PostViewModel

class FeedTabs extends StatefulWidget {
  const FeedTabs({Key? key}) : super(key: key);

  @override
  State<FeedTabs> createState() => _FeedTabsState();
}

class _FeedTabsState extends State<FeedTabs> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['All Feed', 'News', 'Videos', 'Reels', 'Q&A'];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: CreatePost(), // Add CreatePost widget here
        ),
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabs.map((String name) => Tab(text: name)).toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: _tabs.map((String tabName) {
              if (tabName == 'All Feed') {
                return StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('posts').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No posts yet.'));
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final doc = snapshot.data!.docs[index];
                        final post = Post.fromFirestore(doc);
                        return Padding(
                          key: ValueKey(post.id),
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ChangeNotifierProvider(
                            create: (context) => PostViewModel(
                              postId: post.id,
                              isLiked: post.likedBy.contains(FirebaseAuth.instance.currentUser?.uid),
                              likeCount: post.likedBy.length,
                              commentCount: post.commentCount,
                            ),
                            child: PostCard(post: post),
                          ),
                        );
                      },
                    );
                  },
                );
              } else {
                // Existing logic for other tabs
                final posts = initialMockPosts[tabName] ?? [];
                if (tabName == 'Reels') {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReelsViewer(
                            reels: posts.cast<Post>(),
                            isFullScreen: true,
                          ),
                        ),
                      );
                    },
                    child: ReelsViewer(reels: posts.cast<Post>()),
                  );
                }
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    if (post is Post) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: PostCard(post: post),
                      );
                    } else if (post is QnAData) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: QnACard(data: post),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                );
              }
            }).toList(),
          ),
        ),
      ],
    );
  }
}
