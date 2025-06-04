import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:confetti/confetti.dart';

import '../models/game_models.dart';
import '../providers/game_provider.dart';
import '../widgets/game_grid.dart';
import '../widgets/word_list.dart';
import '../widgets/game_stats.dart';

class GameScreen extends StatefulWidget {
  final Difficulty difficulty;
  final int level;

  const GameScreen({super.key, required this.difficulty, this.level = 0});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GameProvider>(context, listen: false)
          .startNewGame(widget.difficulty, widget.level);
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
        title: Text('${widget.difficulty.name.toUpperCase()} - Level ${widget.level + 1}'),
        actions: [
          Consumer<GameProvider>(
            builder: (context, gameProvider, _) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _showGameMenu(context, gameProvider),
            ),
          ),
        ],
      ),
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, _) {
          if (gameProvider.gameCompleted) {
            return _GameCompletedScreen(
              gameProvider: gameProvider,
              difficulty: widget.difficulty,
              level: widget.level,
            );
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
                      icon: const Icon(Icons.clear),
                      label: const Text("Clear"),
                      onPressed: gameProvider.selectedPositions.isNotEmpty
                          ? gameProvider.clearSelection
                          : null,
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.lightbulb),
                      label: const Text("Hint"),
                      onPressed: () => _showHint(context, gameProvider),
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
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!gameProvider.isPaused)
              ListTile(
                leading: const Icon(Icons.pause),
                title: const Text('Pause Game'),
                onTap: () {
                  gameProvider.pauseGame();
                  Navigator.pop(context);
                },
              ),
            if (gameProvider.isPaused)
              ListTile(
                leading: const Icon(Icons.play_arrow),
                title: const Text('Resume Game'),
                onTap: () {
                  gameProvider.resumeGame();
                  Navigator.pop(context);
                },
              ),
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('New Game'),
              onTap: () {
                gameProvider.startNewGame(widget.difficulty, widget.level);
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
      builder: (_) => AlertDialog(
        title: const Text("Hint"),
        content: Text(
          'Look for "${hint.word}" starting at row ${firstPosition.row + 1}, column ${firstPosition.col + 1}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}

class _GameCompletedScreen extends StatefulWidget {
  final GameProvider gameProvider;
  final Difficulty difficulty;
  final int level;

  const _GameCompletedScreen({
    required this.gameProvider,
    required this.difficulty,
    required this.level,
  });

  @override
  State<_GameCompletedScreen> createState() => _GameCompletedScreenState();
}

class _GameCompletedScreenState extends State<_GameCompletedScreen> {
  late ConfettiController _confettiController;
  int stars = 1;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _calculateStars();
    if (stars == 3) _confettiController.play();
    _saveStars();
  }

  void _calculateStars() {
    final score = widget.gameProvider.score;
    if (score > 100) stars = 2;
    if (score > 200) stars = 3;
  }

  Future<void> _saveStars() async {
    final prefs = await SharedPreferences.getInstance();
    final currentKey =
        '${widget.difficulty.name}_level_${widget.level + 1}_stars';
    final current = prefs.getInt(currentKey) ?? 0;
    if (stars > current) await prefs.setInt(currentKey, stars);

    if (widget.level < 4) {
      final nextKey =
          '${widget.difficulty.name}_level_${widget.level + 2}_stars';
      if ((prefs.getInt(nextKey) ?? -1) < 0) {
        await prefs.setInt(nextKey, 0);
      }
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWin = widget.gameProvider.foundWords ==
        widget.gameProvider.totalWords;

    return Stack(
      children: [
        Center(
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
                const SizedBox(height: 12),
                if (isWin)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                          (i) => Icon(
                        Icons.star,
                        color: i < stars ? Colors.amber : Colors.grey.shade400,
                        size: 30,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _ResultRow(
                          icon: Icons.score,
                          label: 'Final Score',
                          value: widget.gameProvider.score.toString(),
                        ),
                        const SizedBox(height: 12),
                        _ResultRow(
                          icon: Icons.check_circle,
                          label: 'Words Found',
                          value:
                          '${widget.gameProvider.foundWords}/${widget.gameProvider.totalWords}',
                        ),
                        const SizedBox(height: 12),
                        _ResultRow(
                          icon: Icons.star,
                          label: 'Difficulty',
                          value: widget.difficulty.name.toUpperCase(),
                        ),
                        const SizedBox(height: 12),
                        _ResultRow(
                          icon: Icons.grade,
                          label: 'Stars Earned',
                          value: '$stars / 3',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 12,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text("Play Again"),
                      onPressed: () {
                        widget.gameProvider.startNewGame(
                            widget.difficulty, widget.level);
                      },
                    ),
                    if (widget.level < 4)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.skip_next),
                        label: const Text("Next Level"),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GameScreen(
                                difficulty: widget.difficulty,
                                level: widget.level + 1,
                              ),
                            ),
                          );
                        },
                      ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.home),
                      label: const Text("Home"),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            numberOfParticles: 30,
            emissionFrequency: 0.04,
            gravity: 0.3,
            shouldLoop: false,
          ),
        ),
      ],
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
        Row(children: [Icon(icon, size: 20), const SizedBox(width: 8), Text(label)]),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
