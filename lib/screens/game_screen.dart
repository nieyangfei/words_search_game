import 'package:flutter/material.dart';
import '../widgets/letter_grid.dart';
import '../widgets/word_list.dart';
import '../utils/puzzle_generator.dart';
import '../theme/app_colors.dart';

class GameScreen extends StatefulWidget {
  final String theme;
  final List<String> wordList;

  const GameScreen({super.key, required this.theme, required this.wordList});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<List<String>> grid;
  final Set<String> foundWords = {};

  @override
  void initState() {
    super.initState();
    final puzzle = PuzzleGenerator(gridSize: 14, wordList: widget.wordList);
    grid = puzzle.getGrid();
  }

  void _onWordSelected(String selectedWord) {
    final reversed = selectedWord.split('').reversed.join();

    // Check both directions for valid words
    String? foundWord = widget.wordList.firstWhere(
          (word) => word == selectedWord || word == reversed,
      orElse: () => '',
    );

    if (foundWord.isNotEmpty && !foundWords.contains(foundWord)) {
      setState(() {
        foundWords.add(foundWord);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 Found: $foundWord'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('${widget.theme} Puzzle'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          WordList(wordList: widget.wordList, foundWords: foundWords),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LetterGrid(
                grid: grid,
                onWordSelected: _onWordSelected,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
