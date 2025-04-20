import 'package:flutter/material.dart';

class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  final List<Map<String, String>> tips = const [
    {
      "title": "Explore Books",
      "description": "Browse a wide variety of books with just a tap!",
      "icon": "📚"
    },
    {
      "title": "Play Audio",
      "description": "Listen to audiobooks directly in the app.",
      "icon": "🎧"
    },
    {
      "title": "Bookmark Favorites",
      "description": "Mark your favorite books and access them easily.",
      "icon": "🔖"
    },
    {
      "title": "Track Progress",
      "description": "Keep track of your reading and listening history.",
      "icon": "📈"
    },
    {
      "title": "Search Smartly",
      "description": "Find books by title, author, or category.",
      "icon": "🔍"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tips & Tricks"),
        backgroundColor: Colors.blue.shade900,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          final tip = tips[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            color: Colors.blueGrey.shade900,
            child: ListTile(
              leading: Text(
                tip["icon"]!,
                style: const TextStyle(fontSize: 30),
              ),
              title: Text(
                tip["title"]!,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              subtitle: Text(
                tip["description"]!,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          );
        },
      ),
      backgroundColor: Colors.black,
    );
  }
}
