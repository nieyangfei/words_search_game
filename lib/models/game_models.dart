import 'package:flutter/material.dart';

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
  String toString() => 'Position(\$row, \$col)';
}

class WordPlacement {
  final String word;
  final Position startPosition;
  final Direction direction;
  final List<Position> positions;
  bool isFound;
  final Color color;

  WordPlacement({
    required this.word,
    required this.startPosition,
    required this.direction,
    required this.positions,
    this.isFound = false,
    required this.color,
  });
}

class GameConfig {
  final Difficulty difficulty;
  final int gridSize;
  final List<String> words;
  final int timeLimit;

  const GameConfig({
    required this.difficulty,
    required this.gridSize,
    required this.words,
    required this.timeLimit,
  });

  static GameConfig getConfig(Difficulty difficulty, [int level = 0]) {
    switch (difficulty) {
      case Difficulty.easy:
        return GameConfig(
          difficulty: difficulty,
          gridSize: 8,
          words: _easyWords[level % _easyWords.length],
          timeLimit: 10,
        );
      case Difficulty.medium:
        return GameConfig(
          difficulty: difficulty,
          gridSize: 12,
          words: _mediumWords[level % _mediumWords.length],
          timeLimit: 15,
        );
      case Difficulty.hard:
        return GameConfig(
          difficulty: difficulty,
          gridSize: 16,
          words: _hardWords[level % _hardWords.length],
          timeLimit: 20,
        );
    }
  }

  static const List<List<String>> _easyWords = [
    ['CAT', 'DOG', 'BIRD', 'FISH', 'TREE', 'BOOK', 'MOON', 'STAR'],
    ['SUN', 'MAP', 'TOY', 'BAG', 'CAR', 'PEN', 'FOOD', 'BELL'],
    ['MILK', 'HAT', 'CUP', 'ROAD', 'FORK', 'HAND', 'DESK', 'BEE'],
    ['LAMP', 'DESK', 'FAN', 'CHAIR', 'COIN', 'BALL', 'SOAP', 'KEY'],
    ['PEN', 'NOTE', 'FLAG', 'RING', 'GOLD', 'CARD', 'FIRE', 'DOOR'],
  ];

  static const List<List<String>> _mediumWords = [
    ['FLUTTER', 'MOBILE', 'WIDGET', 'SCREEN', 'BUTTON', 'DESIGN', 'CODING', 'ANDROID', 'APPLE', 'PHONE'],
    ['WINDOW', 'COLUMN', 'LAYOUT', 'ACTION', 'SCROLL', 'HEIGHT', 'IMPORT', 'STATE', 'ROUTE', 'INPUT'],
    ['DEVICE', 'EDITOR', 'TOOLBAR', 'CANVAS', 'SCRIPT', 'BANNER', 'SERVER', 'CLIENT', 'FORMAT', 'TEMPLATE'],
    ['PACKAGE', 'PADDING', 'MARGIN', 'WIDGETS', 'ALIGN', 'OFFSET', 'TWEEN', 'LOADER', 'GITHUB', 'FOLDER'],
    ['CACHE', 'HOTKEY', 'STYLES', 'EXPORT', 'TAPBAR', 'ASSETS', 'BORDER', 'SYNTAX', 'HANDLE', 'BRIDGE'],
  ];

  static const List<List<String>> _hardWords = [
    ['DEVELOPMENT', 'PROGRAMMING', 'ARCHITECTURE', 'FRAMEWORK', 'RESPONSIVE', 'INTERFACE', 'COMPONENT', 'PROVIDER', 'NAVIGATOR', 'MATERIAL', 'STATEFUL', 'ANIMATION'],
    ['ALGORITHM', 'DEBUGGING', 'REFACTORING', 'ENCAPSULATION', 'ABSTRACTION', 'COMPLEXITY', 'EXTENSION', 'INHERITANCE', 'POLYMORPHISM', 'CONCURRENCY', 'SYNCHRONOUS', 'MUTABILITY'],
    ['ISOLATION', 'SCHEDULER', 'MIDDLEWARE', 'MUTATION', 'REACTIVE', 'CONTROLLER', 'PERSISTENCE', 'SECURITY', 'THREADSAFE', 'WORKFLOW', 'VALIDATION', 'DEPRECATION'],
    ['RENDERING', 'SIMULATION', 'VISUALIZE', 'SINGLETON', 'DELEGATE', 'INJECTION', 'PROTOCOL', 'INTROSPECT', 'ITERATION', 'BYTECODE', 'PIPELINE', 'OPTIMIZER'],
    ['OVERLOADING', 'MIXINCLASS', 'DISPATCHER', 'MEMORYMAP', 'SERIALIZE', 'WRAPPER', 'DECORATOR', 'ABSTRACTOR', 'OVERRIDDEN', 'EXPRESSION', 'SCHEDULING', 'INSTANCEOF'],
  ];

}
