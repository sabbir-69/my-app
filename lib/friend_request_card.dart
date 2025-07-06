import 'package:flutter/material.dart';

class FriendRequestCard extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final String timeOrMutual;
  final VoidCallback onConnect;
  final VoidCallback onDecline;

  const FriendRequestCard({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.timeOrMutual,
    required this.onConnect,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(timeOrMutual, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
              ],
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: onConnect,
                child: const Text('Connect'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: onDecline,
                child: const Text('Decline'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
