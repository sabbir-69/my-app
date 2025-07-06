import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class BottomNav extends StatefulWidget {
  final Function(int) onItemTapped;
  const BottomNav({super.key, required this.onItemTapped});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onItemTapped(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black.withOpacity(0.2),
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedItemColor: const Color(0xFFB30000),
      unselectedItemColor: Colors.grey[400],
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(LineAwesome.home_solid),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(LineAwesome.user_friends_solid),
          label: 'Friend',
        ),
        BottomNavigationBarItem(
          icon: Icon(LineAwesome.bell_solid),
          label: 'Notification',
        ),
        BottomNavigationBarItem(
          icon: Icon(LineAwesome.exclamation_triangle_solid),
          label: 'SOS',
        ),
        BottomNavigationBarItem(
          icon: Icon(LineAwesome.comment_dots_solid),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(LineAwesome.ellipsis_h_solid),
          label: 'More',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }
}
