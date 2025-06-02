import 'package:find_the_word/find_the_word.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'game_over_overlay.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: WordSearchGame(
          config: WordSearchConfig(
            words: ['FLUTTER', 'GAME', 'FUN', 'CODE'],
            onGameOver: (result) {
              print('Score: ${result.score}');
              print('Words Found: ${result.foundWords}');
            },
            primaryColor: Colors.purple,
            secondaryColor: Colors.pink,
            timeLimit: 180,
          ),
        ),
        overlayBuilderMap: {
          'gameOver': (context, game) => GameOverOverlay(
            game: game as WordSearchGame,
          ),
        },
      ),
    );
  }
}