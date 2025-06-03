import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import '../models/game_models.dart';

class GameProvider extends ChangeNotifier {
  GameConfig? _currentConfig;
  List<List<String>> _grid = [];
  List<WordPlacement> _wordPlacements = [];
  final List<Position> _selectedPositions = [];
  int _score = 0;
  int _timeRemaining = 0;
  Timer? _gameTimer;
  bool _gameStarted = false;
  bool _gameCompleted = false;

  // Getters
  GameConfig? get currentConfig => _currentConfig;
  List<List<String>> get grid => _grid;
  List<WordPlacement> get wordPlacements => _wordPlacements;
  List<Position> get selectedPositions => _selectedPositions;
  int get score => _score;
  int get timeRemaining => _timeRemaining;
  bool get gameStarted => _gameStarted;
  bool get gameCompleted => _gameCompleted;
  int get foundWords => _wordPlacements.where((w) => w.isFound).length;
  int get totalWords => _wordPlacements.length;

  void startNewGame(Difficulty difficulty) {
    _currentConfig = GameConfig.getConfig(difficulty);
    _generateGrid();
    _score = 0;
    _timeRemaining = _currentConfig!.timeLimit * 60;
    _gameStarted = true;
    _gameCompleted = false;
    _startTimer();
    notifyListeners();
  }

  void _generateGrid() {
    final size = _currentConfig!.gridSize;
    _grid = List.generate(size, (i) => List.generate(size, (j) => ''));
    _wordPlacements = [];

    // Place words in grid
    for (String word in _currentConfig!.words) {
      _placeWordInGrid(word);
    }

    // Fill empty cells with random letters
    final random = Random();
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (_grid[i][j].isEmpty) {
          _grid[i][j] = letters[random.nextInt(letters.length)];
        }
      }
    }
  }

  void _placeWordInGrid(String word) {
    final random = Random();
    final size = _currentConfig!.gridSize;
    int attempts = 0;
    const maxAttempts = 100;

    while (attempts < maxAttempts) {
      final direction =
          Direction.values[random.nextInt(Direction.values.length)];
      final row = random.nextInt(size);
      final col = random.nextInt(size);

      if (_canPlaceWord(word, row, col, direction)) {
        final positions = _getWordPositions(word, row, col, direction);

        // Place the word
        for (int i = 0; i < word.length; i++) {
          final pos = positions[i];
          _grid[pos.row][pos.col] = word[i];
        }

        _wordPlacements.add(
          WordPlacement(
            word: word,
            startPosition: Position(row, col),
            direction: direction,
            positions: positions,
          ),
        );
        return;
      }
      attempts++;
    }
  }

  bool _canPlaceWord(String word, int row, int col, Direction direction) {
    final positions = _getWordPositions(word, row, col, direction);

    // Check if all positions are valid and empty or match existing letters
    for (int i = 0; i < positions.length; i++) {
      final pos = positions[i];
      if (pos.row < 0 ||
          pos.row >= _currentConfig!.gridSize ||
          pos.col < 0 ||
          pos.col >= _currentConfig!.gridSize) {
        return false;
      }

      if (_grid[pos.row][pos.col].isNotEmpty &&
          _grid[pos.row][pos.col] != word[i]) {
        return false;
      }
    }
    return true;
  }

  List<Position> _getWordPositions(
    String word,
    int row,
    int col,
    Direction direction,
  ) {
    List<Position> positions = [];

    for (int i = 0; i < word.length; i++) {
      int newRow = row;
      int newCol = col;

      switch (direction) {
        case Direction.horizontal:
          newCol += i;
          break;
        case Direction.vertical:
          newRow += i;
          break;
        case Direction.diagonal:
          newRow += i;
          newCol += i;
          break;
        case Direction.reverseDiagonal:
          newRow += i;
          newCol -= i;
          break;
      }

      positions.add(Position(newRow, newCol));
    }

    return positions;
  }

  void selectPosition(Position position) {
    if (!_gameStarted || _gameCompleted) {
      return;
    }

    // If this is the first position or the position is adjacent to the last selected position
    if (_selectedPositions.isEmpty) {
      _selectedPositions.add(position);
    } else {
      // Check if we're continuing a line or starting a new selection
      if (_isValidNextPosition(position)) {
        _selectedPositions.add(position);
      } else {
        // Start new selection from this position
        _selectedPositions.clear();
        _selectedPositions.add(position);
      }
    }

    notifyListeners();

    // Check if selection forms a word (only if we have at least 2 positions)
    if (_selectedPositions.length >= 2) {
      _checkForWord();
    }
  }

  bool _isValidNextPosition(Position newPosition) {
    if (_selectedPositions.isEmpty) return true;

    Position lastPosition = _selectedPositions.last;
    int rowDiff = (newPosition.row - lastPosition.row).abs();
    int colDiff = (newPosition.col - lastPosition.col).abs();

    // Check if the new position is adjacent (including diagonally)
    return rowDiff <= 1 && colDiff <= 1 && (rowDiff + colDiff > 0);
  }

  void clearSelection() {
    _selectedPositions.clear();
    notifyListeners();
  }

  void _checkForWord() {
    String selectedWord = _getSelectedWord();

    for (WordPlacement placement in _wordPlacements) {
      if (!placement.isFound &&
          (placement.word == selectedWord ||
              placement.word == selectedWord.split('').reversed.join())) {
        // Check if selected positions match word positions (forward or backward)
        if (_positionsMatch(placement.positions, _selectedPositions) ||
            _positionsMatch(
              placement.positions,
              _selectedPositions.reversed.toList(),
            )) {
          placement.isFound = true;
          _score += _calculateWordScore(placement.word);
          _selectedPositions.clear();

          if (_wordPlacements.every((w) => w.isFound)) {
            _completeGame();
          }

          notifyListeners();
          return;
        }
      }
    }
  }

  String _getSelectedWord() {
    return _selectedPositions.map((pos) => _grid[pos.row][pos.col]).join();
  }

  bool _positionsMatch(
    List<Position> wordPositions,
    List<Position> selectedPositions,
  ) {
    if (wordPositions.length != selectedPositions.length) {
      return false;
    }

    // Check if positions match exactly
    for (int i = 0; i < wordPositions.length; i++) {
      if (wordPositions[i] != selectedPositions[i]) {
        return false;
      }
    }

    return true;
  }

  int _calculateWordScore(String word) {
    int baseScore = word.length * 10;
    int difficultyMultiplier = _currentConfig!.difficulty.index + 1;
    return baseScore * difficultyMultiplier;
  }

  void _startTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        _timeRemaining--;
        notifyListeners();
      } else {
        _completeGame();
      }
    });
  }

  void _completeGame() {
    _gameCompleted = true;
    _gameTimer?.cancel();

    // Bonus points for remaining time
    if (_wordPlacements.every((w) => w.isFound)) {
      _score += _timeRemaining * 2;
    }

    notifyListeners();
  }

  void pauseGame() {
    _gameTimer?.cancel();
    notifyListeners();
  }

  void resumeGame() {
    if (_gameStarted && !_gameCompleted && _timeRemaining > 0) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }
}
