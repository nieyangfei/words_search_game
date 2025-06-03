import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class WordList extends StatelessWidget {
  const WordList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        if (gameProvider.currentConfig == null) {
          return const SizedBox.shrink();
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Words to Find',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      gameProvider.wordPlacements.map((placement) {
                        return WordChip(
                          word: placement.word,
                          isFound: placement.isFound,
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class WordChip extends StatelessWidget {
  final String word;
  final bool isFound;

  const WordChip({super.key, required this.word, required this.isFound});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color:
            isFound
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
        ),
      ),
      child: Text(
        word,
        style: TextStyle(
          color:
              isFound
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
          fontWeight: isFound ? FontWeight.bold : FontWeight.normal,
          decoration: isFound ? TextDecoration.lineThrough : null,
        ),
      ),
    );
  }
}
