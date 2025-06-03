import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class WordList extends StatelessWidget {
  final List<String> wordList;
  final Set<String> foundWords;

  const WordList({
    super.key,
    required this.wordList,
    required this.foundWords,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      children: wordList.map((word) {
        final isFound = foundWords.contains(word);
        return Chip(
          label: Text(
            word,
            style: TextStyle(
              color: isFound ? Colors.white : AppColors.text,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: isFound ? Colors.green : Colors.grey[300],
        );
      }).toList(),
    );
  }
}
