import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class SearchModal extends StatefulWidget {
  const SearchModal({super.key});

  @override
  State<SearchModal> createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = []; // Placeholder for search results

  void _performSearch(String query) {
    // TODO: Implement actual search logic (e.g., filter mock data, call API)
    setState(() {
      _searchResults = [
        'Result for "$query" 1',
        'Result for "$query" 2',
        'Result for "$query" 3',
      ];
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          // Background overlay with blur (similar to bg-black/50 backdrop-blur-xl)
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop(); // Dismiss modal on tap outside
            },
            child: Container(
              color: Colors.black.withOpacity(0.5),
              // BackdropFilter is for blur, but it's performance intensive and often avoided for simple overlays.
              // For a true blur, you'd need a package or more complex rendering.
              // For now, just a dark overlay.
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[900], // Dark background for the search bar
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: _performSearch,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              prefixIcon: Icon(LineAwesome.search_solid, color: Colors.grey[500]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    if (_searchResults.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_searchResults[index], style: const TextStyle(color: Colors.white)),
                            onTap: () {
                              // TODO: Handle search result tap
                              print('Tapped on: ${_searchResults[index]}');
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
