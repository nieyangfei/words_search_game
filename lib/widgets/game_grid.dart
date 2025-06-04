import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_models.dart';
import '../providers/game_provider.dart';

class GameGrid extends StatelessWidget {
  const GameGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        final grid = provider.grid;
        final size = provider.currentConfig!.gridSize;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: size,
              ),
              itemCount: size * size,
              itemBuilder: (context, index) {
                final row = index ~/ size;
                final col = index % size;
                final position = Position(row, col);
                final letter = grid[row][col];
                final isSelected = provider.selectedPositions.contains(position);
                final tileColor = _getTileColor(context, position, provider);

                return GestureDetector(
                  onTap: () => provider.selectPosition(position),
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 200),
                    scale: isSelected ? 1.1 : 1.0,
                    curve: Curves.elasticOut,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: tileColor,
                        border: Border.all(color: Colors.black26, width: 0.5),
                      ),
                      child: Text(
                        letter.isNotEmpty ? letter : '?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: _getTextColor(context, tileColor),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Color _getTileColor(BuildContext context, Position pos, GameProvider provider) {
    for (final word in provider.wordPlacements) {
      if (word.isFound && word.positions.contains(pos)) {
        return word.color;
      }
    }

    if (provider.selectedPositions.contains(pos)) {
      return Theme.of(context).colorScheme.secondary.withOpacity(0.5);
    }

    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? Colors.grey[900]!
        : Colors.grey[100]!;
  }

  Color _getTextColor(BuildContext context, Color background) {
    return background.computeLuminance() < 0.5 ? Colors.white : Colors.black;
  }
}
