import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_models.dart';
import '../providers/game_provider.dart';
import '../widgets/game_grid.dart';
import '../widgets/word_list.dart';
import '../widgets/game_stats.dart';

class GameScreen extends StatefulWidget {
  final Difficulty difficulty;

  const GameScreen({super.key, required this.difficulty});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GameProvider>(
        context,
        listen: false,
      ).startNewGame(widget.difficulty);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    if (state == AppLifecycleState.paused) {
      gameProvider.pauseGame();
    } else if (state == AppLifecycleState.resumed) {
      gameProvider.resumeGame();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.difficulty.name.toUpperCase()} Mode'),
        actions: [
          Consumer<GameProvider>(
            builder: (context, gameProvider, child) {
              return IconButton(
                onPressed: () => _showGameMenu(context, gameProvider),
                icon: const Icon(Icons.menu),
              );
            },
          ),
        ],
      ),
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          if (gameProvider.gameCompleted) {
            return _GameCompletedScreen(gameProvider: gameProvider);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const GameStats(),
                const SizedBox(height: 16),
                const GameGrid(),
                const SizedBox(height: 16),
                const WordList(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed:
                          gameProvider.selectedPositions.isNotEmpty
                              ? gameProvider.clearSelection
                              : null,
                      icon: const Icon(Icons.clear),
                      label: const Text('Clear'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _showHint(context, gameProvider),
                      icon: const Icon(Icons.lightbulb),
                      label: const Text('Hint'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showGameMenu(BuildContext context, GameProvider gameProvider) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.pause),
                  title: const Text('Pause Game'),
                  onTap: () {
                    gameProvider.pauseGame();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.refresh),
                  title: const Text('New Game'),
                  onTap: () {
                    gameProvider.startNewGame(widget.difficulty);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _showHint(BuildContext context, GameProvider gameProvider) {
    final unFoundWords =
        gameProvider.wordPlacements.where((w) => !w.isFound).toList();

    if (unFoundWords.isEmpty) return;

    final hint = unFoundWords.first;
    final firstPosition = hint.positions.first;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Hint'),
            content: Text(
              'Look for "${hint.word}" starting at row ${firstPosition.row + 1}, column ${firstPosition.col + 1}',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}

class _GameCompletedScreen extends StatelessWidget {
  final GameProvider gameProvider;

  const _GameCompletedScreen({required this.gameProvider});

  @override
  Widget build(BuildContext context) {
    final isWin = gameProvider.foundWords == gameProvider.totalWords;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isWin ? Icons.emoji_events : Icons.access_time,
              size: 80,
              color: isWin ? Colors.amber : Colors.orange,
            ),
            const SizedBox(height: 24),
            Text(
              isWin ? 'Congratulations!' : 'Time\'s Up!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isWin ? Colors.amber : Colors.orange,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _ResultRow(
                      icon: Icons.score,
                      label: 'Final Score',
                      value: gameProvider.score.toString(),
                    ),
                    const SizedBox(height: 12),
                    _ResultRow(
                      icon: Icons.check_circle,
                      label: 'Words Found',
                      value:
                          '${gameProvider.foundWords}/${gameProvider.totalWords}',
                    ),
                    const SizedBox(height: 12),
                    _ResultRow(
                      icon: Icons.star,
                      label: 'Difficulty',
                      value:
                          gameProvider.currentConfig!.difficulty.name
                              .toUpperCase(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    gameProvider.startNewGame(
                      gameProvider.currentConfig!.difficulty,
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Play Again'),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.home),
                  label: const Text('Home'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ResultRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
