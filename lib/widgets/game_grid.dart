import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/game_models.dart';

class GameGrid extends StatefulWidget {
  const GameGrid({super.key});

  @override
  State<GameGrid> createState() => _GameGridState();
}

class _GameGridState extends State<GameGrid> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        if (gameProvider.currentConfig == null) {
          return const Center(child: Text('No game started'));
        }

        final grid = gameProvider.grid;
        final size = gameProvider.currentConfig!.gridSize;

        return AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            padding: const EdgeInsets.all(8),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: size,
                childAspectRatio: 1.0,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: size * size,
              itemBuilder: (context, index) {
                final row = index ~/ size;
                final col = index % size;
                final position = Position(row, col);

                return GestureDetector(
                  onTap: () => gameProvider.selectPosition(position),
                  child: GridCell(letter: grid[row][col], position: position),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class GridCell extends StatelessWidget {
  final String letter;
  final Position position;

  const GridCell({super.key, required this.letter, required this.position});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final isSelected = gameProvider.selectedPositions.contains(position);
        final isPartOfFoundWord = gameProvider.wordPlacements.any(
          (w) => w.isFound && w.positions.contains(position),
        );

        // Calculate cell size for responsive font sizing
        final screenWidth = MediaQuery.of(context).size.width;
        final gridSize = gameProvider.currentConfig?.gridSize ?? 8;
        final cellSize = (screenWidth - 48) / gridSize;

        Color backgroundColor;
        Color textColor = Theme.of(context).colorScheme.onSurface;

        if (isPartOfFoundWord) {
          backgroundColor = Theme.of(
            context,
          ).colorScheme.primary.withOpacity(0.3);
          textColor = Theme.of(context).colorScheme.primary;
        } else if (isSelected) {
          backgroundColor = Theme.of(
            context,
          ).colorScheme.secondary.withOpacity(0.5);
        } else {
          backgroundColor = Theme.of(context).colorScheme.surface;
        }

        return Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              letter,
              style: TextStyle(
                fontSize:
                    cellSize > 40
                        ? 16
                        : cellSize > 30
                        ? 14
                        : 12,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
