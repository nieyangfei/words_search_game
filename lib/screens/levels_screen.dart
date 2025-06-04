import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_models.dart';
import 'game_screen.dart';

class LevelsScreen extends StatefulWidget {
  final Difficulty difficulty;

  const LevelsScreen({super.key, required this.difficulty});

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  List<int> stars = List.filled(5, 0);

  @override
  void initState() {
    super.initState();
    _loadStars();
  }

  Future<void> _loadStars() async {
    final prefs = await SharedPreferences.getInstance();

    // 🧪 Un-comment below line ONCE to reset Easy mode stars
     await _clearEasyStarsIfDebug();

    List<int> loaded = [];

    for (int i = 0; i < 5; i++) {
      int starCount = prefs.getInt(_starKey(i)) ?? -1;
      loaded.add(starCount);
    }

    // Always unlock Level 1
    if (loaded[0] < 0) loaded[0] = 0;

    // Lock levels if previous level has less than 1 star
    for (int i = 1; i < loaded.length; i++) {
      if (loaded[i - 1] < 1) {
        loaded[i] = -1;
      }
    }

    setState(() {
      stars = loaded;
    });
  }

  // 🔄 One-time reset function for EASY mode
  Future<void> _clearEasyStarsIfDebug() async {
    final prefs = await SharedPreferences.getInstance();
    if (widget.difficulty == Difficulty.easy) {
      for (int i = 1; i < 5; i++) {
        await prefs.remove('${widget.difficulty.name}_level_${i + 1}_stars');
      }
    }
  }

  String _starKey(int level) {
    return '${widget.difficulty.name}_level_${level + 1}_stars';
  }

  void _startGame(int level) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          difficulty: widget.difficulty,
          level: level,
        ),
      ),
    ).then((_) => _loadStars()); // Refresh after return
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.difficulty.name.toUpperCase();

    return Scaffold(
      appBar: AppBar(title: Text('$title Levels')),
      body: ListView.builder(
        itemCount: 5,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final isLocked = stars[index] < 0;

          return AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: isLocked ? 0.4 : 1.0,
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text("Level ${index + 1}"),
                leading: Icon(
                  isLocked ? Icons.lock : Icons.videogame_asset,
                  color: isLocked ? Colors.grey : Colors.blue,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (i) {
                    return Icon(
                      i < (stars[index] > 0 ? stars[index] : 0)
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                    );
                  }),
                ),
                onTap: isLocked ? null : () => _startGame(index),
              ),
            ),
          );
        },
      ),
    );
  }
}
