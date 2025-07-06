import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'mock_data.dart';

class QnACard extends StatefulWidget {
  final QnAData data;
  const QnACard({super.key, required this.data});

  @override
  State<QnACard> createState() => _QnACardState();
}

class _QnACardState extends State<QnACard> {
  @override
  Widget build(BuildContext context) {
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
                backgroundImage: NetworkImage(widget.data.avatar),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.data.user, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(widget.data.time, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (String result) {
                  // Handle menu item selection
                  switch (result) {
                    case 'edit':
                      print('Edit Q&A: ${widget.data.id}');
                      // Implement edit logic
                      break;
                    case 'delete':
                      print('Delete Q&A: ${widget.data.id}');
                      // Implement delete logic
                      break;
                    case 'report':
                      print('Report Q&A: ${widget.data.id}');
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
          Text(widget.data.question, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Type your answer...',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    border: InputBorder.none,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Answer'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(LineAwesome.thumbs_up, color: Colors.white.withOpacity(0.6)),
                  ),
                  Text('${widget.data.upvotes}', style: TextStyle(color: Colors.white.withOpacity(0.6))),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(LineAwesome.comment, color: Colors.white.withOpacity(0.6)),
                  ),
                  Text('${widget.data.comments}', style: TextStyle(color: Colors.white.withOpacity(0.6))),
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
  }
}
