import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'mock_data.dart';
import 'video_player_controls.dart';
import 'comment_modal.dart';
import 'post_view_model.dart';

class PostCard extends StatefulWidget {
  final Post post;
  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.post.video != null) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.post.video!))
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PostViewModel(
        postId: widget.post.id,
        isLiked: widget.post.likedBy.contains(FirebaseAuth.instance.currentUser?.uid),
        likeCount: widget.post.likedBy.length,
        commentCount: widget.post.commentCount,
      ),
      child: Consumer<PostViewModel>(
        builder: (context, postViewModel, _) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(widget.post.avatar),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.post.user, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text(widget.post.time, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (String result) {
                        // Handle menu item selection
                        switch (result) {
                          case 'edit':
                            print('Edit Post: ${widget.post.id}');
                            // Implement edit logic
                            break;
                          case 'delete':
                            print('Delete Post: ${widget.post.id}');
                            // Implement delete logic
                            break;
                          case 'report':
                            print('Report Post: ${widget.post.id}');
                            // Implement report logic
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'report',
                          child: Text('Report'),
                        ),
                      ],
                      icon: Icon(LineAwesome.ellipsis_h_solid, color: Colors.white.withOpacity(0.6)),
                      color: Colors.grey[800], // Background color of the menu
                      surfaceTintColor: Colors.transparent, // Remove default surface tint
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(widget.post.text, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
                const SizedBox(height: 16),
                if (widget.post.image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(widget.post.image!),
                  ),
                if (widget.post.video != null && _controller != null && _controller!.value.isInitialized)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      ),
                      VideoPlayerControls(controller: _controller!),
                    ],
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => postViewModel.toggleLike(),
                          icon: Icon(
                            postViewModel.isLiked ? LineAwesome.thumbs_up_solid : LineAwesome.thumbs_up,
                            color: postViewModel.isLiked ? Colors.blue : Colors.white.withOpacity(0.6),
                          ),
                        ),
                        Text('${postViewModel.likeCount}', style: TextStyle(color: Colors.white.withOpacity(0.6))),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: () => _showCommentsModal(widget.post.id),
                          icon: Icon(LineAwesome.comment, color: Colors.white.withOpacity(0.6)),
                        ),
                        Text('${postViewModel.commentCount}', style: TextStyle(color: Colors.white.withOpacity(0.6))),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(LineAwesome.share_solid, color: Colors.white.withOpacity(0.6)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCommentsModal(String postId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return CommentModal(postId: postId);
      },
    );
  }
}
