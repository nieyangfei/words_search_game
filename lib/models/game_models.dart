enum Difficulty { easy, medium, hard }

enum Direction { horizontal, vertical, diagonal, reverseDiagonal }

class Position {
  final int row;
  final int col;

  const Position(this.row, this.col);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Position &&
          runtimeType == other.runtimeType &&
          row == other.row &&
          col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;

  @override
  String toString() => 'Position($row, $col)';
}

class WordPlacement {
  final String word;
  final Position startPosition;
  final Direction direction;
  final List<Position> positions;
  bool isFound;

  WordPlacement({
    required this.word,
    required this.startPosition,
    required this.direction,
    required this.positions,
    this.isFound = false,
  });
}

class GameConfig {
  final Difficulty difficulty;
  final int gridSize;
  final List<String> words;
  final int timeLimit; // in minutes

  const GameConfig({
    required this.difficulty,
    required this.gridSize,
    required this.words,
    required this.timeLimit,
  });

  static GameConfig getConfig(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return GameConfig(
          difficulty: difficulty,
          gridSize: 8,
          words: ['CAT', 'DOG', 'BIRD', 'FISH', 'TREE', 'BOOK', 'MOON', 'STAR'],
          timeLimit: 10,
        );
      case Difficulty.medium:
        return GameConfig(
          difficulty: difficulty,
          gridSize: 12,
          words: [
            'FLUTTER',
            'MOBILE',
            'WIDGET',
            'SCREEN',
            'BUTTON',
            'DESIGN',
            'CODING',
            'ANDROID',
            'APPLE',
            'PHONE',
          ],
          timeLimit: 15,
        );
      case Difficulty.hard:
        return GameConfig(
          difficulty: difficulty,
          gridSize: 16,
          words: [
            'DEVELOPMENT',
            'PROGRAMMING',
            'ARCHITECTURE',
            'FRAMEWORK',
            'RESPONSIVE',
            'INTERFACE',
            'COMPONENT',
            'PROVIDER',
            'NAVIGATOR',
            'MATERIAL',
            'STATEFUL',
            'ANIMATION',
          ],
          timeLimit: 20,
        );
    }
  }
}
