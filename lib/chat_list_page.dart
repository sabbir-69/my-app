import 'package:flutter/material.dart';
import 'package:my_app/services/matrix_service.dart'; // Assuming my_app is your project name

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final MatrixService _matrixService = MatrixService();
  String _authStatus = 'Not authenticated with Matrix';

  @override
  void initState() {
    super.initState();
    _authenticateAndFetchChats();
  }

  Future<void> _authenticateAndFetchChats() async {
    try {
      setState(() {
        _authStatus = 'Authenticating with Matrix...';
      });
      final authData = await _matrixService.authenticateWithMatrix();
      setState(() {
        _authStatus = 'Authenticated! Access Token: ${authData['accessToken']}';
      });
      // TODO: Fetch chat rooms/conversations using the Matrix access token
    } catch (e) {
      setState(() {
        _authStatus = 'Authentication failed: $e';
      });
      print('Matrix authentication error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messenger'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_square),
            onPressed: () {
              // TODO: Implement new chat functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Implement settings
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_authStatus), // Display authentication status
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Placeholder for number of chats
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(
                    // Placeholder for user avatar
                    backgroundColor: Colors.blue,
                    child: Text('U'),
                  ),
                  title: Text('User Name $index'),
                  subtitle: Text('Last message from User $index'),
                  trailing: const Text('10:00 AM'),
                  onTap: () {
                    // TODO: Navigate to individual chat screen
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
