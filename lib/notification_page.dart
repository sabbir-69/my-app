import 'package:flutter/material.dart';
import 'mock_data.dart';
import 'notification_card.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Notifications',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: NotificationCard(
                  name: notification.name,
                  avatarUrl: notification.avatarUrl,
                  action: notification.action,
                  content: notification.content,
                  time: notification.time,
                  isRead: notification.isRead,
                  onDelete: () {
                    // TODO: Implement delete logic
                    print('Delete notification ${notification.id}');
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
