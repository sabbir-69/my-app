import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class ConnectionCard extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final int mutual;
  final VoidCallback onMessage;
  final VoidCallback onMore;

  const ConnectionCard({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.mutual,
    required this.onMessage,
    required this.onMore,
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
                Text('$mutual Mutual Friends', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: onMessage,
                icon: const Icon(LineAwesome.comment_dots_solid, color: Colors.white),
              ),
              IconButton(
                onPressed: onMore,
                icon: const Icon(LineAwesome.ellipsis_h_solid, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
