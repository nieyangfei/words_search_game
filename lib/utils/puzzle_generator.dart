import 'dart:math';

class PuzzleGenerator {
  final int gridSize;
  final List<String> wordList;
  late List<List<String>> grid;

  PuzzleGenerator({required this.gridSize, required this.wordList}) {
    grid = List.generate(
      gridSize,
          (_) => List.generate(gridSize, (_) => ''),
    );
    _placeWords();
    _fillEmptySpaces();
  }

  List<List<String>> getGrid() => grid;

  void _placeWords() {
    final random = Random();
    for (var word in wordList) {
      bool placed = false;
      while (!placed) {
        int direction = random.nextInt(8);
        int row = random.nextInt(gridSize);
        int col = random.nextInt(gridSize);
        if (_canPlaceWord(word, row, col, direction)) {
          _setWord(word, row, col, direction);
          placed = true;
        }
      }
    }
  }

  bool _canPlaceWord(String word, int row, int col, int direction) {
    int dx = 0, dy = 0;
    switch (direction) {
      case 0: dx = 0; dy = -1; break;
      case 1: dx = 1; dy = -1; break;
      case 2: dx = 1; dy = 0; break;
      case 3: dx = 1; dy = 1; break;
      case 4: dx = 0; dy = 1; break;
      case 5: dx = -1; dy = 1; break;
      case 6: dx = -1; dy = 0; break;
      case 7: dx = -1; dy = -1; break;
    }

    for (int i = 0; i < word.length; i++) {
      int newRow = row + dy * i;
      int newCol = col + dx * i;
      if (newRow < 0 || newRow >= gridSize || newCol < 0 || newCol >= gridSize) {
        return false;
      }
      String currentLetter = grid[newRow][newCol];
      if (currentLetter != '' && currentLetter != word[i]) {
        return false;
      }
    }
    return true;
  }

  void _setWord(String word, int row, int col, int direction) {
    int dx = 0, dy = 0;
    switch (direction) {
      case 0: dx = 0; dy = -1; break;
      case 1: dx = 1; dy = -1; break;
      case 2: dx = 1; dy = 0; break;
      case 3: dx = 1; dy = 1; break;
      case 4: dx = 0; dy = 1; break;
      case 5: dx = -1; dy = 1; break;
      case 6: dx = -1; dy = 0; break;
      case 7: dx = -1; dy = -1; break;
    }

    for (int i = 0; i < word.length; i++) {
      int newRow = row + dy * i;
      int newCol = col + dx * i;
      grid[newRow][newCol] = word[i];
    }
  }

  void _fillEmptySpaces() {
    final random = Random();
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (grid[i][j] == '') {
          grid[i][j] = letters[random.nextInt(letters.length)];
        }
      }
    }
  }
}
