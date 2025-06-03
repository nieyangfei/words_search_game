import 'package:flutter/material.dart';
import 'package:find_the_word/find_the_word.dart';

class GameOverOverlay extends StatelessWidget {
  final WordSearchGame game;

  const GameOverOverlay({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final result = game.result; // Assuming game.result contains score/foundWords

    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Game Over!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Score: ${result?.score ?? 0}'),
            Text('Words Found: ${result?.foundWords.length ?? 0}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // or restart the game
              },
              child: const Text('Exit'),
            ),
          ],
        ),
      ),
    );
  }
}

extension on WordSearchGame {
   get result => null;
}
