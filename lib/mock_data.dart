import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id; // Changed to String for Firestore document ID
  final String user;
  final String time;
  final String avatar;
  final String text;
  final String? image;
  final String? video;
  final List<String> likedBy; // List of user UIDs who liked the post
  final int commentCount; // Number of comments

  Post({
    required this.id,
    required this.user,
    required this.time,
    required this.avatar,
    required this.text,
    this.image,
    this.video,
    required this.likedBy,
    required this.commentCount,
  });

  // Factory constructor to create a Post from a Firestore DocumentSnapshot
  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      user: data['user'] ?? '',
      time: data['time'] ?? '',
      avatar: data['avatar'] ?? '',
      text: data['text'] ?? '',
      image: data['image'],
      video: data['video'],
      likedBy: List<String>.from(data['likedBy'] ?? []),
      commentCount: data['commentCount'] ?? 0,
    );
  }

  // Method to convert a Post to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'user': user,
      'time': time,
      'avatar': avatar,
      'text': text,
      'image': image,
      'video': video,
      'likedBy': likedBy,
      'commentCount': commentCount,
    };
  }
}

class QnAData {
  final int id;
  final String user;
  final String time;
  final String avatar;
  final String question;
  final int upvotes;
  final int comments;
  final int shares;

  QnAData({
    required this.id,
    required this.user,
    required this.time,
    required this.avatar,
    required this.question,
    required this.upvotes,
    required this.comments,
    required this.shares,
  });
}

class FriendRequest {
  final int id;
  final String name;
  final String timeOrMutual;
  final String avatarUrl;

  FriendRequest({
    required this.id,
    required this.name,
    required this.timeOrMutual,
    required this.avatarUrl,
  });
}

class Connection {
  final int id;
  final String name;
  final int mutual;
  final String avatarUrl;

  Connection({
    required this.id,
    required this.name,
    required this.mutual,
    required this.avatarUrl,
  });
}

class AppNotification {
  final int id;
  final String name;
  final String avatarUrl;
  final String action;
  final String content;
  final String time;
  final bool isRead;

  AppNotification({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.action,
    required this.content,
    required this.time,
    required this.isRead,
  });
}

final Map<String, List<dynamic>> initialMockPosts = {
  'All Feed': [
    Post(id: '1', user: 'Borsha Akter', time: '2h ago', avatar: 'https://i.pravatar.cc/150?u=a042581f4e29026704a', text: 'Beautiful day in Dhaka! Enjoying the weather. 🇧🇩', image: 'https://picsum.photos/seed/picsum/800/600', likedBy: [], commentCount: 0),
    Post(id: '2', user: 'Rahim Sheikh', time: '5h ago', avatar: 'https://i.pravatar.cc/150?u=a042581f4e29026704b', text: "Just tried the new cafe downtown, amazing coffee!", likedBy: [], commentCount: 0),
  ],
  'News': [
    Post(id: '3', user: 'BD News 24', time: '1h ago', avatar: 'https://i.pravatar.cc/150?u=a042581f4e29026704c', text: 'Padma Bridge sees record traffic over the weekend. Economic boost expected for the southern region.', image: 'https://picsum.photos/seed/padma/800/600', likedBy: [], commentCount: 0),
    Post(id: '4', user: 'Dhaka Tribune', time: '30m ago', avatar: 'https://i.pravatar.cc/150?u=dhaka', text: 'New metro rail station opens in Uttara, reducing commute time by 40 minutes for thousands of residents.', image: 'https://picsum.photos/seed/metro/800/600', likedBy: [], commentCount: 0),
    Post(id: '5', user: 'BBC World', time: '15m ago', avatar: 'https://i.pravatar.cc/150?u=bbc', text: 'Climate summit reaches breakthrough agreement on renewable energy targets for developing nations.', image: 'https://picsum.photos/seed/climate/800/600', likedBy: [], commentCount: 0),
    Post(id: '6', user: 'Global Times', time: '45m ago', avatar: 'https://i.pravatar.cc/150?u=global', text: 'International space collaboration announces new mission to explore Mars surface minerals.', likedBy: [], commentCount: 0),
  ],
  'Videos': [
    Post(id: '7', user: 'Travel Vlogger', time: '1d ago', avatar: 'https://i.pravatar.cc/150?u=a042581f4e29026704d', text: 'Exploring the Sundarbans! Check out this short clip.', video: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', likedBy: [], commentCount: 0),
  ],
  'Reels': [
    Post(id: '11', user: 'Reel Maker', time: '20m ago', avatar: 'https://i.pravatar.cc/150?u=reel1', text: 'Quick highlights from Dhaka city life!', video: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', likedBy: [], commentCount: 0),
    Post(id: '12', user: 'Fun Moments', time: '1h ago', avatar: 'https://i.pravatar.cc/150?u=reel2', text: 'Don’t miss this funny street performance 😂', video: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', likedBy: [], commentCount: 0),
  ],
  'Q&A': [
    QnAData(id: 1001, user: "Upendra Prasad", time: "2y ago", avatar: "https://i.pravatar.cc/150?u=upendra", question: "Isn't it correct to correct a fool, or he will hate you, correct a wise man, and he will appreciate you?", upvotes: 31, comments: 19, shares: 1),
    QnAData(id: 1002, user: "Vasudevan Iyengar", time: "1y ago", avatar: "https://i.pravatar.cc/150?u=vasu", question: "Who will benefit from the Russia-Ukraine war?", upvotes: 18, comments: 5, shares: 1),
  ],
};

final List<FriendRequest> friendRequests = [
  FriendRequest(id: 1, name: 'Alif Islam', timeOrMutual: '4h', avatarUrl: 'https://i.pravatar.cc/150?u=alif-islam'),
  FriendRequest(id: 2, name: 'Sikder Leon', timeOrMutual: '7h', avatarUrl: 'https://i.pravatar.cc/150?u=sikder-leon'),
  FriendRequest(id: 3, name: 'Sabikun Nahar Shanta', timeOrMutual: '11 mutual friends', avatarUrl: 'https://i.pravatar.cc/150?u=sabikun-nahar'),
  FriendRequest(id: 4, name: 'Tasniya Jhumu', timeOrMutual: '26 mutual friends', avatarUrl: 'https://i.pravatar.cc/150?u=tasniya-jhumu'),
  FriendRequest(id: 5, name: 'Jazib', timeOrMutual: '3d', avatarUrl: 'https://i.pravatar.cc/150?u=jazib'),
  FriendRequest(id: 6, name: 'Kayfee Kabir', timeOrMutual: '11w', avatarUrl: 'https://i.pravatar.cc/150?u=kayfee-kabir'),
  FriendRequest(id: 7, name: 'Mahmud Imran', timeOrMutual: '1 mutual friend', avatarUrl: 'https://i.pravatar.cc/150?u=mahmud-imran'),
  FriendRequest(id: 8, name: 'John Doe', timeOrMutual: '1d', avatarUrl: 'https://i.pravatar.cc/150?u=john-doe'),
  FriendRequest(id: 9, name: 'Jane Smith', timeOrMutual: '2d', avatarUrl: 'https://i.pravatar.cc/150?u=jane-smith'),
  FriendRequest(id: 10, name: 'Peter Jones', timeOrMutual: '5 mutual friends', avatarUrl: 'https://i.pravatar.cc/150?u=peter-jones'),
];

final List<Connection> yourConnections = [
  Connection(id: 1, name: 'Alica Martin', mutual: 21, avatarUrl: 'https://i.pravatar.cc/150?u=alica-martin'),
  Connection(id: 2, name: 'David Warner', mutual: 11, avatarUrl: 'https://i.pravatar.cc/150?u=david-warner'),
  Connection(id: 3, name: 'Marnus Labuschagne', mutual: 9, avatarUrl: 'https://i.pravatar.cc/150?u=marnus-labuschagne'),
  Connection(id: 4, name: 'Steve Smith', mutual: 34, avatarUrl: 'https://i.pravatar.cc/150?u=steve-smith'),
  Connection(id: 5, name: 'Pat Cummins', mutual: 2, avatarUrl: 'https://i.pravatar.cc/150?u=pat-cummins'),
  Connection(id: 6, name: 'Kayfee Kabir', mutual: 11, avatarUrl: 'https://i.pravatar.cc/150?u=kayfee-kabir'),
  Connection(id: 7, name: 'Mahmud Imran', mutual: 1, avatarUrl: 'https://i.pravatar.cc/150?u=mahmud-imran'),
  Connection(id: 8, name: 'Alif Islam', mutual: 4, avatarUrl: 'https://i.pravatar.cc/150?u=alif-islam'),
];

final List<AppNotification> notifications = [
  AppNotification(id: 1, name: 'Alif Islam', avatarUrl: 'https://i.pravatar.cc/150?u=alif-islam', action: 'reacted to your post', content: 'This is a great photo!', time: '2m ago', isRead: false),
  AppNotification(id: 2, name: 'Sikder Leon', avatarUrl: 'https://i.pravatar.cc/150?u=sikder-leon', action: 'commented on your photo', content: 'Nice shot!', time: '1h ago', isRead: false),
  AppNotification(id: 3, name: 'Sabikun Nahar Shanta', avatarUrl: 'https://i.pravatar.cc/150?u=sabikun-nahar', action: 'liked your comment', content: 'You said: "Thanks everyone!"', time: '3h ago', isRead: true),
  AppNotification(id: 4, name: 'Connect Team', avatarUrl: 'https://www.gravatar.com/avatar/?d=mp', action: 'sent you a new message', content: 'Welcome to Connect!', time: '1d ago', isRead: true),
];
