import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostViewModel extends ChangeNotifier {
  final String postId;
  bool isLiked;
  int likeCount;
  int commentCount;

  PostViewModel({
    required this.postId,
    required this.isLiked,
    required this.likeCount,
    required this.commentCount,
  });

  Future<void> toggleLike() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);

    if (isLiked) {
      // Unlike the post
      await postRef.update({
        'likedBy': FieldValue.arrayRemove([userId]),
      });
      isLiked = false;
      likeCount--;
    } else {
      // Like the post
      await postRef.update({
        'likedBy': FieldValue.arrayUnion([userId]),
      });
      isLiked = true;
      likeCount++;
    }
    notifyListeners(); // Notify listeners (PostCard) to rebuild
  }

  void updateCommentCount(int newCount) {
    commentCount = newCount;
    notifyListeners();
  }
}
