import 'package:flutter/material.dart';
import 'game_screen.dart';
import '../theme/app_colors.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  final List<Map<String, dynamic>> themes = const [
    {'name': 'Animals', 'words': ['CAT', 'DOG', 'LION', 'ZEBRA']},
    {'name': 'Space', 'words': ['MOON', 'SUN', 'STAR', 'PLANET']},
    {'name': 'Sports', 'words': ['BALL', 'RUN', 'SWIM', 'BIKE']},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Pick a Theme')),
      body: ListView.builder(
        itemCount: themes.length,
        itemBuilder: (context, index) {
          final theme = themes[index];
          return ListTile(
            title: Text(
              theme['name'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.primary),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GameScreen(
                    theme: theme['name'],
                    wordList: List<String>.from(theme['words']),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
