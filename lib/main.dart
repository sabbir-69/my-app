import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Keep this import for MethodChannel if needed later, though not directly used in this main.dart
import 'package:my_app/services/matrix_service.dart'; // Import MatrixService

import 'bottom_nav.dart';
import 'feed_tabs.dart';
import 'friend_page.dart';
import 'notification_page.dart';
import 'top_bar.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'more_page.dart'; // Import the new MorePage
import 'chat_list_page.dart'; // Import the new ChatListPage

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mock_data.dart'; // Import mock_data.dart

bool _hasUploadedMockData = false; // Flag to ensure data is uploaded only once

Future<void> _uploadMockDataToFirestore() async {
  if (_hasUploadedMockData) return; // Only run once

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  print('Starting mock data upload to Firestore...');

  for (var categoryEntry in initialMockPosts.entries) {
    final List<dynamic> posts = categoryEntry.value;

    for (var item in posts) {
      if (item is Post) {
        try {
          // Add post to 'posts' collection, using its ID as document ID
          await firestore.collection('posts').doc(item.id).set(item.toFirestore());
          print('Uploaded Post: ${item.id} - ${item.text}');
        } catch (e) {
          print('Error uploading post ${item.id}: $e');
        }
      } else {
        print('Skipping non-Post item: $item');
      }
    }
  }

  _hasUploadedMockData = true; // Set flag after successful upload
  print('Mock data upload complete.');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize MatrixService
  final MatrixService matrixService = MatrixService();
  await matrixService.init(); // Await initialization

  // Upload mock data to Firestore on app start (only once)
  await _uploadMockDataToFirestore();

  runApp(MyApp(matrixService: matrixService)); // Pass MatrixService to MyApp
}

class MyApp extends StatelessWidget {
  final MatrixService matrixService; // Add MatrixService parameter

  const MyApp({Key? key, required this.matrixService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connect',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return MyHomePage(matrixService: matrixService); // Pass MatrixService
          }
          return LoginPage(matrixService: matrixService);
        },
      ),
      routes: {
        '/login': (context) => LoginPage(matrixService: matrixService),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => MyHomePage(matrixService: matrixService), // Pass MatrixService
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final MatrixService matrixService; // Add MatrixService parameter

  const MyHomePage({Key? key, required this.matrixService}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  late PageController _pageController;

  final List<Widget> _pages = [
    const FeedTabs(),
    const FriendPage(),
    const NotificationPage(),
    const Center(child: Text('SOS Page (Placeholder)')),
    const ChatListPage(), // Use the new ChatListPage
    const MorePage(), // Use the actual MorePage
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF006A4E), // connect-green
            Color(0xFF111827), // gray-900
            Color(0x4DF42A41), // connect-red at 30% opacity (0x4D is approx 30% of FF)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Make Scaffold background transparent
        appBar: const TopBar(),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: _pages,
        ),
        bottomNavigationBar: BottomNav(
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
