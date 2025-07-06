import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'search_modal.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black.withOpacity(0.1),
      elevation: 0,
      title: const Text(
        'Connect',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
          letterSpacing: 1.2,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const SearchModal();
              },
            );
          },
          icon: Icon(LineAwesome.search_solid, color: Colors.white),
        ),
        IconButton(
          onPressed: () {
            // TODO: Implement settings
          },
          icon: Icon(LineAwesome.cog_solid, color: Colors.white),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
