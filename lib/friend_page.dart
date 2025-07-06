import 'package:flutter/material.dart';
import 'mock_data.dart';
import 'friend_request_card.dart';
import 'connection_card.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Requests', 'Your Connection'];

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Friends',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.6),
              tabs: _tabs.map((String name) => Tab(text: name)).toList(),
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: _tabs.map((String name) {
              if (name == 'Requests') {
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: friendRequests.length,
                  itemBuilder: (context, index) {
                    final request = friendRequests[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: FriendRequestCard(
                        name: request.name,
                        avatarUrl: request.avatarUrl,
                        timeOrMutual: request.timeOrMutual,
                        onConnect: () {
                          // TODO: Implement connect logic
                          print('Connect ${request.name}');
                        },
                        onDecline: () {
                          // TODO: Implement decline logic
                          print('Decline ${request.name}');
                        },
                      ),
                    );
                  },
                );
              } else {
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: yourConnections.length,
                  itemBuilder: (context, index) {
                    final connection = yourConnections[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ConnectionCard(
                        name: connection.name,
                        avatarUrl: connection.avatarUrl,
                        mutual: connection.mutual,
                        onMessage: () {
                          // TODO: Implement message logic
                          print('Message ${connection.name}');
                        },
                        onMore: () {
                          // TODO: Implement more options logic
                          print('More on ${connection.name}');
                        },
                      ),
                    );
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
