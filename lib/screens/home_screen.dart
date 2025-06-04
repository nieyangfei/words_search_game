import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_models.dart';
import '../screens/levels_screen.dart';
import '../providers/theme_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Search'),
        actions: [
          Consumer<ThemeNotifier>(
            builder: (context, themeNotifier, _) => IconButton(
              icon: Icon(themeNotifier.isDark ? Icons.dark_mode : Icons.light_mode),
              onPressed: () => themeNotifier.toggleTheme(),
            ),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.grid_view,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Word Search',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Find hidden words in the grid',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  _DifficultyCard(
                    difficulty: Difficulty.easy,
                    title: 'Easy',
                    subtitle: '8x8 Grid • 8 Words • 10 Minutes',
                    icon: Icons.sentiment_satisfied,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 16),
                  _DifficultyCard(
                    difficulty: Difficulty.medium,
                    title: 'Medium',
                    subtitle: '12x12 Grid • 10 Words • 15 Minutes',
                    icon: Icons.sentiment_neutral,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  _DifficultyCard(
                    difficulty: Difficulty.hard,
                    title: 'Hard',
                    subtitle: '16x16 Grid • 12 Words • 20 Minutes',
                    icon: Icons.sentiment_very_dissatisfied,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DifficultyCard extends StatelessWidget {
  final Difficulty difficulty;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _DifficultyCard({
    required this.difficulty,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LevelsScreen(difficulty: difficulty),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color:
                Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
